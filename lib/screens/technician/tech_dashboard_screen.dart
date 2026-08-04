import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../providers/tech_dashboard_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/models.dart';

class TechDashboardScreen extends StatefulWidget {
  const TechDashboardScreen({super.key});

  @override
  State<TechDashboardScreen> createState() => _TechDashboardScreenState();
}

class _TechDashboardScreenState extends State<TechDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.firebaseUser != null) {
        context
            .read<TechDashboardProvider>()
            .loadProfile(auth.firebaseUser!.uid);
      }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  static const _catMeta = {
    'plumbing': {'ar': 'سباكة', 'icon': '🔧', 'color': Color(0xFF1565C0)},
    'electrical': {'ar': 'كهرباء', 'icon': '⚡', 'color': Color(0xFFF57F17)},
    'cleaning': {'ar': 'تنظيف', 'icon': '🧹', 'color': Color(0xFF00897B)},
    'painting': {'ar': 'دهانات', 'icon': '🎨', 'color': Color(0xFF7B1FA2)},
    'carpentry': {'ar': 'نجارة', 'icon': '🪚', 'color': Color(0xFF5D4037)},
    'ac': {'ar': 'تكييف', 'icon': '❄️', 'color': Color(0xFF0097A7)},
    'appliances': {'ar': 'أجهزة', 'icon': '🔌', 'color': Color(0xFFE65100)},
    'pest_control': {
      'ar': 'مكافحة حشرات',
      'icon': '🐛',
      'color': Color(0xFFC62828)
    },
  };

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<TechDashboardProvider>();
    final profile = dash.profile;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0d47a1)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        profile?.fullName.isNotEmpty == true
                            ? profile!.fullName[0]
                            : '؟',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'أهلاً، ${profile?.fullName ?? ''} 👋',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            profile?.specializations
                                    .map((s) =>
                                        _catMeta[s]?['ar'] as String? ?? s)
                                    .join(' · ') ??
                                '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Availability Toggle
                    GestureDetector(
                      onTap: () {
                        final auth = context.read<AuthProvider>();
                        dash.toggleAvailability(auth.firebaseUser!.uid);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dash.isAvailable ? 'متاح' : 'غير متاح',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: dash.isAvailable
                                    ? Colors.greenAccent
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stats Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _statCard('طلبات جديدة', '${dash.newJobsCount}',
                    const Color(0xFFFF6F00)),
                _statCard('قيد التنفيذ', '${dash.activeJobsCount}',
                    const Color(0xFF1565C0)),
                _statCard('مكتملة', '${dash.completedCount}',
                    const Color(0xFF00897B)),
                _statCard(
                    'الأرباح',
                    '${dash.totalEarnings.toStringAsFixed(0)}',
                    const Color(0xFF7B1FA2)),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabCtrl,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('طلبات جديدة'),
                    if (dash.newJobsCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${dash.newJobsCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Tab(text: 'مهامي'),
              const Tab(text: 'السجل'),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildNewJobsTab(dash),
                _buildMyJobsTab(dash),
                _buildHistoryTab(dash),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // =========== NEW JOBS TAB (Category Filtered) ===========
  Widget _buildNewJobsTab(TechDashboardProvider dash) {
    if (dash.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (dash.newJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'لا توجد طلبات جديدة حالياً',
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            Text(
              'الطلبات هتظهر على حسب تخصصاتك',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final auth = context.read<AuthProvider>();
        await dash.refresh(auth.firebaseUser!.uid);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dash.newJobs.length,
        itemBuilder: (context, index) {
          return _buildJobCard(dash.newJobs[index], dash, isNew: true);
        },
      ),
    );
  }

  // =========== MY JOBS TAB ===========
  Widget _buildMyJobsTab(TechDashboardProvider dash) {
    if (dash.myJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'لا توجد مهام حالية',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dash.myJobs.length,
      itemBuilder: (context, index) {
        return _buildJobCard(dash.myJobs[index], dash, isNew: false);
      },
    );
  }

  // =========== HISTORY TAB ===========
  Widget _buildHistoryTab(TechDashboardProvider dash) {
    if (dash.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('لا يوجد سجل بعد',
                style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dash.history.length,
      itemBuilder: (context, index) {
        final job = dash.history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.services.map((s) => s.nameAr).join(' + '),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(job.date),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${job.totalAmount.toStringAsFixed(0)} ج.م',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                  ),
                  const Text('✅ مكتمل',
                      style: TextStyle(fontSize: 10, color: Colors.green)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // =========== JOB CARD ===========
  Widget _buildJobCard(
      BookingModel job, TechDashboardProvider dash,
      {required bool isNew}) {
    final category = job.services.isNotEmpty ? job.services.first.category : '';
    final meta = _catMeta[category];
    final color = meta?['color'] as Color? ?? Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: service + price
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    meta?['icon'] as String? ?? '🔧',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.services.map((s) => s.nameAr).join(' + '),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: job.services
                          .map((s) => s.category)
                          .toSet()
                          .map((cat) {
                        final cm = _catMeta[cat];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (cm?['color'] as Color? ?? Colors.grey)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cm?['ar'] as String? ?? cat,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: cm?['color'] as Color? ?? Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${job.totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Text('ج.م',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Details
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                isNew ? job.address.split('—').first : job.address,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd/MM/yyyy').format(job.date),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                job.timeSlot,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),

          if (job.isEmergency) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt, size: 12, color: Colors.red.shade700),
                  Text(
                    ' طوارئ',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Action Buttons
          if (isNew)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final auth = context.read<AuthProvider>();
                      await dash.acceptJob(
                          job.id, auth.firebaseUser!.uid);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      foregroundColor: const Color(0xFF2E7D32),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('✅ قبول',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => dash.skipJob(job.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFC62828),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.red.shade200),
                    ),
                    child: const Text('❌ تخطي',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('اتصال'),
                    onPressed: () {
                      // Call customer
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      foregroundColor: const Color(0xFF2E7D32),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat, size: 16),
                    label: const Text('محادثة'),
                    onPressed: () {
                      // Open chat
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE3F2FD),
                      foregroundColor: const Color(0xFF1565C0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Open maps
                    launchUrl(Uri.parse(
                        'https://maps.google.com/?q=${job.address}'));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF3E0),
                    foregroundColor: const Color(0xFFE65100),
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.map, size: 18),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

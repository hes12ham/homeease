import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/auth_provider.dart';
import '../services/service_details_screen.dart';
import '../auth/login_screen_v2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ★ Only 4 visible categories (rest are hidden but still in services_provider)
  static const List<Map<String, dynamic>> _visibleCategories = [
    {'key': 'electrical', 'ar': 'كهرباء', 'icon': Icons.electrical_services, 'color': Color(0xFFF57F17)},
    {'key': 'plumbing', 'ar': 'سباكة', 'icon': Icons.plumbing, 'color': Color(0xFF1565C0)},
    {'key': 'carpentry', 'ar': 'نجارة', 'icon': Icons.carpenter, 'color': Color(0xFF5D4037)},
    {'key': 'ac', 'ar': 'تكييف وتبريد', 'icon': Icons.ac_unit, 'color': Color(0xFF0097A7)},
  ];

  // Hidden categories (kept in code for future use):
  // {'key': 'appliances', 'ar': 'أجهزة منزلية', 'icon': Icons.kitchen, 'color': Color(0xFFE65100)},
  // {'key': 'finishing', 'ar': 'تشطيبات', 'icon': Icons.format_paint, 'color': Color(0xFF7B1FA2)},
  // {'key': 'security', 'ar': 'أنظمة أمان', 'icon': Icons.videocam, 'color': Color(0xFF37474F)},
  // {'key': 'pest_control', 'ar': 'مكافحة حشرات', 'icon': Icons.bug_report, 'color': Color(0xFFC62828)},

  // Services shown under the 4 visible categories
  static const List<Map<String, dynamic>> _visibleServices = [
    // كهرباء
    {'id': 'elc_01', 'ar': 'كهرباء عامة', 'icon': Icons.electrical_services, 'color': Color(0xFFF57F17)},
    {'id': 'elc_03', 'ar': 'شاتر', 'icon': Icons.blinds, 'color': Color(0xFFF57F17)},
    {'id': 'elc_02', 'ar': 'مروحة', 'icon': Icons.mode_fan_off_outlined, 'color': Color(0xFFF57F17)},
    // سباكة
    {'id': 'plb_01', 'ar': 'سباكة عامة', 'icon': Icons.plumbing, 'color': Color(0xFF1565C0)},
    {'id': 'plb_03', 'ar': 'تسليك مجاري', 'icon': Icons.water_damage_outlined, 'color': Color(0xFF1565C0)},
    {'id': 'plb_02', 'ar': 'دش', 'icon': Icons.satellite_alt, 'color': Color(0xFF1565C0)},
    // نجارة
    {'id': 'crp_01', 'ar': 'نجارة', 'icon': Icons.carpenter, 'color': Color(0xFF5D4037)},
    {'id': 'crp_02', 'ar': 'ألوميتال', 'icon': Icons.window_outlined, 'color': Color(0xFF5D4037)},
    {'id': 'crp_04', 'ar': 'تركيب مطبخ', 'icon': Icons.countertops_outlined, 'color': Color(0xFF5D4037)},
    // تكييف
    {'id': 'ac_01', 'ar': 'صيانة التكييف', 'icon': Icons.ac_unit, 'color': Color(0xFF0097A7)},
    {'id': 'ac_02', 'ar': 'تركيب ونقل تكييف', 'icon': Icons.hvac_outlined, 'color': Color(0xFF0097A7)},
    {'id': 'ac_03', 'ar': 'شحن فريون', 'icon': Icons.thermostat_outlined, 'color': Color(0xFF0097A7)},
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    return hour < 12 ? 'صباح الخير 👋' : 'مساء الخير 👋';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final servicesProvider = context.watch<ServicesProvider>();

    // Auto-load services if empty
    if (servicesProvider.services.isEmpty && !servicesProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        servicesProvider.loadServices();
      });
    }
    final userName = auth.user?.name ?? 'زائر';
    final isLoggedIn = auth.firebaseUser != null;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.home, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getGreeting(),
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                          Text(userName,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    if (!isLoggedIn)
                      TextButton.icon(
                        icon: const Icon(Icons.login, size: 18),
                        label: const Text('دخول'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ));
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.build_circle, color: Colors.white, size: 36),
                    SizedBox(height: 10),
                    Text('الصيانة والتركيبات',
                      style: TextStyle(color: Colors.white, fontSize: 24,
                          fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('صلّح وركّب أي حاجة في بيتك',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ),

            // Emergency
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  if (!isLoggedIn) {
                    _showLoginRequired(context);
                    return;
                  }
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD32F2F), Color(0xFFF44336)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('خدمة طوارئ',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w700, fontSize: 15)),
                            Text('حجز أولوية خلال ساعة',
                                style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('احجز الآن',
                            style: TextStyle(color: Color(0xFFD32F2F),
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4 Categories
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text('التصنيفات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _visibleCategories.length,
                  itemBuilder: (context, index) {
                    final cat = _visibleCategories[index];
                    final color = cat['color'] as Color;
                    return Container(
                      width: 85,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Container(
                            width: 60, height: 60,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(cat['icon'] as IconData, color: color, size: 28),
                          ),
                          const SizedBox(height: 8),
                          Text(cat['ar'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Services Title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text('الخدمات المتاحة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),

            // Services Grid (3 columns)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _visibleServices[index];
                    final color = item['color'] as Color;

                    return GestureDetector(
                      onTap: () {
                        final serviceId = item['id'] as String;
                        final service = servicesProvider.services
                            .where((s) => s.id == serviceId)
                            .toList();

                        if (service.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ServiceDetailsScreen(service: service.first),
                          ));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 52, height: 52,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(item['icon'] as IconData,
                                  color: color, size: 26),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                item['ar'] as String,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11,
                                    fontWeight: FontWeight.w600, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _visibleServices.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ★ Show login required dialog when user tries to book without login
  static void _showLoginRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_outline, color: Color(0xFF1565C0)),
            SizedBox(width: 10),
            Text('تسجيل الدخول مطلوب'),
          ],
        ),
        content: const Text('لازم تسجّل دخولك الأول عشان تقدر تحجز خدمة.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ));
            },
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }
}

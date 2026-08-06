import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../services/category_services_screen.dart';
import '../services/service_details_screen.dart';
import '../services/services_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // All 19 services as individual cards (like Fi El Khedma)
  static const List<Map<String, dynamic>> _allServices = [
    {'id': 'elc_01', 'ar': 'كهرباء', 'icon': Icons.electrical_services, 'color': Color(0xFF1565C0)},
    {'id': 'elc_03', 'ar': 'شاتر', 'icon': Icons.blinds, 'color': Color(0xFF1565C0)},
    {'id': 'elc_02', 'ar': 'مروحة', 'icon': Icons.mode_fan_off_outlined, 'color': Color(0xFF1565C0)},

    {'id': 'plb_02', 'ar': 'دش', 'icon': Icons.satellite_alt, 'color': Color(0xFF00897B)},
    {'id': 'fin_01', 'ar': 'تأسيس تشطيبات', 'icon': Icons.home_work_outlined, 'color': Color(0xFF7B1FA2)},
    {'id': 'app_01', 'ar': 'غسالة أطباق', 'icon': Icons.countertops_outlined, 'color': Color(0xFFE65100)},

    {'id': 'sec_02', 'ar': 'صيانة الانتركم', 'icon': Icons.doorbell_outlined, 'color': Color(0xFF37474F)},
    {'id': 'sec_01', 'ar': 'تركيب وصيانة\nكاميرا مراقبة', 'icon': Icons.videocam_outlined, 'color': Color(0xFF37474F)},
    {'id': 'app_02', 'ar': 'بوتجاز', 'icon': Icons.microwave_outlined, 'color': Color(0xFFE65100)},

    {'id': 'app_03', 'ar': 'سخانات غاز', 'icon': Icons.water_drop_outlined, 'color': Color(0xFFE65100)},
    {'id': 'app_04', 'ar': 'ثلاجة/فريزر', 'icon': Icons.kitchen_outlined, 'color': Color(0xFFE65100)},
    {'id': 'app_05', 'ar': 'غسالة', 'icon': Icons.local_laundry_service_outlined, 'color': Color(0xFFE65100)},

    {'id': 'fin_02', 'ar': 'نقاشة', 'icon': Icons.format_paint_outlined, 'color': Color(0xFF7B1FA2)},
    {'id': 'fin_03', 'ar': 'تركيب البلاط\nوالسيراميك', 'icon': Icons.grid_view_outlined, 'color': Color(0xFF7B1FA2)},
    {'id': 'pst_01', 'ar': 'مكافحة الحشرات', 'icon': Icons.pest_control_outlined, 'color': Color(0xFFC62828)},

    {'id': 'ac_01', 'ar': 'صيانة التكييف', 'icon': Icons.ac_unit, 'color': Color(0xFF0097A7)},
    {'id': 'ac_02', 'ar': 'تركيب ونقل تكييف', 'icon': Icons.hvac_outlined, 'color': Color(0xFF0097A7)},
    {'id': 'crp_02', 'ar': 'ألوميتال', 'icon': Icons.window_outlined, 'color': Color(0xFF5D4037)},

    {'id': 'crp_01', 'ar': 'نجارة', 'icon': Icons.carpenter, 'color': Color(0xFF5D4037)},
    {'id': 'plb_01', 'ar': 'سباكة', 'icon': Icons.plumbing, 'color': Color(0xFF1565C0)},
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    return hour < 12 ? 'صباح الخير 👋' : 'مساء الخير 👋';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final servicesProvider = context.watch<ServicesProvider>();
    final l10n = AppLocalizations.of(context);
    final userName = auth.user?.name ?? 'زائر';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with location
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_getGreeting(),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          Text(userName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Title: الصيانة و التركيبات
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.build, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'الصيانة والتركيبات',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'صلّح وركّب أي حاجة في بيتك',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Emergency Banner
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD32F2F), Color(0xFFF44336)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('خدمة طوارئ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('حجز أولوية خلال ساعة', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('احجز الآن', style: TextStyle(color: Color(0xFFD32F2F), fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Services Grid (3 per row like Fi El Khedma)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _allServices[index];
                    final color = item['color'] as Color;

                    return GestureDetector(
                      onTap: () {
                        // Find the actual service from provider
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
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                item['ar'] as String,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _allServices.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/models.dart';
import '../services/service_details_screen.dart';
import '../auth/login_screen_v2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 4 visible categories
  static const List<Map<String, dynamic>> _categories = [
    {'key': 'electrical', 'ar': 'كهرباء', 'icon': Icons.electrical_services, 'color': Color(0xFFF57F17)},
    {'key': 'plumbing', 'ar': 'سباكة', 'icon': Icons.plumbing, 'color': Color(0xFF1565C0)},
    {'key': 'carpentry', 'ar': 'نجارة', 'icon': Icons.carpenter, 'color': Color(0xFF5D4037)},
    {'key': 'ac', 'ar': 'تكييف وتبريد', 'icon': Icons.ac_unit, 'color': Color(0xFF0097A7)},
  ];

  // Hidden categories (uncomment to show):
  // {'key': 'appliances', 'ar': 'أجهزة منزلية', 'icon': Icons.kitchen, 'color': Color(0xFFE65100)},
  // {'key': 'finishing', 'ar': 'تشطيبات', 'icon': Icons.format_paint, 'color': Color(0xFF7B1FA2)},
  // {'key': 'security', 'ar': 'أنظمة أمان', 'icon': Icons.videocam, 'color': Color(0xFF37474F)},
  // {'key': 'pest_control', 'ar': 'مكافحة حشرات', 'icon': Icons.bug_report, 'color': Color(0xFFC62828)},

  String _selectedCategory = 'electrical'; // Default selected

  static const _catIcons = {
    'electrical': Icons.electrical_services,
    'plumbing': Icons.plumbing,
    'carpentry': Icons.carpenter,
    'ac': Icons.ac_unit,
  };

  static const _catColors = {
    'electrical': Color(0xFFF57F17),
    'plumbing': Color(0xFF1565C0),
    'carpentry': Color(0xFF5D4037),
    'ac': Color(0xFF0097A7),
  };

  String _getGreeting() {
    final hour = DateTime.now().hour;
    return hour < 12 ? 'صباح الخير 👋' : 'مساء الخير 👋';
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider? auth;
    try { auth = context.watch<AuthProvider>(); } catch (_) {}
    final servicesProvider = context.watch<ServicesProvider>();
    final userName = auth?.user?.name ?? 'زائر';
    final isLoggedIn = auth?.firebaseUser != null;

    // Auto-load services
    if (servicesProvider.services.isEmpty && !servicesProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        servicesProvider.loadServices();
      });
    }

    // Filter services by selected category
    final filteredServices = servicesProvider.services
        .where((s) => s.category == _selectedCategory)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ===== HEADER =====
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
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    if (!isLoggedIn)
                      TextButton.icon(
                        icon: const Icon(Icons.login, size: 16),
                        label: const Text('دخول', style: TextStyle(fontSize: 13)),
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

            // ===== BANNER =====
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



            // ===== 4 CATEGORY CHIPS =====
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Text('التصنيفات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final key = cat['key'] as String;
                    final isSelected = key == _selectedCategory;
                    final color = cat['color'] as Color;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = key),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? color : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? color : const Color(0xFFE0E4E8),
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: color.withValues(alpha: 0.3),
                                  blurRadius: 8, offset: const Offset(0, 3))]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(cat['icon'] as IconData,
                                size: 18,
                                color: isSelected ? Colors.white : color),
                            const SizedBox(width: 6),
                            Text(
                              cat['ar'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ===== SERVICES LIST (filtered by category) =====
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    Text(
                      _categories.firstWhere((c) => c['key'] == _selectedCategory)['ar'] as String,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (_catColors[_selectedCategory] ?? Colors.grey).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${filteredServices.length} خدمة',
                        style: TextStyle(
                          fontSize: 12,
                          color: _catColors[_selectedCategory] ?? Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Service cards
            filteredServices.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined, size: 48,
                                color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('جاري تحميل الخدمات...',
                                style: TextStyle(color: Colors.grey.shade400)),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final service = filteredServices[index];
                        final color = _catColors[service.category] ?? Colors.grey;
                        final icon = _catIcons[service.category] ?? Icons.build;

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ServiceDetailsScreen(service: service),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Icon
                                    Container(
                                      width: 52, height: 52,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(icon, color: color, size: 26),
                                    ),
                                    const SizedBox(width: 14),

                                    // Name + Description
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service.nameAr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            service.descriptionAr,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (service.isEmergencyAvailable) ...[
                                            const SizedBox(height: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.bolt, size: 10,
                                                      color: Colors.red.shade700),
                                                  Text(' متاح طوارئ',
                                                    style: TextStyle(fontSize: 9,
                                                        color: Colors.red.shade700,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),

                                    // Price
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${service.price.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                            color: color,
                                          ),
                                        ),
                                        Text('ج.م',
                                            style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 11)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: filteredServices.length,
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

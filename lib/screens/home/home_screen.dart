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

  static const Map<String, Map<String, dynamic>> _categoryMeta = {
    'electrical': {
      'ar': 'كهرباء',
      'en': 'Electrical',
      'icon': Icons.electrical_services,
      'color': Color(0xFFF57F17),
    },
    'plumbing': {
      'ar': 'سباكة',
      'en': 'Plumbing',
      'icon': Icons.plumbing,
      'color': Color(0xFF1565C0),
    },
    'appliances': {
      'ar': 'أجهزة منزلية',
      'en': 'Home Appliances',
      'icon': Icons.kitchen,
      'color': Color(0xFFE65100),
    },
    'ac': {
      'ar': 'تكييف وتبريد',
      'en': 'AC & Cooling',
      'icon': Icons.ac_unit,
      'color': Color(0xFF0097A7),
    },
    'finishing': {
      'ar': 'تشطيبات ودهانات',
      'en': 'Finishing & Painting',
      'icon': Icons.format_paint,
      'color': Color(0xFF7B1FA2),
    },
    'carpentry': {
      'ar': 'نجارة وألوميتال',
      'en': 'Carpentry & Aluminum',
      'icon': Icons.carpenter,
      'color': Color(0xFF5D4037),
    },
    'security': {
      'ar': 'أنظمة أمان',
      'en': 'Security Systems',
      'icon': Icons.videocam,
      'color': Color(0xFF37474F),
    },
    'pest_control': {
      'ar': 'مكافحة حشرات',
      'en': 'Pest Control',
      'icon': Icons.bug_report,
      'color': Color(0xFFC62828),
    },
  };

  String _getGreeting(bool isAr) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return isAr ? 'صباح الخير 👋' : 'Good morning 👋';
    } else {
      return isAr ? 'مساء الخير 👋' : 'Good evening 👋';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final servicesProvider = context.watch<ServicesProvider>();
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final userName = auth.user?.name ?? (isAr ? 'زائر' : 'Guest');

    final featuredCategories = servicesProvider.featuredCategoryKeys;
    final popularServices = servicesProvider.popularServices;

    return Scaffold(
      body: SafeArea(
        child: servicesProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(isAr),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ServicesScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE8ECF0)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade400),
                      const SizedBox(width: 10),
                      Text(
                        isAr
                            ? 'ابحث عن خدمة...'
                            : 'Search for a service...',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD32F2F), Color(0xFFF44336)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('⚡', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAr ? 'خدمة طوارئ' : 'Emergency Service',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              isAr
                                  ? 'حجز أولوية خلال ساعة'
                                  : 'Priority booking within one hour',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isAr ? 'أهم التصنيفات' : 'Top Categories',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ServicesScreen(),
                          ),
                        );
                      },
                      child: Text(isAr ? 'عرض الكل' : 'View all'),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: featuredCategories.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final key = featuredCategories[index];
                    final meta = _categoryMeta[key] ?? {};
                    final color = (meta['color'] as Color?) ?? Colors.grey;
                    final icon = (meta['icon'] as IconData?) ?? Icons.build;
                    final title = isAr
                        ? (meta['ar'] as String? ?? key)
                        : (meta['en'] as String? ?? key);

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CategoryServicesScreen(
                              category: key,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(icon, color: color, size: 27),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                height: 1.25,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isAr ? 'الخدمات الشائعة' : 'Popular Services',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ServicesScreen(),
                          ),
                        );
                      },
                      child: Text(isAr ? 'كل الخدمات' : 'All services'),
                    ),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index >= popularServices.length) return null;
                  final service = popularServices[index];

                  final meta = _categoryMeta[service.category] ?? {};
                  final color = (meta['color'] as Color?) ?? Colors.grey;
                  final icon = (meta['icon'] as IconData?) ?? Icons.build;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ServiceDetailsScreen(service: service),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(icon, color: color, size: 24),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAr ? service.nameAr : service.nameEn,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      isAr
                                          ? service.descriptionAr
                                          : service.descriptionEn,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (service.isEmergencyAvailable) ...[
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius:
                                          BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.bolt,
                                              size: 10,
                                              color: Colors.red.shade700,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              isAr ? 'طوارئ' : 'Emergency',
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.red.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    service.price.toStringAsFixed(0),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                  Text(
                                    l10n.translate('egp'),
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: popularServices.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
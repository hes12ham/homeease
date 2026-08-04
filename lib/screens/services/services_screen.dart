import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services_provider.dart';
import '../../l10n/app_localizations.dart';
import 'category_services_screen.dart';
import 'service_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final servicesProvider = context.watch<ServicesProvider>();
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'الخدمات' : 'Services'),
      ),
      body: servicesProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => context.read<ServicesProvider>().loadServices(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<ServicesProvider>().searchServices(value);
              },
              decoration: InputDecoration(
                hintText:
                isAr ? 'ابحث عن خدمة...' : 'Search for a service...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    context.read<ServicesProvider>().searchServices('');
                    setState(() {});
                  },
                  icon: const Icon(Icons.close),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              isAr ? 'كل التصنيفات' : 'All Categories',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: servicesProvider.categories.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 14,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                final key = servicesProvider.categories[index];
                final meta = _categoryMeta[key] ?? {};
                final color = (meta['color'] as Color?) ?? Colors.grey;
                final icon = (meta['icon'] as IconData?) ?? Icons.build;
                final title =
                isAr ? (meta['ar'] as String? ?? key) : (meta['en'] as String? ?? key);

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

            const SizedBox(height: 28),

            Text(
              isAr ? 'كل الخدمات' : 'All Services',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),

            if (servicesProvider.services.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  isAr ? 'لا توجد خدمات حالياً' : 'No services available',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            else
              ...servicesProvider.services.map((service) {
                final meta = _categoryMeta[service.category] ?? {};
                final color = (meta['color'] as Color?) ?? Colors.grey;
                final icon = (meta['icon'] as IconData?) ?? Icons.build;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
              }),
          ],
        ),
      ),
    );
  }
}
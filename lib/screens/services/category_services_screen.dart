import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/services_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/service_item_card.dart';
import 'service_details_screen.dart';

class CategoryServicesScreen extends StatelessWidget {
  final String category;
  final bool isEmergency;

  const CategoryServicesScreen({
    super.key,
    required this.category,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    final services = context.watch<ServicesProvider>();
    final l10n = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final categoryNamesAr = {
      'electrical': 'كهرباء',
      'plumbing': 'سباكة',
      'appliances': 'أجهزة منزلية',
      'ac': 'تكييف وتبريد',
      'finishing': 'تشطيبات ودهانات',
      'carpentry': 'نجارة وألوميتال',
      'security': 'أنظمة أمان',
      'pest_control': 'مكافحة حشرات',
    };

    final categoryNamesEn = {
      'electrical': 'Electrical',
      'plumbing': 'Plumbing',
      'appliances': 'Home Appliances',
      'ac': 'AC & Cooling',
      'finishing': 'Finishing & Painting',
      'carpentry': 'Carpentry & Aluminum',
      'security': 'Security Systems',
      'pest_control': 'Pest Control',
    };

    final servicesList = services.services
        .where((s) => s.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic
              ? (categoryNamesAr[category] ?? category)
              : (categoryNamesEn[category] ?? category),
        ),
      ),
      body: servicesList.isEmpty
          ? Center(
        child: Text(
          isArabic ? 'لا توجد خدمات حالياً' : 'No services available حاليا',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: servicesList.length,
        itemBuilder: (context, index) {
          final service = servicesList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ServiceItemCard(
              service: service,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ServiceDetailsScreen(service: service),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
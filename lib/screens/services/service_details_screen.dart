import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/cart_provider.dart';
import '../../providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final cart = context.read<CartProvider>();

    final categoryIcons = {
      'plumbing': Icons.plumbing,
      'electrical': Icons.electrical_services,
      'ac': Icons.ac_unit,
      'carpentry': Icons.carpenter,
      'finishing': Icons.format_paint,
      'security': Icons.security,
      'appliances': Icons.kitchen,
      'pest_control': Icons.pest_control,
    };

    final categoryColors = {
      'plumbing': const Color(0xFF1565C0),
      'electrical': const Color(0xFFF57F17),
      'ac': const Color(0xFF0097A7),
      'carpentry': const Color(0xFF5D4037),
      'finishing': const Color(0xFF7B1FA2),
      'security': const Color(0xFF37474F),
      'appliances': const Color(0xFFE65100),
      'pest_control': const Color(0xFFC62828),
    };

    final color = categoryColors[service.category] ?? Colors.blue;
    final icon = categoryIcons[service.category] ?? Icons.build;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: color,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withOpacity(0.7)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(icon, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          isArabic ? service.nameAr : service.nameEn,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.translate('price'),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${service.price.toStringAsFixed(0)} ${l10n.translate('egp')}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_user,
                                  color: Colors.green.shade700, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                l10n.translate('warranty_info'),
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    l10n.translate('description'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic ? service.descriptionAr : service.descriptionEn,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    isArabic ? 'ما يشمله' : "What's Included",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildIncluded(
                    Icons.person_pin,
                    isArabic ? 'فني متخصص' : 'Specialized Technician',
                    isArabic: isArabic,
                  ),
                  _buildIncluded(
                    Icons.verified_user,
                    isArabic ? 'ضمان أسبوع' : '7-Day Warranty',
                    isArabic: isArabic,
                  ),
                  _buildIncluded(
                    Icons.support_agent,
                    isArabic ? 'دعم فني بعد الخدمة' : 'Post-service Support',
                    isArabic: isArabic,
                  ),
                  _buildIncluded(
                    Icons.cleaning_services,
                    isArabic ? 'تنظيف بعد الانتهاء' : 'Clean-up After Service',
                    isArabic: isArabic,
                  ),
                  if (service.isEmergencyAvailable)
                    _buildIncluded(
                      Icons.bolt,
                      isArabic
                          ? 'متاح كخدمة طوارئ'
                          : 'Available as Emergency Service',
                      color: Colors.orange,
                      isArabic: isArabic,
                    ),
                  const SizedBox(height: 24),

                  Text(
                    l10n.translate('reviews'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildReviewPreview(context, isArabic),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      cart.addItem(service);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.translate('added_to_cart')),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(l10n.translate('add_to_cart')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncluded(
      IconData icon,
      String text, {
        Color? color,
        required bool isArabic,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (color ?? Colors.blue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color ?? Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewPreview(BuildContext context, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.person, color: Color(0xFF1565C0)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ahmed M.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                isArabic ? 'منذ يومين' : '2 days ago',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'خدمة ممتازة، الفني كان محترفًا ووصل في الموعد.'
                : 'Excellent service! The technician was professional and arrived on time.',
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
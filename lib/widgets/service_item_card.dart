import 'package:flutter/material.dart';
import '../models/models.dart';
import '../l10n/app_localizations.dart';

class ServiceItemCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;
  final bool isArabic;

  const ServiceItemCard({
    super.key,
    required this.service,
    required this.onTap,
    this.isArabic = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr =
        isArabic || Localizations.localeOf(context).languageCode == 'ar';
    final name = isAr ? service.nameAr : service.nameEn;
    final desc = isAr ? service.descriptionAr : service.descriptionEn;

    final categoryColors = {
      'plumbing': const Color(0xFF1565C0),
      'electrical': const Color(0xFFF57F17),
      'finishing': const Color(0xFF7B1FA2),
      'carpentry': const Color(0xFF5D4037),
      'ac': const Color(0xFF0097A7),
      'appliances': const Color(0xFFE65100),
      'pest_control': const Color(0xFFC62828),
      'security': const Color(0xFF37474F),
    };

    final color = categoryColors[service.category] ?? Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getCategoryIcon(service.category),
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (service.rating > 0) ...[
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            service.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (service.isEmergencyAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    service.price.toStringAsFixed(0),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    l10n.translate('egp'),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical':
        return Icons.electrical_services;
      case 'finishing':
        return Icons.format_paint;
      case 'carpentry':
        return Icons.carpenter;
      case 'ac':
        return Icons.ac_unit;
      case 'appliances':
        return Icons.kitchen;
      case 'pest_control':
        return Icons.bug_report;
      case 'security':
        return Icons.videocam;
      default:
        return Icons.home_repair_service;
    }
  }
}
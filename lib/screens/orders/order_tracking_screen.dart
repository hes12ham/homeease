import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/models.dart';
import '../../providers/booking_provider.dart';
import '../../l10n/app_localizations.dart';

class OrderTrackingScreen extends StatelessWidget {
  final BookingModel booking;

  const OrderTrackingScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final steps = [
      _TrackingStep(
        BookingStatus.pending,
        'status_pending',
        Icons.hourglass_top,
      ),
      _TrackingStep(
        BookingStatus.confirmed,
        'status_confirmed',
        Icons.check_circle_outline,
      ),
      _TrackingStep(
        BookingStatus.technicianAssigned,
        'status_assigned',
        Icons.person_pin,
      ),
      _TrackingStep(
        BookingStatus.inProgress,
        'status_in_progress',
        Icons.engineering,
      ),
      _TrackingStep(
        BookingStatus.completed,
        'status_completed',
        Icons.task_alt,
      ),
    ];

    int currentIndex = steps.indexWhere((s) => s.status == booking.status);
    if (currentIndex < 0) currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.translate('order_tracking')} #${booking.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: List.generate(steps.length, (index) {
                  final step = steps[index];
                  final isCompleted = index <= currentIndex;
                  final isCurrent = index == currentIndex;
                  final isLast = index == steps.length - 1;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                              boxShadow: isCurrent
                                  ? [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                                  : null,
                            ),
                            child: Icon(
                              step.icon,
                              size: 18,
                              color: isCompleted ? Colors.white : Colors.grey,
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 40,
                              color: isCompleted && index < currentIndex
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade300,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: isLast ? 0 : 20,
                            top: 6,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.translate(step.titleKey),
                                style: TextStyle(
                                  fontWeight: isCurrent
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: isCurrent ? 16 : 14,
                                  color: isCompleted
                                      ? null
                                      : Colors.grey.shade500,
                                ),
                              ),
                              if (isCurrent)
                                Text(
                                  isAr ? 'الحالة الحالية' : 'Current Status',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'تفاصيل الحجز' : 'Booking Details',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _detailRow(
                    Icons.calendar_today,
                    isAr ? 'التاريخ' : 'Date',
                    DateFormat('EEEE, MMM d, yyyy').format(booking.date),
                  ),
                  _detailRow(
                    Icons.access_time,
                    isAr ? 'الوقت' : 'Time',
                    l10n.translate(booking.timeSlot),
                  ),
                  _detailRow(
                    Icons.location_on,
                    isAr ? 'العنوان' : 'Address',
                    booking.address,
                  ),
                  if (booking.addressDetails.isNotEmpty)
                    _detailRow(
                      Icons.apartment,
                      isAr ? 'تفاصيل إضافية' : 'Details',
                      booking.addressDetails,
                    ),
                  _detailRow(
                    Icons.payment,
                    isAr ? 'طريقة الدفع' : 'Payment',
                    l10n.translate(booking.paymentMethod),
                  ),
                  _detailRow(
                    Icons.attach_money,
                    isAr ? 'الإجمالي' : 'Total',
                    '${booking.totalAmount.toStringAsFixed(0)} ${l10n.translate('egp')}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (booking.status != BookingStatus.cancelled &&
                booking.status != BookingStatus.completed)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      isAr ? 'QR دخول الفني' : 'Technician Check-in QR',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    QrImageView(
                      data: booking.qrCode ?? 'HOMEEASE-${booking.id}',
                      version: QrVersions.auto,
                      size: 160,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAr
                          ? 'اعرض هذا الكود للفني عند الوصول'
                          : 'Show this to the technician on arrival',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_user, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.translate('warranty'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(
                          isAr ? 'الضمان 7 أيام فقط' : '7 days warranty only',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (booking.status == BookingStatus.completed)
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.translate('warranty_claim')),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (booking.status == BookingStatus.pending)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(isAr ? 'إلغاء الحجز؟' : 'Cancel Booking?'),
                        content: Text(
                          isAr
                              ? 'هل أنت متأكد أنك تريد إلغاء هذا الحجز؟'
                              : 'Are you sure you want to cancel this booking?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(l10n.translate('no')),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              await context
                                  .read<BookingProvider>()
                                  .cancelBooking(booking.id);
                              if (context.mounted) {
                                Navigator.pop(ctx);
                                Navigator.pop(context);
                              }
                            },
                            child: Text(l10n.translate('cancel')),
                          ),
                        ],
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text(l10n.translate('cancel')),
                ),
              ),

            if (booking.status == BookingStatus.completed) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.star),
                  label: Text(l10n.translate('rate_service')),
                  onPressed: () {
                    _showRatingDialog(context);
                  },
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    double rating = 5;
    final commentController = TextEditingController();
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(l10n.translate('rate_technician')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                    onPressed: () => setState(() => rating = i + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: l10n.translate('write_review'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.translate('thank_review')),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(l10n.translate('submit_review')),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingStep {
  final BookingStatus status;
  final String titleKey;
  final IconData icon;

  _TrackingStep(this.status, this.titleKey, this.icon);
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/loyalty_provider.dart';
import '../../l10n/app_localizations.dart';
import '../orders/booking_confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'cash';
  bool _usePoints = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final booking = context.watch<BookingProvider>();
    final cart = context.watch<CartProvider>();
    final loyalty = context.watch<LoyaltyProvider>();

    double total = cart.total;
    if (booking.isEmergency) total *= 1.5;

    double discount = 0;
    if (_usePoints && loyalty.points > 0) {
      discount = loyalty.calculateMaxDiscount(total);
    }

    final finalTotal = total - discount;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('payment')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...cart.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.nameEn} x${item.quantity}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Text(
                              '${item.total.toStringAsFixed(0)} ${l10n.translate('egp')}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.translate('subtotal')),
                      Text(
                          '${cart.total.toStringAsFixed(0)} ${l10n.translate('egp')}'),
                    ],
                  ),
                  if (booking.isEmergency) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.translate('emergency_surcharge'),
                          style: const TextStyle(color: Colors.red),
                        ),
                        Text(
                          '+${(cart.total * 0.5).toStringAsFixed(0)} ${l10n.translate('egp')}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                  if (discount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.translate('discount'),
                          style: const TextStyle(color: Colors.green),
                        ),
                        Text(
                          '-${discount.toStringAsFixed(0)} ${l10n.translate('egp')}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.translate('cart_total'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${finalTotal.toStringAsFixed(0)} ${l10n.translate('egp')}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Loyalty Points Toggle
            if (loyalty.points > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate('redeem_points'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${loyalty.points} ${l10n.translate('points')} = ${loyalty.redeemableAmount.toStringAsFixed(0)} ${l10n.translate('egp')}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _usePoints,
                      onChanged: (v) => setState(() => _usePoints = v),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Payment Method
            Text(
              l10n.translate('payment_method'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Cash option
            _buildPaymentOption(
              context,
              icon: Icons.money,
              title: l10n.translate('cash'),
              subtitle: 'Pay when the technician arrives',
              value: 'cash',
            ),
            const SizedBox(height: 8),

            // Card option
            _buildPaymentOption(
              context,
              icon: Icons.credit_card,
              title: l10n.translate('card'),
              subtitle: 'Pay securely with Stripe',
              value: 'card',
            ),
          ],
        ),
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
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : () => _processPayment(context),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      '${l10n.translate('confirm_booking')} · ${finalTotal.toStringAsFixed(0)} ${l10n.translate('egp')}'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final isSelected = _selectedMethod == value;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      tileColor: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
          : null,
      leading: Icon(icon,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: isSelected
          ? Icon(Icons.check_circle,
              color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () => setState(() => _selectedMethod = value),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    setState(() => _isProcessing = true);

    final booking = context.read<BookingProvider>();
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final loyalty = context.read<LoyaltyProvider>();

    booking.setPaymentMethod(_selectedMethod);

    double discount = 0;
    int pointsUsed = 0;
    if (_usePoints && loyalty.points > 0) {
      double total = cart.total;
      if (booking.isEmergency) total *= 1.5;
      discount = loyalty.calculateMaxDiscount(total);
      pointsUsed = (discount * 100).round();
    }

    if (_selectedMethod == 'card') {
      // In production, integrate Stripe payment here
      await Future.delayed(const Duration(seconds: 2));
    }

    final bookingId = await booking.createBooking(
      userId: auth.firebaseUser?.uid ?? 'demo_user',
      services: cart.items,
      totalAmount: cart.total,
      discount: discount,
      loyaltyPointsUsed: pointsUsed,
    );

    if (bookingId != null && mounted) {
      // Add loyalty points
      final earnedPoints = loyalty.calculatePointsEarned(cart.total);
      if (auth.firebaseUser != null) {
        await loyalty.addPoints(auth.firebaseUser?.uid ?? "", cart.total);
      }

      cart.clearCart();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(bookingId: bookingId),
        ),
        (route) => route.isFirst,
      );
    }

    setState(() => _isProcessing = false);
  }
}

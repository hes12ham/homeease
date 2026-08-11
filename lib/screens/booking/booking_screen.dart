import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/booking_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../payment/payment_screen.dart';
import '../map/address_picker_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _addressController = TextEditingController();
  final _addressDetailsController = TextEditingController();
  final _notesController = TextEditingController();
  int _currentStep = 0;

  final List<String> _timeSlots = [
    'morning',
    'afternoon',
    'evening',
  ];

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    if (auth.user?.address.isNotEmpty == true) {
      _addressController.text = auth.user?.address ?? '';
      context.read<BookingProvider>().setAddress(auth.user?.address ?? '');
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _addressDetailsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final booking = context.watch<BookingProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('booking_details')),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0 && booking.selectedDate == null) {
            _showError('Please select a date');
            return;
          }
          if (_currentStep == 1 && booking.selectedTimeSlot == null) {
            _showError('Please select a time slot');
            return;
          }
          if (_currentStep == 2 && _addressController.text.isEmpty) {
            _showError('Please enter your address');
            return;
          }

          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            // Proceed to payment
            booking.setAddress(_addressController.text);
            booking.setAddressDetails(_addressDetailsController.text);
            booking.setNotes(_notesController.text);

            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PaymentScreen()),
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(
                      _currentStep == 2
                          ? l10n.translate('next')
                          : l10n.translate('next'),
                    ),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: Text(l10n.translate('back')),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // Step 1: Select Date
          Step(
            title: Text(l10n.translate('select_date')),
            subtitle: booking.selectedDate != null
                ? Text(DateFormat('EEEE, MMM d, yyyy')
                    .format(booking.selectedDate!))
                : null,
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                if (booking.isEmergency)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bolt, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.translate('emergency_note'),
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                CalendarDatePicker(
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: booking.isEmergency
                      ? DateTime.now()
                      : DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  onDateChanged: (date) {
                    booking.setDate(date);
                  },
                ),
              ],
            ),
          ),

          // Step 2: Select Time Slot
          Step(
            title: Text(l10n.translate('select_time')),
            subtitle: booking.selectedTimeSlot != null
                ? Text(l10n.translate(booking.selectedTimeSlot!))
                : null,
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Column(
              children: _timeSlots.map((slot) {
                final isSelected = booking.selectedTimeSlot == slot;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
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
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.05)
                        : null,
                    leading: Icon(
                      slot == 'morning'
                          ? Icons.wb_sunny
                          : slot == 'afternoon'
                              ? Icons.wb_cloudy
                              : Icons.nights_stay,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    title: Text(l10n.translate(slot)),
                    trailing: isSelected
                        ? Icon(Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () => booking.setTimeSlot(slot),
                  ),
                );
              }).toList(),
            ),
          ),

          // Step 3: Address
          Step(
            title: Text(l10n.translate('enter_address')),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            content: Column(
              children: [
                // Map Picker Button
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.of(context).push<Map<String, dynamic>>(
                      MaterialPageRoute(
                        builder: (_) => const AddressPickerScreen(),
                      ),
                    );
                    if (result != null) {
                      _addressController.text = result['address'] ?? '';
                      _addressDetailsController.text = result['details'] ?? '';
                      booking.setAddress(result['address'] ?? '');
                      booking.setAddressDetails(result['details'] ?? '');
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE0E4E8)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.map, color: Color(0xFF1565C0)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _addressController.text.isEmpty
                                    ? 'اختر العنوان من الخريطة'
                                    : _addressController.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _addressController.text.isEmpty
                                      ? Colors.grey.shade400
                                      : Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (_addressController.text.isEmpty)
                                Text(
                                  'أو حدد موقعك GPS تلقائياً',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                                ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ),
                if (_addressDetailsController.text.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.apartment, size: 16, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _addressDetailsController.text,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF2E7D32)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.translate('notes'),
                    prefixIcon: const Icon(Icons.note_outlined),
                    alignLabelWithHint: true,
                  ),
                  onChanged: (v) => booking.setNotes(v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

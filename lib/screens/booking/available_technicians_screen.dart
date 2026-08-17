import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/booking_request.dart';

class AvailableTechniciansScreen extends StatefulWidget {
  final String category;
  final String categoryName;
  final String serviceName;
  final String serviceId;
  final double basePrice;
  final String address;
  final String city;
  final DateTime date;
  final String timeSlot;
  final String? problemDescription;
  final String? problemImagePath;

  const AvailableTechniciansScreen({
    super.key,
    required this.category,
    required this.categoryName,
    required this.serviceName,
    required this.serviceId,
    required this.basePrice,
    required this.address,
    required this.city,
    required this.date,
    required this.timeSlot,
    this.problemDescription,
    this.problemImagePath,
  });

  @override
  State<AvailableTechniciansScreen> createState() => _State();
}

class _State extends State<AvailableTechniciansScreen> {
  late double _offerPrice;
  String? _sentToTechId;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _offerPrice = widget.basePrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context)),
                  Expanded(
                    child: Column(
                      children: [
                        Text(widget.serviceName,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        Text(widget.timeSlot,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Price adjustment section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Text('حدد سعرك', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Minus button
                      _priceButton(Icons.remove, () {
                        if (_offerPrice > 50) setState(() => _offerPrice -= 10);
                      }),
                      // Price display
                      GestureDetector(
                        onTap: () => _editPriceManually(),
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE0E4E8)),
                          ),
                          child: Column(
                            children: [
                              Text('${_offerPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32))),
                              Text('ج.م', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                      ),
                      // Plus button
                      _priceButton(Icons.add, () {
                        setState(() => _offerPrice += 10);
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('السعر الأساسي: ${widget.basePrice.toStringAsFixed(0)} ج.م',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  // Quick price buttons
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      _quickPrice(widget.basePrice),
                      _quickPrice(widget.basePrice + 50),
                      _quickPrice(widget.basePrice + 100),
                      _quickPrice(widget.basePrice + 150),
                    ],
                  ),
                ],
              ),
            ),

            // Problem description
            if (widget.problemDescription != null && widget.problemDescription!.isNotEmpty)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description, color: Color(0xFFE65100), size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(widget.problemDescription!,
                        style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),

            // Technicians header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  const Text('اختار الفني', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('اضغط "أرسل عرض" للفني', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ),

            // Technicians list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('technician_applications')
                    .where('status', isEqualTo: 'approved')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Filter by category client-side
                  final allTechs = snapshot.data?.docs ?? [];
                  final techs = allTechs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final specs = (data['specializations'] as List<dynamic>?) ?? [];
                    return specs.contains(widget.category);
                  }).toList();
                  debugPrint('🔍 Category: \${widget.category}, Found: \${techs.length} techs (from \${allTechs.length} total)');
                  if (techs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search, size: 56, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text('لا يوجد فنيين متاحين', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: techs.length,
                    itemBuilder: (context, index) {
                      final data = techs[index].data() as Map<String, dynamic>;
                      return _techCard(techs[index].id, data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1565C0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _quickPrice(double price) {
    final isSelected = _offerPrice == price;
    return GestureDetector(
      onTap: () => setState(() => _offerPrice = price),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF1565C0) : const Color(0xFFE0E4E8)),
        ),
        child: Text('${price.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700)),
      ),
    );
  }

  void _editPriceManually() {
    final ctrl = TextEditingController(text: _offerPrice.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('أدخل السعر'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            suffixText: 'ج.م',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final p = double.tryParse(ctrl.text);
              if (p != null && p > 0) setState(() => _offerPrice = p);
              Navigator.pop(ctx);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  Widget _techCard(String techId, Map<String, dynamic> data) {
    final name = data['fullName'] ?? 'فني';
    final rating = (data['rating'] ?? 4.5).toDouble();
    final jobs = data['completedJobs'] ?? 0;
    final address = data['address'] ?? data['city'] ?? '';
    final isSent = _sentToTechId == techId;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSent ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isSent ? Border.all(color: Colors.green, width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE3F2FD),
            child: Text(name.isNotEmpty ? name[0] : '?',
                style: const TextStyle(color: Color(0xFF1565C0), fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                Row(
                  children: [
                    const Icon(Icons.star, size: 13, color: Color(0xFFF59E0B)),
                    Text(' ${rating.toStringAsFixed(1)} ($jobs)',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
                if (address.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 11, color: Colors.grey.shade400),
                      Flexible(child: Text(' $address',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          overflow: TextOverflow.ellipsis)),
                    ],
                  ),
              ],
            ),
          ),
          // Send offer button
          GestureDetector(
            onTap: isSent || _isSending ? null : () => _sendOffer(techId, data),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSent ? Colors.green : const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isSending && _sentToTechId == techId
                  ? const SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Column(
                      children: [
                        Text(isSent ? 'تم ✓' : 'أرسل عرض',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                        if (!isSent)
                          Text('${_offerPrice.toStringAsFixed(0)} ج.م',
                              style: const TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendOffer(String techId, Map<String, dynamic> data) async {
    final auth = context.read<AuthProvider>();
    if (auth.firebaseUser == null) {
      Navigator.of(context).pushNamed('/login');
      return;
    }

    setState(() { _isSending = true; _sentToTechId = techId; });

    try {
      final fees = BookingRequest.calculateFees(_offerPrice);

      await FirebaseFirestore.instance.collection('booking_requests').add({
        'clientId': auth.firebaseUser!.uid,
        'clientName': auth.user?.name ?? 'عميل',
        'clientPhone': auth.user?.phone ?? '',
        'techId': techId,
        'techName': data['fullName'] ?? '',
        'techPhone': data['phone'] ?? '',
        'serviceId': widget.serviceId,
        'serviceName': widget.serviceName,
        'category': widget.category,
        'address': widget.address,
        'city': widget.city,
        'date': Timestamp.fromDate(widget.date),
        'timeSlot': widget.timeSlot,
        'problemDescription': widget.problemDescription ?? '',
        'basePrice': widget.basePrice,
        'offerPrice': _offerPrice,
        'agreedPrice': null,
        'appFee': fees['appFee'],
        'techReceives': fees['techReceives'],
        'status': 'pending_tech_response',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إرسال عرض ${_offerPrice.toStringAsFixed(0)} ج.م للفني ${data['fullName']}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }

    setState(() => _isSending = false);
  }
}

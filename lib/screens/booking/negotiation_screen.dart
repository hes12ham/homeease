import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/booking_request.dart';

class NegotiationScreen extends StatefulWidget {
  final String requestId;
  const NegotiationScreen({super.key, required this.requestId});

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen> {
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isClient = auth.firebaseUser != null;

    return Scaffold(
      appBar: AppBar(title: const Text('التفاوض على السعر')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('booking_requests')
            .doc(widget.requestId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: CircularProgressIndicator());
          }

          final request = BookingRequest.fromFirestore(snapshot.data!);
          final myId = auth.firebaseUser?.uid ?? '';
          final amClient = myId == request.clientId;
          final amTech = myId == request.techId;

          return Column(
            children: [
              // Service Info
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(request.serviceName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        _statusBadge(request.status),
                      ],
                    ),
                    const Divider(height: 20),
                    _infoRow('الفني', request.techName),
                    _infoRow('السعر المبدئي', '${request.basePrice.toStringAsFixed(0)} ج.م'),
                    _infoRow('السعر الحالي', '${request.currentPrice.toStringAsFixed(0)} ج.م'),
                    if (request.agreedPrice != null) ...[
                      const Divider(height: 20),
                      _infoRow('السعر المتفق عليه', '${request.agreedPrice!.toStringAsFixed(0)} ج.م'),
                      _infoRow('نسبة التطبيق (10%)', '${request.appFee?.toStringAsFixed(0) ?? "0"} ج.م'),
                      _infoRow('الفني يستلم', '${request.techReceives?.toStringAsFixed(0) ?? "0"} ج.م'),
                    ],
                  ],
                ),
              ),

              // Offers timeline
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: request.offers.length,
                  itemBuilder: (context, index) {
                    final offer = request.offers[index];
                    final isMe = (amClient && offer.from == 'client') || (amTech && offer.from == 'tech');

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFF1565C0) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.from == 'client' ? '👤 العميل' : '🔧 الفني',
                              style: TextStyle(
                                fontSize: 12,
                                color: isMe ? Colors.white70 : Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${offer.price.toStringAsFixed(0)} ج.م',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: isMe ? Colors.white : const Color(0xFF1565C0),
                              ),
                            ),
                            if (offer.accepted)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text('✅ تم الموافقة',
                                    style: TextStyle(color: isMe ? Colors.greenAccent : Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Actions
              if (request.status != 'agreed' && request.status != 'completed' && request.status != 'cancelled')
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -4))],
                  ),
                  child: Column(
                    children: [
                      // Accept current price
                      if (request.offers.isNotEmpty && request.lastOffer!.from != (amClient ? 'client' : 'tech'))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle),
                              label: Text('موافق على ${request.currentPrice.toStringAsFixed(0)} ج.م'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () => _acceptPrice(request),
                            ),
                          ),
                        ),

                      // Counter offer
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'اكتب سعرك...',
                                suffixText: 'ج.م',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _sendOffer(request, amClient),
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
                            child: const Icon(Icons.send),
                          ),
                        ],
                      ),

                      // Cancel
                      TextButton(
                        onPressed: () => _cancelRequest(request),
                        child: const Text('إلغاء الطلب', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),

              // Agreed state
              if (request.status == 'agreed')
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFFE8F5E9),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 10),
                      const Text('تم الاتفاق على السعر! ✅', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('السعر النهائي: ${request.agreedPrice?.toStringAsFixed(0)} ج.م',
                          style: const TextStyle(fontSize: 16)),
                      Text('نسبة التطبيق: ${request.appFee?.toStringAsFixed(0)} ج.م (10%)',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final colors = {
      'pending': Colors.orange,
      'negotiating': Colors.blue,
      'agreed': Colors.green,
      'cancelled': Colors.red,
    };
    final labels = {
      'pending': 'بانتظار الرد',
      'negotiating': 'جاري التفاوض',
      'agreed': 'تم الاتفاق',
      'cancelled': 'ملغي',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (colors[status] ?? Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(labels[status] ?? status,
          style: TextStyle(color: colors[status] ?? Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Future<void> _sendOffer(BookingRequest request, bool amClient) async {
    final priceText = _priceController.text.trim();
    if (priceText.isEmpty) return;
    final price = double.tryParse(priceText);
    if (price == null || price <= 0) return;

    await FirebaseFirestore.instance
        .collection('booking_requests')
        .doc(widget.requestId)
        .update({
      'offers': FieldValue.arrayUnion([
        PriceOffer(from: amClient ? 'client' : 'tech', price: price, timestamp: DateTime.now()).toMap()
      ]),
      'status': 'negotiating',
    });
    _priceController.clear();
  }

  Future<void> _acceptPrice(BookingRequest request) async {
    final fees = BookingRequest.calculateFees(request.currentPrice);

    await FirebaseFirestore.instance
        .collection('booking_requests')
        .doc(widget.requestId)
        .update({
      'agreedPrice': request.currentPrice,
      'appFee': fees['appFee'],
      'techReceives': fees['techReceives'],
      'status': 'agreed',
      'offers': FieldValue.arrayUnion([
        PriceOffer(from: 'system', price: request.currentPrice, timestamp: DateTime.now(), accepted: true).toMap()
      ]),
    });
  }

  Future<void> _cancelRequest(BookingRequest request) async {
    await FirebaseFirestore.instance
        .collection('booking_requests')
        .doc(widget.requestId)
        .update({'status': 'cancelled'});
    if (mounted) Navigator.of(context).pop();
  }
}

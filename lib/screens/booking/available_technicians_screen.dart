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
  State<AvailableTechniciansScreen> createState() => _AvailableTechniciansScreenState();
}

class _AvailableTechniciansScreenState extends State<AvailableTechniciansScreen> {
  String? _acceptedTechId;
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(widget.serviceName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        Text('${widget.basePrice.toStringAsFixed(0)} ج.م · ${widget.timeSlot}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${widget.basePrice.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),

            // Problem description card (if provided)
            if (widget.problemDescription != null && widget.problemDescription!.isNotEmpty)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description, color: Color(0xFFE65100), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(widget.problemDescription!,
                          style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Text('الفنيين المتاحين',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Icon(Icons.sort, size: 18, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text('الأقرب', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),

            // Technicians list (InDrive style)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('technician_applications')
                    .where('status', isEqualTo: 'approved')
                    .where('specializations', arrayContains: widget.category)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final techs = snapshot.data?.docs ?? [];

                  if (techs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text('لا يوجد فنيين متاحين حالياً',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text('جرّب تاني بعد شوية', style: TextStyle(color: Colors.grey.shade500)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: techs.length,
                    itemBuilder: (context, index) {
                      final data = techs[index].data() as Map<String, dynamic>;
                      return _buildTechCard(context, techs[index].id, data);
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

  // InDrive-style technician card
  Widget _buildTechCard(BuildContext context, String techId, Map<String, dynamic> data) {
    final name = data['fullName'] ?? 'فني';
    final rating = (data['rating'] ?? 4.5).toDouble();
    final jobs = data['completedJobs'] ?? 0;
    final address = data['address'] ?? data['city'] ?? '';
    final experience = data['experience'] ?? '';
    final photoUrl = data['profilePhotoUrl'] as String?;
    final isAccepted = _acceptedTechId == techId;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isAccepted ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isAccepted ? Border.all(color: Colors.green, width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
      ),
      child: Row(
        children: [
          // Photo
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFE3F2FD),
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Text(name.isNotEmpty ? name[0] : '?',
                    style: const TextStyle(color: Color(0xFF1565C0), fontSize: 20, fontWeight: FontWeight.bold))
                : null,
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                    Text(' ${rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12)),
                    Text(' ($jobs)', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
                if (address.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(address,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Price + buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Price
              Text('${widget.basePrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32))),
              Text('ج.م', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              const SizedBox(height: 8),
              // Accept / Decline buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decline
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('رفض', style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Accept
                  GestureDetector(
                    onTap: _isRequesting ? null : () => _acceptTech(context, techId, data),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isAccepted ? Colors.green : const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _isRequesting && _acceptedTechId == techId
                          ? const SizedBox(width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(isAccepted ? 'تم ✓' : 'قبول',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _acceptTech(BuildContext context, String techId, Map<String, dynamic> data) async {
    final auth = context.read<AuthProvider>();
    if (auth.firebaseUser == null) {
      Navigator.of(context).pushNamed('/login');
      return;
    }

    setState(() { _isRequesting = true; _acceptedTechId = techId; });

    try {
      final fees = BookingRequest.calculateFees(widget.basePrice);

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
        'problemImagePath': widget.problemImagePath ?? '',
        'basePrice': widget.basePrice,
        'agreedPrice': widget.basePrice,
        'appFee': fees['appFee'],
        'techReceives': fees['techReceives'],
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text('تم تأكيد الطلب! ✅',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('الفني ${data['fullName']} هيتواصل معاك قريب',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text('السعر: ${widget.basePrice.toStringAsFixed(0)} ج.م',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('نسبة التطبيق: ${fees['appFee']?.toStringAsFixed(0)} ج.م (10%)',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('تم'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حصل خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }

    setState(() => _isRequesting = false);
  }
}

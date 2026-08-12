import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/booking_request.dart';
import 'negotiation_screen.dart';

class AvailableTechniciansScreen extends StatelessWidget {
  final String category;
  final String categoryName;
  final String serviceName;
  final String serviceId;
  final double basePrice;
  final String address;
  final String city;
  final DateTime date;
  final String timeSlot;

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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('فنيين $categoryName المتاحين')),
      body: Column(
        children: [
          // Service info card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF1565C0)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serviceName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      Text('السعر المبدئي: ${basePrice.toStringAsFixed(0)} ج.م',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Technicians list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('technician_applications')
                  .where('status', isEqualTo: 'approved')
                  .where('specializations', arrayContains: category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final techs = snapshot.data?.docs ?? [];

                if (techs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text('لا يوجد فنيين متاحين حالياً',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text('جرّب تاني بعد شوية',
                              style: TextStyle(color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: techs.length,
                  itemBuilder: (context, index) {
                    final data = techs[index].data() as Map<String, dynamic>;
                    final techName = data['fullName'] ?? 'فني';
                    final phone = data['phone'] ?? '';
                    final experience = data['experience'] ?? '';
                    final rating = (data['rating'] ?? 4.5).toDouble();
                    final completedJobs = data['completedJobs'] ?? 0;
                    final age = data['age'] ?? '';
                    final address = data['address'] ?? data['governorate'] ?? '';
                    final photoUrl = data['profilePhotoUrl'] as String?;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xFFE3F2FD),
                                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                                  child: photoUrl == null
                                      ? Text(techName.isNotEmpty ? techName[0] : '?',
                                          style: const TextStyle(color: Color(0xFF1565C0), fontSize: 22, fontWeight: FontWeight.bold))
                                      : null,
                                ),
                                const SizedBox(width: 14),
                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(techName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                                          Text(' ${rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 13)),
                                          Text('  ·  $completedJobs مهمة', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                        ],
                                      ),
                                      if (experience.isNotEmpty)
                                        Text('خبرة: $experience', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                    ],
                                  ),
                                ),
                                // Price
                                Column(
                                  children: [
                                    Text('${basePrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1565C0))),
                                    Text('ج.م', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Request button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _sendRequest(context, techs[index].id, techName, phone),
                                child: const Text('اطلب الفني ده'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendRequest(BuildContext context, String techId, String techName, String techPhone) async {
    final auth = context.read<AuthProvider>();
    if (auth.firebaseUser == null) {
      Navigator.of(context).pushNamed('/login');
      return;
    }

    // Create booking request
    final request = BookingRequest(
      id: '',
      clientId: auth.firebaseUser!.uid,
      clientName: auth.user?.name ?? 'عميل',
      clientPhone: auth.user?.phone ?? '',
      techId: techId,
      techName: techName,
      serviceId: serviceId,
      serviceName: serviceName,
      category: category,
      address: address,
      city: city,
      date: date,
      timeSlot: timeSlot,
      basePrice: basePrice,
      offers: [PriceOffer(from: 'client', price: basePrice, timestamp: DateTime.now())],
      status: 'pending',
    );

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('booking_requests')
          .add(request.toMap());

      if (context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => NegotiationScreen(requestId: docRef.id),
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حصل خطأ: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

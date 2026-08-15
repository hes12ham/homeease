import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';

class TechMainScreen extends StatefulWidget {
  const TechMainScreen({super.key});

  @override
  State<TechMainScreen> createState() => _TechMainScreenState();
}

class _TechMainScreenState extends State<TechMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        _buildOrdersTab(),
        _buildProfileTab(),
      ][_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'الطلبات',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }

  // ===== ORDERS TAB =====
  Widget _buildOrdersTab() {
    final auth = context.watch<AuthProvider>();
    final techPhone = auth.user?.phone ?? '';

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF0D47A1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white24,
                  child: Text(
                    (auth.user?.name ?? '?')[0],
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('أهلاً، ${auth.user?.name ?? 'فني'} 👋',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      const Text('لوحة تحكم الفني',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.greenAccent),
                      SizedBox(width: 4),
                      Text('متاح', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab header
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: Row(
              children: [
                Text('الطلبات الواردة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),

          // Orders list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('booking_requests')
                  .where('techPhone', isEqualTo: techPhone)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Also check by techId
                final orders = snapshot.data?.docs ?? [];

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text('لا توجد طلبات حالياً', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text('الطلبات هتظهر هنا لما عميل يبعتلك عرض',
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final data = orders[index].data() as Map<String, dynamic>;
                    return _buildOrderCard(orders[index].id, data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(String orderId, Map<String, dynamic> data) {
    final status = data['status'] ?? 'pending';
    final statusLabels = {
      'pending_tech_response': 'في انتظار ردك',
      'confirmed': 'مؤكد',
      'inProgress': 'جاري التنفيذ',
      'completed': 'مكتمل',
      'cancelled': 'ملغي',
    };
    final statusColors = {
      'pending_tech_response': Colors.orange,
      'confirmed': Colors.blue,
      'inProgress': Colors.blue,
      'completed': Colors.green,
      'cancelled': Colors.red,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service + Status
          Row(
            children: [
              Expanded(
                child: Text(data['serviceName'] ?? 'خدمة',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (statusColors[status] ?? Colors.grey).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(statusLabels[status] ?? status,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                        color: statusColors[status] ?? Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Client + Price
          Row(
            children: [
              Icon(Icons.person, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(data['clientName'] ?? '', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              const Spacer(),
              Text('${(data['offerPrice'] ?? data['basePrice'] ?? 0).toStringAsFixed(0)} ج.م',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF2E7D32))),
            ],
          ),
          const SizedBox(height: 6),

          // Address
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Flexible(child: Text(data['address'] ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  overflow: TextOverflow.ellipsis)),
            ],
          ),

          // Problem description
          if (data['problemDescription'] != null && (data['problemDescription'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description, size: 14, color: Color(0xFFE65100)),
                  const SizedBox(width: 6),
                  Flexible(child: Text(data['problemDescription'],
                      style: const TextStyle(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Action buttons
          if (status == 'pending_tech_response')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectOrder(orderId),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('رفض'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptOrder(orderId, data),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('قبول'),
                  ),
                ),
              ],
            ),

          if (status == 'confirmed')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('اتصل بالعميل'),
                    onPressed: () {
                      final phone = data['clientPhone'] ?? '';
                      if (phone.isNotEmpty) {
                        // launchUrl for phone
                      }
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _acceptOrder(String orderId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('booking_requests').doc(orderId).update({
      'status': 'confirmed',
      'agreedPrice': data['offerPrice'] ?? data['basePrice'],
    });
  }

  Future<void> _rejectOrder(String orderId) async {
    await FirebaseFirestore.instance.collection('booking_requests').doc(orderId).update({
      'status': 'cancelled',
    });
  }

  // ===== PROFILE TAB =====
  Widget _buildProfileTab() {
    final auth = context.watch<AuthProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: const Color(0xFF1565C0),
              child: Text(
                (auth.user?.name ?? '?')[0],
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),
            Text(auth.user?.name ?? 'فني', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            Text(auth.user?.phone ?? '', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 24),

            // Stats
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('booking_requests')
                  .where('techPhone', isEqualTo: auth.user?.phone ?? '')
                  .snapshots(),
              builder: (context, snapshot) {
                final orders = snapshot.data?.docs ?? [];
                final completed = orders.where((d) => (d.data() as Map)['status'] == 'completed').length;
                final earnings = orders
                    .where((d) => (d.data() as Map)['status'] == 'completed')
                    .fold<double>(0, (sum, d) => sum + ((d.data() as Map)['agreedPrice'] ?? 0).toDouble() * 0.9);

                return Row(
                  children: [
                    _statCard('الطلبات', '${orders.length}', Icons.assignment, Colors.blue),
                    _statCard('مكتملة', '$completed', Icons.check_circle, Colors.green),
                    _statCard('الأرباح', '${earnings.toStringAsFixed(0)}', Icons.account_balance_wallet, Colors.orange),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Menu items
            _menuItem(Icons.edit, 'تعديل البيانات', () {}),
            _menuItem(Icons.star, 'تقييماتي', () {}),
            _menuItem(Icons.help_outline, 'الدعم الفني', () {}),
            _menuItem(Icons.logout, 'تسجيل الخروج', () async {
              await auth.signOut();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/role', (route) => false);
              }
            }, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          leading: Icon(icon, color: color ?? const Color(0xFF1565C0)),
          title: Text(label, style: TextStyle(color: color)),
          trailing: const Icon(Icons.chevron_right, size: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onTap: onTap,
        ),
      ),
    );
  }
}

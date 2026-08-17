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
    final techUid = auth.firebaseUser?.uid ?? '';

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
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Also check by techId
                var orders = snapshot.data?.docs ?? [];
                // Filter by tech phone or tech ID
                orders = orders.where((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  return d['techPhone'] == techPhone || d['techId'] == techUid;
                }).toList();
                // Sort by creation date
                orders.sort((a, b) {
                  final aTime = (a.data() as Map)['createdAt'] as Timestamp?;
                  final bTime = (b.data() as Map)['createdAt'] as Timestamp?;
                  return (bTime?.millisecondsSinceEpoch ?? 0).compareTo(aTime?.millisecondsSinceEpoch ?? 0);
                });

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
            CircleAvatar(
              radius: 45,
              backgroundColor: const Color(0xFF1565C0),
              child: Text(
                (auth.user?.name ?? '?').isNotEmpty ? (auth.user?.name ?? '?')[0] : '?',
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14),
            Text(auth.user?.name ?? 'فني', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            Text(auth.user?.phone ?? '', style: TextStyle(color: Colors.grey.shade600)),
            Text(auth.user?.email ?? '', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            const SizedBox(height: 24),

            // Stats - clickable
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('booking_requests').snapshots(),
              builder: (context, snapshot) {
                final allDocs = snapshot.data?.docs ?? [];
                final uid = auth.firebaseUser?.uid ?? '';
                final phone = auth.user?.phone ?? '';
                final myOrders = allDocs.where((doc) {
                  final d = doc.data() as Map<String, dynamic>;
                  return d['techPhone'] == phone || d['techId'] == uid;
                }).toList();
                
                final pending = myOrders.where((d) => (d.data() as Map)['status'] == 'pending_tech_response').toList();
                final confirmed = myOrders.where((d) => (d.data() as Map)['status'] == 'confirmed').toList();
                final completed = myOrders.where((d) => (d.data() as Map)['status'] == 'completed').toList();
                final earnings = completed.fold<double>(0, (sum, d) => sum + ((d.data() as Map)['agreedPrice'] ?? 0).toDouble() * 0.9);

                return Column(
                  children: [
                    Row(
                      children: [
                        _statCard('طلبات واردة', '${pending.length}', Icons.notifications, Colors.orange,
                            () => _showOrdersList(context, 'طلبات واردة', pending)),
                        _statCard('مؤكدة', '${confirmed.length}', Icons.check_circle, Colors.blue,
                            () => _showOrdersList(context, 'طلبات مؤكدة', confirmed)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _statCard('مكتملة', '${completed.length}', Icons.done_all, Colors.green,
                            () => _showOrdersList(context, 'طلبات مكتملة', completed)),
                        _statCard('الأرباح', '${earnings.toStringAsFixed(0)} ج.م', Icons.account_balance_wallet, const Color(0xFFE65100), null),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Menu items
            _menuItem(Icons.edit, 'تعديل البيانات', () => _showEditProfile(context)),
            _menuItem(Icons.lock_outline, 'تغيير كلمة المرور', () => _showChangePassword(context)),
            _menuItem(Icons.star_outline, 'تقييماتي', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('التقييمات قريباً'), behavior: SnackBarBehavior.floating));
            }),
            _menuItem(Icons.help_outline, 'الدعم الفني', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تواصل معنا: 01000000000'), behavior: SnackBarBehavior.floating));
            }),
            _menuItem(Icons.info_outline, 'عن التطبيق', () {
              showAboutDialog(
                context: context,
                applicationName: 'Home Service',
                applicationVersion: '1.0.0',
                children: [const Text('تطبيق خدمات منزلية — نسبة التطبيق 10% من كل طلب')],
              );
            }),
            const SizedBox(height: 8),
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

  void _showOrdersList(BuildContext context, String title, List<QueryDocumentSnapshot> orders) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: orders.isEmpty
                  ? Center(child: Text('لا توجد طلبات', style: TextStyle(color: Colors.grey.shade500)))
                  : ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: orders.length,
                      itemBuilder: (_, i) {
                        final d = orders[i].data() as Map<String, dynamic>;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(d['serviceName'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700))),
                                  Text('${(d['offerPrice'] ?? d['basePrice'] ?? 0).toStringAsFixed(0)} ج.م',
                                      style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2E7D32))),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('👤 ${d['clientName'] ?? ''}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                              Text('📍 ${d['address'] ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                              if (d['problemDescription'] != null && (d['problemDescription'] as String).isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text('📋 ${d['problemDescription']}',
                                      style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final nameCtrl = TextEditingController(text: auth.user?.name ?? '');
    final phoneCtrl = TextEditingController(text: auth.user?.phone ?? '');
    final addressCtrl = TextEditingController(text: auth.user?.address ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تعديل البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'الاسم', prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'الموبايل', prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 12),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'العنوان', prefixIcon: Icon(Icons.location_on))),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await auth.updateProfile(
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    address: addressCtrl.text.trim(),
                  );
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تحديث البيانات ✅'), backgroundColor: Colors.green));
                  }
                },
                child: const Text('حفظ التعديلات'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تغيير كلمة المرور', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(controller: currentCtrl, obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور الحالية', prefixIcon: Icon(Icons.lock))),
            const SizedBox(height: 12),
            TextField(controller: newCtrl, obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور الجديدة', prefixIcon: Icon(Icons.lock_outline))),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تغيير كلمة المرور ✅'), backgroundColor: Colors.green));
                },
                child: const Text('تغيير'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _statCard(String label, String value, IconData icon, Color color, VoidCallback? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
              FittedBox(child: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color))),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
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

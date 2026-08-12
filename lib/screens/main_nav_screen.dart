import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import 'home/home_screen.dart';
import 'orders/orders_list_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
import 'auth/login_screen_v2.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().items.length;
    bool isLoggedIn = false;
    try {
      isLoggedIn = context.watch<AuthProvider>().firebaseUser != null;
    } catch (_) {}

    return Scaffold(
      // ALL tabs accessible - no login blocking
      body: _buildBody(isLoggedIn),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'طلباتي',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'السلة',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(bool isLoggedIn) {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return isLoggedIn ? const OrdersListScreen() : _loginPrompt('شوف طلباتك السابقة والحالية');
      case 2:
        return const CartScreen(); // Cart always accessible
      case 3:
        return isLoggedIn ? const ProfileScreen() : _loginPrompt('ادخل على حسابك وعدّل بياناتك');
      default:
        return const HomeScreen();
    }
  }

  Widget _loginPrompt(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.lock_outline, size: 40, color: Color(0xFF1565C0)),
            ),
            const SizedBox(height: 20),
            const Text('سجّل دخولك',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(message,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('تسجيل الدخول'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

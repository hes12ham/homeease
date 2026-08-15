import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'technician/tech_main_screen.dart';
import 'main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    // If already logged in, route based on role
    try {
      final auth = context.read<AuthProvider>();
      if (auth.firebaseUser != null) {
        // Wait for user data to load
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        
        if (auth.user?.role == 'technician') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const TechMainScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavScreen()),
          );
        }
        return;
      }
    } catch (_) {}
    
    Navigator.of(context).pushReplacementNamed('/role');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1), Color(0xFF1A237E)],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.home_repair_service_rounded,
                      size: 60, color: Color(0xFF1565C0)),
                ),
                const SizedBox(height: 30),
                const Text('خدمات منزلية',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold,
                      color: Colors.white, letterSpacing: 2)),
                const SizedBox(height: 4),
                const Text('Home Service',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300,
                      color: Colors.white70, letterSpacing: 3)),
                const SizedBox(height: 8),
                Text('صلّح وركّب أي حاجة في بيتك',
                  style: TextStyle(fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.7))),
                const SizedBox(height: 60),
                const SizedBox(
                  width: 30, height: 30,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

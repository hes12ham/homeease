import 'package:flutter/material.dart';
import '../main_nav_screen.dart';
import '../technician/tech_registration_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.home_repair_service,
                    size: 52, color: Colors.white),
              ),
              const SizedBox(height: 20),

              const Text('هوم إيز',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: 1)),
              const SizedBox(height: 6),
              Text('خدمات منزلية بكل سهولة',
                style: TextStyle(fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7))),

              const Spacer(flex: 2),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('أنت عايز تستخدم التطبيق كـ...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,
                      color: Colors.white),
                  textAlign: TextAlign.center),
              ),
              const SizedBox(height: 24),

              // Client Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _RoleCard(
                  icon: Icons.person,
                  emoji: '👤',
                  title: 'عميل',
                  subtitle: 'تصفّح الخدمات واحجز صيانة لبيتك',
                  color: Colors.white,
                  textColor: const Color(0xFF1565C0),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainNavScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // Technician Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _RoleCard(
                  icon: Icons.build,
                  emoji: '🔧',
                  title: 'فني',
                  subtitle: 'سجّل كفني وابدأ استقبال طلبات الشغل',
                  color: Colors.white.withValues(alpha: 0.15),
                  textColor: Colors.white,
                  borderColor: Colors.white.withValues(alpha: 0.3),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const TechRegistrationScreen()),
                    );
                  },
                ),
              ),

              const Spacer(flex: 3),

              // Language toggle
              TextButton(
                onPressed: () {},
                child: Text('English ↔ العربية',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.5)
              : null,
          boxShadow: borderColor == null
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20, offset: const Offset(0, 8))]
              : null,
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
                        color: textColor)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                    style: TextStyle(fontSize: 13,
                        color: textColor.withValues(alpha: 0.7))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: textColor, size: 18),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/loyalty_provider.dart';
import '../../l10n/app_localizations.dart';
import '../auth/login_screen_v2.dart';
import 'support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthProvider>();
    
    // Show login prompt if not logged in
    if (auth.firebaseUser == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
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
                    child: const Icon(Icons.person_outline, size: 40, color: Color(0xFF1565C0)),
                  ),
                  const SizedBox(height: 20),
                  const Text('حسابي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('سجّل دخولك عشان تشوف بيانات حسابك',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('تسجيل الدخول'),
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final theme = context.watch<ThemeProvider>();
    final locale = context.watch<LocaleProvider>();
    final loyalty = context.watch<LoyaltyProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('profile')),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      (user?.name.isNotEmpty == true)
                          ? (user?.name.isNotEmpty == true ? (user?.name ?? '?')[0].toUpperCase() : '؟')
                          : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Guest',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  if (user?.phone.isNotEmpty == true) ...[
                    const SizedBox(height: 2),
                    Text(
                      user?.phone ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Loyalty Points Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.stars, color: Colors.amber, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.translate('loyalty_points'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${loyalty.points} ${l10n.translate('points')}',
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '= ${loyalty.redeemableAmount.toStringAsFixed(0)} ${l10n.translate('egp')} ${l10n.translate('discount')}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Section
            _sectionTitle(l10n.translate('settings')),
            const SizedBox(height: 8),

            // Dark Mode Toggle
            _settingsTile(
              context,
              icon: Icons.dark_mode_outlined,
              title: l10n.translate('dark_mode'),
              trailing: Switch(
                value: theme.isDarkMode,
                onChanged: (_) => theme.toggleTheme(),
              ),
            ),

            // Language Toggle
            _settingsTile(
              context,
              icon: Icons.language,
              title: l10n.translate('language'),
              trailing: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'en', label: Text('EN')),
                  ButtonSegment(value: 'ar', label: Text('AR')),
                ],
                selected: {locale.locale.languageCode},
                onSelectionChanged: (s) => locale.toggleLocale(),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Account Section
            _sectionTitle(l10n.translate('profile')),
            const SizedBox(height: 8),

            _settingsTile(
              context,
              icon: Icons.person_outline,
              title: l10n.translate('edit_profile'),
              onTap: () => _showEditProfileDialog(context),
            ),

            _settingsTile(
              context,
              icon: Icons.location_on_outlined,
              title: l10n.translate('enter_address'),
              subtitle: user?.address,
              onTap: () => _showEditAddressDialog(context),
            ),

            _settingsTile(
              context,
              icon: Icons.support_agent,
              title: l10n.translate('support'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SupportScreen()),
                );
              },
            ),

            _settingsTile(
              context,
              icon: Icons.info_outline,
              title: l10n.translate('about'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Home Service',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2026 Home Service. All rights reserved.',
                );
              },
            ),

            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(
                  l10n.translate('logout'),
                  style: const TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.translate('logout')),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.translate('cancel')),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.translate('logout')),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final nameCtrl = TextEditingController(text: auth.user?.name ?? '');
    final phoneCtrl = TextEditingController(text: auth.user?.phone ?? '');
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.translate('edit_profile')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.translate('name'),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(
                labelText: l10n.translate('phone'),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.updateProfile(
                name: nameCtrl.text,
                phone: phoneCtrl.text,
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.translate('save')),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final addrCtrl = TextEditingController(text: auth.user?.address ?? '');
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.translate('enter_address')),
        content: TextField(
          controller: addrCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: l10n.translate('enter_address'),
            prefixIcon: const Icon(Icons.location_on_outlined),
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              await auth.updateProfile(address: addrCtrl.text);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.translate('save')),
          ),
        ],
      ),
    );
  }
}

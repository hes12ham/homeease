import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/services_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/loyalty_provider.dart';
import 'providers/chat_provider.dart';
import 'app.dart';
import 'utils/seed_test_technicians.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized');

    // 2. Seed test technicians (runs once)
    await TestDataSeeder.seedTechnicians();
  } catch (e) {
    debugPrint('⚠️ Firebase/Seed error: $e');
  }

  // 3. Load preferences
  final themeProvider = ThemeProvider();
  try { await themeProvider.loadTheme(); } catch (_) {}

  final localeProvider = LocaleProvider();
  try { await localeProvider.loadLocale(); } catch (_) {}

  // 4. Run app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider(create: (_) => LoyaltyProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Builder(
        builder: (context) {
          // Load saved cart on startup
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try { Provider.of<CartProvider>(context, listen: false).loadCart(); } catch (_) {}
          });
          return const HomeServiceApp();
        },
      ),
    ),
  );
}

# HomeEase — Egyptian Home Services Booking App

A complete Flutter/Firebase mobile application for booking home maintenance and repair services in Egypt, inspired by "Fi El Khedma" with modern enhancements.

## Features

### Core
- **8 Service Categories**: Plumbing, Electrical, Cleaning, Painting, Carpentry, AC, Appliances, Pest Control
- **Booking Flow**: Browse → Cart → Date/Time → Address → Payment → Confirmation
- **Order Tracking**: Real-time status timeline (Pending → Confirmed → Assigned → In Progress → Completed)
- **QR Check-in**: Generated QR code for technician verification on arrival

### Payments & Loyalty
- **Cash & Card**: Cash on delivery + Stripe card integration
- **Loyalty Points**: Earn 1pt/EGP spent, redeem 100pts = 1 EGP discount (max 20% per order)
- **Emergency Booking**: Same-day service with 50% surcharge

### User Experience
- **Bilingual**: Full Arabic & English support with RTL layout
- **Dark Mode**: System-aware + manual toggle, persisted locally
- **AI Recommendations**: Suggested services based on booking history
- **Chat Support**: Real-time Firebase chat with support team
- **Hotline**: Direct-dial support numbers
- **30-day Warranty**: Warranty claims from order tracking

### Admin Dashboard (HTML)
- Login-protected Bootstrap dashboard
- CRUD for Services, Technicians, Bookings
- Analytics: revenue charts, category breakdown, completion rate
- Booking status management

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| State Management | Provider |
| Backend | Firebase (Auth, Firestore, FCM, Storage) |
| Payments | Stripe (Flutter Stripe SDK) |
| Auth | Email/Password, Google Sign-In, Phone OTP |
| QR Codes | qr_flutter / mobile_scanner |
| Localization | Custom AppLocalizations (EN/AR) |
| Admin | Standalone HTML + Bootstrap 5 |

---

## Project Structure

```
homeease/
├── lib/
│   ├── main.dart                    # Entry point, Firebase init
│   ├── app.dart                     # MaterialApp, themes, routes
│   ├── firebase_options.dart        # Firebase config (placeholder)
│   ├── models/
│   │   └── models.dart              # All data models
│   ├── l10n/
│   │   └── app_localizations.dart   # EN/AR translations (~100 keys)
│   ├── providers/
│   │   ├── auth_provider.dart       # Auth (email, Google, phone OTP)
│   │   ├── services_provider.dart   # Services + AI recommendations
│   │   ├── cart_provider.dart       # Shopping cart
│   │   ├── booking_provider.dart    # Booking form + Firestore
│   │   ├── theme_provider.dart      # Dark/light mode
│   │   ├── locale_provider.dart     # AR/EN toggle
│   │   ├── loyalty_provider.dart    # Points system
│   │   └── chat_provider.dart       # Support chat
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── main_nav_screen.dart     # Bottom nav (Home, Orders, Cart, Profile)
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart     # Categories grid, search, emergency
│   │   ├── services/
│   │   │   ├── category_services_screen.dart
│   │   │   └── service_details_screen.dart
│   │   ├── cart/
│   │   │   └── cart_screen.dart
│   │   ├── booking/
│   │   │   └── booking_screen.dart  # 3-step stepper
│   │   ├── payment/
│   │   │   └── payment_screen.dart
│   │   ├── orders/
│   │   │   ├── orders_list_screen.dart
│   │   │   ├── order_tracking_screen.dart
│   │   │   └── booking_confirmation_screen.dart
│   │   └── profile/
│   │       ├── profile_screen.dart
│   │       └── support_screen.dart  # Chat + FAQ + hotline
│   └── widgets/
│       ├── service_category_card.dart
│       └── service_item_card.dart
├── admin/
│   └── index.html                   # Admin dashboard
├── firestore.rules                  # Security rules
├── pubspec.yaml
└── README.md
```

---

## Setup Instructions

### 1. Prerequisites
- Flutter SDK 3.x+ installed
- Firebase CLI (`npm install -g firebase-tools`)
- A Firebase project created at [console.firebase.google.com](https://console.firebase.google.com)

### 2. Firebase Configuration

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure (run from project root)
flutterfire configure --project=YOUR_PROJECT_ID
```

This generates `lib/firebase_options.dart` with your real keys. Replace the placeholder file.

**Enable in Firebase Console:**
- Authentication → Email/Password, Google, Phone
- Cloud Firestore → Create database (start in test mode, then deploy rules)
- Cloud Messaging → Enable FCM
- Storage → Enable (for future profile photos)

### 3. Deploy Firestore Rules

```bash
firebase deploy --only firestore:rules
```

### 4. Stripe Setup (Optional)
1. Create a Stripe account at [stripe.com](https://stripe.com)
2. Get your publishable key
3. Add to the app's payment flow (see `payment_screen.dart`)
4. Set up a Cloud Function for server-side payment intent creation

### 5. Run the App

```bash
cd homeease
flutter pub get
flutter run
```

### 6. Seed Firestore (Optional)
The app includes hardcoded fallback services in `services_provider.dart`. On first run with an empty Firestore, these 20+ services are available automatically. To persist them to Firestore, use the admin dashboard or write a seed script.

---

## Admin Dashboard

Open `admin/index.html` in any browser.

**Default credentials:**
- Email: `admin@homeease.com`
- Password: `admin123`

> Note: The admin dashboard uses demo data. To connect it to live Firestore, add the Firebase JS SDK and replace the demo arrays with Firestore queries.

---

## Firestore Schema

```
users/{userId}
  ├── name, email, phone, address
  ├── role: "user" | "admin"
  ├── loyaltyPoints: number
  └── fcmToken: string

services/{serviceId}
  ├── nameEn, nameAr, descriptionEn, descriptionAr
  ├── category, price, rating, reviewCount
  ├── isEmergencyAvailable: boolean
  └── includedItems: string[]

bookings/{bookingId}
  ├── userId, services[], totalAmount, discount
  ├── date, timeSlot, address, addressDetails, notes
  ├── paymentMethod, status, qrCode
  ├── isEmergency, loyaltyPointsUsed
  └── createdAt

technicians/{techId}
  ├── name, phone, photoUrl
  ├── specializations[], rating, completedJobs
  └── isAvailable

reviews/{reviewId}
  ├── userId, bookingId, technicianId
  ├── rating, comment
  └── createdAt

chats/{userId}
  ├── lastMessage, lastTimestamp, unreadCount
  └── messages/{msgId}
      ├── senderId, message, timestamp
      └── isFromUser

loyalty/{userId}
  ├── points, totalEarned, totalRedeemed
  └── history[]
```

---

## Color Scheme

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Blue | `#1565C0` | Buttons, links, headers |
| Secondary Orange | `#FF6F00` | Accents, badges |
| Tertiary Teal | `#00897B` | Success, revenue |
| Emergency Red | gradient `#D32F2F` → `#F44336` | Emergency CTA |

---

## Building for Production

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Play Store)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
# Then archive in Xcode for App Store submission
```

> Remember to update `android/app/build.gradle` with your signing config and `ios/Runner.xcodeproj` with your provisioning profile before release builds.

---

## License

This project is proprietary. All rights reserved.

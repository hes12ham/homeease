# دليل تشغيل تطبيق هوم إيز — من الصفر للنشر على Google Play

---

## المرحلة ١: تجهيز بيئة التطوير

### ١.١ تثبيت Flutter SDK

**ويندوز:**
```bash
# حمّل Flutter SDK من الموقع الرسمي
# https://docs.flutter.dev/get-started/install/windows

# بعد التحميل، فك الضغط في مجلد مثل:
C:\flutter

# أضف Flutter لمتغيرات البيئة (Path):
# Settings > System > Environment Variables > Path > Edit
# أضف: C:\flutter\bin

# تحقق من التثبيت:
flutter doctor
```

**ماك:**
```bash
# باستخدام Homebrew:
brew install flutter

# أو حمّل يدوياً من:
# https://docs.flutter.dev/get-started/install/macos

flutter doctor
```

**لينكس:**
```bash
sudo snap install flutter --classic
flutter doctor
```

### ١.٢ تثبيت Android Studio

1. حمّل Android Studio من: https://developer.android.com/studio
2. ثبّته وافتحه
3. من الشاشة الأولى اختر: **More Actions > SDK Manager**
4. تأكد من تثبيت:
   - **Android SDK** (API 34 أو أحدث)
   - **Android SDK Command-line Tools**
   - **Android SDK Build-Tools**
   - **Android Emulator** (لو عايز تجرب على محاكي)
5. من **More Actions > AVD Manager** — أنشئ جهاز افتراضي (اختياري)

### ١.٣ تثبيت أدوات إضافية

```bash
# تثبيت Firebase CLI
npm install -g firebase-tools

# تثبيت FlutterFire CLI
dart pub global activate flutterfire_cli

# تأكد إن كل حاجة شغالة
flutter doctor -v
```

**المفروض تشوف ✓ قدام:**
- Flutter
- Android toolchain
- Android Studio
- Connected device (لما توصل موبايلك)

---

## المرحلة ٢: إعداد Firebase (قاعدة البيانات)

### ٢.١ إنشاء مشروع Firebase

1. افتح: https://console.firebase.google.com
2. اضغط **"إنشاء مشروع"** (Create a project)
3. سمّ المشروع: `homeease-app`
4. فعّل Google Analytics (اختياري)
5. اضغط **"إنشاء المشروع"**

### ٢.٢ إضافة تطبيق Android للمشروع

1. في Firebase Console، اضغط أيقونة **Android** 🤖
2. **Android package name**: `com.homeease.app`
   - مهم! لازم يكون نفس الاسم في ملفات المشروع
3. **App nickname**: `HomeEase Android`
4. **Debug signing certificate SHA-1** (مطلوب لـ Google Sign-In):

```bash
# على ويندوز:
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# على ماك/لينكس:
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# انسخ قيمة SHA1 وحطها في Firebase Console
```

5. اضغط **Register app**
6. حمّل ملف **`google-services.json`**
7. حط الملف في: `homeease/android/app/google-services.json`

### ٢.٣ ربط Firebase بالمشروع تلقائياً

```bash
cd homeease

# سجّل دخولك في Firebase
firebase login

# ربط المشروع (هيسألك تختار المشروع)
flutterfire configure --project=homeease-app

# الأمر ده هيعمل تلقائياً:
# ✅ يولّد lib/firebase_options.dart بالقيم الصحيحة
# ✅ يضيف google-services.json لأندرويد
# ✅ يضيف GoogleService-Info.plist لـ iOS (لو محتاج)
```

### ٢.٤ تفعيل خدمات Firebase

#### أ) Authentication (المصادقة):
1. في Firebase Console > **Authentication** > **Sign-in method**
2. فعّل:
   - ✅ **Email/Password**
   - ✅ **Google** (أضف SHA-1 لو مطلبتش)
   - ✅ **Phone** (للـ OTP)

#### ب) Cloud Firestore (قاعدة البيانات):
1. **Firestore Database** > **Create database**
2. اختر **Start in test mode** (للتطوير فقط)
3. اختر أقرب موقع سيرفر: `europe-west1` أو `us-central1`
4. بعد الإنشاء، ارفع قواعد الأمان:

```bash
cd homeease
firebase deploy --only firestore:rules
```

#### ج) Cloud Messaging (الإشعارات):
1. في Firebase Console > **Cloud Messaging**
2. مفعّل تلقائياً — مش محتاج حاجة

#### د) Firebase Storage (اختياري — لصور البروفايل):
1. **Storage** > **Get Started**
2. اختر **Start in test mode**

### ٢.٥ إضافة بيانات أولية لـ Firestore

الطريقة الأسهل: التطبيق فيه خدمات افتراضية مبرمجة (في `services_provider.dart`)، فأول ما التطبيق يشتغل هتظهر الخدمات تلقائياً.

لو عايز تضيف بيانات يدوياً:

1. افتح Firebase Console > **Firestore Database**
2. اضغط **Start collection**
3. اسم الـ collection: `services`
4. أضف document بالحقول دي:

```
nameEn: "Pipe Repair"
nameAr: "إصلاح المواسير"
descriptionEn: "Fix leaking or broken pipes"
descriptionAr: "إصلاح المواسير المكسورة أو المسربة"
category: "plumbing"
price: 250
rating: 4.7
reviewCount: 142
isEmergencyAvailable: true
includedItems: ["فحص وتشخيص", "إصلاح المواسير", "اختبار التسريب"]
```

---

## المرحلة ٣: تشغيل التطبيق على الموبايل

### ٣.١ تجهيز المشروع

```bash
cd homeease

# تثبيت الـ packages
flutter pub get

# تحقق من المشروع
flutter analyze
```

### ٣.٢ تشغيل على محاكي (Emulator)

```bash
# اعرض المحاكيات المتاحة
flutter emulators

# شغّل محاكي
flutter emulators --launch <emulator_id>

# أو من Android Studio: Tools > Device Manager > Create/Play

# شغّل التطبيق
flutter run
```

### ٣.٣ تشغيل على موبايل حقيقي (Android)

**الخطوة ١: تفعيل Developer Options على الموبايل**
1. افتح **الإعدادات** > **حول الهاتف**
2. اضغط على **رقم الإصدار** (Build Number) **٧ مرات**
3. هتظهر رسالة "أنت الآن مطور"

**الخطوة ٢: تفعيل USB Debugging**
1. **الإعدادات** > **خيارات المطور** (Developer Options)
2. فعّل **تصحيح USB** (USB Debugging)

**الخطوة ٣: وصّل الموبايل بالكمبيوتر**
1. وصّل بكابل USB
2. لما تظهر رسالة "Allow USB debugging?" اضغط **Allow**

**الخطوة ٤: شغّل التطبيق**
```bash
# تأكد إن الموبايل ظاهر
flutter devices

# المفروض تشوف حاجة زي:
# SM A546E (mobile) • R5CX... • android-arm64 • Android 14

# شغّل التطبيق على الموبايل
flutter run

# لو في أكتر من جهاز، حدد الجهاز:
flutter run -d <device_id>
```

**الخطوة ٥: Hot Reload (تعديل لحظي)**
- اضغط `r` في الترمينال = Hot Reload (تعديلات سريعة)
- اضغط `R` = Hot Restart (إعادة تشغيل كاملة)
- اضغط `q` = إيقاف

### ٣.٤ تشغيل على iOS (لو عندك ماك)

```bash
# تأكد من تثبيت Xcode
xcode-select --install

# تثبيت CocoaPods
sudo gem install cocoapods

# شغّل على محاكي iOS
open -a Simulator
flutter run

# أو وصّل iPhone وشغّل:
flutter run -d <iphone_device_id>
```

---

## المرحلة ٤: إعداد ملف التوقيع (Signing) للنشر

### ٤.١ إنشاء Upload Key (مطلوب لـ Google Play)

```bash
# أنشئ مفتاح توقيع (هيسألك عن كلمة مرور وبيانات)
keytool -genkey -v -keystore ~/homeease-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias homeease

# ⚠️ مهم جداً: احتفظ بالملف وكلمة المرور في مكان آمن!
# لو ضاعوا مش هتقدر تحدّث التطبيق على Google Play أبداً
```

### ٤.٢ إعداد ملف key.properties

أنشئ ملف `homeease/android/key.properties`:

```properties
storePassword=كلمة_المرور_اللي_اخترتها
keyPassword=كلمة_المرور_اللي_اخترتها
keyAlias=homeease
storeFile=/Users/اسمك/homeease-upload-key.jks
```

⚠️ **لا ترفع الملف ده على GitHub أبداً!** أضفه لـ `.gitignore`

### ٤.٣ تعديل build.gradle

افتح `homeease/android/app/build.gradle` وعدّل:

```groovy
// أضف فوق android { }:
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... الإعدادات الموجودة ...

    defaultConfig {
        applicationId "com.homeease.app"
        minSdk 23
        targetSdk 34
        versionCode 1          // زوّد الرقم مع كل تحديث
        versionName "1.0.0"    // رقم الإصدار الظاهر للمستخدم
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## المرحلة ٥: بناء التطبيق للنشر

### ٥.١ بناء App Bundle (المطلوب لـ Google Play)

```bash
cd homeease

# نظّف المشروع
flutter clean
flutter pub get

# ابنِ App Bundle للنشر
flutter build appbundle --release

# الملف هيطلع في:
# build/app/outputs/bundle/release/app-release.aab
```

### ٥.٢ بناء APK (للتوزيع المباشر)

```bash
# APK عادي
flutter build apk --release

# الملف هيطلع في:
# build/app/outputs/flutter-apk/app-release.apk

# APK مقسم حسب المعالج (حجم أصغر):
flutter build apk --split-per-abi --release
# هيطلع 3 ملفات: arm64-v8a, armeabi-v7a, x86_64
```

### ٥.٣ اختبار نسخة الـ Release

```bash
# ثبّت نسخة الـ release على موبايلك
flutter install --release
```

---

## المرحلة ٦: النشر على Google Play Store

### ٦.١ إنشاء حساب مطور

1. افتح: https://play.google.com/console
2. اضغط **"Create account"**
3. ادفع رسوم التسجيل: **$25** (مرة واحدة فقط — لن تتكرر)
4. أكمل بيانات الحساب:
   - الاسم
   - البريد الإلكتروني
   - رقم الهاتف
   - العنوان
5. انتظر الموافقة (عادةً ١-٣ أيام)

### ٦.٢ إنشاء تطبيق جديد

1. في Google Play Console اضغط **"Create app"**
2. املأ:
   - **App name**: `HomeEase - هوم إيز`
   - **Default language**: العربية
   - **App or game**: App
   - **Free or paid**: Free
3. وافق على السياسات واضغط **Create**

### ٦.٣ إعداد صفحة التطبيق (Store Listing)

**أ) الوصف:**
```
العنوان: HomeEase - هوم إيز | خدمات منزلية
الوصف المختصر: احجز خدمات منزلية احترافية بضغطة زر
الوصف الكامل:
هوم إيز — تطبيقك الأول لحجز خدمات الصيانة المنزلية في مصر.

✅ ٨ تصنيفات: سباكة، كهرباء، تنظيف، دهانات، نجارة، تكييف، أجهزة، مكافحة حشرات
✅ حجز فوري مع تتبع الفني لحظياً
✅ ضمان ٣٠ يوم على جميع الخدمات
✅ نظام نقاط ولاء — وفّر مع كل حجز
✅ خدمة طوارئ ٢٤/٧
✅ محادثة مباشرة مع الفني
✅ دعم عربي وإنجليزي
✅ وضع داكن
```

**ب) الصور المطلوبة:**

| النوع | المقاس | العدد |
|-------|--------|-------|
| App Icon | 512 × 512 px | 1 |
| Feature Graphic | 1024 × 500 px | 1 |
| Phone Screenshots | 1080 × 1920 px (أو أي نسبة 9:16) | 4-8 |
| Tablet Screenshots (اختياري) | 1200 × 1920 px | 4-8 |

**طريقة أخذ screenshots:**
```bash
# من المحاكي أو الموبايل
flutter screenshot --out=screenshot_home.png

# أو استخدم العرض التفاعلي HTML اللي عملناه وخد screenshots منه
```

### ٦.٤ تصنيف المحتوى (Content Rating)

1. اذهب لـ **Policy > App content > Content rating**
2. اضغط **Start questionnaire**
3. اختر **Utility, Productivity, Communication**
4. أجب على الأسئلة (معظمها "لا" لأن التطبيق مش فيه محتوى عنيف أو حساس)
5. هيطلع التصنيف تلقائياً (عادةً **Everyone / الكل**)

### ٦.٥ إعدادات التطبيق

1. **Policy > App content** — أكمل كل البنود:
   - ✅ Privacy Policy (لازم يكون عندك رابط سياسة خصوصية)
   - ✅ Ads (حدد: لا يحتوي إعلانات)
   - ✅ App access (حدد: يحتاج تسجيل دخول — وفّر حساب تجريبي)
   - ✅ Data safety (حدد أنواع البيانات اللي بتجمعها)
   - ✅ Government apps (لا)
   - ✅ Financial features (لو فيه دفع إلكتروني: نعم)

2. **Grow > Store presence > Main store listing** — أكمل كل الحقول

### ٦.٦ رفع الـ App Bundle

1. اذهب لـ **Release > Production**
2. اضغط **"Create new release"**
3. **App signing**: اقبل Google Play App Signing (موصى به)
4. ارفع ملف `.aab`:
   - `build/app/outputs/bundle/release/app-release.aab`
5. **Release name**: `1.0.0`
6. **Release notes** (بالعربي):
```
الإصدار الأول من هوم إيز!
- حجز خدمات منزلية في ٨ تصنيفات
- تتبع الفني لحظياً
- محادثة مباشرة مع الفني
- نظام نقاط ولاء
- ضمان ٣٠ يوم
```
7. اضغط **Review release**
8. اضغط **Start rollout to Production**

### ٦.٧ انتظار المراجعة

- أول مراجعة: **٣-٧ أيام عمل** (أحياناً أكثر)
- التحديثات اللاحقة: **١-٣ أيام**
- ممكن يرفضوا لأسباب مثل:
  - سياسة خصوصية ناقصة
  - screenshots مش واضحة
  - صلاحيات مش مبررة
  - لو التطبيق مش شغال (crashes)

---

## المرحلة ٧: سياسة الخصوصية (مطلوبة إجبارياً)

لازم يكون عندك صفحة سياسة خصوصية على الإنترنت. ممكن تعملها ببساطة:

### الخيار ١: صفحة مجانية

استخدم أي من المواقع دي لتوليد سياسة خصوصية:
- https://app-privacy-policy-generator.firebaseapp.com
- https://www.termsfeed.com/privacy-policy-generator

### الخيار ٢: استضافة على GitHub Pages (مجاني)

1. أنشئ repository على GitHub
2. أضف ملف `privacy-policy.html`
3. فعّل GitHub Pages من Settings
4. الرابط هيكون: `https://username.github.io/repo/privacy-policy.html`

---

## المرحلة ٨: بعد النشر — تحديثات وصيانة

### ٨.١ إرسال تحديث

```bash
# 1. عدّل versionCode و versionName في build.gradle
# versionCode: 2  (لازم يزيد كل مرة)
# versionName: "1.1.0"

# 2. ابنِ من جديد
flutter clean
flutter build appbundle --release

# 3. ارفع على Google Play Console > Production > Create new release
```

### ٨.٢ مراقبة التطبيق

- **Firebase Analytics**: تتبع الاستخدام
- **Firebase Crashlytics**: تقارير الأخطاء
- **Google Play Console > Statistics**: التحميلات والتقييمات

### ٨.٣ إعداد Stripe (للدفع الإلكتروني)

```bash
# 1. أنشئ حساب على https://stripe.com
# 2. احصل على Publishable Key و Secret Key
# 3. أنشئ Cloud Function للـ Payment Intent:

cd homeease
mkdir functions && cd functions
npm init -y
npm install firebase-functions firebase-admin stripe
```

أنشئ ملف `functions/index.js`:
```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('sk_live_YOUR_SECRET_KEY');

admin.initializeApp();

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  const { amount, currency } = data;
  const paymentIntent = await stripe.paymentIntents.create({
    amount: amount,        // بالقروش (مثلاً 57600 = 576 جنيه)
    currency: currency || 'egp',
  });
  return { clientSecret: paymentIntent.client_secret };
});
```

```bash
# ارفع الـ Cloud Function
firebase deploy --only functions
```

---

## ملخص سريع — الخطوات الأساسية

```
١. ثبّت Flutter + Android Studio           ← ٣٠ دقيقة
٢. أنشئ مشروع Firebase                    ← ١٠ دقائق
٣. شغّل flutterfire configure             ← ٥ دقائق
٤. فعّل Auth + Firestore + FCM            ← ١٠ دقائق
٥. flutter pub get && flutter run          ← ٥ دقائق (أول مرة أطول)
٦. جرّب على الموبايل                      ← ٥ دقائق
٧. أنشئ Upload Key                        ← ٥ دقائق
٨. flutter build appbundle --release       ← ٥ دقائق
٩. أنشئ حساب Google Play ($25)            ← ١٥ دقيقة
١٠. ارفع واملأ البيانات                    ← ٣٠ دقيقة
١١. انتظر المراجعة                         ← ٣-٧ أيام
```

**الإجمالي التقريبي: ساعتين عمل + ٣-٧ أيام انتظار المراجعة**

---

## أخطاء شائعة وحلولها

| المشكلة | الحل |
|---------|------|
| `flutter doctor` يظهر ✗ Android | ثبّت Android SDK من Android Studio > SDK Manager |
| `JAVA_HOME` not found | ثبّت JDK 17: `brew install openjdk@17` أو حمّله من Oracle |
| الموبايل مش ظاهر | تأكد من تفعيل USB Debugging + جرّب كابل تاني |
| `google-services.json` missing | حمّله من Firebase Console > Project Settings > Android app |
| `SHA-1` error مع Google Sign-In | أضف SHA-1 في Firebase Console > Project Settings > Android app |
| `Gradle build failed` | `cd android && ./gradlew clean && cd .. && flutter clean && flutter pub get` |
| `Multidex` error | أضف `multiDexEnabled true` في `android/app/build.gradle` > defaultConfig |
| App rejected on Play Store | اقرأ سبب الرفض بالتفصيل في Console وعدّل |

---

## الملفات المهمة — لا تفقدها أبداً! ⚠️

| الملف | السبب |
|-------|-------|
| `homeease-upload-key.jks` | مفتاح التوقيع — بدونه مش هتقدر تحدّث التطبيق |
| `key.properties` | كلمات مرور المفتاح |
| `google-services.json` | إعدادات Firebase لأندرويد |
| `firebase_options.dart` | إعدادات Firebase للتطبيق |

**انسخهم في مكان آمن (Google Drive, USB) واحتفظ بنسخة احتياطية!**

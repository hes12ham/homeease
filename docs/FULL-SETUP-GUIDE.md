# ══════════════════════════════════════════════════
# دليل تشغيل هوم إيز الكامل
# من الصفر — خطوة بخطوة بالصور والأوامر
# ══════════════════════════════════════════════════

---

# الجزء ١: تثبيت الأدوات المطلوبة
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ١.١ — تثبيت Flutter

### ويندوز:
```
الخطوة ١: افتح الرابط ده في المتصفح:
         https://docs.flutter.dev/get-started/install/windows

الخطوة ٢: حمّل الملف المضغوط (flutter_windows_x.x.x-stable.zip)

الخطوة ٣: فك الضغط في:
         C:\flutter

الخطوة ٤: أضف Flutter لمتغيرات البيئة:
         ● اضغط Windows + S واكتب "environment"
         ● اختر "Edit the system environment variables"
         ● اضغط "Environment Variables"
         ● في "User variables" اختر "Path" واضغط "Edit"
         ● اضغط "New" وأضف: C:\flutter\bin
         ● اضغط OK في كل النوافذ

الخطوة ٥: افتح CMD جديد واكتب:
         flutter doctor
```

### ماك:
```bash
brew install flutter
flutter doctor
```

### لينكس:
```bash
sudo snap install flutter --classic
flutter doctor
```

## ١.٢ — تثبيت Android Studio

```
الخطوة ١: حمّل من: https://developer.android.com/studio

الخطوة ٢: ثبّت البرنامج وافتحه

الخطوة ٣: من أول شاشة اختر "Standard Installation"

الخطوة ٤: بعد التثبيت، افتح:
         More Actions → SDK Manager

الخطوة ٥: تأكد من تثبيت:
         ✅ Android SDK Platform 34 (أو أحدث)
         ✅ Android SDK Command-line Tools
         ✅ Android SDK Build-Tools
         ✅ Android Emulator

الخطوة ٦: قبول التراخيص:
         افتح CMD واكتب:
         flutter doctor --android-licenses
         واكتب y لكل سؤال
```

## ١.٣ — تثبيت Node.js و Firebase CLI

```
الخطوة ١: حمّل Node.js من: https://nodejs.org
         (اختر النسخة LTS)

الخطوة ٢: ثبّته عادي (Next → Next → Install)

الخطوة ٣: افتح CMD واكتب:
         npm install -g firebase-tools

الخطوة ٤: ثبّت FlutterFire CLI:
         dart pub global activate flutterfire_cli
```

## ١.٤ — تثبيت Git (لو مش موجود)

```
حمّل من: https://git-scm.com/downloads
ثبّته بالإعدادات الافتراضية
```

## ١.٥ — التحقق من كل حاجة

```bash
flutter doctor -v
```

لازم تشوف ✓ (صح أخضر) قدام:
```
[✓] Flutter (Channel stable, x.x.x)
[✓] Android toolchain
[✓] Android Studio
[✓] Connected device (أو Chrome)
```

لو فيه ✗ (خطأ أحمر)، اتبع التعليمات اللي بيقولها flutter doctor.

---

# الجزء ٢: تجهيز مشروع Firebase
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ٢.١ — إنشاء مشروع Firebase

```
الخطوة ١: افتح: https://console.firebase.google.com

الخطوة ٢: سجّل دخولك بحساب جوجل

الخطوة ٣: اضغط "إنشاء مشروع" (Create a project)

الخطوة ٤: اسم المشروع: homeease-app

الخطوة ٥: Google Analytics:
         ● اختر "تفعيل" لو عايز إحصائيات (اختياري)
         ● أو "عدم التفعيل" لو عايز تبسّطها

الخطوة ٦: اضغط "إنشاء المشروع"
         (انتظر ٣٠ ثانية حتى يتم الإنشاء)
```

## ٢.٢ — تفعيل Authentication (تسجيل الدخول)

```
الخطوة ١: في Firebase Console، من القائمة الجانبية:
         Build → Authentication

الخطوة ٢: اضغط "Get started"

الخطوة ٣: فعّل الطرق دي واحدة واحدة:

         ✅ Email/Password:
            ● اضغط عليها → فعّل "Enable" → Save

         ✅ Google:
            ● اضغط عليها → فعّل "Enable"
            ● اكتب اسم المشروع: HomeEase
            ● اختر Support email (إيميلك)
            ● Save

         ✅ Phone:
            ● اضغط عليها → فعّل "Enable" → Save
```

## ٢.٣ — إنشاء Firestore Database (قاعدة البيانات)

```
الخطوة ١: في Firebase Console:
         Build → Firestore Database

الخطوة ٢: اضغط "Create database"

الخطوة ٣: اختر "Start in test mode"
         (ده يسمح بالقراءة والكتابة بدون قيود — للتطوير فقط)

الخطوة ٤: اختر أقرب موقع سيرفر:
         ● لو في مصر: اختر europe-west1 (بلجيكا)
         ● أو eur3 (أوروبا)

الخطوة ٥: اضغط "Enable"
```

## ٢.٤ — تفعيل Firebase Storage (لصور الفنيين)

```
الخطوة ١: في Firebase Console:
         Build → Storage

الخطوة ٢: اضغط "Get started"

الخطوة ٣: اختر "Start in test mode"

الخطوة ٤: اختر نفس الموقع (europe-west1)

الخطوة ٥: اضغط "Done"
```

## ٢.٥ — تفعيل Cloud Messaging (الإشعارات)

```
الخطوة ١: في Firebase Console:
         Engage → Messaging

الخطوة ٢: مفعّل تلقائياً — مش محتاج حاجة إضافية
```

---

# الجزء ٣: ربط المشروع بـ Firebase
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ٣.١ — فك ضغط المشروع

```bash
# فك ضغط الملف اللي حمّلته
tar -xzf homeease-project-v5.tar.gz

# ادخل مجلد المشروع
cd homeease
```

## ٣.٢ — تسجيل دخول Firebase في الترمينال

```bash
firebase login
```
هيفتح المتصفح — سجّل دخولك بنفس حساب جوجل اللي عملت بيه المشروع.

## ٣.٣ — ربط المشروع (الخطوة الأهم!)

```bash
flutterfire configure --project=homeease-app
```

الأمر ده هيسألك أسئلة:
```
? Which platforms should your configuration support?
  ● اختر: android (اضغط Space عليه ثم Enter)
  ● لو عايز iOS كمان: اخترهم الاتنين

? Which Android application id do you want to use?
  ● اكتب: com.homeease.app

الأمر هيعمل تلقائياً:
  ✅ يولّد lib/firebase_options.dart بالقيم الصحيحة
  ✅ يضيف google-services.json في android/app/
  ✅ يعدّل android/app/build.gradle
```

## ٣.٤ — إضافة SHA-1 (مطلوب لـ Google Sign-In)

```bash
# ويندوز:
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# ماك/لينكس:
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

انسخ قيمة **SHA1** (هتكون حاجة زي: `AA:BB:CC:DD:...`)

```
الخطوة ١: في Firebase Console:
         Project Settings (الترس ⚙️ في الأعلى)

الخطوة ٢: انزل لقسم "Your apps" → Android app

الخطوة ٣: اضغط "Add fingerprint"

الخطوة ٤: الصق SHA-1 واضغط Save
```

## ٣.٥ — رفع قواعد الأمان لـ Firestore

```bash
cd homeease
firebase deploy --only firestore:rules
```

---

# الجزء ٤: تشغيل التطبيق
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ٤.١ — تثبيت الـ Packages

```bash
cd homeease
flutter pub get
```

لو ظهر أي خطأ:
```bash
flutter clean
flutter pub get
```

## ٤.٢ — تشغيل على المحاكي (Emulator)

```
الخطوة ١: افتح Android Studio

الخطوة ٢: More Actions → Device Manager

الخطوة ٣: اضغط "Create Device"
         ● اختر: Pixel 6 (أو أي موبايل)
         ● اضغط Next
         ● اختر: API 34 (حمّلها لو مش موجودة)
         ● اضغط Next → Finish

الخطوة ٤: اضغط زر ▶️ بجوار الجهاز لتشغيله

الخطوة ٥: في الترمينال:
```

```bash
flutter run
```

## ٤.٣ — تشغيل على موبايل حقيقي (الطريقة المفضّلة)

```
═══════════════════════════════════════
على الموبايل:
═══════════════════════════════════════

الخطوة ١: افتح "الإعدادات" → "حول الهاتف"

الخطوة ٢: اضغط على "رقم الإصدار" (Build Number) ٧ مرات
         هتظهر رسالة: "أنت الآن مطور!"

الخطوة ٣: ارجع للإعدادات → "خيارات المطور" (Developer Options)

الخطوة ٤: فعّل:
         ✅ تصحيح USB (USB Debugging)

الخطوة ٥: وصّل الموبايل بالكمبيوتر بكابل USB

الخطوة ٦: لما تظهر رسالة على الموبايل:
         "Allow USB debugging?"
         ✅ اضغط "Allow" (سماح)
         ✅ حط صح على "Always allow from this computer"

═══════════════════════════════════════
على الكمبيوتر:
═══════════════════════════════════════

الخطوة ٧: تأكد إن الموبايل ظاهر:
```

```bash
flutter devices
```

```
المفروض تشوف:
  Samsung SM-XXXX (mobile) • XXXXXXX • android-arm64 • Android 14

الخطوة ٨: شغّل التطبيق:
```

```bash
flutter run
```

```
أول مرة هياخد ٢-٥ دقائق لبناء التطبيق.
بعد كده هيتثبّت على الموبايل ويفتح تلقائياً!

═══════════════════════════════════════
أثناء التطوير:
═══════════════════════════════════════

● اضغط r في الترمينال = Hot Reload (تعديل سريع)
● اضغط R = Hot Restart (إعادة تشغيل)
● اضغط q = إيقاف التطبيق
```

---

# الجزء ٥: إضافة البيانات لقاعدة البيانات
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ٥.١ — الخدمات (تلقائية)

التطبيق فيه ١٩ خدمة افتراضية مبرمجة. أول ما يشتغل هتظهر تلقائياً:

```
كهرباء:         كهرباء عامة (٢٠٠) | مروحة (١٥٠) | شاتر (٢٥٠)
سباكة:          سباكة عامة (٢٠٠) | دش (١٨٠)
أجهزة منزلية:   غسالة أطباق (٣٥٠) | بوتجاز (٣٠٠) | سخان غاز (٢٨٠) | ثلاجة (٣٥٠) | غسالة (٣٠٠)
تكييف:          صيانة تكييف (٣٥٠) | تركيب ونقل (٥٠٠)
تشطيبات:        تأسيس (٨٠٠) | نقاشة (٦٠٠) | بلاط وسيراميك (٧٠٠)
نجارة وألوميتال: نجارة (٤٠٠) | ألوميتال (٤٥٠)
أنظمة أمان:     كاميرات مراقبة (٥٠٠) | انتركم (٢٥٠)
مكافحة حشرات:   مكافحة حشرات (٣٠٠)
```

## ٥.٢ — إضافة خدمات يدوياً (اختياري)

```
الخطوة ١: افتح Firebase Console → Firestore Database

الخطوة ٢: اضغط "Start collection"

الخطوة ٣: Collection ID: services

الخطوة ٤: أضف Document بالحقول:
         nameEn: "General Plumbing"        (string)
         nameAr: "سباكة عامة"              (string)
         descriptionEn: "..."               (string)
         descriptionAr: "..."               (string)
         category: "plumbing"               (string)
         price: 200                         (number)
         rating: 4.7                        (number)
         reviewCount: 0                     (number)
         isEmergencyAvailable: true          (boolean)
         isActive: true                      (boolean)
```

## ٥.٣ — إنشاء حساب أدمن

```
الخطوة ١: في Firebase Console → Authentication → Users

الخطوة ٢: اضغط "Add user"

الخطوة ٣: 
         Email: admin@homeease.app
         Password: (اختر باسوورد قوي)

الخطوة ٤: في Firestore → أنشئ collection: users

الخطوة ٥: أنشئ document بالـ UID بتاع الأدمن:
         name: "Admin"                     (string)
         email: "admin@homeease.app"       (string)
         role: "admin"                     (string)
         phone: "01000000000"              (string)
```

---

# الجزء ٦: لوحة تحكم الأدمن (Admin Dashboard)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```
الخطوة ١: افتح الملف: homeease/admin/index.html
         في أي متصفح (Chrome مثلاً)

الخطوة ٢: سجّل دخول:
         Email: admin@homeease.com
         Password: admin123

الخطوة ٣: هتلاقي:
         ● لوحة إحصائيات
         ● إدارة الحجوزات
         ● إدارة الخدمات (إضافة/تعديل/حذف)
         ● إدارة الفنيين
         ● طلبات تسجيل الفنيين الجدد
         ● إحصائيات وتقارير

ملاحظة: لوحة الأدمن حالياً ببيانات تجريبية.
لربطها بـ Firestore الحقيقي، تحتاج إضافة Firebase JS SDK.
```

---

# الجزء ٧: بناء نسخة الإنتاج (Release APK)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ٧.١ — إنشاء مفتاح التوقيع

```bash
keytool -genkey -v -keystore homeease-upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias homeease
```

هيسألك:
```
Enter keystore password: (اكتب باسوورد واحفظه!)
Re-enter password: (نفس الباسوورد)
What is your first and last name? (اسمك)
What is your organizational unit? (اكتب: Development)
What is your organization? (اكتب: HomeEase)
What is your city? (اكتب: Cairo)
What is your state? (اكتب: Cairo)
What is your country code? (اكتب: EG)
Is CN=... correct? (اكتب: yes)
```

⚠️ **احفظ الملف والباسوورد في مكان آمن جداً!**

## ٧.٢ — إنشاء key.properties

أنشئ ملف `homeease/android/key.properties`:

```properties
storePassword=الباسوورد_بتاعك
keyPassword=الباسوورد_بتاعك
keyAlias=homeease
storeFile=المسار/homeease-upload-key.jks
```

مثال المسار:
```
# ويندوز:
storeFile=C:\\Users\\Ahmed\\homeease-upload-key.jks

# ماك/لينكس:
storeFile=/Users/ahmed/homeease-upload-key.jks
```

## ٧.٣ — تعديل build.gradle

افتح `homeease/android/app/build.gradle` وأضف قبل `android {`:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

وغيّر `buildTypes` لـ:

```groovy
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
    }
}
```

## ٧.٤ — بناء APK

```bash
flutter clean
flutter pub get
flutter build apk --release
```

الملف هيطلع في:
```
build/app/outputs/flutter-apk/app-release.apk
```

ممكن تبعته لأي حد يثبّته على موبايله!

## ٧.٥ — بناء App Bundle (لـ Google Play)

```bash
flutter build appbundle --release
```

الملف هيطلع في:
```
build/app/outputs/bundle/release/app-release.aab
```

---

# الجزء ٨: النشر على Google Play Store
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ٨.١ — إنشاء حساب مطور

```
الخطوة ١: افتح: https://play.google.com/console

الخطوة ٢: اضغط "Create account"

الخطوة ٣: ادفع $25 (مرة واحدة فقط — بطاقة فيزا أو ماستركارد)

الخطوة ٤: أكمل البيانات:
         ● الاسم الكامل
         ● البريد الإلكتروني  
         ● رقم الهاتف
         ● العنوان
         ● هل أنت فرد أم شركة؟ (اختر "Personal")

الخطوة ٥: انتظر الموافقة (١-٣ أيام)
```

## ٨.٢ — إنشاء التطبيق

```
الخطوة ١: اضغط "Create app"

الخطوة ٢: 
         App name: HomeEase - هوم إيز
         Default language: العربية
         App or game: App
         Free or paid: Free

الخطوة ٣: وافق على السياسات → Create
```

## ٨.٣ — إعداد صفحة التطبيق

```
Grow → Store presence → Main store listing

العنوان: HomeEase - هوم إيز | خدمات منزلية

الوصف المختصر:
احجز خدمات منزلية احترافية — سباكة، كهرباء، تكييف، وأكتر

الوصف الكامل:
هوم إيز — تطبيقك الأول لحجز خدمات الصيانة المنزلية في مصر.

✅ ١٩ خدمة في ٨ تصنيفات:
   كهرباء | سباكة | أجهزة منزلية | تكييف
   تشطيبات ودهانات | نجارة وألوميتال | أنظمة أمان | مكافحة حشرات

✅ حجز فوري مع تتبع الفني لحظياً
✅ محادثة مباشرة مع الفني
✅ ضمان ٣٠ يوم على جميع الخدمات
✅ نظام نقاط ولاء — وفّر مع كل حجز
✅ خدمة طوارئ على مدار الساعة
✅ دعم عربي وإنجليزي
✅ وضع داكن
```

## ٨.٤ — الصور المطلوبة

```
● أيقونة التطبيق: 512 × 512 بكسل (PNG)
● Feature Graphic: 1024 × 500 بكسل
● Screenshots الموبايل: 4-8 صور (1080 × 1920 بكسل)

طريقة أخذ Screenshots:
  ● افتح العرض التفاعلي (homeease-app-preview-ar.html) في Chrome
  ● خد screenshot لكل شاشة من الموبايل الافتراضي
  ● أو من المحاكي: flutter screenshot --out=screen1.png
```

## ٨.٥ — رفع التطبيق

```
الخطوة ١: Release → Production → Create new release

الخطوة ٢: App signing: اقبل Google Play App Signing

الخطوة ٣: ارفع ملف: app-release.aab

الخطوة ٤: Release name: 1.0.0

الخطوة ٥: Release notes (بالعربي):
         الإصدار الأول من هوم إيز!
         - حجز خدمات في ٨ تصنيفات و١٩ خدمة
         - تتبع الفني لحظياً
         - محادثة مع الفني
         - نظام نقاط ولاء
         - ضمان ٣٠ يوم

الخطوة ٦: اضغط Review release

الخطوة ٧: اضغط Start rollout to Production
```

## ٨.٦ — باقي المتطلبات (لازم تكمّلهم)

```
Policy → App content → أكمل كل البنود:

✅ Privacy Policy:
   اعمل صفحة خصوصية مجانية من:
   https://app-privacy-policy-generator.firebaseapp.com
   وحطها على GitHub Pages أو أي موقع

✅ Ads: لا يحتوي إعلانات

✅ App access: يحتاج تسجيل دخول
   (وفّر حساب تجريبي للمراجعين)

✅ Content rating: أجب على الاستبيان
   (معظم الإجابات "لا")

✅ Data safety: حدد البيانات اللي بتجمعها
   (اسم، تليفون، عنوان)
```

## ٨.٧ — انتظار المراجعة

```
● أول مراجعة: ٣-٧ أيام عمل
● التحديثات: ١-٣ أيام
● لو اترفض: اقرأ السبب وعدّل وأعد الرفع
```

---

# الجزء ٩: بعد النشر
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## إرسال تحديث

```bash
# ١. غيّر versionCode و versionName في android/app/build.gradle
#    versionCode: 2  (لازم يزيد)
#    versionName: "1.1.0"

# ٢. ابنِ من جديد
flutter clean
flutter build appbundle --release

# ٣. ارفع على Google Play Console
```

## نقل قواعد الأمان من test mode لـ production

```bash
# بعد ما تتأكد إن كل حاجة شغالة، ارفع القواعد الآمنة:
firebase deploy --only firestore:rules
```

---

# الجزء ١٠: حل المشاكل الشائعة
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## مشكلة: flutter doctor يظهر خطأ Android

```bash
# الحل: تأكد من تثبيت Android SDK:
# Android Studio → SDK Manager → Android SDK → تثبيت

# قبول التراخيص:
flutter doctor --android-licenses
```

## مشكلة: الموبايل مش ظاهر

```
● تأكد إن USB Debugging مفعّل
● جرّب كابل USB تاني (بعض الكابلات شحن فقط)
● على الموبايل: لما يسألك "USB for?" اختر "File Transfer"
● جرّب: adb devices (لازم يظهر الجهاز)
```

## مشكلة: JAVA_HOME not found

```bash
# ويندوز:
# أضف متغير بيئة: JAVA_HOME
# القيمة: المسار بتاع Java في Android Studio
# عادةً: C:\Program Files\Android\Android Studio\jbr

# ماك:
export JAVA_HOME=$(/usr/libexec/java_home)
```

## مشكلة: Gradle build failed

```bash
cd homeease
cd android
./gradlew clean       # ماك/لينكس
gradlew.bat clean     # ويندوز
cd ..
flutter clean
flutter pub get
flutter run
```

## مشكلة: Google Sign-In مش شغال

```
● تأكد من إضافة SHA-1 في Firebase Console
● تأكد من تفعيل Google Sign-In في Authentication
● أعد تشغيل: flutterfire configure
```

## مشكلة: Multidex error

```
في android/app/build.gradle → defaultConfig:
أضف: multiDexEnabled true
```

---

# ملخص الخطوات (Quick Reference)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```
١. ثبّت Flutter + Android Studio + Firebase CLI    ⏱️ ٣٠ دقيقة
٢. أنشئ مشروع Firebase                             ⏱️ ٥ دقائق
٣. فعّل Auth + Firestore + Storage                  ⏱️ ١٠ دقائق
٤. شغّل: flutterfire configure                     ⏱️ ٣ دقائق
٥. أضف SHA-1 في Firebase Console                   ⏱️ ٣ دقائق
٦. firebase deploy --only firestore:rules           ⏱️ ١ دقيقة
٧. flutter pub get                                   ⏱️ ٢ دقيقة
٨. وصّل الموبايل + flutter run                      ⏱️ ٥ دقائق
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
الإجمالي: ≈ ساعة واحدة للتشغيل الأول
```

```
٩. أنشئ Upload Key                                  ⏱️ ٥ دقائق
١٠. flutter build appbundle --release                ⏱️ ٥ دقائق
١١. أنشئ حساب Google Play ($25)                     ⏱️ ١٥ دقيقة
١٢. ارفع واملأ البيانات                             ⏱️ ٣٠ دقيقة
١٣. انتظر المراجعة                                  ⏱️ ٣-٧ أيام
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
الإجمالي للنشر: ≈ ساعة إضافية + ٣-٧ أيام انتظار
```

---

# ⚠️ ملفات مهمة — لا تفقدها أبداً!

```
homeease-upload-key.jks    ← مفتاح التوقيع (بدونه مفيش تحديثات!)
key.properties             ← كلمات مرور المفتاح
google-services.json       ← إعدادات Firebase
firebase_options.dart      ← إعدادات Firebase في الكود
```

**انسخهم في Google Drive أو USB واحتفظ بنسخة احتياطية!**

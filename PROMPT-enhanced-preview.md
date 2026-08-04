PROMPT — HomeEase Enhanced Interactive App Preview (Arabic-First + Uber-Style Technician Tracking)

Build a single self-contained HTML file that serves as a fully interactive, clickable prototype of the "HomeEase" Egyptian home-services mobile app. The prototype must render inside a realistic iPhone-style phone frame (375×812, notch, rounded corners) on a dark background, with a horizontal pill-nav bar above it to switch between screens.

═══════════════════════════════════════════════════
1. LANGUAGE & DIRECTION
═══════════════════════════════════════════════════
- The ENTIRE app UI must be in Arabic (RTL layout).
- Use the "Cairo" Google Font for all Arabic text.
- All labels, buttons, status text, navigation items, greetings, timestamps, currency ("ج.م"), and placeholder text must be in Arabic.
- The page wrapper (header, screen-nav pills, screen-info panel below the phone) should also be in Arabic.
- Ensure proper RTL: text-align right, flex-direction reversed where needed, icons on the correct side.

═══════════════════════════════════════════════════
2. SCREENS TO BUILD (14 total)
═══════════════════════════════════════════════════

Screen 1 — Splash
  Centered animated logo "🏠" with app name "هوم إيز" and tagline "خدمات منزلية بكل سهولة".

Screen 2 — Login / تسجيل الدخول
  - RTL form: email + password fields with Arabic labels & placeholders
  - "تسجيل الدخول" primary button
  - Social login row: Google + Phone OTP buttons
  - "إنشاء حساب جديد" link
  - "English ↔ العربية" language toggle at bottom

Screen 3 — Home / الرئيسية
  - Greeting: "صباح الخير 👋" + user name "أحمد"
  - Search bar: "ابحث عن خدمة..."
  - Emergency banner (red gradient): "⚡ خدمة طوارئ — حجز أولوية خلال ساعة"
  - 4×2 category grid with Arabic labels:
    سباكة 🔧 | كهرباء ⚡ | تنظيف 🧹 | دهانات 🎨
    نجارة 🪚 | تكييف ❄️ | أجهزة 🔌 | مكافحة حشرات 🐛
  - "الخدمات الشائعة" section with 3 service cards (Arabic names, prices in ج.م, star ratings)
  - Bottom nav (RTL): الرئيسية | طلباتي | السلة (badge "2") | حسابي

Screen 4 — Service Details / تفاصيل الخدمة
  - Hero header with category gradient + icon + Arabic service name "إصلاح المواسير" + description
  - Price card: "250 ج.م" + warranty badge "🛡️ ضمان 30 يوم"
  - "ما يشمله" checklist (5 items in Arabic)
  - Review card with Arabic reviewer name, stars, Arabic comment
  - Bottom bar: "🛒 أضف للسلة — 250 ج.م"

Screen 5 — Cart / السلة
  - 2 cart items with Arabic names, quantity controls (+/−), prices
  - Loyalty points banner: "⭐ لديك 2,450 نقطة — وفّر حتى 24 ج.م"
  - Total bar: "الإجمالي 600 ج.م" + "متابعة ←" button
  - Bottom nav

Screen 6 — Booking / تفاصيل الحجز
  - 3-step RTL stepper:
    Step 1 (done): "اختر التاريخ" with mini calendar (Arabic day names: أحد, إثن, ثلا, أرب, خمي, جمع, سبت), selected date highlighted
    Step 2 (active): "اختر الوقت" with 3 slots: صباحي ☀️ | ظهري 🌤️ | مسائي 🌙 (one selected)
    Step 3: "العنوان"
  - "التالي →" button

Screen 7 — Payment / الدفع
  - Order summary card with Arabic labels, line items, subtotal, loyalty discount (green), bold total
  - Loyalty toggle bar: "استخدم 2,400 نقطة — وفّر 24 ج.م" with toggle
  - Payment methods: "💵 كاش — الدفع عند الوصول" (selected) | "💳 بطاقة — الدفع عبر Stripe"
  - "تأكيد الحجز · 576 ج.م" button

Screen 8 — Confirmation / تأكيد الحجز
  - Green check animation
  - "تم تأكيد الحجز!" heading
  - Booking ID "#HE-1042"
  - QR code placeholder
  - "اعرض الكود للفني عند وصوله"
  - Warranty badge: "🛡️ ضمان 30 يوم مشمول"

═══════════════════════════════════════════════════
3. NEW UBER-STYLE SCREENS (the core addition)
═══════════════════════════════════════════════════

Screen 9 — Technician Assigned / الفني في الطريق (★ KEY SCREEN)
  This is the Uber-like real-time tracking experience:
  - Top section: Fake map area (CSS gradient/pattern simulating a map with streets) with a pulsing blue dot showing technician location and a pin showing user's home
  - ETA card overlaying bottom of map: "الوقت المتوقع للوصول: 15 دقيقة" with a progress bar
  - Technician info card (slides up from bottom):
    • Circular photo placeholder with technician initial "أ"
    • Name: "أحمد حسن"
    • Rating: ⭐ 4.8 (142 مهمة)
    • Specialization badge: "سباكة"
    • Vehicle/transport info: "سيارة بيضاء — أ ب ج ١٢٣٤"
  - Two action buttons side by side:
    • "📞 اتصال" (green) — call technician
    • "💬 محادثة" (blue) — open chat (navigates to Screen 10)
  - "إلغاء الطلب" text button (red, small)

Screen 10 — Chat with Technician / المحادثة مع الفني
  - App bar: technician name "أحمد حسن" + avatar + online indicator (green dot)
  - Chat bubbles (RTL aligned):
    • Technician (right, gray): "السلام عليكم، أنا في الطريق إليك" — 10:30 ص
    • User (left, blue): "أهلاً، الشقة في الدور الثالث" — 10:31 ص  
    • Technician: "تمام، هوصل في حوالي 15 دقيقة إن شاء الله" — 10:32 ص
    • User: "ممتاز، هستناك" — 10:33 ص
    • Technician: "وصلت تحت العمارة" — 10:45 ص
  - Quick-reply chips above input: "أنا في البيت" | "اتصل بيا" | "الباب مفتوح"
  - Input bar with send button

Screen 11 — Order Tracking / تتبع الطلب
  - RTL status timeline (vertical):
    ✓ قيد الانتظار (done)
    ✓ تم التأكيد (done)
    ✓ تم تعيين فني (done)
    ● جاري التنفيذ (current, pulsing)
    ○ مكتمل
  - Booking details card (Arabic): date, time, address, payment, total
  - QR code card: "كود تحقق الفني"
  - Warranty bar: "🛡️ ضمان 30 يوم"

Screen 12 — Rating / تقييم الخدمة
  - Technician avatar + name "أحمد حسن"
  - "كيف كانت الخدمة؟" heading
  - 5 large tappable stars (3 filled = selected state)
  - Category ratings (small stars):
    • "الالتزام بالموعد" ⭐⭐⭐⭐⭐
    • "جودة العمل" ⭐⭐⭐⭐
    • "النظافة" ⭐⭐⭐⭐⭐
  - Textarea: "اكتب تعليقك..." 
  - "إرسال التقييم" button
  - "تخطي" text link

Screen 13 — Profile / حسابي
  - Blue gradient header with avatar "أ", name "أحمد حسن", email
  - Loyalty points card: "⭐ 2,450 نقطة = 24 ج.م"
  - Settings list (RTL):
    🌙 الوضع الداكن (toggle)
    🌐 اللغة (EN | AR)
    👤 تعديل الملف الشخصي
    📍 العنوان
    💬 الدعم الفني
    ℹ️ عن التطبيق
  - "🚪 تسجيل الخروج" red outlined button
  - Bottom nav

Screen 14 — Support / الدعم الفني
  - Quick actions row: "📞 اتصال" | "❓ أسئلة شائعة" | "🛡️ ضمان"
  - Chat with support team (Arabic messages, different from technician chat)
  - Input bar

═══════════════════════════════════════════════════
4. DESIGN SYSTEM
═══════════════════════════════════════════════════
Colors:
  Primary: #1565C0 (blue)
  Secondary: #FF6F00 (orange)
  Tertiary: #00897B (teal)
  Emergency: linear-gradient(135deg, #D32F2F, #F44336)
  Background (page): #0f1923
  Phone screen bg: #f5f7fa
  Cards: #ffffff

Typography: "Cairo" for all Arabic, weights 400/600/700/800

The map simulation on the technician tracking screen should use CSS only:
  - Light green/gray background with a grid pattern suggesting streets
  - A pulsing blue circle for technician
  - A red pin for user location
  - A dashed line connecting them suggesting a route
  - Semi-transparent overlay card from bottom with technician info

═══════════════════════════════════════════════════
5. INTERACTION & NAVIGATION
═══════════════════════════════════════════════════
- Horizontal pill nav at top cycles through all 14 screens (Arabic labels)
- Clickable elements navigate between screens:
  • Home category tap → Service Details
  • "أضف للسلة" → Cart
  • "متابعة" → Booking
  • "التالي" → Payment
  • "تأكيد الحجز" → Confirmation
  • "تتبع الطلب" (from orders) → Technician Tracking
  • "💬 محادثة" on tracking screen → Chat with Technician
  • "تقييم الخدمة" → Rating screen
  • Bottom nav items navigate to respective screens
- Screen info panel below phone (Arabic) shows: screen title, description, feature chips

═══════════════════════════════════════════════════
6. TECHNICAL REQUIREMENTS
═══════════════════════════════════════════════════
- Single HTML file, no external dependencies except Google Fonts CDN
- All CSS inline in <style>
- All JS inline in <script>
- RTL: dir="rtl" on phone screen container, proper CSS for RTL layout
- Smooth transitions when switching screens
- Responsive: on mobile (<500px), phone frame goes full-width borderless
- No emoji rendering issues: use native emoji only

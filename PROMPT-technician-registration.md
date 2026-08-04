PROMPT — HomeEase Technician Registration & Onboarding System

Build a complete technician registration and onboarding flow for the HomeEase app. Technicians are service providers (plumbers, electricians, cleaners, etc.) who sign up to receive job requests from customers. This is their dedicated portal within the same app.

═══════════════════════════════════════════════════
1. TECHNICIAN REGISTRATION FLOW (Multi-Step Form)
═══════════════════════════════════════════════════

The registration must be a guided, multi-step wizard (4 steps) that feels professional and trustworthy. All UI in Arabic (RTL). The flow:

STEP 1 — البيانات الشخصية (Personal Information)
  Fields:
  • الاسم بالكامل (Full name) — text input, required
  • السن (Age) — number input, required, min 18 max 65
  • رقم الموبايل (Phone number) — phone input with +20 prefix, required
  • العنوان (Address) — text input with area/district, required
  • المحافظة (Governorate) — dropdown: القاهرة, الجيزة, الإسكندرية, etc.

STEP 2 — التخصص والخبرة (Specialization & Experience)
  Fields:
  • التخصص (Specialization) — multi-select chips:
    سباكة 🔧 | كهرباء ⚡ | تنظيف 🧹 | دهانات 🎨 | نجارة 🪚 | تكييف ❄️ | أجهزة 🔌 | مكافحة حشرات 🐛
  • سنوات الخبرة (Years of experience) — slider or number, 1-30+
  • نبذة عنك (About you) — textarea, 50-500 chars
    Placeholder: "اكتب نبذة مختصرة عن خبرتك ومهاراتك..."
  • المؤهل الدراسي (Education) — single select:
    - ابتدائي (Primary)
    - إعدادي (Preparatory) 
    - ثانوي / دبلوم (Secondary / Diploma)
    - مؤهل عالي (University/College)
    - تعليم فني / مهني (Technical/Vocational)

STEP 3 — المستندات والصور (Documents & Photos)
  Upload fields (each with camera icon + gallery option):
  • صورة شخصية (Profile photo) — circular preview, face clearly visible
  • صورة البطاقة - وجه أمامي (National ID - Front) — rectangular preview
  • صورة البطاقة - وجه خلفي (National ID - Back) — rectangular preview  
  • صورة الفيش والتشبيه (Criminal Record Clearance) — rectangular preview
  
  Each upload area shows:
  - Dashed border placeholder with camera icon
  - Tap to upload from camera or gallery
  - After upload: thumbnail preview with X to remove
  - File size limit note: "الحد الأقصى ٥ ميجا"

STEP 4 — المراجعة والموافقة (Review & Submit)
  • Summary card showing all entered data
  • Preview of uploaded photos (thumbnails)
  • Checkbox: أوافق على شروط الاستخدام وسياسة الخصوصية
  • Checkbox: أقر بأن جميع البيانات المقدمة صحيحة
  • "إرسال طلب التسجيل" button
  • Note: "سيتم مراجعة طلبك خلال ٢٤-٤٨ ساعة"

═══════════════════════════════════════════════════
2. POST-REGISTRATION SCREENS
═══════════════════════════════════════════════════

SCREEN — طلبك قيد المراجعة (Application Under Review)
  • Hourglass/clock animation
  • "تم إرسال طلبك بنجاح!"
  • "جاري مراجعة بياناتك — سنتواصل معك خلال ٢٤-٤٨ ساعة"
  • Application status: قيد المراجعة (Under Review)
  • "تواصل معنا" support button
  • Illustration or icon

SCREEN — لوحة تحكم الفني (Technician Dashboard) — after approval
  • Welcome header with technician name + photo
  • Stats cards: طلبات جديدة (3) | مكتملة (142) | التقييم (4.8⭐) | الأرباح (12,500 ج.م)
  • New job request cards with accept/reject buttons
  • Toggle: متاح / غير متاح (Available / Unavailable)

═══════════════════════════════════════════════════
3. VISUAL DESIGN
═══════════════════════════════════════════════════
  • Step indicator at top: 4 connected dots with labels
  • Progress bar showing completion percentage
  • Each step slides in from left (RTL: right)
  • Upload areas: dashed border, 2px, rounded 16px, light gray bg
  • Photo previews: object-fit cover, rounded corners
  • Form validation: red border + error text below invalid fields
  • All in Arabic with Cairo font, RTL direction
  • Color scheme: same HomeEase blue (#1565C0), teal (#00897B), orange (#FF6F00)

PROMPT — HomeEase Dual Registration System (Client vs Technician)

Redesign the entire authentication flow of the HomeEase app to support TWO distinct user types: Clients (customers who book services) and Technicians (service providers who receive jobs). The login screen serves as the single entry point, and registration splits into two completely separate paths.

═══════════════════════════════════════════════════
1. LOGIN SCREEN (Unified) — تسجيل الدخول
═══════════════════════════════════════════════════

A single login screen for BOTH user types. After login, the app checks the user's role from Firestore and routes accordingly (client → home screen, technician → technician dashboard).

Layout (Arabic RTL):
- Blue gradient hero header with app logo "🏠 هوم إيز"
- Phone number input field: "رقم الموبايل" with +20 prefix
- Password input field: "كلمة المرور" with show/hide toggle
- "تسجيل الدخول" primary button (full width, blue gradient)
- "نسيت كلمة المرور؟" text link (centered, small)
- Divider line with "أو" (or) in the middle
- Google Sign-In button (outlined, full width): "تسجيل بحساب جوجل"
- Bottom section — THE KEY PART:
  "ليس لديك حساب؟" heading
  Two large tappable cards side by side:
  
  CARD 1 — تسجيل كعميل (Register as Client)
    Icon: 👤
    Color: Blue (#1565C0)
    Label: "عميل"
    Sublabel: "احجز خدمات منزلية"
    → Navigates to: Client Registration Screen

  CARD 2 — تسجيل كفني (Register as Technician)
    Icon: 🔧
    Color: Teal (#00897B)
    Label: "فني"
    Sublabel: "انضم كمقدم خدمة"
    → Navigates to: Technician Registration (existing 4-step wizard)

- Language toggle at very bottom: "English ↔ العربية"

═══════════════════════════════════════════════════
2. CLIENT REGISTRATION SCREEN — تسجيل عميل جديد
═══════════════════════════════════════════════════

Simple, single-page registration form. Minimal fields — get the client onboarded fast.

Header:
- Back button → returns to login
- Title: "تسجيل عميل جديد"
- Subtitle: "أنشئ حسابك واحجز أول خدمة"
- Icon/illustration: 👤 in blue circle

Form fields (all required):
1. الاسم بالكامل (Full Name)
   - Text input, icon: person
   - Placeholder: "مثال: أحمد محمد"

2. رقم الموبايل (Phone Number)  
   - Phone input with +20 prefix
   - Placeholder: "01XXXXXXXXX"
   - Note: "سيتم إرسال كود تأكيد"

3. كلمة المرور (Password)
   - Password input with show/hide toggle
   - Minimum 6 characters
   - Strength indicator bar (weak/medium/strong)

4. تأكيد كلمة المرور (Confirm Password)
   - Must match password field

Bottom:
- Checkbox: "أوافق على شروط الاستخدام وسياسة الخصوصية"
- "إنشاء حساب" primary button (blue gradient)
- "لديك حساب بالفعل؟ تسجيل الدخول" text link

After successful registration:
→ OTP verification screen (enter 6-digit code sent to phone)
→ Then navigate to Home Screen

═══════════════════════════════════════════════════
3. TECHNICIAN REGISTRATION (Already Built — 4 Steps)
═══════════════════════════════════════════════════

The existing 4-step technician registration wizard remains as-is:
Step 1: Personal info (name, age, phone, address, governorate)
Step 2: Specialization, experience, education, bio
Step 3: Documents (profile photo, ID front/back, criminal record)
Step 4: Review & submit

The only change: the entry point is now from the login screen's "تسجيل كفني" card instead of from a menu option.

═══════════════════════════════════════════════════
4. ROLE SELECTION CARD DESIGN
═══════════════════════════════════════════════════

The two registration cards on the login screen should be:
- Side by side, equal width
- Height: ~120px
- Rounded corners (16px)
- Light colored background (blue-light for client, teal-light for tech)
- Centered icon (large, 36px)
- Bold label text
- Small subtitle text
- Subtle border (1.5px)
- Tap effect / hover state
- The active/selected card should have a stronger border and slight shadow

═══════════════════════════════════════════════════
5. OTP VERIFICATION SCREEN — تأكيد رقم الموبايل
═══════════════════════════════════════════════════

After client registration:
- Header: "تأكيد رقم الموبايل"
- Subtitle: "أدخل الكود المرسل إلى 01XXXXXXXXX"
- 6 individual digit input boxes (auto-focus next on entry)
- Timer: "إعادة الإرسال بعد 00:45"
- "لم يصلك الكود؟ إعادة الإرسال" link (enabled after timer)
- "تأكيد" button
- Auto-submit when all 6 digits entered

═══════════════════════════════════════════════════
6. FIRESTORE USER DOCUMENT STRUCTURE
═══════════════════════════════════════════════════

users/{userId}:
  role: "client" | "technician"
  name: string
  phone: string
  email: string (optional, from Google Sign-In)
  address: string
  createdAt: timestamp
  
  // Client-specific:
  loyaltyPoints: number
  
  // Technician-specific:
  technicianStatus: "pending" | "approved" | "rejected"
  technicianApplicationId: string (reference to technician_applications collection)

═══════════════════════════════════════════════════
7. POST-LOGIN ROUTING LOGIC
═══════════════════════════════════════════════════

After any login (email, phone, Google):
1. Fetch user document from Firestore
2. Check role field:
   - role == "client" → navigate to Main Home Screen
   - role == "technician":
     - technicianStatus == "approved" → navigate to Technician Dashboard
     - technicianStatus == "pending" → navigate to "Under Review" screen
     - technicianStatus == "rejected" → show rejection message with reason
3. No user document (new Google sign-in) → show role selection dialog

═══════════════════════════════════════════════════
8. VISUAL REQUIREMENTS
═══════════════════════════════════════════════════
- All Arabic RTL with Cairo font
- Same HomeEase color scheme
- Smooth transitions between screens
- Form validation with inline error messages (red text below fields)
- Password strength: red (weak) → orange (medium) → green (strong)
- OTP digits: large font (24px), centered, auto-focus behavior
- Role cards: subtle animation on tap (scale 0.97)

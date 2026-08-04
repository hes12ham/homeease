PROMPT — HomeEase Technician Lifecycle & Category-Based Job Routing

Build the complete technician management pipeline: from application submission, through admin review, credential issuance, to category-filtered job display. This covers admin dashboard updates, Firestore logic, and technician app screens.

═══════════════════════════════════════════════════
1. TECHNICIAN APPLICATION LIFECYCLE
═══════════════════════════════════════════════════

FLOW:
  Technician submits 4-step application
    → Status: "pending" (قيد المراجعة)
    → Admin sees new application in dashboard
    → Admin reviews documents (ID, criminal record, profile photo)
    → Admin contacts technician via phone/WhatsApp (number from application)
    → Admin either APPROVES or REJECTS:
      
      IF APPROVED:
        → Admin creates login credentials (phone + password) in Firebase Auth
        → Admin sends credentials to technician via WhatsApp/SMS
        → Firestore: technicianStatus = "approved", role = "technician"
        → Technician can now log in with those credentials
        → Technician sees their personalized dashboard
      
      IF REJECTED:
        → Admin writes rejection reason
        → Firestore: technicianStatus = "rejected", rejectionReason = "..."
        → Technician sees rejection screen with reason if they check status

═══════════════════════════════════════════════════
2. ADMIN DASHBOARD — TECHNICIAN APPLICATIONS TAB
═══════════════════════════════════════════════════

New section in admin dashboard: "طلبات الفنيين" (Technician Applications)

TABLE COLUMNS:
  - الاسم (Name)
  - الموبايل (Phone) — clickable: opens WhatsApp link
  - التخصصات (Specializations) — colored badges
  - المؤهل (Education)
  - الخبرة (Experience years)
  - المستندات (Documents) — thumbnail previews: profile photo, ID front/back, criminal record
  - تاريخ التقديم (Application date)
  - الحالة (Status) — badge: pending/approved/rejected
  - إجراءات (Actions)

ACTION BUTTONS PER APPLICATION:
  1. "👁️ عرض التفاصيل" — opens modal with FULL application data:
     - All personal info
     - Full-size document previews (profile photo, ID front, ID back, criminal record)
     - Bio text
     - Education level
     - Selected specializations
     
  2. "✅ قبول" — opens approval modal:
     - Pre-filled phone number from application
     - Auto-generated password field (random 8-char) with "generate new" button
     - "إنشاء حساب وإرسال البيانات" button
     - Creates Firebase Auth account
     - Updates Firestore: status = "approved"
     - Shows copyable credentials block:
       "رقم الدخول: 01012345678"  
       "كلمة المرور: xK9#mP2q"
     - "نسخ للواتساب" button — copies formatted message:
       "أهلاً [name]! تم قبول طلبك في هوم إيز 🎉
        بيانات الدخول:
        رقم الدخول: [phone]
        كلمة المرور: [password]
        حمّل التطبيق وسجّل دخولك الآن!"
     - "📱 فتح واتساب" button — opens wa.me/[phone] with pre-filled message
     
  3. "❌ رفض" — opens rejection modal:
     - Rejection reason textarea
     - Pre-defined reasons dropdown:
       - "مستندات غير واضحة"
       - "بيانات غير مكتملة"
       - "الفيش والتشبيه غير صالح"
       - "سبب آخر"
     - "تأكيد الرفض" button

FILTER/TABS at top:
  - الكل (All)
  - قيد المراجعة (Pending) — with count badge
  - مقبول (Approved)
  - مرفوض (Rejected)

═══════════════════════════════════════════════════
3. CATEGORY-BASED JOB ROUTING (Core Logic)
═══════════════════════════════════════════════════

The KEY business rule: Each technician ONLY sees bookings that match their registered specializations.

FIRESTORE STRUCTURE:

  technicians/{techId}:
    userId: string (Firebase Auth UID)
    fullName: string
    phone: string  
    specializations: ["plumbing", "ac"]  ← array of category keys
    status: "approved"
    isAvailable: true
    rating: 4.8
    completedJobs: 142

  bookings/{bookingId}:
    categories: ["plumbing"]  ← derived from booked services' categories
    status: "confirmed"  ← only confirmed bookings shown to technicians
    assignedTechId: null  ← null means unassigned, available for pickup
    ...other booking fields

QUERY LOGIC (Technician Dashboard):
  1. Get technician's specializations array: ["plumbing", "ac"]
  2. Query bookings where:
     - status == "confirmed" (paid and waiting for technician)
     - assignedTechId == null (not yet assigned)
     - categories array contains ANY of technician's specializations
  3. Sort by: date ascending (nearest first), then isEmergency (emergency first)
  4. Display as job cards with accept/reject

WHEN TECHNICIAN ACCEPTS A JOB:
  - Update booking: assignedTechId = techId, status = "technicianAssigned"
  - Send push notification to client: "تم تعيين فني لطلبك"
  - Job disappears from other technicians' feeds
  - Job appears in technician's "مهامي" (My Jobs) tab

═══════════════════════════════════════════════════
4. TECHNICIAN APP SCREENS (After Login)
═══════════════════════════════════════════════════

SCREEN A — لوحة التحكم (Dashboard)
  Header: Technician name + photo + availability toggle
  Stats row: طلبات جديدة | قيد التنفيذ | مكتملة | التقييم | الأرباح
  
  TAB 1: "طلبات جديدة" (New Requests) — category-filtered
    Each job card shows:
    - Service name + icon
    - Category badge matching technician's specialization
    - Customer area/district (not full address until accepted)
    - Date + time slot
    - Price
    - Emergency badge (if applicable)
    - Distance estimate (optional)
    - TWO BUTTONS: "✅ قبول" | "❌ رفض"
    
  TAB 2: "مهامي" (My Jobs) — accepted jobs
    Shows jobs in progress with:
    - Full customer info (name, address, phone)
    - Navigation button (opens Google Maps)
    - "📞 اتصال" + "💬 محادثة" buttons
    - Status update buttons: "وصلت" → "بدأت العمل" → "انتهيت"
    
  TAB 3: "السجل" (History) — completed jobs
    Past jobs with ratings received

SCREEN B — تفاصيل الطلب (Job Details)
  When technician taps a job card:
  - Full service details
  - Customer first name only (privacy)
  - Area/district
  - Date, time, notes
  - Price breakdown
  - Accept/Reject buttons
  - After acceptance: full customer details revealed

═══════════════════════════════════════════════════
5. SPECIALIZATION CATEGORIES (Must Match App Categories)
═══════════════════════════════════════════════════

The 8 categories are shared between client booking and technician registration:

  KEY          | ARABIC        | ICON | COLOR
  plumbing     | سباكة         | 🔧   | #1565C0
  electrical   | كهرباء        | ⚡   | #F57F17
  cleaning     | تنظيف         | 🧹   | #00897B
  painting     | دهانات        | 🎨   | #7B1FA2
  carpentry    | نجارة         | 🪚   | #5D4037
  ac           | تكييف         | ❄️   | #0097A7
  appliances   | أجهزة         | 🔌   | #E65100
  pest_control | مكافحة حشرات  | 🐛   | #C62828

These MUST be identical in:
  - Client home screen category grid
  - Service model category field
  - Technician registration specialization chips
  - Technician dashboard job filter
  - Admin dashboard technician badges
  - Booking model categories field

═══════════════════════════════════════════════════
6. LOGIN ROUTING (Updated)
═══════════════════════════════════════════════════

After login with phone + password:
  1. Check Firestore users/{uid}.role:
     - "client" → Home Screen
     - "technician":
       - technicianStatus == "approved" + isAvailable → Technician Dashboard
       - technicianStatus == "pending" → "Under Review" screen  
       - technicianStatus == "rejected" → Rejection screen with reason
  2. No document → Error: "الحساب غير موجود"

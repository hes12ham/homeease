PROMPT — HomeEase Updated Service Categories & Services Catalog

Replace ALL existing categories and services across the entire HomeEase app with the following real-world Egyptian home services catalog. Every screen, provider, widget, preview, and admin dashboard must reflect these exact categories and services.

═══════════════════════════════════════════════════
CATEGORIES & SERVICES (8 Categories, 19 Services)
═══════════════════════════════════════════════════

CAT 1: كهرباء (Electrical) ⚡ #F57F17
  - كهرباء عامة (General Electrical) — 200 EGP
  - مروحة (Fan Repair/Install) — 150 EGP
  - شاتر (Shutter Repair) — 250 EGP

CAT 2: سباكة (Plumbing) 🔧 #1565C0
  - سباكة عامة (General Plumbing) — 200 EGP
  - دش (Shower Install/Repair) — 180 EGP

CAT 3: أجهزة منزلية (Home Appliances) 🔌 #E65100
  - غسالة أطباق (Dishwasher Repair) — 350 EGP
  - بوتجاز (Stove/Oven Repair) — 300 EGP
  - سخانات غاز (Gas Water Heater) — 280 EGP
  - ثلاجة/فريزر (Fridge/Freezer Repair) — 350 EGP
  - غسالة (Washing Machine Repair) — 300 EGP

CAT 4: تكييف وتبريد (AC & Cooling) ❄️ #0097A7
  - صيانة التكييف (AC Maintenance) — 350 EGP
  - تركيب ونقل تكييف (AC Install/Move) — 500 EGP

CAT 5: تشطيبات ودهانات (Finishing & Painting) 🎨 #7B1FA2
  - تأسيس تشطيبات (Finishing Setup) — 800 EGP
  - نقاشة (Painting) — 600 EGP
  - تركيب البلاط والسيراميك (Tiles & Ceramics) — 700 EGP

CAT 6: نجارة وألوميتال (Carpentry & Aluminum) 🪚 #5D4037
  - نجارة (Carpentry) — 400 EGP
  - ألوميتال (Aluminum Works) — 450 EGP

CAT 7: أنظمة أمان (Security Systems) 📷 #37474F
  - تركيب وصيانة كاميرا مراقبة (CCTV Install/Repair) — 500 EGP
  - صيانة الانتركم (Intercom Repair) — 250 EGP

CAT 8: مكافحة حشرات (Pest Control) 🐛 #C62828
  - مكافحة الحشرات (Pest Control) — 300 EGP

═══════════════════════════════════════════════════
FILES TO UPDATE
═══════════════════════════════════════════════════

1. services_provider.dart — Replace defaultServices list
2. home_screen (preview) — Update category grid (4×2) with new names/icons/colors
3. Technician registration — Update specialization chips
4. Admin dashboard — Update service categories
5. Interactive preview HTML — All screens showing categories/services
6. Category colors, icons, and labels everywhere
7. ServiceItemCard widget — Update icon mapping
8. Booking model — Ensure categories match

═══════════════════════════════════════════════════
CATEGORY KEYS (for code)
═══════════════════════════════════════════════════

  KEY            | AR                  | ICON | COLOR
  electrical     | كهرباء              | ⚡   | #F57F17
  plumbing       | سباكة              | 🔧   | #1565C0
  appliances     | أجهزة منزلية        | 🔌   | #E65100
  ac             | تكييف وتبريد        | ❄️   | #0097A7
  finishing      | تشطيبات ودهانات     | 🎨   | #7B1FA2
  carpentry      | نجارة وألوميتال     | 🪚   | #5D4037
  security       | أنظمة أمان          | 📷   | #37474F
  pest_control   | مكافحة حشرات       | 🐛   | #C62828

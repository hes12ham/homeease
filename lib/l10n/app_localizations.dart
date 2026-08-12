import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) 
        ?? AppLocalizations(const Locale('ar'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'app_name': 'Home Service',
      'home': 'Home',
      'services': 'Services',
      'cart': 'Cart',
      'orders': 'Orders',
      'profile': 'Profile',
      'support': 'Support',
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'edit': 'Edit',
      'back': 'Back',
      'next': 'Next',
      'done': 'Done',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'search': 'Search services...',
      'no_results': 'No results found',
      'view_all': 'View All',
      'all_services': 'All Services',
      'all_categories': 'All Categories',
      'top_categories': 'Top Categories',
      'no_categories': 'No categories available right now',

      // Auth
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'phone': 'Phone Number',
      'full_name': 'Full Name',
      'forgot_password': 'Forgot Password?',
      'or_continue_with': 'Or continue with',
      'google_sign_in': 'Sign in with Google',
      'phone_sign_in': 'Sign in with Phone',
      'no_account': "Don't have an account?",
      'have_account': 'Already have an account?',
      'logout': 'Logout',

      // Home
      'welcome': 'Welcome',
      'our_services': 'Our Services',
      'emergency_service': 'Emergency Service',
      'emergency_desc': 'Priority booking within 1 hour',
      'popular_services': 'Popular Services',
      'recommended': 'Recommended for You',

      // Categories
      'plumbing': 'Plumbing',
      'electricity': 'Electricity',
      'ac_maintenance': 'AC Maintenance',
      'carpentry': 'Carpentry',
      'painting': 'Painting',
      'satellite': 'Satellite/Dish',
      'aluminum': 'Aluminum',
      'home_appliances': 'Home Appliances',

      // Service Details
      'service_details': 'Service Details',
      'price': 'Price',
      'warranty': 'Warranty',
      'warranty_info': '1 Month Warranty Included',
      'add_to_cart': 'Add to Cart',
      'added_to_cart': 'Added to cart!',
      'book_now': 'Book Now',
      'description': 'Description',

      // Cart
      'your_cart': 'Your Cart',
      'empty_cart': 'Your cart is empty',
      'cart_total': 'Total',
      'proceed_booking': 'Proceed to Booking',
      'remove_item': 'Remove Item',
      'quantity': 'Quantity',
      'subtotal': 'Subtotal',
      'discount': 'Discount',

      // Booking
      'booking_details': 'Booking Details',
      'select_date': 'Select Date',
      'select_time': 'Select Time Slot',
      'enter_address': 'Enter Address',
      'address_details': 'Apartment/Floor/Building Details',
      'notes': 'Additional Notes (Optional)',
      'confirm_booking': 'Confirm Booking',
      'booking_confirmed': 'Booking Confirmed!',
      'booking_id': 'Booking ID',

      // Time slots
      'morning': 'Morning (8 AM - 12 PM)',
      'afternoon': 'Afternoon (12 PM - 4 PM)',
      'evening': 'Evening (4 PM - 8 PM)',

      // Payment
      'payment': 'Payment',
      'payment_method': 'Payment Method',
      'cash': 'Cash on Service',
      'card': 'Credit/Debit Card',
      'pay_now': 'Pay Now',
      'payment_successful': 'Payment Successful!',

      // Orders / Tracking
      'my_orders': 'My Orders',
      'order_tracking': 'Order Tracking',
      'order_status': 'Order Status',
      'status_pending': 'Pending',
      'status_confirmed': 'Confirmed',
      'status_assigned': 'Technician Assigned',
      'status_in_progress': 'In Progress',
      'status_completed': 'Completed',
      'status_cancelled': 'Cancelled',
      'no_orders': 'No orders yet',
      'rate_service': 'Rate Service',
      'warranty_claim': 'Warranty Claim',

      // Profile
      'my_profile': 'My Profile',
      'edit_profile': 'Edit Profile',
      'past_orders': 'Past Orders',
      'loyalty_points': 'Loyalty Points',
      'points': 'Points',
      'redeem_points': 'Redeem Points',
      'subscription': 'Subscription Plans',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'arabic': 'العربية',
      'english': 'English',
      'notifications': 'Notifications',

      // Support
      'customer_support': 'Customer Support',
      'chat_with_us': 'Chat with us',
      'call_us': 'Call Us',
      'hotline': 'Hotline',
      'type_message': 'Type a message...',
      'send': 'Send',
      'faq': 'FAQ',

      // Loyalty
      'loyalty_program': 'Loyalty Program',
      'earn_points': 'Earn points with every booking!',
      'points_balance': 'Points Balance',
      'points_earned': 'Points earned: +',
      'points_redeemed': 'Points redeemed: -',

      // Subscription
      'subscription_plans': 'Subscription Plans',
      'subscribe': 'Subscribe',
      'monthly': '/month',
      'visits_month': 'visits/month',
      'plan_includes': 'Plan includes:',

      // Rating
      'rate_technician': 'Rate Technician',
      'write_review': 'Write a review',
      'submit_review': 'Submit Review',
      'reviews': 'Reviews',
      'thank_review': 'Thank you for your review!',

      // Emergency
      'emergency_booking': 'Emergency Booking',
      'emergency_note': 'Our technician will arrive within 1 hour',
      'emergency_surcharge': 'Emergency surcharge: 50%',

      // QR
      'scan_qr': 'Scan QR Code',
      'qr_verified': 'Technician verified!',

      // Currency
      'egp': 'EGP',
    },
    'ar': {
      // General
      'app_name': 'خدمات منزلية',
      'home': 'الرئيسية',
      'services': 'الخدمات',
      'cart': 'السلة',
      'orders': 'الطلبات',
      'profile': 'حسابي',
      'support': 'الدعم',
      'settings': 'الإعدادات',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'delete': 'حذف',
      'edit': 'تعديل',
      'back': 'رجوع',
      'next': 'التالي',
      'done': 'تم',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'تم بنجاح',
      'search': 'ابحث عن خدمة...',
      'no_results': 'لا توجد نتائج',
      'view_all': 'عرض الكل',
      'all_services': 'كل الخدمات',
      'all_categories': 'كل التصنيفات',
      'top_categories': 'أهم التصنيفات',
      'no_categories': 'لا توجد تصنيفات متاحة حالياً',

      // Auth
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'phone': 'رقم الهاتف',
      'full_name': 'الاسم الكامل',
      'forgot_password': 'نسيت كلمة المرور؟',
      'or_continue_with': 'أو تابع بواسطة',
      'google_sign_in': 'تسجيل بواسطة جوجل',
      'phone_sign_in': 'تسجيل بواسطة الهاتف',
      'no_account': 'ليس لديك حساب؟',
      'have_account': 'لديك حساب بالفعل؟',
      'logout': 'تسجيل الخروج',

      // Home
      'welcome': 'مرحباً',
      'our_services': 'خدماتنا',
      'emergency_service': 'خدمة طوارئ',
      'emergency_desc': 'حجز أولوية خلال ساعة واحدة',
      'popular_services': 'الخدمات الشائعة',
      'recommended': 'مُقترح لك',

      // Categories
      'plumbing': 'سباكة',
      'electricity': 'كهرباء',
      'ac_maintenance': 'صيانة تكييفات',
      'carpentry': 'نجارة',
      'painting': 'دهانات',
      'satellite': 'ستالايت/دش',
      'aluminum': 'ألوميتال',
      'home_appliances': 'أجهزة منزلية',

      // Service Details
      'service_details': 'تفاصيل الخدمة',
      'price': 'السعر',
      'warranty': 'الضمان',
      'warranty_info': 'ضمان شهر واحد مجاناً',
      'add_to_cart': 'أضف إلى السلة',
      'added_to_cart': 'تمت الإضافة!',
      'book_now': 'احجز الآن',
      'description': 'الوصف',

      // Cart
      'your_cart': 'سلتك',
      'empty_cart': 'السلة فارغة',
      'cart_total': 'الإجمالي',
      'proceed_booking': 'متابعة الحجز',
      'remove_item': 'إزالة',
      'quantity': 'الكمية',
      'subtotal': 'المجموع الفرعي',
      'discount': 'الخصم',

      // Booking
      'booking_details': 'تفاصيل الحجز',
      'select_date': 'اختر التاريخ',
      'select_time': 'اختر الوقت',
      'enter_address': 'أدخل العنوان',
      'address_details': 'تفاصيل الشقة/الطابق/المبنى',
      'notes': 'ملاحظات إضافية (اختياري)',
      'confirm_booking': 'تأكيد الحجز',
      'booking_confirmed': 'تم تأكيد الحجز!',
      'booking_id': 'رقم الحجز',

      // Time slots
      'morning': 'صباحاً (٨ ص - ١٢ م)',
      'afternoon': 'ظهراً (١٢ م - ٤ م)',
      'evening': 'مساءً (٤ م - ٨ م)',

      // Payment
      'payment': 'الدفع',
      'payment_method': 'طريقة الدفع',
      'cash': 'نقداً عند الخدمة',
      'card': 'بطاقة ائتمان/مدين',
      'pay_now': 'ادفع الآن',
      'payment_successful': 'تم الدفع بنجاح!',

      // Orders / Tracking
      'my_orders': 'طلباتي',
      'order_tracking': 'تتبع الطلب',
      'order_status': 'حالة الطلب',
      'status_pending': 'قيد الانتظار',
      'status_confirmed': 'مؤكد',
      'status_assigned': 'تم تعيين الفني',
      'status_in_progress': 'جاري التنفيذ',
      'status_completed': 'مكتمل',
      'status_cancelled': 'ملغي',
      'no_orders': 'لا توجد طلبات بعد',
      'rate_service': 'قيّم الخدمة',
      'warranty_claim': 'مطالبة ضمان',

      // Profile
      'my_profile': 'حسابي',
      'edit_profile': 'تعديل الحساب',
      'past_orders': 'الطلبات السابقة',
      'loyalty_points': 'نقاط الولاء',
      'points': 'نقطة',
      'redeem_points': 'استبدال النقاط',
      'subscription': 'باقات الاشتراك',
      'dark_mode': 'الوضع المظلم',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'English',
      'notifications': 'الإشعارات',

      // Support
      'customer_support': 'الدعم الفني',
      'chat_with_us': 'تحدث معنا',
      'call_us': 'اتصل بنا',
      'hotline': 'الخط الساخن',
      'type_message': 'اكتب رسالة...',
      'send': 'إرسال',
      'faq': 'الأسئلة الشائعة',

      // Loyalty
      'loyalty_program': 'برنامج الولاء',
      'earn_points': 'اكسب نقاط مع كل حجز!',
      'points_balance': 'رصيد النقاط',
      'points_earned': 'نقاط مكتسبة: +',
      'points_redeemed': 'نقاط مُستبدلة: -',

      // Subscription
      'subscription_plans': 'باقات الاشتراك',
      'subscribe': 'اشترك',
      'monthly': '/شهرياً',
      'visits_month': 'زيارة/شهر',
      'plan_includes': 'تشمل الباقة:',

      // Rating
      'rate_technician': 'قيّم الفني',
      'write_review': 'اكتب تقييماً',
      'submit_review': 'إرسال التقييم',
      'reviews': 'التقييمات',
      'thank_review': 'شكراً لتقييمك!',

      // Emergency
      'emergency_booking': 'حجز طوارئ',
      'emergency_note': 'سيصل الفني خلال ساعة واحدة',
      'emergency_surcharge': 'رسوم إضافية للطوارئ: ٥٠٪',

      // QR
      'scan_qr': 'مسح رمز QR',
      'qr_verified': 'تم التحقق من الفني!',

      // Currency
      'egp': 'ج.م',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  bool get isArabic => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
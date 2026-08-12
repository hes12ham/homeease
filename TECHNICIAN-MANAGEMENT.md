# إدارة الفنيين — Technician Management

## كيف يتم إضافة فني جديد؟

### الخطوة 1: الفني يسجّل من التطبيق
- يفتح التطبيق → يختار "فني" من شاشة اختيار الدور
- يملأ 4 خطوات:
  1. البيانات الشخصية (الاسم، السن، الموبايل، العنوان، المحافظة)
  2. التخصصات (يختار من: كهرباء، سباكة، نجارة، تكييف...)
  3. المستندات (صورة شخصية، بطاقة أمام/خلف، فيش وتشبيه)
  4. مراجعة وإرسال

### الخطوة 2: الطلب يتحفظ في Firestore
```
Collection: technician_applications
Document fields:
  fullName: "أحمد محمد"
  age: "30"
  phone: "01012345678"
  address: "شارع التحرير"
  governorate: "القاهرة"
  city: "وسط البلد"
  specializations: ["electrical", "plumbing"]
  experience: "5 سنوات"
  education: "دبلوم صنايع"
  bio: "فني كهرباء وسباكة خبرة 5 سنوات"
  status: "pending"
  profilePhotoUrl: "..."
  idFrontUrl: "..."
  idBackUrl: "..."
  criminalRecordUrl: "..."
```

### الخطوة 3: الأدمن يراجع
- يدخل Firebase Console → Firestore → technician_applications
- يراجع البيانات والصور
- يغيّر status من "pending" لـ:
  - "approved" → الفني يقدر يسجّل دخول
  - "rejected" → الفني مترفض

### الخطوة 4: إنشاء حساب للفني (لو اتقبل)
1. Firebase Console → Authentication → Add user
2. Email: 01012345678@homeservice.app
3. Password: (اختار باسوورد)
4. في Firestore → users/{uid}:
   ```
   name: "أحمد محمد"
   email: "01012345678@homeservice.app"
   phone: "01012345678"
   role: "technician"
   technicianStatus: "approved"
   ```
5. ابعت للفني بيانات الدخول على واتساب

## ربط الفني بالمنطقة والتخصص

في Firestore كل فني عنده:
- `governorate`: المحافظة (القاهرة، الجيزة، الإسكندرية...)
- `city`: المدينة/الحي (وسط البلد، المعادي، الدقي...)
- `specializations`: مصفوفة التخصصات ["electrical", "plumbing"]
- `isAvailable`: متاح ولا لا

### فلترة الفنيين (كود Firestore):
```
FirebaseFirestore.instance
  .collection('technician_applications')
  .where('status', isEqualTo: 'approved')
  .where('specializations', arrayContains: 'electrical')
  // + فلترة بالمنطقة client-side
```

## تغيير بيانات فني
- Firebase Console → Firestore → technician_applications
- اضغط على الـ document → عدّل الحقول

## حذف فني
- غيّر status لـ "rejected" أو "suspended"
- في Authentication → احذف الـ user

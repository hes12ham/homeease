import 'package:cloud_firestore/cloud_firestore.dart';

enum TechnicianStatus { pending, approved, rejected, suspended }

enum EducationLevel { primary, preparatory, secondary, university, technical }

class TechnicianApplication {
  final String id;
  final String userId;
  final String fullName;
  final int age;
  final String phone;
  final String address;
  final String governorate;
  final List<String> specializations;
  final int yearsOfExperience;
  final String bio;
  final EducationLevel education;
  final String profilePhotoUrl;
  final String idFrontUrl;
  final String idBackUrl;
  final String criminalRecordUrl;
  final TechnicianStatus status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  TechnicianApplication({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.age,
    required this.phone,
    required this.address,
    required this.governorate,
    required this.specializations,
    required this.yearsOfExperience,
    required this.bio,
    required this.education,
    required this.profilePhotoUrl,
    required this.idFrontUrl,
    required this.idBackUrl,
    required this.criminalRecordUrl,
    this.status = TechnicianStatus.pending,
    this.rejectionReason,
    required this.createdAt,
    this.reviewedAt,
  });

  factory TechnicianApplication.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return TechnicianApplication(
      id: doc.id,
      userId: d['userId'] ?? '',
      fullName: d['fullName'] ?? '',
      age: d['age'] ?? 18,
      phone: d['phone'] ?? '',
      address: d['address'] ?? '',
      governorate: d['governorate'] ?? '',
      specializations: List<String>.from(d['specializations'] ?? []),
      yearsOfExperience: d['yearsOfExperience'] ?? 0,
      bio: d['bio'] ?? '',
      education: EducationLevel.values.firstWhere(
        (e) => e.name == d['education'],
        orElse: () => EducationLevel.primary,
      ),
      profilePhotoUrl: d['profilePhotoUrl'] ?? '',
      idFrontUrl: d['idFrontUrl'] ?? '',
      idBackUrl: d['idBackUrl'] ?? '',
      criminalRecordUrl: d['criminalRecordUrl'] ?? '',
      status: TechnicianStatus.values.firstWhere(
        (e) => e.name == d['status'],
        orElse: () => TechnicianStatus.pending,
      ),
      rejectionReason: d['rejectionReason'],
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedAt: (d['reviewedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'fullName': fullName,
        'age': age,
        'phone': phone,
        'address': address,
        'governorate': governorate,
        'specializations': specializations,
        'yearsOfExperience': yearsOfExperience,
        'bio': bio,
        'education': education.name,
        'profilePhotoUrl': profilePhotoUrl,
        'idFrontUrl': idFrontUrl,
        'idBackUrl': idBackUrl,
        'criminalRecordUrl': criminalRecordUrl,
        'status': status.name,
        'rejectionReason': rejectionReason,
        'createdAt': Timestamp.fromDate(createdAt),
        'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      };

  static String educationLabel(EducationLevel level, {bool isAr = true}) {
    final arLabels = {
      EducationLevel.primary: 'ابتدائي',
      EducationLevel.preparatory: 'إعدادي',
      EducationLevel.secondary: 'ثانوي / دبلوم',
      EducationLevel.university: 'مؤهل عالي',
      EducationLevel.technical: 'تعليم فني / مهني',
    };
    final enLabels = {
      EducationLevel.primary: 'Primary',
      EducationLevel.preparatory: 'Preparatory',
      EducationLevel.secondary: 'Secondary / Diploma',
      EducationLevel.university: 'University',
      EducationLevel.technical: 'Technical / Vocational',
    };
    return isAr ? arLabels[level]! : enLabels[level]!;
  }

  static String statusLabel(TechnicianStatus status, {bool isAr = true}) {
    final arLabels = {
      TechnicianStatus.pending: 'قيد المراجعة',
      TechnicianStatus.approved: 'مقبول',
      TechnicianStatus.rejected: 'مرفوض',
      TechnicianStatus.suspended: 'موقوف',
    };
    final enLabels = {
      TechnicianStatus.pending: 'Under Review',
      TechnicianStatus.approved: 'Approved',
      TechnicianStatus.rejected: 'Rejected',
      TechnicianStatus.suspended: 'Suspended',
    };
    return isAr ? arLabels[status]! : enLabels[status]!;
  }

  static const List<String> governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'القليوبية',
    'الشرقية',
    'الدقهلية',
    'المنوفية',
    'الغربية',
    'كفر الشيخ',
    'البحيرة',
    'دمياط',
    'بورسعيد',
    'الإسماعيلية',
    'السويس',
    'شمال سيناء',
    'جنوب سيناء',
    'البحر الأحمر',
    'الفيوم',
    'بني سويف',
    'المنيا',
    'أسيوط',
    'سوهاج',
    'قنا',
    'الأقصر',
    'أسوان',
    'الوادي الجديد',
    'مطروح',
  ];
}

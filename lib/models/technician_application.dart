import 'package:cloud_firestore/cloud_firestore.dart';

enum TechnicianStatus { pending, approved, rejected, suspended }

class TechnicianApplication {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String address;
  final String governorate;
  final List<String> specializations;
  final int yearsOfExperience;
  final String bio;
  final String profilePhotoUrl;
  final String idFrontUrl;
  final String idBackUrl;
  final TechnicianStatus status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  TechnicianApplication({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.governorate,
    required this.specializations,
    required this.yearsOfExperience,
    required this.bio,
    required this.profilePhotoUrl,
    required this.idFrontUrl,
    required this.idBackUrl,
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
      phone: d['phone'] ?? '',
      address: d['address'] ?? '',
      governorate: d['governorate'] ?? '',
      specializations: List<String>.from(d['specializations'] ?? []),
      yearsOfExperience: d['yearsOfExperience'] ?? 0,
      bio: d['bio'] ?? '',
      profilePhotoUrl: d['profilePhotoUrl'] ?? '',
      idFrontUrl: d['idFrontUrl'] ?? '',
      idBackUrl: d['idBackUrl'] ?? '',
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
        'phone': phone,
        'address': address,
        'governorate': governorate,
        'specializations': specializations,
        'yearsOfExperience': yearsOfExperience,
        'bio': bio,
        'profilePhotoUrl': profilePhotoUrl,
        'idFrontUrl': idFrontUrl,
        'idBackUrl': idBackUrl,
        'status': status.name,
        'rejectionReason': rejectionReason,
        'createdAt': Timestamp.fromDate(createdAt),
        'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      };



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

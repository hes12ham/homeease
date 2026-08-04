import 'package:cloud_firestore/cloud_firestore.dart';

// ─── User Model ──────────────────────────────────────────────
class AppUser {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String role;
  final String? technicianStatus;
  final int loyaltyPoints;
  final String? photoUrl;
  final String? fcmToken;
  final DateTime createdAt;
  final String? subscriptionPlanId;

  AppUser({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    this.address = '',
    this.role = 'client',
    this.technicianStatus,
    this.loyaltyPoints = 0,
    this.photoUrl,
    this.fcmToken,
    DateTime? createdAt,
    this.subscriptionPlanId,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      role: data['role'] ?? 'client',
      technicianStatus: data['technicianStatus'],
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      photoUrl: data['photoUrl'],
      fcmToken: data['fcmToken'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      subscriptionPlanId: data['subscriptionPlanId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'role': role,
        'technicianStatus': technicianStatus,
        'loyaltyPoints': loyaltyPoints,
        'photoUrl': photoUrl,
        'fcmToken': fcmToken,
        'createdAt': Timestamp.fromDate(createdAt),
        'subscriptionPlanId': subscriptionPlanId,
      };
}

// ─── Service Model ───────────────────────────────────────────
class ServiceModel {
  final String id;
  final String nameEn;
  final String nameAr;
  final String category;
  final String descriptionEn;
  final String descriptionAr;
  final double price;
  final double rating;
  final int reviewCount;
  final String warrantyPeriod;
  final String iconName;
  final String? imageUrl;
  final bool isEmergencyAvailable;
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.category,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.warrantyPeriod = '1 month',
    required this.iconName,
    this.imageUrl,
    this.isEmergencyAvailable = false,
    this.isActive = true,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      nameEn: data['nameEn'] ?? '',
      nameAr: data['nameAr'] ?? '',
      category: data['category'] ?? '',
      descriptionEn: data['descriptionEn'] ?? '',
      descriptionAr: data['descriptionAr'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      warrantyPeriod: data['warrantyPeriod'] ?? '1 month',
      iconName: data['iconName'] ?? 'build',
      imageUrl: data['imageUrl'],
      isEmergencyAvailable: data['isEmergencyAvailable'] ?? false,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'nameEn': nameEn,
        'nameAr': nameAr,
        'category': category,
        'descriptionEn': descriptionEn,
        'descriptionAr': descriptionAr,
        'price': price,
        'rating': rating,
        'reviewCount': reviewCount,
        'warrantyPeriod': warrantyPeriod,
        'iconName': iconName,
        'imageUrl': imageUrl,
        'isEmergencyAvailable': isEmergencyAvailable,
        'isActive': isActive,
      };
}

// ─── Booking Model ───────────────────────────────────────────
enum BookingStatus {
  pending,
  confirmed,
  technicianAssigned,
  inProgress,
  completed,
  cancelled,
}

class BookingModel {
  final String id;
  final String userId;
  final List<CartItem> services;
  final DateTime date;
  final String timeSlot;
  final String address;
  final String addressDetails;
  final BookingStatus status;
  final String? technicianId;
  final String paymentMethod;
  final double totalAmount;
  final double discount;
  final int loyaltyPointsUsed;
  final bool isEmergency;
  final DateTime createdAt;
  final String? notes;
  final String? qrCode;

  BookingModel({
    required this.id,
    required this.userId,
    required this.services,
    required this.date,
    required this.timeSlot,
    required this.address,
    this.addressDetails = '',
    this.status = BookingStatus.pending,
    this.technicianId,
    required this.paymentMethod,
    required this.totalAmount,
    this.discount = 0,
    this.loyaltyPointsUsed = 0,
    this.isEmergency = false,
    DateTime? createdAt,
    this.notes,
    this.qrCode,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      services: (data['services'] as List<dynamic>?)
              ?.map((s) => CartItem.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
      date: (data['date'] as Timestamp).toDate(),
      timeSlot: data['timeSlot'] ?? '',
      address: data['address'] ?? '',
      addressDetails: data['addressDetails'] ?? '',
      status: BookingStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => BookingStatus.pending,
      ),
      technicianId: data['technicianId'],
      paymentMethod: data['paymentMethod'] ?? 'cash',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      loyaltyPointsUsed: data['loyaltyPointsUsed'] ?? 0,
      isEmergency: data['isEmergency'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: data['notes'],
      qrCode: data['qrCode'],
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'services': services.map((s) => s.toMap()).toList(),
        'date': Timestamp.fromDate(date),
        'timeSlot': timeSlot,
        'address': address,
        'addressDetails': addressDetails,
        'status': status.name,
        'technicianId': technicianId,
        'paymentMethod': paymentMethod,
        'totalAmount': totalAmount,
        'discount': discount,
        'loyaltyPointsUsed': loyaltyPointsUsed,
        'isEmergency': isEmergency,
        'createdAt': Timestamp.fromDate(createdAt),
        'notes': notes,
        'qrCode': qrCode,
      };
}

// ─── Cart Item ───────────────────────────────────────────────
class CartItem {
  final String serviceId;
  final String nameEn;
  final String nameAr;
  final String category;
  final double price;
  int quantity;

  CartItem({
    required this.serviceId,
    required this.nameEn,
    required this.nameAr,
    this.category = '',
    required this.price,
    this.quantity = 1,
  });

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      serviceId: data['serviceId'] ?? '',
      nameEn: data['nameEn'] ?? '',
      nameAr: data['nameAr'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() => {
        'serviceId': serviceId,
        'nameEn': nameEn,
        'nameAr': nameAr,
        'category': category,
        'price': price,
        'quantity': quantity,
      };

  double get total => price * quantity;
}

// ─── Technician Model ────────────────────────────────────────
class Technician {
  final String id;
  final String name;
  final String phone;
  final List<String> skills;
  final double rating;
  final int completedJobs;
  final String? photoUrl;
  final List<String> documents;
  final bool isAvailable;

  Technician({
    required this.id,
    required this.name,
    required this.phone,
    required this.skills,
    this.rating = 0.0,
    this.completedJobs = 0,
    this.photoUrl,
    this.documents = const [],
    this.isAvailable = true,
  });

  factory Technician.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Technician(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      completedJobs: data['completedJobs'] ?? 0,
      photoUrl: data['photoUrl'],
      documents: List<String>.from(data['documents'] ?? []),
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'skills': skills,
        'rating': rating,
        'completedJobs': completedJobs,
        'photoUrl': photoUrl,
        'documents': documents,
        'isAvailable': isAvailable,
      };
}

// ─── Review Model ────────────────────────────────────────────
class ReviewModel {
  final String id;
  final String bookingId;
  final String userId;
  final String technicianId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.technicianId,
    required this.rating,
    required this.comment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      bookingId: data['bookingId'] ?? '',
      userId: data['userId'] ?? '',
      technicianId: data['technicianId'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'bookingId': bookingId,
        'userId': userId,
        'technicianId': technicianId,
        'rating': rating,
        'comment': comment,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}

// ─── Chat Message Model ──────────────────────────────────────
class ChatMessage {
  final String id;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final bool isFromUser;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.isFromUser,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isFromUser: data['isFromUser'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'message': message,
        'timestamp': Timestamp.fromDate(timestamp),
        'isFromUser': isFromUser,
      };
}

// ─── Subscription Plan Model ─────────────────────────────────
class SubscriptionPlan {
  final String id;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final double monthlyPrice;
  final int visitsPerMonth;
  final List<String> includedCategories;
  final double discountPercentage;

  SubscriptionPlan({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.monthlyPrice,
    required this.visitsPerMonth,
    required this.includedCategories,
    this.discountPercentage = 0,
  });

  factory SubscriptionPlan.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubscriptionPlan(
      id: doc.id,
      nameEn: data['nameEn'] ?? '',
      nameAr: data['nameAr'] ?? '',
      descriptionEn: data['descriptionEn'] ?? '',
      descriptionAr: data['descriptionAr'] ?? '',
      monthlyPrice: (data['monthlyPrice'] ?? 0).toDouble(),
      visitsPerMonth: data['visitsPerMonth'] ?? 0,
      includedCategories: List<String>.from(data['includedCategories'] ?? []),
      discountPercentage: (data['discountPercentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'nameEn': nameEn,
        'nameAr': nameAr,
        'descriptionEn': descriptionEn,
        'descriptionAr': descriptionAr,
        'monthlyPrice': monthlyPrice,
        'visitsPerMonth': visitsPerMonth,
        'includedCategories': includedCategories,
        'discountPercentage': discountPercentage,
      };
}

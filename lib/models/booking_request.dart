import 'package:cloud_firestore/cloud_firestore.dart';

class PriceOffer {
  final String from; // "client" or "tech"
  final double price;
  final DateTime timestamp;
  final bool accepted;

  PriceOffer({
    required this.from,
    required this.price,
    required this.timestamp,
    this.accepted = false,
  });

  Map<String, dynamic> toMap() => {
    'from': from,
    'price': price,
    'timestamp': Timestamp.fromDate(timestamp),
    'accepted': accepted,
  };

  factory PriceOffer.fromMap(Map<String, dynamic> m) => PriceOffer(
    from: m['from'] ?? '',
    price: (m['price'] ?? 0).toDouble(),
    timestamp: (m['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    accepted: m['accepted'] ?? false,
  );
}

class BookingRequest {
  final String id;
  final String clientId;
  final String clientName;
  final String clientPhone;
  final String techId;
  final String techName;
  final String serviceId;
  final String serviceName;
  final String category;
  final String address;
  final String city;
  final DateTime date;
  final String timeSlot;
  final double basePrice;
  final List<PriceOffer> offers;
  final double? agreedPrice;
  final double? appFee; // 10%
  final double? techReceives; // 90%
  final String status; // pending, negotiating, agreed, inProgress, completed, cancelled

  BookingRequest({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.clientPhone,
    required this.techId,
    required this.techName,
    required this.serviceId,
    required this.serviceName,
    required this.category,
    required this.address,
    required this.city,
    required this.date,
    required this.timeSlot,
    required this.basePrice,
    this.offers = const [],
    this.agreedPrice,
    this.appFee,
    this.techReceives,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() => {
    'clientId': clientId,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'techId': techId,
    'techName': techName,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'category': category,
    'address': address,
    'city': city,
    'date': Timestamp.fromDate(date),
    'timeSlot': timeSlot,
    'basePrice': basePrice,
    'offers': offers.map((o) => o.toMap()).toList(),
    'agreedPrice': agreedPrice,
    'appFee': appFee,
    'techReceives': techReceives,
    'status': status,
    'createdAt': FieldValue.serverTimestamp(),
  };

  factory BookingRequest.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return BookingRequest(
      id: doc.id,
      clientId: d['clientId'] ?? '',
      clientName: d['clientName'] ?? '',
      clientPhone: d['clientPhone'] ?? '',
      techId: d['techId'] ?? '',
      techName: d['techName'] ?? '',
      serviceId: d['serviceId'] ?? '',
      serviceName: d['serviceName'] ?? '',
      category: d['category'] ?? '',
      address: d['address'] ?? '',
      city: d['city'] ?? '',
      date: (d['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      timeSlot: d['timeSlot'] ?? '',
      basePrice: (d['basePrice'] ?? 0).toDouble(),
      offers: (d['offers'] as List<dynamic>?)
          ?.map((o) => PriceOffer.fromMap(o as Map<String, dynamic>))
          .toList() ?? [],
      agreedPrice: (d['agreedPrice'] as num?)?.toDouble(),
      appFee: (d['appFee'] as num?)?.toDouble(),
      techReceives: (d['techReceives'] as num?)?.toDouble(),
      status: d['status'] ?? 'pending',
    );
  }

  // Calculate fees
  static Map<String, double> calculateFees(double agreedPrice) {
    final appFee = (agreedPrice * 0.10).roundToDouble();
    final techReceives = agreedPrice - appFee;
    return {'appFee': appFee, 'techReceives': techReceives};
  }

  // Get last offer
  PriceOffer? get lastOffer => offers.isNotEmpty ? offers.last : null;
  double get currentPrice => lastOffer?.price ?? basePrice;
}

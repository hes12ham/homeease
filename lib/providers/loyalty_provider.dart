import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoyaltyProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _points = 0;
  static const int pointsPerEGP = 1; // 1 point per 1 EGP spent
  static const int pointsToEGP = 100; // 100 points = 1 EGP discount
  static const double maxDiscountPercent = 0.2; // Max 20% discount

  int get points => _points;
  double get redeemableAmount => _points / pointsToEGP;

  Future<void> loadPoints(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      _points = (doc.data()?['loyaltyPoints'] ?? 0) as int;
      notifyListeners();
    } catch (_) {}
  }

  // Calculate points earned from a booking
  int calculatePointsEarned(double amount) {
    return (amount * pointsPerEGP).round();
  }

  // Calculate max discount from points
  double calculateMaxDiscount(double totalAmount) {
    final maxFromPoints = redeemableAmount;
    final maxFromPercent = totalAmount * maxDiscountPercent;
    return maxFromPoints < maxFromPercent ? maxFromPoints : maxFromPercent;
  }

  // Add points after completed booking
  Future<void> addPoints(String userId, double bookingAmount) async {
    final earned = calculatePointsEarned(bookingAmount);
    _points += earned;

    try {
      await _firestore.collection('users').doc(userId).update({
        'loyaltyPoints': FieldValue.increment(earned),
      });
    } catch (_) {}
    notifyListeners();
  }

  // Redeem points for discount
  Future<double> redeemPoints(String userId, double totalAmount,
      int pointsToRedeem) async {
    if (pointsToRedeem > _points) return 0;

    final discount = pointsToRedeem / pointsToEGP;
    final maxDiscount = totalAmount * maxDiscountPercent;
    final actualDiscount = discount < maxDiscount ? discount : maxDiscount;

    final actualPointsUsed = (actualDiscount * pointsToEGP).round();
    _points -= actualPointsUsed;

    try {
      await _firestore.collection('users').doc(userId).update({
        'loyaltyPoints': FieldValue.increment(-actualPointsUsed),
      });
    } catch (_) {}

    notifyListeners();
    return actualDiscount;
  }
}

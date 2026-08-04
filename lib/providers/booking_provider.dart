import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<BookingModel> _bookings = [];
  BookingModel? _currentBooking;
  bool _isLoading = false;

  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String _address = '';
  String _addressDetails = '';
  String _notes = '';
  String _paymentMethod = 'cash';
  bool _isEmergency = false;

  List<BookingModel> get bookings => _bookings;
  BookingModel? get currentBooking => _currentBooking;
  bool get isLoading => _isLoading;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  String get address => _address;
  String get addressDetails => _addressDetails;
  String get notes => _notes;
  String get paymentMethod => _paymentMethod;
  bool get isEmergency => _isEmergency;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTimeSlot(String slot) {
    _selectedTimeSlot = slot;
    notifyListeners();
  }

  void setAddress(String addr) {
    _address = addr;
    notifyListeners();
  }

  void setAddressDetails(String details) {
    _addressDetails = details;
    notifyListeners();
  }

  void setNotes(String n) {
    _notes = n;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setEmergency(bool value) {
    _isEmergency = value;
    notifyListeners();
  }

  Future<String?> createBooking({
    required String userId,
    required List<CartItem> services,
    required double totalAmount,
    double discount = 0,
    int loyaltyPointsUsed = 0,
  }) async {
    if (_selectedDate == null || _selectedTimeSlot == null || _address.isEmpty) {
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final bookingId = const Uuid().v4().substring(0, 8).toUpperCase();
      final qrCode = 'HOMEEASE-$bookingId';

      double finalAmount = totalAmount;
      if (_isEmergency) {
        finalAmount *= 1.5;
      }
      finalAmount -= discount;

      final booking = BookingModel(
        id: bookingId,
        userId: userId,
        services: services,
        date: _selectedDate!,
        timeSlot: _selectedTimeSlot!,
        address: _address,
        addressDetails: _addressDetails,
        status: BookingStatus.pending,
        paymentMethod: _paymentMethod,
        totalAmount: finalAmount,
        discount: discount,
        loyaltyPointsUsed: loyaltyPointsUsed,
        isEmergency: _isEmergency,
        notes: _notes,
        qrCode: qrCode,
      );

      await _firestore.collection('bookings').doc(bookingId).set({
        ...booking.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentBooking = booking;
      _resetForm();
      _isLoading = false;
      notifyListeners();
      return bookingId;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error creating booking: $e');
      return null;
    }
  }

  Future<void> loadUserBookings(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;

      try {
        snapshot = await _firestore
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .get();
      } catch (e) {
        debugPrint('Indexed query failed, falling back to simple query: $e');

        snapshot = await _firestore
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .get();
      }

      _bookings = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();

      _bookings.sort((a, b) {
        try {
          return b.date.compareTo(a.date);
        } catch (_) {
          return 0;
        }
      });
    } catch (e) {
      debugPrint('Error loading bookings: $e');
      _bookings = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Stream<BookingModel> watchBooking(String bookingId) {
    return _firestore
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .map((doc) => BookingModel.fromFirestore(doc));
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.cancelled.name,
      });

      final bookingDoc =
      await _firestore.collection('bookings').doc(bookingId).get();

      final data = bookingDoc.data();
      final userId = data?['userId'];

      if (userId != null && userId is String) {
        await loadUserBookings(userId);
      }

      return true;
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }

  void _resetForm() {
    _selectedDate = null;
    _selectedTimeSlot = null;
    _address = '';
    _addressDetails = '';
    _notes = '';
    _paymentMethod = 'cash';
    _isEmergency = false;
  }
}
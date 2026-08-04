import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import '../models/technician_application.dart';

class TechDashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAvailable = true;
  List<BookingModel> _newJobs = [];
  List<BookingModel> _myJobs = [];
  List<BookingModel> _history = [];
  TechnicianApplication? _profile;
  int _currentTab = 0;

  // Stats
  int get newJobsCount => _newJobs.length;
  int get activeJobsCount => _myJobs.length;
  int get completedCount => _history.length;
  double get totalEarnings =>
      _history.fold(0.0, (sum, b) => sum + b.totalAmount);

  // Getters
  bool get isLoading => _isLoading;
  bool get isAvailable => _isAvailable;
  List<BookingModel> get newJobs => _newJobs;
  List<BookingModel> get myJobs => _myJobs;
  List<BookingModel> get history => _history;
  TechnicianApplication? get profile => _profile;
  int get currentTab => _currentTab;

  void setTab(int tab) {
    _currentTab = tab;
    notifyListeners();
  }

  // Toggle availability
  Future<void> toggleAvailability(String techId) async {
    _isAvailable = !_isAvailable;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection('technicians')
        .doc(techId)
        .update({'isAvailable': _isAvailable});
  }

  // Load technician profile
  Future<void> loadProfile(String userId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('technician_applications')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'approved')
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        _profile = TechnicianApplication.fromFirestore(query.docs.first);
        notifyListeners();

        // Load category-filtered jobs
        await _loadNewJobs();
        await _loadMyJobs(userId);
        await _loadHistory(userId);
      }
    } catch (e) {
      debugPrint('Error loading tech profile: $e');
    }
  }

  // ★ CORE LOGIC: Load jobs filtered by technician's specializations
  Future<void> _loadNewJobs() async {
    if (_profile == null || _profile!.specializations.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Firestore 'whereIn' supports up to 10 values — our categories are max 8
      final query = await FirebaseFirestore.instance
          .collection('bookings')
          .where('status', isEqualTo: 'confirmed')
          .where('assignedTechId', isNull: true)
          .orderBy('isEmergency', descending: true)
          .orderBy('date')
          .get();

      // Client-side filter: match booking categories with tech specializations
      _newJobs = query.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .where((booking) {
        // Check if ANY of the booking's service categories
        // match ANY of the technician's specializations
        final bookingCategories = booking.services
            .map((s) => s.category)
            .toSet();
        return bookingCategories
            .intersection(_profile!.specializations.toSet())
            .isNotEmpty;
      }).toList();
    } catch (e) {
      debugPrint('Error loading new jobs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load technician's accepted jobs
  Future<void> _loadMyJobs(String userId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('bookings')
          .where('assignedTechId', isEqualTo: userId)
          .where('status', whereIn: [
        'technicianAssigned',
        'inProgress',
      ]).orderBy('date').get();

      _myJobs =
          query.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading my jobs: $e');
    }
  }

  // Load completed jobs
  Future<void> _loadHistory(String userId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('bookings')
          .where('assignedTechId', isEqualTo: userId)
          .where('status', isEqualTo: 'completed')
          .orderBy('date', descending: true)
          .limit(50)
          .get();

      _history =
          query.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  // Accept a job
  Future<bool> acceptJob(String bookingId, String techId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({
        'assignedTechId': techId,
        'status': 'technicianAssigned',
        'assignedAt': FieldValue.serverTimestamp(),
      });

      // Move from new to my jobs
      final job = _newJobs.firstWhere((j) => j.id == bookingId);
      _newJobs.removeWhere((j) => j.id == bookingId);
      _myJobs.add(job);
      notifyListeners();

      // TODO: Send FCM notification to client
      return true;
    } catch (e) {
      debugPrint('Error accepting job: $e');
      return false;
    }
  }

  // Reject/skip a job (just hide it from feed)
  void skipJob(String bookingId) {
    _newJobs.removeWhere((j) => j.id == bookingId);
    notifyListeners();
  }

  // Update job status (technician workflow)
  Future<void> updateJobStatus(String bookingId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': newStatus});

      if (newStatus == 'completed') {
        final job = _myJobs.firstWhere((j) => j.id == bookingId);
        _myJobs.removeWhere((j) => j.id == bookingId);
        _history.insert(0, job);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating job status: $e');
    }
  }

  // Refresh all data
  Future<void> refresh(String userId) async {
    await loadProfile(userId);
  }
}

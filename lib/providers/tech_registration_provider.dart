import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/technician_application.dart';

class TechRegistrationProvider extends ChangeNotifier {
  int _currentStep = 0;
  bool _isLoading = false;
  bool _submitted = false;
  TechnicianStatus? _applicationStatus;

  // Step 1: Personal Info
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String _governorate = 'القاهرة';

  // Step 2: Specialization
  final List<String> _selectedSpecs = [];
  final experienceController = TextEditingController(text: '1');
  final bioController = TextEditingController();

  // Step 3: Documents
  File? _profilePhoto;
  File? _idFront;
  File? _idBack;

  // Step 4: Agreement
  bool _agreeTerms = false;
  bool _agreeDataCorrect = false;

  // Getters
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  bool get submitted => _submitted;
  TechnicianStatus? get applicationStatus => _applicationStatus;
  String get governorate => _governorate;
  List<String> get selectedSpecs => _selectedSpecs;
  File? get profilePhoto => _profilePhoto;
  File? get idFront => _idFront;
  File? get idBack => _idBack;
  bool get agreeTerms => _agreeTerms;
  bool get agreeDataCorrect => _agreeDataCorrect;

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 3) {
      _currentStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setGovernorate(String gov) {
    _governorate = gov;
    notifyListeners();
  }

  void toggleSpec(String spec) {
    if (_selectedSpecs.contains(spec)) {
      _selectedSpecs.remove(spec);
    } else {
      _selectedSpecs.add(spec);
    }
    notifyListeners();
  }



  void setAgreeTerms(bool v) {
    _agreeTerms = v;
    notifyListeners();
  }

  void setAgreeDataCorrect(bool v) {
    _agreeDataCorrect = v;
    notifyListeners();
  }

  // Image Picking
  final _picker = ImagePicker();

  Future<void> pickProfilePhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked != null) {
      _profilePhoto = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickIdFront() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (picked != null) {
      _idFront = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickIdBack() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (picked != null) {
      _idBack = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> pickCriminalRecord() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (picked != null) {
      notifyListeners();
    }
  }

  void removeProfilePhoto() {
    _profilePhoto = null;
    notifyListeners();
  }

  void removeIdFront() {
    _idFront = null;
    notifyListeners();
  }

  void removeIdBack() {
    _idBack = null;
    notifyListeners();
  }

  void removeCriminalRecord() {
    notifyListeners();
  }

  // Validation
  String? validateStep1() {
    if (fullNameController.text.trim().isEmpty) return 'الاسم مطلوب';
    if (phoneController.text.trim().isEmpty) return 'رقم الموبايل مطلوب';
    if (phoneController.text.trim().length < 10) return 'رقم الموبايل غير صحيح';
    if (addressController.text.trim().isEmpty) return 'العنوان مطلوب';
    return null;
  }

  String? validateStep2() {
    if (_selectedSpecs.isEmpty) return 'اختر تخصص واحد على الأقل';
    if (bioController.text.trim().length < 20) return 'اكتب نبذة لا تقل عن ٢٠ حرف';
    return null;
  }

  String? validateStep3() {
    if (_profilePhoto == null) return 'الصورة الشخصية مطلوبة';
    if (_idFront == null) return 'صورة البطاقة (أمام) مطلوبة';
    if (_idBack == null) return 'صورة البطاقة (خلف) مطلوبة';
    return null;
  }

  String? validateStep4() {
    if (!_agreeTerms) return 'يجب الموافقة على الشروط والأحكام';
    if (!_agreeDataCorrect) return 'يجب الإقرار بصحة البيانات';
    return null;
  }

  // Upload image to Firebase Storage
  Future<String> _uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }


  // Submit without auth/upload (saves directly to Firestore)
  Future<bool> submitApplicationDirect() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = {
        'fullName': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'governorate': _governorate,
        'specializations': _selectedSpecs,
        'experience': experienceController.text.trim(),
        'bio': bioController.text.trim(),
        'status': 'pending',
        'isAvailable': false,
        'rating': 0.0,
        'completedJobs': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('technician_applications')
          .add(data);

      _submitted = true;
      _applicationStatus = TechnicianStatus.pending;
      _isLoading = false;
      notifyListeners();

      // Send WhatsApp notification
      try {
        await _sendWhatsAppNotification(
          phone: phoneController.text.trim(),
          name: fullNameController.text.trim(),
        );
      } catch (_) {}

      return true;
    } catch (e) {
      _isLoading = false;
      debugPrint('Submit error: $e');
      notifyListeners();
      return false;
    }
  }

  // Submit application (legacy - requires auth)
  Future<bool> submitApplication(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Upload all images
      final profileUrl = await _uploadFile(
        _profilePhoto!,
        'technicians/$userId/profile.jpg',
      );
      final idFrontUrl = await _uploadFile(
        _idFront!,
        'technicians/$userId/id_front.jpg',
      );
      final idBackUrl = await _uploadFile(
        _idBack!,
        'technicians/$userId/id_back.jpg',
      );
      const criminalUrl = '';

      // Create application document
      final application = TechnicianApplication(
        id: '',
        userId: userId,
        fullName: fullNameController.text.trim(),

        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        governorate: _governorate,
        specializations: _selectedSpecs,
        yearsOfExperience: int.tryParse(experienceController.text) ?? 1,
        bio: bioController.text.trim(),

        profilePhotoUrl: profileUrl,
        idFrontUrl: idFrontUrl,
        idBackUrl: idBackUrl,

        status: TechnicianStatus.pending,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('technician_applications')
          .add(application.toMap());

      // Update user role
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'technicianStatus': 'pending'});

      _submitted = true;
      _applicationStatus = TechnicianStatus.pending;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Check existing application
  Future<void> checkApplicationStatus(String userId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('technician_applications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final app = TechnicianApplication.fromFirestore(query.docs.first);
        _applicationStatus = app.status;
        _submitted = true;
        notifyListeners();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    experienceController.dispose();
    bioController.dispose();
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestDataSeeder {
  static Future<void> seedTechnicians() async {
    final firestore = FirebaseFirestore.instance;
    
    final existing = await firestore.collection('technician_applications')
        .where('phone', isEqualTo: '01012345671').get();
    if (existing.docs.isNotEmpty) {
      debugPrint('Test technicians already exist');
      return;
    }

    final techs = [
      {'fullName': 'أحمد محمد حسن', 'phone': '01012345671', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['electrical'], 'experience': '8 سنوات', 'bio': 'فني كهرباء متخصص', 'status': 'approved', 'isAvailable': true, 'rating': 4.8, 'completedJobs': 142, 'createdAt': FieldValue.serverTimestamp()},
      {'fullName': 'محمود عبد الله', 'phone': '01012345672', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['electrical'], 'experience': '5 سنوات', 'bio': 'كهربائي منازل', 'status': 'approved', 'isAvailable': true, 'rating': 4.5, 'completedJobs': 89, 'createdAt': FieldValue.serverTimestamp()},
      {'fullName': 'حسين علي إبراهيم', 'phone': '01012345673', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['plumbing'], 'experience': '10 سنوات', 'bio': 'سباك محترف', 'status': 'approved', 'isAvailable': true, 'rating': 4.7, 'completedJobs': 210, 'createdAt': FieldValue.serverTimestamp()},
      {'fullName': 'عمر سعيد', 'phone': '01012345674', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['plumbing'], 'experience': '6 سنوات', 'bio': 'سباكة وأدوات صحية', 'status': 'approved', 'isAvailable': true, 'rating': 4.6, 'completedJobs': 95, 'createdAt': FieldValue.serverTimestamp()},
      {'fullName': 'خالد عبد الرحمن', 'phone': '01012345675', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['carpentry'], 'experience': '12 سنة', 'bio': 'نجار أثاث ومطابخ', 'status': 'approved', 'isAvailable': true, 'rating': 4.9, 'completedJobs': 178, 'createdAt': FieldValue.serverTimestamp()},
      {'fullName': 'ياسر محمد', 'phone': '01012345676', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['carpentry'], 'experience': '7 سنوات', 'bio': 'ألوميتال ونجارة', 'status': 'approved', 'isAvailable': true, 'rating': 4.4, 'completedJobs': 67, 'createdAt': FieldValue.serverTimestamp()},
      {'fullName': 'مصطفى أحمد', 'phone': '01012345677', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['ac'], 'experience': '9 سنوات', 'bio': 'تكييفات تركيب وصيانة', 'status': 'approved', 'isAvailable': true, 'rating': 4.7, 'completedJobs': 156, 'createdAt': FieldValue.serverTimestamp()},
      {'fullName': 'طارق حسن', 'phone': '01012345678', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['ac'], 'experience': '4 سنوات', 'bio': 'صيانة تكييفات', 'status': 'approved', 'isAvailable': true, 'rating': 4.3, 'completedJobs': 45, 'createdAt': FieldValue.serverTimestamp()},
      {'fullName': 'سامي عبد العزيز', 'phone': '01012345679', 'address': 'قليوب', 'governorate': 'القليوبية', 'city': 'قليوب', 'specializations': ['electrical', 'plumbing', 'ac'], 'experience': '15 سنة', 'bio': 'صيانة عامة', 'status': 'approved', 'isAvailable': true, 'rating': 4.9, 'completedJobs': 320, 'createdAt': FieldValue.serverTimestamp()},
    ];

    for (final tech in techs) {
      await firestore.collection('technician_applications').add(tech);
    }
    debugPrint('✅ Seeded ${techs.length} test technicians');
  }
}

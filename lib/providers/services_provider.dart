import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class ServicesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ServiceModel> _services = [];
  List<ServiceModel> _filteredServices = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;

  static const List<String> _featuredCategoryKeys = [
    'electrical',
    'plumbing',
    'ac',
    'appliances',
  ];

  static const List<String> _popularServiceIds = [
    'elc_01',
    'plb_01',
    'ac_01',
    'app_05',
    'pst_01',
    'app_02',
  ];

  List<ServiceModel> get services =>
      _filteredServices.isEmpty && _selectedCategory == null
          ? _services
          : _filteredServices;

  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  List<String> get featuredCategoryKeys {
    final existing = _services.map((s) => s.category).toSet();
    return _featuredCategoryKeys.where(existing.contains).toList();
  }

  List<ServiceModel> get popularServices {
    final popular = _popularServiceIds
        .map((id) => getServiceById(id))
        .whereType<ServiceModel>()
        .toList();

    if (popular.length >= 6) return popular;

    final usedIds = popular.map((e) => e.id).toSet();
    final extras = _services.where((s) => !usedIds.contains(s.id)).take(6 - popular.length);
    return [...popular, ...extras];
  }

  Future<void> loadServices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('services')
          .where('isActive', isEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) {
        _services = _getDefaultServices();
        debugPrint(
          'ServicesProvider: Firestore returned no active services, using fallback data.',
        );
      } else {
        _services = snapshot.docs
            .map((doc) => ServiceModel.fromFirestore(doc))
            .toList();
      }

      _categories = _extractOrderedCategories(_services);
      _filteredServices = [];
      _selectedCategory = null;
    } catch (e) {
      debugPrint('Error loading services: $e');
      _services = _getDefaultServices();
      _categories = _extractOrderedCategories(_services);
      _filteredServices = [];
      _selectedCategory = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterByCategory(String? category) {
    _selectedCategory = category;

    if (category == null) {
      _filteredServices = [];
    } else {
      _filteredServices =
          _services.where((s) => s.category == category).toList();
    }

    notifyListeners();
  }

  void searchServices(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      _filteredServices = [];
      _selectedCategory = null;
    } else {
      _filteredServices = _services.where((s) {
        return s.nameEn.toLowerCase().contains(q) ||
            s.nameAr.contains(q) ||
            s.category.toLowerCase().contains(q) ||
            s.descriptionEn.toLowerCase().contains(q) ||
            s.descriptionAr.contains(q);
      }).toList();
    }

    notifyListeners();
  }

  List<ServiceModel> getServicesByCategory(String category) {
    return _services.where((s) => s.category == category).toList();
  }

  ServiceModel? getServiceById(String id) {
    try {
      return _services.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<ServiceModel> getRecommendations(List<String> pastCategories) {
    if (pastCategories.isEmpty) {
      return _services.take(4).toList();
    }

    final recommended = _services
        .where((s) => pastCategories.contains(s.category))
        .toList();

    if (recommended.length < 4) {
      final others = _services
          .where((s) => !pastCategories.contains(s.category))
          .take(4 - recommended.length);

      recommended.addAll(others);
    }

    return recommended.take(4).toList();
  }

  List<String> _extractOrderedCategories(List<ServiceModel> services) {
    const preferredOrder = [
      'electrical',
      'plumbing',
      'appliances',
      'ac',
      'finishing',
      'carpentry',
      'security',
      'pest_control',
    ];

    final existing = services.map((s) => s.category).toSet();

    final ordered = preferredOrder.where(existing.contains).toList();
    final remaining = existing.where((c) => !preferredOrder.contains(c)).toList()..sort();

    return [...ordered, ...remaining];
  }

  List<ServiceModel> _getDefaultServices() {
    return [
      ServiceModel(
        id: 'elc_01',
        nameEn: 'General Electrical',
        nameAr: 'كهرباء عامة',
        category: 'electrical',
        descriptionEn:
        'Electrical wiring, sockets, switches, and circuit breaker repairs.',
        descriptionAr:
        'أعمال الأسلاك والمفاتيح والبرايز وإصلاح القواطع الكهربائية.',
        price: 200,
        iconName: 'electrical',
        isEmergencyAvailable: true,
      ),
      ServiceModel(
        id: 'elc_02',
        nameEn: 'Fan Repair/Install',
        nameAr: 'مروحة',
        category: 'electrical',
        descriptionEn:
        'Ceiling and standing fan installation, repair, and maintenance.',
        descriptionAr: 'تركيب وإصلاح وصيانة المراوح السقف والوقوف.',
        price: 150,
        iconName: 'electrical',
      ),
      ServiceModel(
        id: 'elc_03',
        nameEn: 'Shutter Repair',
        nameAr: 'شاتر',
        category: 'electrical',
        descriptionEn:
        'Electric shutter motor repair and roller shutter maintenance.',
        descriptionAr: 'إصلاح موتور الشاتر الكهربائي وصيانة الشاتر.',
        price: 250,
        iconName: 'electrical',
      ),
      ServiceModel(
        id: 'plb_01',
        nameEn: 'General Plumbing',
        nameAr: 'سباكة عامة',
        category: 'plumbing',
        descriptionEn:
        'Pipe repair, leak fixing, faucet installation, and drain unclogging.',
        descriptionAr:
        'إصلاح المواسير وتسريبات المياه وتركيب الحنفيات وتسليك المجاري.',
        price: 200,
        iconName: 'plumbing',
        isEmergencyAvailable: true,
      ),
      ServiceModel(
        id: 'plb_02',
        nameEn: 'Shower Install/Repair',
        nameAr: 'تركيب/إصلاح الشاور',
        category: 'plumbing',
        descriptionEn:
        'Shower mixer installation, repair, replacement, and water flow adjustment.',
        descriptionAr:
        'تركيب وإصلاح واستبدال خلاط الشاور وضبط تدفق المياه.',
        price: 180,
        iconName: 'plumbing',
      ),
      ServiceModel(
        id: 'app_01',
        nameEn: 'Dishwasher Repair',
        nameAr: 'غسالة أطباق',
        category: 'appliances',
        descriptionEn: 'Dishwasher diagnosis, repair, and maintenance.',
        descriptionAr: 'تشخيص وإصلاح وصيانة غسالات الأطباق.',
        price: 350,
        iconName: 'appliances',
      ),
      ServiceModel(
        id: 'app_02',
        nameEn: 'Stove/Oven Repair',
        nameAr: 'بوتجاز',
        category: 'appliances',
        descriptionEn:
        'Gas and electric stove repair, burner and oven fixes.',
        descriptionAr: 'إصلاح البوتجاز والفرن وعيون الغاز.',
        price: 300,
        iconName: 'appliances',
        isEmergencyAvailable: true,
      ),
      ServiceModel(
        id: 'app_03',
        nameEn: 'Gas Water Heater',
        nameAr: 'سخانات غاز',
        category: 'appliances',
        descriptionEn:
        'Gas water heater installation, repair, and safety check.',
        descriptionAr: 'تركيب وإصلاح وفحص أمان سخانات الغاز.',
        price: 280,
        iconName: 'appliances',
        isEmergencyAvailable: true,
      ),
      ServiceModel(
        id: 'app_04',
        nameEn: 'Fridge/Freezer Repair',
        nameAr: 'ثلاجة/فريزر',
        category: 'appliances',
        descriptionEn:
        'Refrigerator and freezer cooling, motor, and thermostat repair.',
        descriptionAr:
        'إصلاح التبريد والموتور والثرموستات في الثلاجة والفريزر.',
        price: 350,
        iconName: 'appliances',
      ),
      ServiceModel(
        id: 'app_05',
        nameEn: 'Washing Machine Repair',
        nameAr: 'غسالة',
        category: 'appliances',
        descriptionEn:
        'Washing machine diagnosis, motor, drum, and drain pump repair.',
        descriptionAr:
        'تشخيص وإصلاح الموتور والحلة وطلمبة الصرف في الغسالة.',
        price: 300,
        iconName: 'appliances',
      ),
      ServiceModel(
        id: 'ac_01',
        nameEn: 'AC Maintenance',
        nameAr: 'صيانة التكييف',
        category: 'ac',
        descriptionEn:
        'AC cleaning, gas refill, filter change, and performance check.',
        descriptionAr:
        'تنظيف التكييف وشحن الفريون وتغيير الفلتر وفحص الأداء.',
        price: 350,
        iconName: 'ac',
      ),
      ServiceModel(
        id: 'ac_02',
        nameEn: 'AC Install/Move',
        nameAr: 'تركيب ونقل تكييف',
        category: 'ac',
        descriptionEn:
        'New AC unit installation or relocating existing units with piping.',
        descriptionAr:
        'تركيب تكييف جديد أو نقل التكييف الحالي مع التمديدات.',
        price: 500,
        iconName: 'ac',
      ),
      ServiceModel(
        id: 'fin_01',
        nameEn: 'Finishing Setup',
        nameAr: 'تأسيس تشطيبات',
        category: 'finishing',
        descriptionEn:
        'Complete apartment finishing: plaster, putty, and preparation.',
        descriptionAr:
        'تأسيس تشطيبات كاملة للشقة: محارة ومعجون وتجهيز.',
        price: 800,
        iconName: 'finishing',
      ),
      ServiceModel(
        id: 'fin_02',
        nameEn: 'Painting',
        nameAr: 'نقاشة',
        category: 'finishing',
        descriptionEn:
        'Professional wall painting with premium paint and clean finish.',
        descriptionAr:
        'نقاشة حوائط احترافية بدهانات ممتازة وتشطيب نظيف.',
        price: 600,
        iconName: 'finishing',
      ),
      ServiceModel(
        id: 'fin_03',
        nameEn: 'Tiles & Ceramics',
        nameAr: 'تركيب البلاط والسيراميك',
        category: 'finishing',
        descriptionEn:
        'Floor and wall tiles installation with precision leveling.',
        descriptionAr:
        'تركيب بلاط وسيراميك أرضيات وحوائط مع ميزان دقيق.',
        price: 700,
        iconName: 'finishing',
      ),
      ServiceModel(
        id: 'crp_01',
        nameEn: 'Carpentry',
        nameAr: 'نجارة',
        category: 'carpentry',
        descriptionEn:
        'Door repair, furniture assembly, wood work, and cabinet fixes.',
        descriptionAr:
        'إصلاح الأبواب وتجميع الأثاث والأعمال الخشبية وإصلاح الدواليب.',
        price: 400,
        iconName: 'carpentry',
      ),
      ServiceModel(
        id: 'crp_02',
        nameEn: 'Aluminum Works',
        nameAr: 'ألوميتال',
        category: 'carpentry',
        descriptionEn:
        'Aluminum windows, kitchen cabinets, and shower cabins.',
        descriptionAr: 'شبابيك ومطابخ ألوميتال وكبائن شاور.',
        price: 450,
        iconName: 'carpentry',
      ),
      ServiceModel(
        id: 'sec_01',
        nameEn: 'CCTV Install/Repair',
        nameAr: 'تركيب وصيانة كاميرا مراقبة',
        category: 'security',
        descriptionEn:
        'Security camera system installation, wiring, and DVR setup.',
        descriptionAr:
        'تركيب كاميرات مراقبة وتمديد الأسلاك وضبط جهاز التسجيل.',
        price: 500,
        iconName: 'security',
      ),
      ServiceModel(
        id: 'sec_02',
        nameEn: 'Intercom Repair',
        nameAr: 'صيانة الانتركم',
        category: 'security',
        descriptionEn:
        'Intercom system repair, wiring, and handset replacement.',
        descriptionAr:
        'إصلاح الانتركم وتوصيلاته واستبدال السماعة.',
        price: 250,
        iconName: 'security',
      ),
      ServiceModel(
        id: 'pst_01',
        nameEn: 'Pest Control',
        nameAr: 'مكافحة الحشرات',
        category: 'pest_control',
        descriptionEn:
        'Full apartment pest control spray for all insect types.',
        descriptionAr:
        'رش مكافحة حشرات شاملة للشقة لجميع أنواع الحشرات.',
        price: 300,
        iconName: 'pest_control',
        isEmergencyAvailable: true,
      ),
    ];
  }
}
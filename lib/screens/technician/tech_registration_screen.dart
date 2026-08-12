import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tech_registration_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/technician_application.dart';
import '../../l10n/app_localizations.dart';

class TechRegistrationScreen extends StatelessWidget {
  const TechRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TechRegistrationProvider(),
      child: const _TechRegistrationBody(),
    );
  }
}

class _TechRegistrationBody extends StatelessWidget {
  const _TechRegistrationBody();

  @override
  Widget build(BuildContext context) {
    final reg = context.watch<TechRegistrationProvider>();

    if (reg.submitted) {
      return _buildSubmittedScreen(context, reg);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل كفني'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Step Indicator
          _buildStepIndicator(context, reg.currentStep),
          // Step Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: [
                _buildStep1(context, reg),
                _buildStep2(context, reg),
                _buildStep3(context, reg),
                _buildStep4(context, reg),
              ][reg.currentStep],
            ),
          ),
          // Navigation Buttons
          _buildNavButtons(context, reg),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, int current) {
    final steps = ['البيانات', 'التخصص', 'المستندات', 'المراجعة'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i <= current;
          final isCurrent = i == current;
          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (i > 0)
                      Expanded(
                        child: Container(
                          height: 3,
                          color: i <= current
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: i < current
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : Text(
                                '${i + 1}',
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                      ),
                    ),
                    if (i < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 3,
                          color: i < current
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  steps[i],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? null : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ============ STEP 1: Personal Info ============
  Widget _buildStep1(BuildContext context, TechRegistrationProvider reg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'البيانات الشخصية',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'أدخل بياناتك الشخصية بدقة',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 24),
        _inputField(
          controller: reg.fullNameController,
          label: 'الاسم بالكامل',
          icon: Icons.person_outline,
          hint: 'مثال: أحمد محمد حسن',
        ),
        const SizedBox(height: 16),
        _inputField(
          controller: reg.ageController,
          label: 'السن',
          icon: Icons.cake_outlined,
          hint: 'مثال: ٣٠',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _inputField(
          controller: reg.phoneController,
          label: 'رقم الموبايل',
          icon: Icons.phone_outlined,
          hint: '01XXXXXXXXX',
          keyboardType: TextInputType.phone,
          prefix: '+20 ',
        ),
        const SizedBox(height: 16),
        _inputField(
          controller: reg.addressController,
          label: 'العنوان بالتفصيل',
          icon: Icons.location_on_outlined,
          hint: 'الحي، الشارع، أقرب علامة',
        ),
        const SizedBox(height: 16),
        const Text('المحافظة', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: reg.governorate,
              isExpanded: true,
              borderRadius: BorderRadius.circular(14),
              items: TechnicianApplication.governorates
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => reg.setGovernorate(v!),
            ),
          ),
        ),
      ],
    );
  }

  // ============ STEP 2: Specialization ============
  Widget _buildStep2(BuildContext context, TechRegistrationProvider reg) {
    final specs = {
      'plumbing': {'ar': 'سباكة', 'icon': '🔧'},
      'electrical': {'ar': 'كهرباء', 'icon': '⚡'},
      'cleaning': {'ar': 'تنظيف', 'icon': '🧹'},
      'painting': {'ar': 'دهانات', 'icon': '🎨'},
      'carpentry': {'ar': 'نجارة', 'icon': '🪚'},
      'ac': {'ar': 'تكييف', 'icon': '❄️'},
      'appliances': {'ar': 'أجهزة', 'icon': '🔌'},
      'pest_control': {'ar': 'مكافحة حشرات', 'icon': '🐛'},
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التخصص والخبرة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'اختر تخصصاتك وأخبرنا عن خبرتك',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 20),
        const Text('التخصصات (اختر واحد أو أكثر)',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: specs.entries.map((e) {
            final selected = reg.selectedSpecs.contains(e.key);
            return FilterChip(
              label: Text('${e.value['icon']} ${e.value['ar']}'),
              selected: selected,
              onSelected: (_) => reg.toggleSpec(e.key),
              selectedColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.15),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _inputField(
          controller: reg.experienceController,
          label: 'سنوات الخبرة',
          icon: Icons.work_outline,
          hint: 'مثال: ٥',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        const Text('المؤهل الدراسي',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...EducationLevel.values.map((edu) {
          return RadioListTile<EducationLevel>(
            value: edu,
            groupValue: reg.education,
            onChanged: (v) => reg.setEducation(v!),
            title: Text(
              TechnicianApplication.educationLabel(edu),
              style: const TextStyle(fontSize: 14),
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),
        const SizedBox(height: 16),
        const Text('نبذة عنك', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: reg.bioController,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'اكتب نبذة مختصرة عن خبرتك ومهاراتك...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  // ============ STEP 3: Documents ============
  Widget _buildStep3(BuildContext context, TechRegistrationProvider reg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المستندات والصور',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'ارفع الصور والمستندات المطلوبة',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 24),

        // Profile Photo
        _uploadField(
          context,
          label: 'صورة شخصية واضحة',
          icon: Icons.face,
          file: reg.profilePhoto,
          onPick: reg.pickProfilePhoto,
          onRemove: reg.removeProfilePhoto,
          isCircular: true,
        ),
        const SizedBox(height: 20),

        // ID Front
        _uploadField(
          context,
          label: 'صورة البطاقة — وجه أمامي',
          icon: Icons.credit_card,
          file: reg.idFront,
          onPick: reg.pickIdFront,
          onRemove: reg.removeIdFront,
        ),
        const SizedBox(height: 20),

        // ID Back
        _uploadField(
          context,
          label: 'صورة البطاقة — وجه خلفي',
          icon: Icons.credit_card,
          file: reg.idBack,
          onPick: reg.pickIdBack,
          onRemove: reg.removeIdBack,
        ),
        const SizedBox(height: 20),

        // Criminal Record
        _uploadField(
          context,
          label: 'صورة الفيش والتشبيه',
          icon: Icons.description_outlined,
          file: reg.criminalRecord,
          onPick: reg.pickCriminalRecord,
          onRemove: reg.removeCriminalRecord,
        ),

        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'الحد الأقصى لحجم كل صورة ٥ ميجا. تأكد من وضوح الصور.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============ STEP 4: Review ============
  Widget _buildStep4(BuildContext context, TechRegistrationProvider reg) {
    final specs = {
      'plumbing': 'سباكة',
      'electrical': 'كهرباء',
      'cleaning': 'تنظيف',
      'painting': 'دهانات',
      'carpentry': 'نجارة',
      'ac': 'تكييف',
      'appliances': 'أجهزة',
      'pest_control': 'مكافحة حشرات',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المراجعة والإرسال',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'راجع بياناتك قبل الإرسال',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 20),

        // Summary Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              if (reg.profilePhoto != null)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: FileImage(reg.profilePhoto!),
                ),
              const SizedBox(height: 12),
              _reviewRow('الاسم', reg.fullNameController.text),
              _reviewRow('السن', reg.ageController.text),
              _reviewRow('الموبايل', reg.phoneController.text),
              _reviewRow('العنوان', reg.addressController.text),
              _reviewRow('المحافظة', reg.governorate),
              _reviewRow(
                'التخصصات',
                reg.selectedSpecs.map((s) => specs[s] ?? s).join('، '),
              ),
              _reviewRow('الخبرة', '${reg.experienceController.text} سنة'),
              _reviewRow(
                'المؤهل',
                TechnicianApplication.educationLabel(reg.education),
              ),
              _reviewRow('نبذة', reg.bioController.text),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _docThumb('البطاقة أمام', reg.idFront),
                  _docThumb('البطاقة خلف', reg.idBack),
                  _docThumb('الفيش', reg.criminalRecord),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Agreements
        CheckboxListTile(
          value: reg.agreeTerms,
          onChanged: (v) => reg.setAgreeTerms(v ?? false),
          title: const Text(
            'أوافق على شروط الاستخدام وسياسة الخصوصية',
            style: TextStyle(fontSize: 13),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        CheckboxListTile(
          value: reg.agreeDataCorrect,
          onChanged: (v) => reg.setAgreeDataCorrect(v ?? false),
          title: const Text(
            'أقر بأن جميع البيانات المقدمة صحيحة وأتحمل المسؤولية',
            style: TextStyle(fontSize: 13),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'سيتم مراجعة طلبك خلال ٢٤-٤٨ ساعة وسنتواصل معك.',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============ Nav Buttons ============
  Widget _buildNavButtons(BuildContext context, TechRegistrationProvider reg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (reg.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: reg.prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('← السابق'),
              ),
            ),
          if (reg.currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: reg.isLoading ? null : () => _handleNext(context, reg),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: reg.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      reg.currentStep == 3
                          ? 'إرسال طلب التسجيل'
                          : 'التالي →',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext(BuildContext context, TechRegistrationProvider reg) {
    String? error;
    switch (reg.currentStep) {
      case 0:
        error = reg.validateStep1();
        break;
      case 1:
        error = reg.validateStep2();
        break;
      case 2:
        error = reg.validateStep3();
        break;
      case 3:
        error = reg.validateStep4();
        if (error == null) {
          final auth = context.read<AuthProvider>();
          reg.submitApplication(auth.firebaseUser!.uid);
          return;
        }
        break;
    }

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      reg.nextStep();
    }
  }

  // ============ Submitted Screen ============
  Widget _buildSubmittedScreen(
      BuildContext context, TechRegistrationProvider reg) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 50,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'تم إرسال طلبك بنجاح! 🎉',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'جاري مراجعة بياناتك\nسنتواصل معك خلال ٢٤-٤٨ ساعة',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⏳ حالة الطلب: قيد المراجعة',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  icon: const Icon(Icons.support_agent),
                  label: const Text('تواصل معنا'),
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ Helpers ============
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    String? prefix,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            prefixText: prefix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _uploadField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required File? file,
    required VoidCallback onPick,
    required VoidCallback onRemove,
    bool isCircular = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: file == null ? onPick : null,
          child: file != null
              ? Stack(
                  children: [
                    if (isCircular)
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(file),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          file,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: isCircular ? 120 : 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                    borderRadius: BorderRadius.circular(isCircular ? 60 : 14),
                    color: Colors.grey.shade50,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 32, color: Colors.grey.shade400),
                      const SizedBox(height: 6),
                      Text(
                        'اضغط للتحميل',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _docThumb(String label, File? file) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(file, fit: BoxFit.cover),
                )
              : Icon(Icons.image_not_supported,
                  color: Colors.grey.shade400, size: 24),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}
git add .

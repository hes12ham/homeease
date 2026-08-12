import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../main_nav_screen.dart';

class ClientRegisterScreen extends StatefulWidget {
  const ClientRegisterScreen({super.key});

  @override
  State<ClientRegisterScreen> createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _agreeTerms = false;
  bool _isLoading = false;
  bool _showOtp = false;
  final List<TextEditingController> _otpCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    super.dispose();
  }

  double get _passwordStrength {
    final p = _passCtrl.text;
    if (p.isEmpty) return 0;
    double s = 0;
    if (p.length >= 6) s += 0.25;
    if (p.length >= 8) s += 0.15;
    if (RegExp(r'[A-Z]').hasMatch(p)) s += 0.2;
    if (RegExp(r'[0-9]').hasMatch(p)) s += 0.2;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) s += 0.2;
    return s.clamp(0, 1);
  }

  Color get _strengthColor {
    final s = _passwordStrength;
    if (s < 0.4) return Colors.red;
    if (s < 0.7) return Colors.orange;
    return Colors.green;
  }

  String get _strengthLabel {
    final s = _passwordStrength;
    if (s == 0) return '';
    if (s < 0.4) return 'ضعيفة';
    if (s < 0.7) return 'متوسطة';
    return 'قوية';
  }

  @override
  Widget build(BuildContext context) {
    if (_showOtp) return _buildOtpScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل عميل جديد'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('👤', style: TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'أنشئ حسابك واحجز أول خدمة',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 28),

            // Name
            _buildField(
              controller: _nameCtrl,
              label: 'الاسم بالكامل',
              hint: 'مثال: أحمد محمد',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 18),

            // Phone
            _buildField(
              controller: _phoneCtrl,
              label: 'رقم الموبايل',
              hint: '01XXXXXXXXX',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              prefix: '+20 ',
              helperText: 'سيتم إرسال كود تأكيد',
            ),
            const SizedBox(height: 18),

            // Password
            _buildField(
              controller: _passCtrl,
              label: 'كلمة المرور',
              hint: '٦ أحرف على الأقل',
              icon: Icons.lock_outline,
              obscure: _obscure1,
              onToggleObscure: () =>
                  setState(() => _obscure1 = !_obscure1),
              onChanged: (_) => setState(() {}),
            ),
            if (_passCtrl.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _passwordStrength,
                        backgroundColor: Colors.grey.shade200,
                        color: _strengthColor,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _strengthLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _strengthColor,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 18),

            // Confirm Password
            _buildField(
              controller: _confirmPassCtrl,
              label: 'تأكيد كلمة المرور',
              hint: 'أعد كتابة كلمة المرور',
              icon: Icons.lock_outline,
              obscure: _obscure2,
              onToggleObscure: () =>
                  setState(() => _obscure2 = !_obscure2),
            ),
            const SizedBox(height: 20),

            // Terms
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _agreeTerms,
                    onChanged: (v) =>
                        setState(() => _agreeTerms = v ?? false),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _agreeTerms = !_agreeTerms),
                    child: Text(
                      'أوافق على شروط الاستخدام وسياسة الخصوصية',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Already have account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'لديك حساب بالفعل؟',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============ OTP Screen ============
  Widget _buildOtpScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد رقم الموبايل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('📱', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'أدخل كود التأكيد',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'تم إرسال كود مكون من ٦ أرقام إلى\n${_phoneCtrl.text}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // OTP Inputs
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (i) {
                  return Flexible(
                    child: Container(
                    constraints: const BoxConstraints(maxWidth: 48),
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: TextField(
                      controller: _otpCtrls[i],
                      focusNode: _otpFocus[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 5) {
                          _otpFocus[i + 1].requestFocus();
                        }
                        if (v.isEmpty && i > 0) {
                          _otpFocus[i - 1].requestFocus();
                        }
                        final code = _otpCtrls.map((c) => c.text).join();
                        if (code.length == 6) {
                          _verifyOtp(code);
                        }
                      },
                    ),
                  ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Timer & Resend
            Text(
              'إعادة الإرسال بعد 00:45',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            TextButton(
              onPressed: null,
              child: Text(
                'لم يصلك الكود؟ إعادة الإرسال',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final code = _otpCtrls.map((c) => c.text).join();
                  if (code.length == 6) _verifyOtp(code);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'تأكيد',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ============ Helpers ============
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? prefix,
    String? helperText,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            prefixText: prefix,
            helperText: helperText,
            helperStyle: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  void _handleRegister() async {
    if (_nameCtrl.text.trim().isEmpty) {
      _showError('أدخل اسمك بالكامل');
      return;
    }
    if (_phoneCtrl.text.trim().length < 10) {
      _showError('أدخل رقم موبايل صحيح');
      return;
    }
    if (_passCtrl.text.length < 6) {
      _showError('كلمة المرور يجب أن تكون ٦ أحرف على الأقل');
      return;
    }
    if (_passCtrl.text != _confirmPassCtrl.text) {
      _showError('كلمة المرور غير متطابقة');
      return;
    }
    if (!_agreeTerms) {
      _showError('يجب الموافقة على الشروط والأحكام');
      return;
    }

    // Register directly (OTP requires Firebase Blaze plan)
    setState(() => _isLoading = true);
    
    try {
      final phone = _phoneCtrl.text.trim();
      final email = '\$phone@homeservice.app';
      
      final success = await context.read<AuthProvider>().registerWithEmail(
            email: email,
            password: _passCtrl.text,
            name: _nameCtrl.text.trim(),
            phone: phone,
          );

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء حسابك بنجاح! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavScreen()),
          (route) => false,
        );
      } else if (mounted) {
        _showError('الرقم ده مسجّل قبل كده. جرّب سجّل دخول.');
      }
    } catch (e) {
      _showError('حدث خطأ: \$e');
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  void _verifyOtp(String code) async {
    setState(() => _isLoading = true);

    try {
      // Create account with phone-derived email
      final email = '${_phoneCtrl.text.trim()}@homeease.app';
      await context.read<AuthProvider>().registerWithEmail(
            email: email,
            password: _passCtrl.text,
            name: _nameCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
          );

      // Update profile with phone
      await context.read<AuthProvider>().updateProfile(
            phone: _phoneCtrl.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showError('حدث خطأ أثناء إنشاء الحساب');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

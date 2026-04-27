import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

final supabase = Supabase.instance.client;

// ─── Colors ───────────────────────────────────────────────────────────────────
const _kRed = Color(0xFFD32F2F);
const _kRedDark = Color(0xFF8B0000);
const _kRedLight = Color(0xFFFFCDD2);
const _kText = Color(0xFF1A0A0A);
const _kTextSoft = Color(0xFF7B5B5B);
const _kBg = Color(0xFFF7F2F2);
const _kCard = Color(0xFFFFFFFF);
const _kDivider = Color(0xFFEDD5D5);

// ─── AuthGate ─────────────────────────────────────────────────────────────────
// Sits at the root. On launch: if a session already exists, route by role.
// Otherwise show LoginPage. No StreamBuilder — avoids the rebuild conflict.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    final existingSession = supabase.auth.currentSession;
    if (existingSession != null) {
      return const _RoleRouter();
    }
    return const LoginPage();
  }
}

// ─── Role Router ──────────────────────────────────────────────────────────────
// Shows splash while fetching role, then navigates with pushAndRemoveUntil.
class _RoleRouter extends StatefulWidget {
  const _RoleRouter();

  @override
  State<_RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends State<_RoleRouter> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    try {
      final uid = supabase.auth.currentUser!.id;

      Map<String, dynamic>? data;
      for (int attempt = 0; attempt < 2; attempt++) {
        try {
          data = await supabase
              .from('profiles')
              .select('role')
              .eq('id', uid)
              .single();
          break;
        } catch (_) {
          if (attempt == 0) {
            await Future.delayed(const Duration(milliseconds: 800));
          }
        }
      }

      if (data == null) {
        if (!mounted) return;
        _goTo(const LoginPage());
        return;
      }

      final role = data['role'] as String;
      if (!mounted) return;

      if (role == 'user') {
        _goTo(const HomePage());
      } else if (role == 'conductor') {
        _goTo(const _ConductorPlaceholder());
      } else {
        _goTo(const LoginPage());
      }
    } catch (_) {
      if (!mounted) return;
      _goTo(const LoginPage()); // no signOut — let them retry
    }
  }

  void _goTo(Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) => const _SplashScreen();
}

// ─── Splash ───────────────────────────────────────────────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _kRedDark,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop_rounded, color: Colors.white, size: 48),
            SizedBox(height: 16),
            Text(
              'BloodLink',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFamily: 'Nunito',
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white54, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}

// ─── Conductor Placeholder ────────────────────────────────────────────────────
class _ConductorPlaceholder extends StatelessWidget {
  const _ConductorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                  color: _kRedLight, shape: BoxShape.circle),
              child:
                  const Icon(Icons.campaign_rounded, color: _kRed, size: 36),
            ),
            const SizedBox(height: 20),
            const Text('Conductor Dashboard',
                style: TextStyle(
                  color: _kText,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Nunito',
                )),
            const SizedBox(height: 8),
            const Text('Coming soon',
                style: TextStyle(color: _kTextSoft, fontSize: 14)),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () async {
                await supabase.auth.signOut();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('Sign out',
                  style:
                      TextStyle(color: _kRed, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Login Page ───────────────────────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          _LoginHero(tabIndex: _tabCtrl.index),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _kDivider),
                    ),
                    child: TabBar(
                      controller: _tabCtrl,
                      indicator: BoxDecoration(
                        color: _kRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.all(3),
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: _kTextSoft,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        fontFamily: 'Nunito',
                      ),
                      tabs: const [
                        Tab(text: 'Sign In'),
                        Tab(text: 'Register'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: const [
                      _SignInForm(),
                      _RegisterForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero ─────────────────────────────────────────────────────────────────────
class _LoginHero extends StatelessWidget {
  final int tabIndex;
  const _LoginHero({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5C0A0A), Color(0xFFB71C1C), Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              top: -40,
              right: -40,
              child: _DecorCircle(size: 180, opacity: 0.07)),
          Positioned(
              top: 20,
              right: 80,
              child: _DecorCircle(size: 90, opacity: 0.05)),
          Positioned(
              bottom: -30,
              left: -30,
              child: _DecorCircle(size: 130, opacity: 0.06)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.water_drop_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text('BloodLink',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            fontFamily: 'Nunito',
                            letterSpacing: -0.3,
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: tabIndex == 0
                        ? const _HeroText(
                            key: ValueKey('signin'),
                            title: 'Welcome back',
                            subtitle: 'Sign in to save lives today',
                          )
                        : const _HeroText(
                            key: ValueKey('register'),
                            title: 'Join BloodLink',
                            subtitle: 'Every donor is a hero',
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final String title;
  final String subtitle;
  const _HeroText(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              fontFamily: 'Nunito',
              letterSpacing: -0.5,
            )),
        const SizedBox(height: 4),
        Text(subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Nunito',
            )),
      ],
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _DecorCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.white.withOpacity(opacity), width: 1.5),
      ),
    );
  }
}

// ─── Sign In Form ─────────────────────────────────────────────────────────────
class _SignInForm extends StatefulWidget {
  const _SignInForm();

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      // 1. Sign in with Supabase Auth
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: pass,
      );

      if (res.user == null) {
        setState(() => _error = 'Sign in failed. Please try again.');
        return;
      }

      // 2. Fetch role from profiles table
      final data = await supabase
          .from('profiles')
          .select('role')
          .eq('id', res.user!.id)
          .single();

      final role = data['role'] as String;
      if (!mounted) return;

      // 3. Navigate based on role — clears entire stack
      if (role == 'user') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      } else if (role == 'conductor') {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const _ConductorPlaceholder()),
          (route) => false,
        );
      } else {
        setState(() => _error = 'Unknown role. Contact support.');
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
  setState(() => _error = e.toString());
} finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            controller: _emailCtrl,
            label: 'Email',
            hint: 'you@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _passCtrl,
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscure: _obscure,
            suffix: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: _kTextSoft,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const _ForgotPasswordSheet(),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _kRed,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 32),
              ),
              child: const Text('Forgot password?',
                  style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            _ErrorBanner(message: _error!),
          ],
          const SizedBox(height: 20),
          _PrimaryButton(
            label: 'Sign In',
            loading: _loading,
            onPressed: _signIn,
          ),
          const SizedBox(height: 24),
          _DividerRow(),
          const SizedBox(height: 20),
          const _GoogleButton(),
        ],
      ),
    );
  }
}

// ─── Register Form ────────────────────────────────────────────────────────────
class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;
  String _bloodGroup = 'O+';

  static const _bloodGroups = [
    'A+', 'A−', 'B+', 'B−', 'O+', 'O−', 'AB+', 'AB−'
  ];

  Future<void> _register() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please enter your full name.');
      return;
    }
    if (_passCtrl.text.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }
    if (_passCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      final res = await supabase.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        data: {'full_name': _nameCtrl.text.trim()},
      );

      if (res.user != null) {
        await supabase.from('profiles').upsert({
          'id': res.user!.id,
          'full_name': _nameCtrl.text.trim(),
          'phone': _phoneCtrl.text.trim(),
          'blood_group': _bloodGroup,
          'role': 'user',
        });
      }

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Registration failed. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            controller: _nameCtrl,
            label: 'Full Name',
            hint: 'Arjun Krishnan',
            icon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _emailCtrl,
            label: 'Email',
            hint: 'you@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _phoneCtrl,
            label: 'Phone Number',
            hint: '+91 98765 43210',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          const _Label(text: 'Blood Group'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bloodGroups.map((bg) {
              final selected = bg == _bloodGroup;
              return GestureDetector(
                onTap: () => setState(() => _bloodGroup = bg),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 54,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected ? _kRed : _kCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? _kRed : _kDivider,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(bg,
                        style: TextStyle(
                          color: selected ? Colors.white : _kTextSoft,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          fontFamily: 'Nunito',
                        )),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _passCtrl,
            label: 'Password',
            hint: 'Min 6 characters',
            icon: Icons.lock_outline_rounded,
            obscure: _obscurePass,
            suffix: IconButton(
              icon: Icon(
                _obscurePass
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: _kTextSoft,
              ),
              onPressed: () =>
                  setState(() => _obscurePass = !_obscurePass),
            ),
          ),
          const SizedBox(height: 14),
          _Field(
            controller: _confirmCtrl,
            label: 'Confirm Password',
            hint: 'Repeat password',
            icon: Icons.lock_outline_rounded,
            obscure: _obscureConfirm,
            suffix: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: _kTextSoft,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            _ErrorBanner(message: _error!),
          ],
          const SizedBox(height: 20),
          _PrimaryButton(
            label: 'Create Account',
            loading: _loading,
            onPressed: _register,
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'By registering you agree to our Terms & Privacy Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _kTextSoft.withOpacity(0.7), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Forgot Password Sheet ────────────────────────────────────────────────────
class _ForgotPasswordSheet extends StatefulWidget {
  const _ForgotPasswordSheet();

  @override
  State<_ForgotPasswordSheet> createState() =>
      _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _error;

  Future<void> _send() async {
    setState(() { _loading = true; _error = null; });
    try {
      await supabase.auth
          .resetPasswordForEmail(_emailCtrl.text.trim());
      setState(() => _sent = true);
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Could not send reset email. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: _sent
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mark_email_read_outlined,
                    color: Color(0xFF2E7D32), size: 48),
                const SizedBox(height: 14),
                const Text('Reset link sent!',
                    style: TextStyle(
                      color: _kText,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Nunito',
                    )),
                const SizedBox(height: 8),
                Text(
                  'Check your inbox at ${_emailCtrl.text.trim()}',
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(color: _kTextSoft, fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close',
                      style: TextStyle(
                          color: _kRed, fontWeight: FontWeight.w700)),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Reset Password',
                    style: TextStyle(
                      color: _kText,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Nunito',
                    )),
                const SizedBox(height: 6),
                const Text(
                  "Enter your email and we'll send a reset link.",
                  style: TextStyle(color: _kTextSoft, fontSize: 13),
                ),
                const SizedBox(height: 20),
                _Field(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'you@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  _ErrorBanner(message: _error!),
                ],
                const SizedBox(height: 20),
                _PrimaryButton(
                  label: 'Send Reset Link',
                  loading: _loading,
                  onPressed: _send,
                ),
              ],
            ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          color: _kText,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          fontFamily: 'Nunito',
        ));
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(text: label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: const TextStyle(
            color: _kText,
            fontSize: 14,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: _kTextSoft.withOpacity(0.5),
              fontSize: 14,
              fontFamily: 'Nunito',
            ),
            prefixIcon: Icon(icon, size: 18, color: _kTextSoft),
            suffixIcon: suffix,
            filled: true,
            fillColor: _kCard,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _kDivider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _kDivider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _kRed, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kRed,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _kRed.withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : Text(label,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 0.3,
                  fontFamily: 'Nunito',
                )),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kRed.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: _kRed, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(
                  color: _kRedDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito',
                )),
          ),
        ],
      ),
    );
  }
}

class _DividerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: _kDivider, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('or continue with',
              style: TextStyle(
                color: _kTextSoft.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              )),
        ),
        Expanded(child: Divider(color: _kDivider, thickness: 1)),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          // await supabase.auth.signInWithOAuth(OAuthProvider.google);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: _kText,
          side: const BorderSide(color: _kDivider, width: 1.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _kDivider),
              ),
              child: const Center(
                child: Text('G',
                    style: TextStyle(
                      color: Color(0xFFDB4437),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    )),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Continue with Google',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  fontFamily: 'Nunito',
                )),
          ],
        ),
      ),
    );
  }
}
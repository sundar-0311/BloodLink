import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
const kRed = Color(0xFFD32F2F);
const kRedDark = Color(0xFF8B0000);
const kCard = Color(0xFFFFFFFF);
const kText = Color(0xFF1A0A0A);
const kTextSoft = Color(0xFF7B5B5B);
const kBg = Color(0xFFF7F2F2);
const kBorder = Color(0xFFEDD5D5);

// ─── Request Page ─────────────────────────────────────────────────────────────
class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  static const int _totalSteps = 4;

  // ── Step 1: Patient Info ────────────────────────────────────────────────────
  final _patientNameCtrl = TextEditingController();
  final _patientAgeCtrl = TextEditingController();
  String _patientGender = '';

  // ── Step 2: Blood Requirement ───────────────────────────────────────────────
  String _bloodType = '';
  int _unitsNeeded = 1;
  String _urgency = '';
  final _reasonCtrl = TextEditingController();
  DateTime? _deadline;

  // ── Step 3: Hospital / Location ─────────────────────────────────────────────
  final _hospitalCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();

  // ── Step 4: Contact ──────────────────────────────────────────────────────────
  final _contactNameCtrl = TextEditingController();
  final _contactPhoneCtrl = TextEditingController();
  String _contactRelation = '';

  // ── Animation ────────────────────────────────────────────────────────────────
  late AnimationController _progressCtrl;
  late Animation<double> _progressAnim;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _progressAnim =
        Tween<double>(begin: 0, end: 1 / _totalSteps).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut),
    );
    _progressCtrl.forward();

    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 320));
    _slideAnim = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _slideCtrl.dispose();
    _patientNameCtrl.dispose();
    _patientAgeCtrl.dispose();
    _reasonCtrl.dispose();
    _hospitalCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _pincodeCtrl.dispose();
    _landmarkCtrl.dispose();
    _contactNameCtrl.dispose();
    _contactPhoneCtrl.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    final prevProgress = (_currentStep + 1) / _totalSteps;
    final nextProgress = (step + 1) / _totalSteps;
    setState(() => _currentStep = step);

    _slideCtrl.reset();
    _slideCtrl.forward();

    _progressAnim = Tween<double>(
      begin: prevProgress,
      end: nextProgress,
    ).animate(
        CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut));
    _progressCtrl
      ..reset()
      ..forward();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _patientNameCtrl.text.trim().isNotEmpty &&
            _patientAgeCtrl.text.trim().isNotEmpty &&
            _patientGender.isNotEmpty;
      case 1:
        return _bloodType.isNotEmpty &&
            _urgency.isNotEmpty &&
            _reasonCtrl.text.trim().isNotEmpty;
      case 2:
        return _hospitalCtrl.text.trim().isNotEmpty &&
            _addressCtrl.text.trim().isNotEmpty &&
            _cityCtrl.text.trim().isNotEmpty;
      case 3:
        return _contactNameCtrl.text.trim().isNotEmpty &&
            _contactPhoneCtrl.text.trim().length >= 10 &&
            _contactRelation.isNotEmpty;
      default:
        return false;
    }
  }

  void _next() {
    if (!_validateCurrentStep()) {
      _showValidationSnack();
      return;
    }
    if (_currentStep < _totalSteps - 1) {
      _goToStep(_currentStep + 1);
    } else {
      _submitRequest();
    }
  }

  void _prev() {
    if (_currentStep > 0) _goToStep(_currentStep - 1);
  }

  void _showValidationSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Please fill all required fields',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        backgroundColor: kRed,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _submitRequest() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SuccessSheet(
        patientName: _patientNameCtrl.text,
        bloodType: _bloodType,
        hospital: _hospitalCtrl.text,
        onDone: () {
          Navigator.pop(context); // close sheet
          Navigator.pop(context); // back to home
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _buildHeader(),
          _buildStepIndicator(),
          Expanded(
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
                child: _buildCurrentStep(),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    final stepTitles = [
      'Patient Info',
      'Blood Requirement',
      'Hospital Details',
      'Contact Info',
    ];
    final stepSubtitles = [
      'Who needs blood?',
      'What type and how urgent?',
      'Where is the patient?',
      'Who should donors call?',
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5C0A0A), Color(0xFFB71C1C), Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(_stepIcon(_currentStep),
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stepTitles[_currentStep],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        stepSubtitles[_currentStep],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _stepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.person_rounded;
      case 1:
        return Icons.water_drop_rounded;
      case 2:
        return Icons.local_hospital_rounded;
      case 3:
        return Icons.call_rounded;
      default:
        return Icons.check_rounded;
    }
  }

  // ── Step Indicator ──────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Container(
      color: kRedDark,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: AnimatedBuilder(
        animation: _progressAnim,
        builder: (_, __) {
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progressAnim.value,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(_totalSteps, (i) {
                  final done = i < _currentStep;
                  final active = i == _currentStep;
                  return Expanded(
                    child: GestureDetector(
                      onTap: done ? () => _goToStep(i) : null,
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: active ? 28 : 20,
                            height: active ? 28 : 20,
                            decoration: BoxDecoration(
                              color: done
                                  ? Colors.white
                                  : active
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: done
                                  ? const Icon(Icons.check_rounded,
                                      color: kRedDark, size: 12)
                                  : Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        color: active
                                            ? kRedDark
                                            : Colors.white,
                                        fontSize: active ? 13 : 11,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                            ),
                          ),
                          if (i < _totalSteps - 1)
                            Expanded(
                              child: Container(
                                height: 2,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4),
                                decoration: BoxDecoration(
                                  color: done
                                      ? Colors.white.withOpacity(0.6)
                                      : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Step Router ─────────────────────────────────────────────────────────────
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return const SizedBox();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 1 — Patient Info
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormCard(
          children: [
            _FieldLabel('Patient Full Name *'),
            _StyledField(
              controller: _patientNameCtrl,
              hint: 'e.g. Lakshmi Venkat',
              icon: Icons.person_outline_rounded,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 18),
            _FieldLabel('Age *'),
            _StyledField(
              controller: _patientAgeCtrl,
              hint: 'e.g. 45',
              icon: Icons.cake_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
            const SizedBox(height: 18),
            _FieldLabel('Gender *'),
            const SizedBox(height: 8),
            Row(
              children: ['Male', 'Female', 'Other'].map((g) {
                final selected = _patientGender == g;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _patientGender = g),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selected
                              ? kRed
                              : kRed.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : kRed.withOpacity(0.2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            g,
                            style: TextStyle(
                              color: selected ? Colors.white : kRed,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _InfoBanner(
          icon: Icons.shield_outlined,
          text:
              'Patient information is kept private and only shared with verified donors.',
          color: const Color(0xFF1565C0),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 2 — Blood Requirement
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep2() {
    final bloodTypes = [
      'A+', 'A−', 'B+', 'B−', 'O+', 'O−', 'AB+', 'AB−'
    ];
    final urgencies = [
      _UrgencyOption('critical', 'Critical', '< 3 hours',
          Icons.emergency_rounded, const Color(0xFFD32F2F)),
      _UrgencyOption('high', 'Urgent', 'Same day',
          Icons.priority_high_rounded, const Color(0xFFE64A19)),
      _UrgencyOption('medium', 'Needed', '1–2 days',
          Icons.info_outline_rounded, const Color(0xFFF57F17)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormCard(
          children: [
            _FieldLabel('Blood Type Required *'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: bloodTypes.map((bt) {
                final selected = _bloodType == bt;
                return GestureDetector(
                  onTap: () => setState(() => _bloodType = bt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 64,
                    height: 52,
                    decoration: BoxDecoration(
                      color:
                          selected ? kRed : kRed.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : kRed.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: kRed.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.water_drop_rounded,
                          color: selected
                              ? Colors.white70
                              : kRed.withOpacity(0.5),
                          size: 11,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          bt,
                          style: TextStyle(
                            color: selected ? Colors.white : kRed,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _FormCard(
          children: [
            _FieldLabel('Units Needed *'),
            const SizedBox(height: 10),
            Row(
              children: [
                _CircleButton(
                  icon: Icons.remove_rounded,
                  onTap: () {
                    if (_unitsNeeded > 1) setState(() => _unitsNeeded--);
                  },
                  active: _unitsNeeded > 1,
                ),
                const SizedBox(width: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Text(
                    '$_unitsNeeded',
                    key: ValueKey(_unitsNeeded),
                    style: const TextStyle(
                      color: kText,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text('unit(s)',
                    style: TextStyle(color: kTextSoft, fontSize: 14)),
                const SizedBox(width: 16),
                _CircleButton(
                  icon: Icons.add_rounded,
                  onTap: () {
                    if (_unitsNeeded < 10) setState(() => _unitsNeeded++);
                  },
                  active: true,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        _FormCard(
          children: [
            _FieldLabel('Urgency Level *'),
            const SizedBox(height: 10),
            ...urgencies.map((u) {
              final selected = _urgency == u.value;
              return GestureDetector(
                onTap: () => setState(() => _urgency = u.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected
                        ? u.color.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? u.color : kBorder,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: u.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(u.icon, color: u.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.label,
                                style: TextStyle(
                                    color: u.color,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14)),
                            Text(u.timeframe,
                                style: const TextStyle(
                                    color: kTextSoft, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (selected)
                        Icon(Icons.check_circle_rounded,
                            color: u.color, size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 14),
        _FormCard(
          children: [
            _FieldLabel('Reason for Request *'),
            _StyledField(
              controller: _reasonCtrl,
              hint:
                  'e.g. Emergency surgery post-accident, requires O− blood urgently',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 18),
            _FieldLabel('Deadline (optional)'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.now().add(const Duration(hours: 6)),
                  firstDate: DateTime.now(),
                  lastDate:
                      DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) => Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: kRed,
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) setState(() => _deadline = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: kBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: kTextSoft, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      _deadline == null
                          ? 'Select deadline date'
                          : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                      style: TextStyle(
                        color: _deadline == null ? kTextSoft : kText,
                        fontSize: 14,
                        fontWeight: _deadline == null
                            ? FontWeight.w400
                            : FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    if (_deadline != null)
                      GestureDetector(
                        onTap: () => setState(() => _deadline = null),
                        child: const Icon(Icons.close_rounded,
                            color: kTextSoft, size: 18),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 3 — Hospital Details
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormCard(
          children: [
            _FieldLabel('Hospital Name *'),
            _StyledField(
              controller: _hospitalCtrl,
              hint: 'e.g. Coimbatore Medical College Hospital',
              icon: Icons.local_hospital_outlined,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 18),
            _FieldLabel('Full Address *'),
            _StyledField(
              controller: _addressCtrl,
              hint: 'Street, Area',
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('City *'),
                      _StyledField(
                        controller: _cityCtrl,
                        hint: 'City',
                        icon: Icons.location_city_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Pincode'),
                      _StyledField(
                        controller: _pincodeCtrl,
                        hint: '6-digit',
                        icon: Icons.pin_drop_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _FieldLabel('Nearby Landmark (optional)'),
            _StyledField(
              controller: _landmarkCtrl,
              hint: 'e.g. Near Race Course, Opp. Bus Stand',
              icon: Icons.place_outlined,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _InfoBanner(
          icon: Icons.map_outlined,
          text:
              'Accurate location helps donors find the hospital quickly. Adding a landmark is strongly recommended.',
          color: const Color(0xFF2E7D32),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // STEP 4 — Contact Info
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildStep4() {
    final relations = [
      'Family Member',
      'Friend',
      'Physician',
      'Hospital Staff',
      'Other',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormCard(
          children: [
            _FieldLabel('Contact Person Name *'),
            _StyledField(
              controller: _contactNameCtrl,
              hint: 'e.g. Ravi Kumar',
              icon: Icons.person_outline_rounded,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 18),
            _FieldLabel('Phone Number *'),
            _StyledField(
              controller: _contactPhoneCtrl,
              hint: '10-digit mobile number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: 18),
            _FieldLabel('Relation to Patient *'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: relations.map((r) {
                final selected = _contactRelation == r;
                return GestureDetector(
                  onTap: () => setState(() => _contactRelation = r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color:
                          selected ? kRed : kRed.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : kRed.withOpacity(0.25),
                      ),
                    ),
                    child: Text(
                      r,
                      style: TextStyle(
                        color: selected ? Colors.white : kRed,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildSummaryPreview(),
        const SizedBox(height: 14),
        _InfoBanner(
          icon: Icons.verified_outlined,
          text:
              'Your request will be reviewed and go live within 5 minutes. Donors nearby will be notified.',
          color: kRed,
        ),
      ],
    );
  }

  Widget _buildSummaryPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.summarize_outlined, color: kRed, size: 16),
              const SizedBox(width: 6),
              const Text('Request Summary',
                  style: TextStyle(
                      color: kText,
                      fontWeight: FontWeight.w900,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: kBorder, height: 1),
          const SizedBox(height: 12),
          _SummaryRow('Patient',
              _patientNameCtrl.text.isEmpty ? '—' : _patientNameCtrl.text),
          _SummaryRow(
              'Blood Type', _bloodType.isEmpty ? '—' : _bloodType),
          _SummaryRow('Units', '$_unitsNeeded unit(s)'),
          _SummaryRow('Urgency',
              _urgency.isEmpty ? '—' : _urgency.toUpperCase()),
          _SummaryRow('Hospital',
              _hospitalCtrl.text.isEmpty ? '—' : _hospitalCtrl.text),
          _SummaryRow(
              'City', _cityCtrl.text.isEmpty ? '—' : _cityCtrl.text),
        ],
      ),
    );
  }

  // ── Bottom Bar ──────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    final isLast = _currentStep == _totalSteps - 1;
    return Container(
      padding: EdgeInsets.fromLTRB(
          18, 14, 18, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: kCard,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _prev,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kRed,
                  side: const BorderSide(color: kRed, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _next,
              icon: Icon(
                isLast
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
              label: Text(isLast ? 'Submit Request' : 'Continue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Success Sheet ────────────────────────────────────────────────────────────
class _SuccessSheet extends StatefulWidget {
  final String patientName;
  final String bloodType;
  final String hospital;
  final VoidCallback onDone;

  const _SuccessSheet({
    required this.patientName,
    required this.bloodType,
    required this.hospital,
    required this.onDone,
  });

  @override
  State<_SuccessSheet> createState() => _SuccessSheetState();
}

class _SuccessSheetState extends State<_SuccessSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 28, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF2E7D32), size: 44),
            ),
          ),
          const SizedBox(height: 18),
          FadeTransition(
            opacity: _fade,
            child: Column(
              children: [
                const Text('Request Posted!',
                    style: TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w900,
                        fontSize: 22)),
                const SizedBox(height: 8),
                Text(
                  'Your request for ${widget.bloodType} blood for ${widget.patientName} at ${widget.hospital} is now live.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: kTextSoft, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kRed.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kRed.withOpacity(0.15)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.notifications_active_rounded,
                          color: kRed, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Nearby donors matching this blood type will be notified immediately.',
                          style:
                              TextStyle(color: kText, fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: widget.onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Back to Home',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_rounded, size: 16),
                  label: const Text('Share Request'),
                  style: TextButton.styleFrom(
                    foregroundColor: kRed,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
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

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              color: kText,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.1)),
    );
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _StyledField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(
          color: kText, fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: kTextSoft.withOpacity(0.6), fontSize: 13),
        prefixIcon:
            Icon(icon, color: kRed.withOpacity(0.6), size: 18),
        filled: true,
        fillColor: kBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kRed, width: 1.5),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  const _CircleButton(
      {required this.icon, required this.onTap, required this.active});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              active ? kRed.withOpacity(0.1) : kBorder.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(
              color: active ? kRed.withOpacity(0.3) : kBorder),
        ),
        child: Icon(icon,
            color: active ? kRed : kTextSoft.withOpacity(0.4), size: 20),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoBanner(
      {required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: color.withOpacity(0.85),
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    color: kTextSoft,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: kText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _UrgencyOption {
  final String value;
  final String label;
  final String timeframe;
  final IconData icon;
  final Color color;
  const _UrgencyOption(
      this.value, this.label, this.timeframe, this.icon, this.color);
}
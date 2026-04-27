import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

// ─── Colors (matching app theme) ─────────────────────────────────────────────
const kRed = Color(0xFFD32F2F);
const kRedDark = Color(0xFF8B0000);
const kRedLight = Color(0xFFFFCDD2);
const kCard = Color(0xFFFFFFFF);
const kText = Color(0xFF1A0A0A);
const kTextSoft = Color(0xFF7B5B5B);
const kBg = Color(0xFFF7F2F2);

// ─── Models ───────────────────────────────────────────────────────────────────
class DonorBadge {
  final String emoji;
  final String title;
  final String description;
  final bool earned;
  final Color color;

  const DonorBadge({
    required this.emoji,
    required this.title,
    required this.description,
    required this.earned,
    required this.color,
  });
}

class EligibilityItem {
  final String label;
  final String value;
  final bool ok;
  final IconData icon;

  const EligibilityItem({
    required this.label,
    required this.value,
    required this.ok,
    required this.icon,
  });
}

class SettingsItem {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;

  const SettingsItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.color,
    required this.onTap,
  });
}

// ─── Mock Data ────────────────────────────────────────────────────────────────
const List<DonorBadge> kBadges = [
  DonorBadge(
    emoji: '🩸',
    title: 'First Drop',
    description: 'Completed first donation',
    earned: true,
    color: Color(0xFFD32F2F),
  ),
  DonorBadge(
    emoji: '🔥',
    title: 'On Fire',
    description: '3 donations in a row',
    earned: true,
    color: Color(0xFFE64A19),
  ),
  DonorBadge(
    emoji: '⭐',
    title: 'Rising Star',
    description: '5 total donations',
    earned: true,
    color: Color(0xFFF57F17),
  ),
  DonorBadge(
    emoji: '💎',
    title: 'Diamond Donor',
    description: '10 total donations',
    earned: false,
    color: Color(0xFF1565C0),
  ),
  DonorBadge(
    emoji: '🏆',
    title: 'Life Saver',
    description: 'Responded to critical request',
    earned: true,
    color: Color(0xFF2E7D32),
  ),
  DonorBadge(
    emoji: '🌟',
    title: 'Legend',
    description: '20 total donations',
    earned: false,
    color: Color(0xFF6A1B9A),
  ),
];

const List<EligibilityItem> kEligibility = [
  EligibilityItem(
    label: 'Last Donation',
    value: '3 months ago',
    ok: true,
    icon: Icons.calendar_today_rounded,
  ),
  EligibilityItem(
    label: 'Hemoglobin',
    value: '14.2 g/dL  ✓',
    ok: true,
    icon: Icons.bloodtype_rounded,
  ),
  EligibilityItem(
    label: 'Blood Pressure',
    value: '118/76 mmHg  ✓',
    ok: true,
    icon: Icons.favorite_rounded,
  ),
  EligibilityItem(
    label: 'Weight',
    value: '72 kg  ✓',
    ok: true,
    icon: Icons.monitor_weight_rounded,
  ),
  EligibilityItem(
    label: 'Recent Illness',
    value: 'None reported',
    ok: true,
    icon: Icons.health_and_safety_rounded,
  ),
  EligibilityItem(
    label: 'Next Eligible',
    value: 'Now eligible ✓',
    ok: true,
    icon: Icons.check_circle_rounded,
  ),
];

// ─── Profile Page ─────────────────────────────────────────────────────────────
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final _supabase = Supabase.instance.client;

  bool _available = true;
  bool _profileLoading = true;

  // Live profile data from Supabase
  String _fullName = '';
  String _phone = '';
  String _bloodGroup = 'O+';
  String _email = '';

  late AnimationController _headerAnim;
  late AnimationController _cardAnim;
  late Animation<double> _cardScale;
  late Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _cardAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cardScale = Tween<double>(begin: 0.93, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnim, curve: Curves.easeOutBack),
    );
    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardAnim, curve: Curves.easeOut),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _cardAnim.forward();
    });

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final data = await _supabase
          .from('profiles')
          .select('full_name, phone, blood_group')
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          _fullName = data['full_name'] ?? '';
          _phone = data['phone'] ?? '';
          _bloodGroup = data['blood_group'] ?? 'O+';
          _email = user.email ?? '';
          _profileLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _profileLoading = false);
    }
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _cardAnim.dispose();
    super.dispose();
  }

  void _toggleAvailability() {
    HapticFeedback.lightImpact();
    setState(() => _available = !_available);
  }

  void _openEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        initialName: _fullName,
        initialPhone: _phone,
        initialBloodGroup: _bloodGroup,
        onSaved: (name, phone, bloodGroup) {
          setState(() {
            _fullName = name;
            _phone = phone;
            _bloodGroup = bloodGroup;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _cardFade,
              child: ScaleTransition(
                scale: _cardScale,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildDonorIDCard(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('🏅 Badges & Achievements'),
                      const SizedBox(height: 14),
                      _buildBadgesGrid(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('🩺 Health & Eligibility'),
                      const SizedBox(height: 14),
                      _buildEligibilityCard(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('⚙️ Settings'),
                      const SizedBox(height: 14),
                      _buildSettingsCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sliver Header ────────────────────────────────────────────────────────────
  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 270,
      collapsedHeight: 72,
      pinned: true,
      stretch: true,
      backgroundColor: kRedDark,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      titleSpacing: 0,
      title: _buildCollapsedBar(),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        collapseMode: CollapseMode.pin,
        background: _buildExpandedHeader(),
      ),
    );
  }

  Widget _buildCollapsedBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          // FIX: Wrap in ConstrainedBox to prevent availability toggle from
          // overflowing on narrow screens
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130),
            child: GestureDetector(
              onTap: _toggleAvailability,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: _available
                      ? Colors.green.withOpacity(0.25)
                      : Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _available
                        ? Colors.green.withOpacity(0.5)
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle,
                        size: 7,
                        color: _available
                            ? const Color(0xFF66BB6A)
                            : Colors.white38),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        _available ? 'Available' : 'Unavailable',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _available
                              ? const Color(0xFFA5D6A7)
                              : Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedHeader() {
    return Container(
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
              top: 40,
              right: 80,
              child: _DecorCircle(size: 90, opacity: 0.05)),
          Positioned(
              bottom: -30,
              left: -30,
              child: _DecorCircle(size: 140, opacity: 0.06)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 3),
                            ),
                            child: const Center(
                              child: Text('👨',
                                  style: TextStyle(fontSize: 38)),
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: GestureDetector(
                              onTap: _toggleAvailability,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: _available
                                      ? const Color(0xFF66BB6A)
                                      : const Color(0xFFEF9A9A),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _profileLoading ? '...' : _fullName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // FIX: Verified badge stays fixed-width, won't
                                // push name text to overflow
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1565C0)
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified_rounded,
                                          size: 10, color: Colors.white),
                                      SizedBox(width: 3),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: Colors.white60, size: 12),
                                const SizedBox(width: 3),
                                Expanded(
                                  // FIX: Location text was unbounded — wrap in
                                  // Expanded + ellipsis to prevent overflow
                                  child: Text(
                                    'Gandhipuram, Coimbatore',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _toggleAvailability,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _available
                                      ? Colors.green.withOpacity(0.22)
                                      : Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _available
                                        ? Colors.green.withOpacity(0.45)
                                        : Colors.white.withOpacity(0.2),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _available
                                          ? Icons.circle
                                          : Icons.do_not_disturb_on_rounded,
                                      size: 8,
                                      color: _available
                                          ? const Color(0xFF66BB6A)
                                          : Colors.white38,
                                    ),
                                    const SizedBox(width: 6),
                                    // FIX: Flexible + overflow ellipsis so the
                                    // label cannot push the mini-switch off-screen
                                    Flexible(
                                      child: Text(
                                        _available
                                            ? 'Available to donate'
                                            : 'Marked unavailable',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: _available
                                              ? const Color(0xFFA5D6A7)
                                              : Colors.white54,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _MiniSwitch(value: _available),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // FIX: Stats row — each stat wrapped in Expanded with
                  // overflow protection so long blood group values (e.g. AB−)
                  // don't cause horizontal overflow
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15), width: 1),
                    ),
                    child: Row(
                      children: [
                        _buildHeaderStat(_bloodGroup, 'Blood\nType'),
                        _buildStatDivider(),
                        _buildHeaderStat('7', 'Donations'),
                        _buildStatDivider(),
                        _buildHeaderStat('21', 'Lives\nSaved'),
                        _buildStatDivider(),
                        _buildHeaderStat('3🔥', 'Streak'),
                      ],
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

  Widget _buildHeaderStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          // FIX: FittedBox so the value (e.g. "AB−") shrinks instead of
          // overflowing its Expanded column
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() => Container(
        width: 1,
        height: 30,
        color: Colors.white.withOpacity(0.18),
        margin: const EdgeInsets.symmetric(horizontal: 4),
      );

  // ── Section Label ────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: kText,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }

  // ── Donor ID Card ────────────────────────────────────────────────────────────
  Widget _buildDonorIDCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B0000), Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kRed.withOpacity(0.38),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: _DecorCircle(size: 110, opacity: 0.1),
          ),
          Positioned(
            bottom: -10,
            left: 60,
            child: _DecorCircle(size: 70, opacity: 0.07),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop_rounded,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    const Expanded(
                      // FIX: Header label row was unbounded; Expanded prevents
                      // it pushing the ID number off screen on narrow devices
                      child: Text(
                        'BLOODLINK DONOR ID',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '#BL-00247',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3), width: 1.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // FIX: FittedBox so blood group text (e.g. AB−) won't
                          // overflow the fixed-size container
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                _bloodGroup,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Blood Type',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profileLoading ? '...' : _fullName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email.isEmpty ? '' : _email,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // FIX: Chip row was using a plain Row, chips could
                          // overflow on narrow screens. Use Wrap instead.
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _buildIDChip(
                                  Icons.favorite_rounded, '7 Donations'),
                              _buildIDChip(Icons.local_hospital_rounded,
                                  '$_bloodGroup Universal'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          // FIX: milestone label overflowed when font scale is
                          // large; Expanded + ellipsis fixes it
                          child: Text(
                            'Next milestone: 10 donations',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '7 / 10',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 7 / 10,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIDChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white70),
          const SizedBox(width: 4),
          // FIX: chip label can overflow on large font scale; constrain it
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Badges Grid ──────────────────────────────────────────────────────────────
  Widget _buildBadgesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // FIX: increased childAspectRatio from 0.85 → 0.80 to give each badge
        // card slightly more vertical room, preventing description text from
        // being clipped at the bottom on devices with larger system font sizes
        childAspectRatio: 0.80,
      ),
      itemCount: kBadges.length,
      itemBuilder: (context, i) =>
          _BadgeCard(badge: kBadges[i], index: i),
    );
  }

  // ── Eligibility Card ─────────────────────────────────────────────────────────
  Widget _buildEligibilityCard() {
    final allGood = kEligibility.every((e) => e.ok);
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: allGood
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFF3E0),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Icon(
                  allGood
                      ? Icons.check_circle_rounded
                      : Icons.warning_rounded,
                  color: allGood
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE65100),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  // FIX: eligibility header text was unbounded; Expanded
                  // prevents it from pushing outside the card on small screens
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allGood
                            ? "You're eligible to donate!"
                            : 'Check required',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: allGood
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFE65100),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        allGood
                            ? 'All health checks passed'
                            : 'Some checks need attention',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: (allGood
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFE65100))
                              .withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: kEligibility.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _EligibilityRow(item: item),
                    if (i < kEligibility.length - 1)
                      const Divider(
                        color: Color(0xFFF0E0E0),
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Settings Card ────────────────────────────────────────────────────────────
  Widget _buildSettingsCard() {
    final items = [
      SettingsItem(
        icon: Icons.person_outline_rounded,
        label: 'Edit Profile',
        subtitle: 'Name, blood group, contact info',
        color: const Color(0xFF1565C0),
        onTap: _openEditProfile,
      ),
      SettingsItem(
        icon: Icons.notifications_outlined,
        label: 'Notifications',
        subtitle: 'Alerts, reminders, requests',
        color: const Color(0xFFE64A19),
        onTap: () {},
      ),
      SettingsItem(
        icon: Icons.lock_outline_rounded,
        label: 'Privacy',
        subtitle: 'Who can see your profile',
        color: const Color(0xFF2E7D32),
        onTap: () {},
      ),
      SettingsItem(
        icon: Icons.share_outlined,
        label: 'Share My Donor Card',
        subtitle: 'Spread the word',
        color: const Color(0xFF6A1B9A),
        onTap: () {},
      ),
      SettingsItem(
        icon: Icons.help_outline_rounded,
        label: 'Help & Support',
        color: kTextSoft,
        onTap: () {},
      ),
      SettingsItem(
        icon: Icons.logout_rounded,
        label: 'Sign Out',
        color: kRed,
        onTap: () async {
          await Supabase.instance.client.auth.signOut();
          if (!context.mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _SettingsRow(item: item),
              if (i < items.length - 1)
                const Divider(
                  color: Color(0xFFF0E0E0),
                  height: 1,
                  indent: 56,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Edit Profile Sheet ───────────────────────────────────────────────────────
class _EditProfileSheet extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String initialBloodGroup;
  final void Function(String name, String phone, String bloodGroup) onSaved;

  const _EditProfileSheet({
    required this.initialName,
    required this.initialPhone,
    required this.initialBloodGroup,
    required this.onSaved,
  });

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _supabase = Supabase.instance.client;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late String _bloodGroup;
  bool _saving = false;
  String? _error;

  static const _bloodGroups = [
    'A+', 'A−', 'B+', 'B−', 'O+', 'O−', 'AB+', 'AB−'
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
    _bloodGroup = widget.initialBloodGroup;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Name cannot be empty.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final uid = _supabase.auth.currentUser!.id;
      await _supabase.from('profiles').update({
        'full_name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'blood_group': _bloodGroup,
      }).eq('id', uid);

      if (!mounted) return;
      widget.onSaved(
        _nameCtrl.text.trim(),
        _phoneCtrl.text.trim(),
        _bloodGroup,
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDD5D5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_outline_rounded,
                      color: Color(0xFF1565C0), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  // FIX: title column had no width constraint; on narrow
                  // screens the subtitle overflows. Wrap in Expanded.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: kText,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Changes save to your account',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kTextSoft,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Full Name
            _sheetLabel('Full Name'),
            const SizedBox(height: 6),
            _sheetField(
              controller: _nameCtrl,
              hint: 'Your full name',
              icon: Icons.person_outline_rounded,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Phone
            _sheetLabel('Phone Number'),
            const SizedBox(height: 6),
            _sheetField(
              controller: _phoneCtrl,
              hint: '+91 98765 43210',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Blood Group
            _sheetLabel('Blood Group'),
            const SizedBox(height: 8),
            // FIX: blood group selector was a Wrap; chips are fixed-size so
            // this is fine, but each chip gets a minimum touch target of 40px
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _bloodGroups.map((bg) {
                final selected = bg == _bloodGroup;
                return GestureDetector(
                  onTap: () => setState(() => _bloodGroup = bg),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    // FIX: Use constraints instead of fixed width so the chip
                    // respects system font scaling
                    constraints: const BoxConstraints(
                      minWidth: 54,
                      minHeight: 40,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected ? kRed : kCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? kRed : const Color(0xFFEDD5D5),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        bg,
                        style: TextStyle(
                          color: selected ? Colors.white : kTextSoft,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            if (_error != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kRed.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: kRed, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: kRedDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kRed,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: kRed.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: kText,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      );

  Widget _sheetField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      style: const TextStyle(
        color: kText,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: kTextSoft.withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, size: 18, color: kTextSoft),
        filled: true,
        fillColor: const Color(0xFFF7F2F2),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEDD5D5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEDD5D5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kRed, width: 1.8),
        ),
      ),
    );
  }
}

// ─── Badge Card ───────────────────────────────────────────────────────────────
class _BadgeCard extends StatefulWidget {
  final DonorBadge badge;
  final int index;
  const _BadgeCard({required this.badge, required this.index});

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.8, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    Future.delayed(Duration(milliseconds: 300 + widget.index * 70), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final badge = widget.badge;
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: badge.earned
                ? badge.color.withOpacity(0.07)
                : const Color(0xFFF7F2F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: badge.earned
                  ? badge.color.withOpacity(0.25)
                  : const Color(0xFFEDD5D5),
              width: 1.5,
            ),
          ),
          // FIX: replaced fixed symmetric padding with padding that has less
          // vertical padding (10 instead of 14) and clips with a Column that
          // uses mainAxisSize.min. The GridView childAspectRatio controls
          // height, so we must not assume extra vertical space is available.
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    badge.emoji,
                    style: TextStyle(
                      fontSize: 28,
                      // FIX: fontSize reduced from 30 → 28 to give a little
                      // more breathing room in the fixed-height grid cell
                      color:
                          badge.earned ? null : Colors.transparent,
                    ),
                  ),
                  if (!badge.earned)
                    Text(
                      badge.emoji,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black.withOpacity(0.12),
                      ),
                    ),
                  if (!badge.earned)
                    const Icon(Icons.lock_rounded,
                        size: 16, color: Color(0xFFBBAAA8)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                badge.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: badge.earned ? badge.color : kTextSoft,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              // FIX: description text now has a hard maxLines: 2 with ellipsis
              // so it never pushes out of the card boundary
              Flexible(
                child: Text(
                  badge.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: badge.earned
                        ? badge.color.withOpacity(0.65)
                        : kTextSoft.withOpacity(0.5),
                    fontSize: 9,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Eligibility Row ──────────────────────────────────────────────────────────
class _EligibilityRow extends StatelessWidget {
  final EligibilityItem item;
  const _EligibilityRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: item.ok
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              size: 18,
              color: item.ok
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFC62828),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kText,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // FIX: value text was unbounded on the right; constrain it so
          // long values (e.g. "118/76 mmHg  ✓") don't overflow the row
          Flexible(
            child: Text(
              item.value,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: item.ok
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFC62828),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Settings Row ─────────────────────────────────────────────────────────────
class _SettingsRow extends StatelessWidget {
  final SettingsItem item;
  const _SettingsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: item.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: item.label == 'Sign Out' ? kRed : kText,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kTextSoft.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.label != 'Sign Out')
              Icon(Icons.chevron_right_rounded,
                  color: kTextSoft.withOpacity(0.4), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Mini Switch ──────────────────────────────────────────────────────────────
class _MiniSwitch extends StatelessWidget {
  final bool value;
  const _MiniSwitch({required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 30,
      height: 17,
      decoration: BoxDecoration(
        color: value
            ? const Color(0xFF66BB6A).withOpacity(0.8)
            : Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 220),
        alignment:
            value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 13,
          height: 13,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ─── Decorative Circle ────────────────────────────────────────────────────────
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
          color: Colors.white.withOpacity(opacity),
          width: 1.5,
        ),
      ),
    );
  }
}
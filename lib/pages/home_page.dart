import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'find_donor_page.dart';
import 'profile_page.dart';
import 'request_page.dart';
import 'donation_history_page.dart';
import 'chatbot_page.dart';
import 'bloodbank_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const BloodDonationApp());
}

class BloodDonationApp extends StatelessWidget {
  const BloodDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BloodLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F2F2),
      ),
      home: const HomePage(),
    );
  }
}

class UrgentRequest {
  final String id;
  final String bloodType;
  final String hospital;
  final String city;
  final int unitsNeeded;
  final String urgency;
  final String postedAgo;
  final String contactName;

  const UrgentRequest({
    required this.id,
    required this.bloodType,
    required this.hospital,
    required this.city,
    required this.unitsNeeded,
    required this.urgency,
    required this.postedAgo,
    required this.contactName,
  });
}

class DonationCamp {
  final String name;
  final String date;
  final String location;
  final double distance;
  final int slotsLeft;

  const DonationCamp({
    required this.name,
    required this.date,
    required this.location,
    required this.distance,
    required this.slotsLeft,
  });
}

class HealthTip {
  final String emoji;
  final String title;
  final String body;
  final Color color;

  const HealthTip({
    required this.emoji,
    required this.title,
    required this.body,
    required this.color,
  });
}

const List<UrgentRequest> kUrgentRequests = [
  UrgentRequest(
    id: '1',
    bloodType: 'O−',
    hospital: 'Coimbatore Medical College',
    city: 'Coimbatore',
    unitsNeeded: 3,
    urgency: 'critical',
    postedAgo: '12 min ago',
    contactName: 'Dr. Priya',
  ),
  UrgentRequest(
    id: '2',
    bloodType: 'AB+',
    hospital: 'G.Kuppuswamy Naidu Hospital',
    city: 'Coimbatore',
    unitsNeeded: 2,
    urgency: 'high',
    postedAgo: '34 min ago',
    contactName: 'Ravi Kumar',
  ),
  UrgentRequest(
    id: '3',
    bloodType: 'B+',
    hospital: 'PSG Hospitals',
    city: 'Coimbatore',
    unitsNeeded: 1,
    urgency: 'medium',
    postedAgo: '1 hr ago',
    contactName: 'Meena S.',
  ),
  UrgentRequest(
    id: '4',
    bloodType: 'A−',
    hospital: 'Sri Ramakrishna Hospital',
    city: 'Coimbatore',
    unitsNeeded: 2,
    urgency: 'high',
    postedAgo: '2 hr ago',
    contactName: 'Suresh R.',
  ),
  UrgentRequest(
    id: '5',
    bloodType: 'B−',
    hospital: 'KG Hospital',
    city: 'Coimbatore',
    unitsNeeded: 4,
    urgency: 'critical',
    postedAgo: '3 hr ago',
    contactName: 'Anitha M.',
  ),
  UrgentRequest(
    id: '6',
    bloodType: 'O+',
    hospital: 'PSG Hospitals',
    city: 'Coimbatore',
    unitsNeeded: 1,
    urgency: 'medium',
    postedAgo: '4 hr ago',
    contactName: 'Vijay K.',
  ),
];

const List<DonationCamp> kCamps = [
  DonationCamp(
    name: 'Lions Club Blood Drive',
    date: 'Sat, 26 Apr',
    location: 'Gandhipuram Community Hall',
    distance: 1.4,
    slotsLeft: 8,
  ),
  DonationCamp(
    name: 'RSM Medical Camp',
    date: 'Sun, 27 Apr',
    location: 'RS Puram Park',
    distance: 3.1,
    slotsLeft: 15,
  ),
];

const List<HealthTip> kHealthTips = [
  HealthTip(
    emoji: '💧',
    title: 'Hydrate Before You Donate',
    body: 'Drink at least 500 ml of water before donation to replenish faster.',
    color: Color(0xFF1565C0),
  ),
  HealthTip(
    emoji: '🍳',
    title: 'Eat Iron-Rich Foods',
    body: 'Spinach, eggs & lentils help maintain hemoglobin levels above 12.5 g/dL.',
    color: Color(0xFF2E7D32),
  ),
  HealthTip(
    emoji: '😴',
    title: 'Rest Well After Donation',
    body: 'Avoid heavy lifting for 5 hours. Your body regenerates red cells in ~4 weeks.',
    color: Color(0xFF6A1B9A),
  ),
];

const kRed = Color(0xFFD32F2F);
const kRedDark = Color(0xFF8B0000);
const kRedLight = Color(0xFFFFCDD2);
const kRedSurface = Color(0xFFFFF5F5);
const kCard = Color(0xFFFFFFFF);
const kText = Color(0xFF1A0A0A);
const kTextSoft = Color(0xFF7B5B5B);
const kDivider = Color(0xFFEDD5D5);

Map<String, Color> urgencyColor = {
  'critical': const Color(0xFFD32F2F),
  'high': const Color(0xFFE64A19),
  'medium': const Color(0xFFF57F17),
};

Map<String, String> urgencyLabel = {
  'critical': 'CRITICAL',
  'high': 'URGENT',
  'medium': 'NEEDED',
};

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  int _tipIndex = 0;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (_, animation, __, child) {
          final slide = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }

  void _navigateToProfile() => _navigateTo(const ProfilePage());
  void _navigateToFindDonor() => _navigateTo(const FindDonorPage());
  void _navigateToRequest() => _navigateTo(const RequestPage());
  void _navigateToChatbot() => _navigateTo(const ChatbotPage());
  void _navigateToBloodBanks() => _navigateTo(const BloodBankPage());

  void _navigateToDonationHistory() => _navigateTo(
        DonationHistoryPage(
          donorProfile: DonorProfile(
            name: 'Arjun Krishnan',
            bloodType: 'O+',
            area: 'Gandhipuram',
            contact: '+91 98765 43210',
            available: true,
            registeredOn: DateTime(2023, 1, 1),
          ),
          onDonorRegistered: (updatedProfile) {
            debugPrint('Donor profile updated: ${updatedProfile.name}');
          },
        ),
      );

  void _navigateToAllUrgentRequests() =>
      _navigateTo(const AllUrgentRequestsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F2),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverHeader(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      '🆘 Urgent Requests Near You',
                      onTap: _navigateToAllUrgentRequests,
                    ),
                    const SizedBox(height: 14),
                    _buildUrgentRequests(),
                    const SizedBox(height: 28),
                    _buildDonationStreak(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('🏕️ Upcoming Camps', onTap: () {}),
                    const SizedBox(height: 14),
                    ..._buildCampCards(),
                    const SizedBox(height: 28),
                    _buildHealthTip(),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      collapsedHeight: 72,
      pinned: true,
      stretch: true,
      backgroundColor: kRedDark,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      title: _CollapsedHeader(),
      titleSpacing: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: _HeaderBackground(pulseAnim: _pulseAnim),
        collapseMode: CollapseMode.pin,
      ),
    );
  }

  Widget _buildUrgentRequests() {
    return SizedBox(
      height: 178,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: kUrgentRequests.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) =>
            _UrgentRequestCard(request: kUrgentRequests[i]),
      ),
    );
  }

  Widget _buildDonationStreak() {
    return GestureDetector(
      onTap: _navigateToDonationHistory,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B0000), Color(0xFFD32F2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kRed.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR IMPACT',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '7',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Donations',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '≈ 21 lives saved',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStreakDots(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.history_rounded,
                        color: Colors.white60, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      'Tap to view full history →',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                _buildCircleStat('🔥', '3', 'Streak'),
                const SizedBox(height: 12),
                _buildCircleStat('⏳', '49d', 'Next ok'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakDots() {
    final months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    final donated = {0, 2, 3, 5, 7, 9, 11};
    return Row(
      children: List.generate(12, (i) {
        final active = donated.contains(i);
        return Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.white24,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                months[i],
                style: TextStyle(
                  color: active ? Colors.white : Colors.white38,
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCircleStat(String emoji, String value, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ],
    );
  }

  List<Widget> _buildCampCards() {
    return kCamps
        .map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CampCard(camp: c),
            ))
        .toList();
  }

  Widget _buildHealthTip() {
    final tip = kHealthTips[_tipIndex % kHealthTips.length];
    return GestureDetector(
      onTap: () => setState(() => _tipIndex++),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: Container(
          key: ValueKey(_tipIndex),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: tip.color.withOpacity(0.08),
            border: Border.all(color: tip.color.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tip.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tip.title,
                            style: TextStyle(
                              color: tip.color,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          'Tap for next →',
                          style: TextStyle(
                            color: tip.color.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tip.body,
                      style: TextStyle(
                        color: tip.color.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(
                        kHealthTips.length,
                        (i) => Container(
                          margin: const EdgeInsets.only(right: 5),
                          width: i == _tipIndex % kHealthTips.length ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _tipIndex % kHealthTips.length
                                ? tip.color
                                : tip.color.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onTap}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: kText,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: kRed,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: const Text(
            'See all →',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home', onTap: () => setState(() => _navIndex = 0)),
      _NavItem(icon: Icons.search_rounded, label: 'Find', onTap: _navigateToFindDonor),
      _NavItem(icon: Icons.bloodtype_rounded, label: 'Request', onTap: _navigateToRequest),
      _NavItem(icon: Icons.local_hospital_rounded, label: 'Blood Banks', onTap: _navigateToBloodBanks),
      _NavItem(icon: Icons.history_rounded, label: 'History', onTap: _navigateToDonationHistory),
      _NavItem(icon: Icons.smart_toy_rounded, label: 'Chat', onTap: _navigateToChatbot),
      _NavItem(icon: Icons.person_rounded, label: 'Profile', onTap: _navigateToProfile),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(items.length, (i) {
            final selected = _navIndex == i;
            return GestureDetector(
              onTap: () {
                setState(() => _navIndex = i);
                items[i].onTap();
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? kRed : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i].icon,
                      color: selected ? Colors.white : kTextSoft,
                      size: 22,
                    ),
                    if (selected) ...[
                      const SizedBox(width: 6),
                      Text(
                        items[i].label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AllUrgentRequestsPage extends StatefulWidget {
  const AllUrgentRequestsPage({super.key});

  @override
  State<AllUrgentRequestsPage> createState() => _AllUrgentRequestsPageState();
}

class _AllUrgentRequestsPageState extends State<AllUrgentRequestsPage> {
  String _selectedUrgency = 'All';
  String _selectedBloodType = 'Any';

  final List<String> _urgencyFilters = ['All', 'Critical', 'Urgent', 'Needed'];
  final List<String> _bloodTypeFilters = [
    'Any', 'A+', 'A−', 'B+', 'B−', 'O+', 'O−', 'AB+', 'AB−'
  ];

  List<UrgentRequest> get _filteredRequests {
    return kUrgentRequests.where((r) {
      if (_selectedUrgency != 'All') {
        final match = {
          'Critical': 'critical',
          'Urgent': 'high',
          'Needed': 'medium',
        }[_selectedUrgency];
        if (r.urgency != match) return false;
      }
      if (_selectedBloodType != 'Any' && r.bloodType != _selectedBloodType) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final requests = _filteredRequests;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F2),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            stretch: true,
            backgroundColor: kRedDark,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: innerBoxIsScrolled
                ? const Text(
                    'Urgent Requests',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.07), width: 1.5),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.emergency_rounded,
                                      color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Urgent Requests',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Text(
                                        '${requests.length} active near Coimbatore',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _urgencyFilters.map((u) {
                        final Map<String, Color> colors = {
                          'All': kRed,
                          'Critical': const Color(0xFFD32F2F),
                          'Urgent': const Color(0xFFE64A19),
                          'Needed': const Color(0xFFF57F17),
                        };
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedUrgency = u),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: _selectedUrgency == u
                                    ? (colors[u] ?? kRed)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _selectedUrgency == u
                                      ? (colors[u] ?? kRed)
                                      : (colors[u] ?? kRed).withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                u,
                                style: TextStyle(
                                  color: _selectedUrgency == u
                                      ? Colors.white
                                      : (colors[u] ?? kRed),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        const Text(
                          'Blood Type:',
                          style: TextStyle(
                            color: kTextSoft,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ..._bloodTypeFilters.map((bt) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedBloodType = bt),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _selectedBloodType == bt
                                        ? const Color(0xFFAD1457)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _selectedBloodType == bt
                                          ? const Color(0xFFAD1457)
                                          : const Color(0xFFAD1457)
                                              .withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    bt,
                                    style: TextStyle(
                                      color: _selectedBloodType == bt
                                          ? Colors.white
                                          : const Color(0xFFAD1457),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: requests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🩸', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          const Text(
                            'No requests found',
                            style: TextStyle(
                              color: kText,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try changing your filters',
                            style: TextStyle(color: kTextSoft, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                      physics: const BouncingScrollPhysics(),
                      itemCount: requests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) =>
                          _UrgentRequestListCard(request: requests[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrgentRequestListCard extends StatelessWidget {
  final UrgentRequest request;
  const _UrgentRequestListCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final color = urgencyColor[request.urgency]!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.18), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              request.bloodType,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        request.hospital,
                        style: const TextStyle(
                          color: kText,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        urgencyLabel[request.urgency]!,
                        style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 11, color: kTextSoft),
                    const SizedBox(width: 3),
                    Text(
                      request.city,
                      style: const TextStyle(color: kTextSoft, fontSize: 11),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.local_hospital_outlined,
                        size: 11, color: kTextSoft),
                    const SizedBox(width: 3),
                    Text(
                      '${request.unitsNeeded} unit${request.unitsNeeded > 1 ? 's' : ''} needed',
                      style: const TextStyle(color: kTextSoft, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        size: 12, color: kTextSoft),
                    const SizedBox(width: 4),
                    Text(
                      request.contactName,
                      style: const TextStyle(
                        color: kText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      request.postedAgo,
                      style: TextStyle(
                          color: kTextSoft.withOpacity(0.7), fontSize: 10),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                          textStyle: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                        child: const Text('Respond'),
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
}

class _HeaderBackground extends StatelessWidget {
  final Animation<double> pulseAnim;
  const _HeaderBackground({required this.pulseAnim});

  @override
  Widget build(BuildContext context) {
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
            top: -30,
            right: -30,
            child: _DecorCircle(size: 160, opacity: 0.08),
          ),
          Positioned(
            top: 30,
            right: 60,
            child: _DecorCircle(size: 80, opacity: 0.06),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: _DecorCircle(size: 120, opacity: 0.06),
          ),
          Positioned(
            right: 24,
            bottom: 28,
            child: AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, child) => Transform.scale(
                scale: pulseAnim.value,
                child: child,
              ),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 52, 100, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Text('🩸', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 5),
                          Text(
                            'O+  Donor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.green.withOpacity(0.4)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle,
                              color: Color(0xFF66BB6A), size: 7),
                          SizedBox(width: 5),
                          Text(
                            'Available',
                            style: TextStyle(
                              color: Color(0xFFA5D6A7),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Good morning,',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Arjun Krishnan 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: Colors.white60, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      '3 urgent requests near Coimbatore',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 52,
            right: 16,
            child: _NotifBell(),
          ),
          Positioned(
            bottom: 24,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, animation, __) => const ProfilePage(),
                    transitionsBuilder: (_, animation, __, child) {
                      final slide = Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeOutCubic));
                      return SlideTransition(position: slide, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 380),
                  ),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
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
          color: Colors.white.withOpacity(opacity),
          width: 1.5,
        ),
      ),
    );
  }
}

class _NotifBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.notifications_rounded,
              color: Colors.white, size: 22),
        ),
        Positioned(
          top: -3,
          right: -3,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6F00),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '3',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CollapsedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          const Icon(Icons.water_drop_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Text(
            'BloodLink',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'O+',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgentRequestCard extends StatelessWidget {
  final UrgentRequest request;
  const _UrgentRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final color = urgencyColor[request.urgency]!;
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  request.bloodType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  urgencyLabel[request.urgency]!,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            request.hospital,
            style: const TextStyle(
              color: kText,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.local_hospital_outlined,
                  size: 11, color: kTextSoft),
              const SizedBox(width: 3),
              Text(
                '${request.unitsNeeded} unit${request.unitsNeeded > 1 ? 's' : ''} needed',
                style: const TextStyle(color: kTextSoft, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                request.postedAgo,
                style:
                    TextStyle(color: kTextSoft.withOpacity(0.7), fontSize: 10),
              ),
              const Spacer(),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    textStyle: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                  child: const Text('Help'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampCard extends StatelessWidget {
  final DonationCamp camp;
  const _CampCard({required this.camp});

  @override
  Widget build(BuildContext context) {
    final slotsLow = camp.slotsLeft <= 5;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: kRedLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.campaign_rounded, color: kRed, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  camp.name,
                  style: const TextStyle(
                    color: kText,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${camp.date}  ·  ${camp.location}',
                  style: const TextStyle(color: kTextSoft, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 11, color: kTextSoft),
                    const SizedBox(width: 3),
                    Text(
                      '${camp.distance} km away',
                      style: const TextStyle(fontSize: 11, color: kTextSoft),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: slotsLow
                            ? const Color(0xFFFFF3E0)
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${camp.slotsLeft} slots left',
                        style: TextStyle(
                          color: slotsLow
                              ? const Color(0xFFE65100)
                              : const Color(0xFF2E7D32),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: kRed,
              side: const BorderSide(color: kRed, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              textStyle:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
            child: const Text('RSVP'),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.onTap});
}
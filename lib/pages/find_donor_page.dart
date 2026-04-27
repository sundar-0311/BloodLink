import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────
const kRed = Color(0xFFD32F2F);
const kRedDark = Color(0xFF8B0000);
const kRedLight = Color(0xFFFFCDD2);
const kGreen = Color(0xFF2E7D32);
const kGreenLight = Color(0xFFE8F5E9);
const kGreenMid = Color(0xFFA5D6A7);
const kOrange = Color(0xFFE65100);
const kOrangeLight = Color(0xFFFFF3E0);
const kCard = Color(0xFFFFFFFF);
const kText = Color(0xFF1A0A0A);
const kTextSoft = Color(0xFF7B5B5B);
const kBg = Color(0xFFF7F2F2);

// ─── Blood compatibility map ──────────────────────────────────────────────────
const Map<String, List<String>> kCanDonateTo = {
  'O−': ['O−', 'O+', 'A−', 'A+', 'B−', 'B+', 'AB−', 'AB+'],
  'O+': ['O+', 'A+', 'B+', 'AB+'],
  'A−': ['A−', 'A+', 'AB−', 'AB+'],
  'A+': ['A+', 'AB+'],
  'B−': ['B−', 'B+', 'AB−', 'AB+'],
  'B+': ['B+', 'AB+'],
  'AB−': ['AB−', 'AB+'],
  'AB+': ['AB+'],
};

// ─── Enums ────────────────────────────────────────────────────────────────────
enum AppMode { findDonor, offerDonate }

enum UrgencyLevel { critical, high, medium }

extension UrgencyExt on UrgencyLevel {
  String get label =>
      name[0].toUpperCase() + name.substring(1);

  Color get color => this == UrgencyLevel.critical
      ? kRed
      : this == UrgencyLevel.high
          ? kOrange
          : const Color(0xFFF57F17);

  Color get bgColor => this == UrgencyLevel.critical
      ? kRedLight
      : this == UrgencyLevel.high
          ? kOrangeLight
          : const Color(0xFFFFF9C4);
}

// ─── Models ───────────────────────────────────────────────────────────────────
class Donor {
  final String id;
  final String name;
  final String bloodType;
  final String city;
  final String area;
  final double distance;
  final bool available;
  final int totalDonations;
  final String lastDonated;
  final String avatarEmoji;
  final bool verified;
  final String responseTime;
  final String phone;

  const Donor({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.city,
    required this.area,
    required this.distance,
    required this.available,
    required this.totalDonations,
    required this.lastDonated,
    required this.avatarEmoji,
    required this.verified,
    required this.responseTime,
    required this.phone,
  });
}

class BloodNeed {
  final String id;
  final String name;
  final String bloodType;
  final String hospital;
  final String area;
  final double distance;
  final UrgencyLevel urgency;
  final String postedAt;
  final String avatarEmoji;
  final int unitsNeeded;
  final String contact;
  final String note;

  const BloodNeed({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.hospital,
    required this.area,
    required this.distance,
    required this.urgency,
    required this.postedAt,
    required this.avatarEmoji,
    required this.unitsNeeded,
    required this.contact,
    required this.note,
  });
}

// ─── Mock Data ────────────────────────────────────────────────────────────────
const List<Donor> kAllDonors = [
  Donor(id: '1', name: 'Priya Venkatesh', bloodType: 'O+', city: 'Coimbatore', area: 'Gandhipuram', distance: 1.2, available: true, totalDonations: 12, lastDonated: '3 months ago', avatarEmoji: '👩', verified: true, responseTime: '~10 min', phone: '+91 98765 43210'),
  Donor(id: '2', name: 'Karthik Rajan', bloodType: 'O−', city: 'Coimbatore', area: 'RS Puram', distance: 2.8, available: true, totalDonations: 7, lastDonated: '2 months ago', avatarEmoji: '👨', verified: true, responseTime: '~30 min', phone: '+91 97654 32109'),
  Donor(id: '3', name: 'Meena Sundar', bloodType: 'AB+', city: 'Coimbatore', area: 'Peelamedu', distance: 4.1, available: false, totalDonations: 5, lastDonated: '6 weeks ago', avatarEmoji: '👩', verified: false, responseTime: '~1 hr', phone: '+91 96543 21098'),
  Donor(id: '4', name: 'Suresh Babu', bloodType: 'B+', city: 'Coimbatore', area: 'Saibaba Colony', distance: 3.5, available: true, totalDonations: 20, lastDonated: '4 months ago', avatarEmoji: '👨', verified: true, responseTime: '~15 min', phone: '+91 95432 10987'),
  Donor(id: '5', name: 'Anitha Krishnan', bloodType: 'A+', city: 'Coimbatore', area: 'Vadavalli', distance: 6.3, available: true, totalDonations: 3, lastDonated: '5 months ago', avatarEmoji: '👩', verified: false, responseTime: '~45 min', phone: '+91 94321 09876'),
  Donor(id: '6', name: 'Vikram Nair', bloodType: 'B−', city: 'Coimbatore', area: 'Singanallur', distance: 5.7, available: true, totalDonations: 9, lastDonated: '2 months ago', avatarEmoji: '👨', verified: true, responseTime: '~20 min', phone: '+91 93210 98765'),
  Donor(id: '7', name: 'Deepa Mohan', bloodType: 'AB−', city: 'Coimbatore', area: 'Hopes College', distance: 2.1, available: false, totalDonations: 15, lastDonated: '5 weeks ago', avatarEmoji: '👩', verified: true, responseTime: '~1 hr', phone: '+91 92109 87654'),
  Donor(id: '8', name: 'Ravi Shankar', bloodType: 'A−', city: 'Coimbatore', area: 'Ukkadam', distance: 3.9, available: true, totalDonations: 6, lastDonated: '3 months ago', avatarEmoji: '👨', verified: false, responseTime: '~25 min', phone: '+91 91098 76543'),
];

final List<BloodNeed> kAllNeeds = [
  const BloodNeed(id: 'n1', name: 'Arun Kumar', bloodType: 'O+', hospital: 'Coimbatore Medical College', area: 'Peelamedu', distance: 3.2, urgency: UrgencyLevel.critical, postedAt: '20 min ago', avatarEmoji: '👤', unitsNeeded: 2, contact: '+91 98111 22333', note: 'Surgery scheduled tomorrow morning'),
  const BloodNeed(id: 'n2', name: 'Lakshmi Hospital', bloodType: 'AB+', hospital: 'Lakshmi Hospital', area: 'Gandhipuram', distance: 1.8, urgency: UrgencyLevel.high, postedAt: '1 hr ago', avatarEmoji: '🏥', unitsNeeded: 3, contact: '+91 97222 33444', note: 'Multiple patients needing AB+ urgently'),
  const BloodNeed(id: 'n3', name: 'Preethi Shankar', bloodType: 'B+', hospital: 'PSG Hospitals', area: 'Peelamedu', distance: 4.5, urgency: UrgencyLevel.medium, postedAt: '3 hrs ago', avatarEmoji: '👩', unitsNeeded: 1, contact: '+91 96333 44555', note: 'Scheduled for knee replacement'),
  const BloodNeed(id: 'n4', name: 'KMCH', bloodType: 'A+', hospital: 'KMCH', area: 'Avanashi Road', distance: 6.1, urgency: UrgencyLevel.high, postedAt: '2 hrs ago', avatarEmoji: '🏥', unitsNeeded: 4, contact: '+91 95444 55666', note: 'ICU patients'),
  const BloodNeed(id: 'n5', name: 'Murugan Selvam', bloodType: 'O−', hospital: 'GEM Hospital', area: 'RS Puram', distance: 2.9, urgency: UrgencyLevel.critical, postedAt: '45 min ago', avatarEmoji: '👤', unitsNeeded: 2, contact: '+91 94555 66777', note: 'Accident victim, rare blood type needed urgently'),
];

const List<String> kBloodTypes = ['All', 'A+', 'A−', 'B+', 'B−', 'O+', 'O−', 'AB+', 'AB−'];
const List<String> kDistances = ['Any', '< 2 km', '< 5 km', '< 10 km'];
const List<String> kSortOptions = ['Nearest', 'Most Donations', 'Fastest Response'];

// ─── Main Page ────────────────────────────────────────────────────────────────
class FindDonorPage extends StatefulWidget {
  final String myBloodType;
  const FindDonorPage({super.key, this.myBloodType = 'O+'});

  @override
  State<FindDonorPage> createState() => _FindDonorPageState();
}

class _FindDonorPageState extends State<FindDonorPage> with TickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  late AnimationController _fabAnim;

  AppMode _mode = AppMode.findDonor;
  String _selectedBloodType = 'All';
  String _selectedDistance = 'Any';
  String _selectedSort = 'Nearest';
  bool _availableOnly = false;
  bool _verifiedOnly = false;
  bool _showFilters = false;
  bool _eligibleOnly = false;

  final List<BloodNeed> _extraNeeds = [];

  List<String> get _myCompatibleTypes => kCanDonateTo[widget.myBloodType] ?? [];

  // ── Filtered donors ──────────────────────────────────────────────────────
  List<Donor> get _filteredDonors {
    var list = List<Donor>.from(kAllDonors);
    if (_eligibleOnly) list = list.where((d) => _myCompatibleTypes.contains(d.bloodType)).toList();
    if (_selectedBloodType != 'All') list = list.where((d) => d.bloodType == _selectedBloodType).toList();
    if (_selectedDistance != 'Any') {
      final max = _selectedDistance == '< 2 km' ? 2.0 : _selectedDistance == '< 5 km' ? 5.0 : 10.0;
      list = list.where((d) => d.distance <= max).toList();
    }
    if (_availableOnly) list = list.where((d) => d.available).toList();
    if (_verifiedOnly) list = list.where((d) => d.verified).toList();
    final q = _searchCtrl.text.toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((d) =>
        d.name.toLowerCase().contains(q) ||
        d.area.toLowerCase().contains(q) ||
        d.bloodType.toLowerCase().contains(q)).toList();
    }
    if (_selectedSort == 'Nearest') list.sort((a, b) => a.distance.compareTo(b.distance));
    else if (_selectedSort == 'Most Donations') list.sort((a, b) => b.totalDonations.compareTo(a.totalDonations));
    else list.sort((a, b) => a.responseTime.compareTo(b.responseTime));
    return list;
  }

  // ── Filtered needs ───────────────────────────────────────────────────────
  List<BloodNeed> get _filteredNeeds {
    var list = [...kAllNeeds, ..._extraNeeds];
    if (_eligibleOnly) list = list.where((n) => _myCompatibleTypes.contains(n.bloodType)).toList();
    if (_selectedBloodType != 'All') list = list.where((n) => n.bloodType == _selectedBloodType).toList();
    if (_selectedDistance != 'Any') {
      final max = _selectedDistance == '< 2 km' ? 2.0 : _selectedDistance == '< 5 km' ? 5.0 : 10.0;
      list = list.where((n) => n.distance <= max).toList();
    }
    final q = _searchCtrl.text.toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((n) =>
        n.name.toLowerCase().contains(q) ||
        n.area.toLowerCase().contains(q) ||
        n.bloodType.toLowerCase().contains(q) ||
        n.hospital.toLowerCase().contains(q)).toList();
    }
    list.sort((a, b) => a.urgency.index.compareTo(b.urgency.index));
    return list;
  }

  int get _activeFilterCount {
    int c = 0;
    if (_selectedBloodType != 'All') c++;
    if (_selectedDistance != 'Any') c++;
    if (_availableOnly) c++;
    if (_verifiedOnly) c++;
    return c;
  }

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..forward();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _switchMode(AppMode m) {
    setState(() {
      _mode = m;
      _eligibleOnly = false;
      _selectedBloodType = 'All';
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedBloodType = 'All';
      _selectedDistance = 'Any';
      _selectedSort = 'Nearest';
      _availableOnly = false;
      _verifiedOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final donors = _filteredDonors;
    final needs = _filteredNeeds;

    return Scaffold(
      backgroundColor: kBg,
      floatingActionButton: _buildFab(),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildModeSwitcher(),
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: _showFilters ? _buildAdvancedFilters() : const SizedBox.shrink(),
          ),
          _buildBloodTypeChips(),
          _buildEligibilityBanner(),
          _buildResultsBar(_mode == AppMode.findDonor ? donors.length : needs.length),
          Expanded(
            child: _mode == AppMode.findDonor
                ? _buildDonorList(donors)
                : _buildNeedsList(needs),
          ),
        ],
      ),
    );
  }

  // ── FAB ──────────────────────────────────────────────────────────────────
  Widget _buildFab() {
    return FloatingActionButton.extended(
      onPressed: () {
        if (_mode == AppMode.findDonor) {
          _openPostNeedSheet();
        } else {
          _openRegisterDonorSheet();
        }
      },
      backgroundColor: kRed,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: Icon(_mode == AppMode.findDonor ? Icons.add_circle_outline_rounded : Icons.volunteer_activism_rounded),
      label: Text(
        _mode == AppMode.findDonor ? 'Post a Need' : 'Register as Donor',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A0000), Color(0xFFB71C1C), Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _mode == AppMode.findDonor ? 'Find a Donor' : 'Offer to Donate',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.3),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
                    child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: _mode == AppMode.findDonor
                    ? [
                        _buildHeaderStat('247', 'Donors\nNearby'),
                        _buildHeaderDivider(),
                        _buildHeaderStat('89', 'Available\nNow'),
                        _buildHeaderDivider(),
                        _buildHeaderStat(widget.myBloodType, 'My Blood\nType'),
                      ]
                    : [
                        _buildHeaderStat('${_filteredNeeds.length}', 'Requests\nNearby'),
                        _buildHeaderDivider(),
                        _buildHeaderStat('${_filteredNeeds.where((n) => n.urgency == UrgencyLevel.critical).length}', 'Critical\nNow'),
                        _buildHeaderDivider(),
                        _buildHeaderStat(widget.myBloodType, 'My Blood\nType'),
                      ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1)),
          const SizedBox(height: 3),
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 10, fontWeight: FontWeight.w600, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildHeaderDivider() {
    return Container(width: 1, height: 32, color: Colors.white.withOpacity(0.2), margin: const EdgeInsets.symmetric(horizontal: 8));
  }

  // ── Search + Filter ───────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: kRedDark,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: _mode == AppMode.findDonor ? 'Search name, area, blood type…' : 'Search hospital, area, blood type…',
                  hintStyle: TextStyle(color: kTextSoft.withOpacity(0.6), fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded, color: kTextSoft, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? GestureDetector(onTap: () => _searchCtrl.clear(), child: const Icon(Icons.close_rounded, color: kTextSoft, size: 18))
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => setState(() => _showFilters = !_showFilters),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: _showFilters ? Colors.white : Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.tune_rounded, color: _showFilters ? kRed : Colors.white, size: 22),
                  if (_activeFilterCount > 0)
                    Positioned(
                      top: 6, right: 6,
                      child: Container(
                        width: 14, height: 14,
                        decoration: const BoxDecoration(color: Color(0xFFFF6F00), shape: BoxShape.circle),
                        child: Center(child: Text('$_activeFilterCount', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900))),
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

  // ── Mode Switcher ─────────────────────────────────────────────────────────
  Widget _buildModeSwitcher() {
    return Container(
      color: kRedDark,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildModeTab(AppMode.findDonor, Icons.search_rounded, 'Find a Donor'),
            _buildModeTab(AppMode.offerDonate, Icons.volunteer_activism_rounded, 'Offer to Donate'),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTab(AppMode m, IconData icon, String label) {
    final active = _mode == m;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchMode(m),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: active ? kRed : Colors.white.withOpacity(0.6)),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: active ? kRed : Colors.white.withOpacity(0.6))),
            ],
          ),
        ),
      ),
    );
  }

  // ── Advanced Filters ──────────────────────────────────────────────────────
  Widget _buildAdvancedFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Color(0xFFEDD5D5), height: 1),
          const SizedBox(height: 12),
          _filterLabel('📍 Distance'),
          const SizedBox(height: 8),
          Row(
            children: kDistances.map((d) {
              final sel = _selectedDistance == d;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDistance = d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.only(right: d != kDistances.last ? 8.0 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? kRedLight : kBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sel ? kRed : const Color(0xFFEDD5D5), width: 1.5),
                    ),
                    child: Text(d, textAlign: TextAlign.center, style: TextStyle(color: sel ? kRed : kTextSoft, fontWeight: FontWeight.w700, fontSize: 11)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          _filterLabel('↕️ Sort By'),
          const SizedBox(height: 8),
          Row(
            children: kSortOptions.map((s) {
              final sel = _selectedSort == s;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedSort = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.only(right: s != kSortOptions.last ? 8.0 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? kRedLight : kBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sel ? kRed : const Color(0xFFEDD5D5), width: 1.5),
                    ),
                    child: Text(s, textAlign: TextAlign.center, style: TextStyle(color: sel ? kRed : kTextSoft, fontWeight: FontWeight.w700, fontSize: 10)),
                  ),
                ),
              );
            }).toList(),
          ),
          if (_mode == AppMode.findDonor) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _buildToggle(label: 'Available Only', icon: Icons.circle, iconColor: kGreen, value: _availableOnly, onChanged: (v) => setState(() => _availableOnly = v))),
                const SizedBox(width: 12),
                Expanded(child: _buildToggle(label: 'Verified Only', icon: Icons.verified_rounded, iconColor: const Color(0xFF1565C0), value: _verifiedOnly, onChanged: (v) => setState(() => _verifiedOnly = v))),
              ],
            ),
          ],
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _resetFilters,
            child: Center(
              child: Text('Reset all filters', style: TextStyle(color: kRed.withOpacity(0.8), fontWeight: FontWeight.w700, fontSize: 13, decoration: TextDecoration.underline, decorationColor: kRed.withOpacity(0.4))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterLabel(String label) => Text(label, style: const TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.3));

  Widget _buildToggle({required String label, required IconData icon, required Color iconColor, required bool value, required ValueChanged<bool> onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? kRedLight : kBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: value ? kRed : const Color(0xFFEDD5D5), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: iconColor),
            const SizedBox(width: 6),
            Flexible(child: Text(label, style: TextStyle(color: value ? kRed : kTextSoft, fontWeight: FontWeight.w700, fontSize: 11))),
            const SizedBox(width: 6),
            _MiniSwitch(value: value),
          ],
        ),
      ),
    );
  }

  // ── Blood Type Chips ──────────────────────────────────────────────────────
  Widget _buildBloodTypeChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: kBloodTypes.map((type) {
            final selected = _selectedBloodType == type;
            final isCompat = _eligibleOnly && type != 'All' && _myCompatibleTypes.contains(type);
            return GestureDetector(
              onTap: () => setState(() => _selectedBloodType = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? kRed : isCompat ? kGreenLight : kBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selected ? kRed : isCompat ? kGreenMid : const Color(0xFFEDD5D5), width: 1.5),
                ),
                child: Text(type, style: TextStyle(color: selected ? Colors.white : isCompat ? kGreen : kTextSoft, fontWeight: FontWeight.w800, fontSize: 13)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Eligibility Banner ────────────────────────────────────────────────────
  Widget _buildEligibilityBanner() {
    final compatTypes = _myCompatibleTypes;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _eligibleOnly = !_eligibleOnly);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _eligibleOnly ? kGreenLight : Colors.white,
          border: Border(bottom: BorderSide(color: _eligibleOnly ? kGreenMid.withOpacity(0.4) : const Color(0xFFEDD5D5), width: 1)),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: _eligibleOnly ? kGreen.withOpacity(0.12) : kBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(Icons.health_and_safety_rounded, size: 17, color: _eligibleOnly ? kGreen : kTextSoft),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _mode == AppMode.findDonor ? 'Show only recipients I can donate to' : 'Show only needs I can fulfill',
                    style: TextStyle(color: _eligibleOnly ? const Color(0xFF1B5E20) : kText, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    _eligibleOnly
                        ? 'Compatible with ${widget.myBloodType}: ${compatTypes.join(', ')}'
                        : 'Your blood type: ${widget.myBloodType}  ·  Tap to filter',
                    style: TextStyle(color: _eligibleOnly ? kGreen.withOpacity(0.75) : kTextSoft.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _BigSwitch(value: _eligibleOnly, activeColor: kGreen),
          ],
        ),
      ),
    );
  }

  // ── Results Bar ───────────────────────────────────────────────────────────
  Widget _buildResultsBar(int count) {
    final label = _mode == AppMode.findDonor ? 'donor' : 'request';
    return Container(
      color: kBg,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 6),
      child: Row(
        children: [
          Text('$count $label${count != 1 ? 's' : ''} found', style: const TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 14)),
          if (_eligibleOnly) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: kGreenMid.withOpacity(0.5))),
              child: const Text('Eligible only', style: TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.w800)),
            ),
          ],
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFEDD5D5))),
            child: Row(
              children: [
                const Icon(Icons.swap_vert_rounded, size: 14, color: kTextSoft),
                const SizedBox(width: 4),
                Text(_selectedSort, style: const TextStyle(color: kTextSoft, fontWeight: FontWeight.w700, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Donor List ────────────────────────────────────────────────────────────
  Widget _buildDonorList(List<Donor> donors) {
    if (donors.isEmpty) return _buildEmptyState('🔍', 'No donors found', 'Try adjusting your filters');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: donors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _DonorCard(donor: donors[i], index: i, myBloodType: widget.myBloodType),
    );
  }

  // ── Needs List ────────────────────────────────────────────────────────────
  Widget _buildNeedsList(List<BloodNeed> needs) {
    if (needs.isEmpty) return _buildEmptyState('❤️', 'No requests found', 'All caught up! Or adjust your filters.');
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: needs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _NeedCard(need: needs[i], index: i, myBloodType: widget.myBloodType),
    );
  }

  Widget _buildEmptyState(String emoji, String title, String sub) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 8),
          Text(sub, style: TextStyle(color: kTextSoft.withOpacity(0.7), fontSize: 14)),
        ],
      ),
    );
  }

  // ── Post a Need Sheet ─────────────────────────────────────────────────────
  void _openPostNeedSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PostNeedSheet(
        onSubmit: (need) {
          setState(() {
            _extraNeeds.insert(0, need);
            _mode = AppMode.offerDonate;
          });
        },
      ),
    );
  }

  // ── Register Donor Sheet ──────────────────────────────────────────────────
  void _openRegisterDonorSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RegisterDonorSheet(myBloodType: widget.myBloodType),
    );
  }
}

// ─── Donor Card ───────────────────────────────────────────────────────────────
class _DonorCard extends StatefulWidget {
  final Donor donor;
  final int index;
  final String myBloodType;

  const _DonorCard({required this.donor, required this.index, required this.myBloodType});

  @override
  State<_DonorCard> createState() => _DonorCardState();
}

class _DonorCardState extends State<_DonorCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _fade;

  bool get _canDonate => (kCanDonateTo[widget.myBloodType] ?? []).contains(widget.donor.bloodType);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 350 + widget.index * 60));
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.index * 60), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final d = widget.donor;
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(18),
            border: _canDonate ? Border.all(color: kGreenMid.withOpacity(0.5), width: 1.5) : null,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.055), blurRadius: 14, offset: const Offset(0, 5))],
          ),
          child: Column(
            children: [
              // Top row
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: d.available ? kGreenLight : const Color(0xFFF3E5F5),
                          shape: BoxShape.circle,
                          border: Border.all(color: d.available ? kGreenMid : const Color(0xFFCE93D8), width: 2.5),
                        ),
                        child: Center(child: Text(d.avatarEmoji, style: const TextStyle(fontSize: 24))),
                      ),
                      if (d.available)
                        Positioned(
                          bottom: 1, right: 1,
                          child: Container(
                            width: 13, height: 13,
                            decoration: BoxDecoration(color: kGreen, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(child: Text(d.name, style: const TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 15), overflow: TextOverflow.ellipsis)),
                            if (d.verified) ...[const SizedBox(width: 5), const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF1565C0))],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 11, color: kTextSoft),
                            const SizedBox(width: 2),
                            Flexible(child: Text('${d.area}, ${d.city}', style: const TextStyle(color: kTextSoft, fontSize: 11), overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 6),
                            _DistBadge(dist: d.distance),
                          ],
                        ),
                        if (_canDonate) ...[
                          const SizedBox(height: 5),
                          _CompatBadge(text: '${widget.myBloodType} can donate to ${d.bloodType}'),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(12)),
                    child: Text(d.bloodType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFF0E0E0), height: 1),
              const SizedBox(height: 12),
              // Stats
              Row(
                children: [
                  _StatItem(icon: Icons.favorite_rounded, value: '${d.totalDonations}', label: 'donations', color: kRed),
                  _StatDivider(),
                  _StatItem(icon: Icons.access_time_rounded, value: d.lastDonated, label: 'last donated', color: kTextSoft),
                  _StatDivider(),
                  _StatItem(icon: Icons.flash_on_rounded, value: d.responseTime, label: 'response', color: const Color(0xFF00695C)),
                ],
              ),
              const SizedBox(height: 14),
              // Actions
              Row(
                children: [
                  _AvailPill(available: d.available),
                  const Spacer(),
                  _ActionButton(icon: Icons.call_rounded, label: 'Call', filled: false, onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Calling ${d.name}…'),
                      backgroundColor: kRedDark,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ));
                  }),
                  const SizedBox(width: 8),
                  _ActionButton(icon: Icons.bloodtype_rounded, label: 'Request', filled: true, onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => _RequestDonationSheet(donor: d, myBloodType: widget.myBloodType, canDonate: _canDonate),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Need Card ────────────────────────────────────────────────────────────────
class _NeedCard extends StatefulWidget {
  final BloodNeed need;
  final int index;
  final String myBloodType;

  const _NeedCard({required this.need, required this.index, required this.myBloodType});

  @override
  State<_NeedCard> createState() => _NeedCardState();
}

class _NeedCardState extends State<_NeedCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _fade;

  bool get _canFulfill => (kCanDonateTo[widget.myBloodType] ?? []).contains(widget.need.bloodType);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 350 + widget.index * 60));
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.index * 60), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final n = widget.need;
    final urgColor = n.urgency.color;
    final isUrgent = n.urgency == UrgencyLevel.critical;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(18),
            border: isUrgent
                ? Border.all(color: kRedLight, width: 1.5)
                : _canFulfill
                    ? Border.all(color: kGreenMid.withOpacity(0.5), width: 1.5)
                    : null,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.055), blurRadius: 14, offset: const Offset(0, 5))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: kRedLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: kRedLight, width: 2.5),
                    ),
                    child: Center(child: Text(n.avatarEmoji, style: const TextStyle(fontSize: 24))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.name, style: const TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 15), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.local_hospital_rounded, size: 11, color: kTextSoft),
                            const SizedBox(width: 3),
                            Flexible(child: Text(n.hospital, style: const TextStyle(color: kTextSoft, fontSize: 11), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 11, color: kTextSoft),
                            const SizedBox(width: 2),
                            Flexible(child: Text(n.area, style: const TextStyle(color: kTextSoft, fontSize: 11), overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 6),
                            _DistBadge(dist: n.distance),
                          ],
                        ),
                        if (_canFulfill) ...[
                          const SizedBox(height: 5),
                          _CompatBadge(text: 'Your ${widget.myBloodType} can donate to ${n.bloodType}'),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(12)),
                    child: Text(n.bloodType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFF0E0E0), height: 1),
              const SizedBox(height: 12),
              // Stats
              Row(
                children: [
                  _StatItem(icon: Icons.water_drop_rounded, value: '${n.unitsNeeded} unit${n.unitsNeeded > 1 ? 's' : ''}', label: 'needed', color: kRed),
                  _StatDivider(),
                  _StatItem(icon: Icons.access_time_rounded, value: n.postedAt, label: 'posted', color: kTextSoft),
                  _StatDivider(),
                  _StatItem(icon: Icons.near_me_rounded, value: '${n.distance} km', label: 'distance', color: const Color(0xFF00695C)),
                ],
              ),
              // Note
              if (n.note.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(10)),
                  child: Text('📋 ${n.note}', style: TextStyle(color: kTextSoft.withOpacity(0.85), fontSize: 11, height: 1.5)),
                ),
              ],
              const SizedBox(height: 12),
              // Actions
              Row(
                children: [
                  // Urgency pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: n.urgency.bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: urgColor.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 12, color: urgColor),
                        const SizedBox(width: 4),
                        Text(n.urgency.label, style: TextStyle(color: urgColor, fontWeight: FontWeight.w700, fontSize: 11)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _ActionButton(icon: Icons.call_rounded, label: 'Call', filled: false, onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Calling ${n.name}…'),
                      backgroundColor: kRedDark,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ));
                  }),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.volunteer_activism_rounded,
                    label: 'Offer',
                    filled: true,
                    color: kGreen,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => _OfferDonationSheet(need: n, myBloodType: widget.myBloodType, canFulfill: _canFulfill),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Request Donation Sheet ───────────────────────────────────────────────────
class _RequestDonationSheet extends StatefulWidget {
  final Donor donor;
  final String myBloodType;
  final bool canDonate;

  const _RequestDonationSheet({required this.donor, required this.myBloodType, required this.canDonate});

  @override
  State<_RequestDonationSheet> createState() => _RequestDonationSheetState();
}

class _RequestDonationSheetState extends State<_RequestDonationSheet> {
  final _msgCtrl = TextEditingController();
  final _hospitalCtrl = TextEditingController();
  UrgencyLevel _urgency = UrgencyLevel.high;
  bool _sent = false;

  @override
  void dispose() { _msgCtrl.dispose(); _hospitalCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
      decoration: const BoxDecoration(color: kCard, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: _sent ? _buildSuccess('Request Sent!', '${widget.donor.name} has been notified.\nExpected response: ${widget.donor.responseTime}', false) : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetHandle(),
          _SheetTitle('Request Donation'),
          // Donor summary
          _DonorSummaryRow(emoji: widget.donor.avatarEmoji, name: widget.donor.name, sub: '${widget.donor.area} · ${widget.donor.distance} km away', bloodType: widget.donor.bloodType),
          const SizedBox(height: 12),
          _CompatNotice(compat: widget.canDonate, myBt: widget.myBloodType, targetBt: widget.donor.bloodType, isDonor: true),
          const SizedBox(height: 16),
          _FieldLabel('Urgency Level'),
          const SizedBox(height: 8),
          _UrgencySelector(selected: _urgency, onChanged: (u) => setState(() => _urgency = u)),
          const SizedBox(height: 14),
          _FieldLabel('Hospital / Location'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _hospitalCtrl, hint: 'e.g. Coimbatore Medical College', icon: Icons.local_hospital_outlined),
          const SizedBox(height: 14),
          _FieldLabel('Message (optional)'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _msgCtrl, hint: 'Add patient info, ward number, urgency details…', maxLines: 3),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              onPressed: () { HapticFeedback.mediumImpact(); setState(() => _sent = true); },
              style: ElevatedButton.styleFrom(backgroundColor: _urgency.color, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.bloodtype_rounded, size: 18),
              label: Text('Send ${_urgency.label} Request', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Offer Donation Sheet ─────────────────────────────────────────────────────
class _OfferDonationSheet extends StatefulWidget {
  final BloodNeed need;
  final String myBloodType;
  final bool canFulfill;

  const _OfferDonationSheet({required this.need, required this.myBloodType, required this.canFulfill});

  @override
  State<_OfferDonationSheet> createState() => _OfferDonationSheetState();
}

class _OfferDonationSheetState extends State<_OfferDonationSheet> {
  final _noteCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  String? _selectedTime;
  DateTime? _selectedDate;
  bool _sent = false;

  static const _times = ['Morning', 'Afternoon', 'Evening'];

  @override
  void dispose() { _noteCtrl.dispose(); _contactCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
      decoration: const BoxDecoration(color: kCard, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: _sent
          ? _buildSuccess('Offer Sent! ❤️', 'Your donation offer has been sent to ${widget.need.name}.\nThey\'ll confirm shortly.', true)
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetHandle(),
          _SheetTitle('Offer to Donate'),
          _DonorSummaryRow(emoji: widget.need.avatarEmoji, name: widget.need.name, sub: '${widget.need.hospital} · ${widget.need.distance} km away', bloodType: widget.need.bloodType),
          const SizedBox(height: 12),
          _CompatNotice(compat: widget.canFulfill, myBt: widget.myBloodType, targetBt: widget.need.bloodType, isDonor: false),
          const SizedBox(height: 16),
          _FieldLabel('When can you donate?'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
              if (date != null) setState(() => _selectedDate = date);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEDD5D5))),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 16, color: kTextSoft),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDate == null ? 'Select a date' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(color: _selectedDate == null ? kTextSoft.withOpacity(0.6) : kText, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _FieldLabel('Preferred time'),
          const SizedBox(height: 8),
          Row(
            children: _times.map((t) {
              final sel = _selectedTime == t;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTime = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    margin: EdgeInsets.only(right: t != _times.last ? 8.0 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? kGreenLight : kBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sel ? kGreen : const Color(0xFFEDD5D5), width: sel ? 1.5 : 1),
                    ),
                    child: Text(t, textAlign: TextAlign.center, style: TextStyle(color: sel ? kGreen : kTextSoft, fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          _FieldLabel('Your contact number'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _contactCtrl, hint: '+91 XXXXX XXXXX', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: 14),
          _FieldLabel('Note (optional)'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _noteCtrl, hint: 'Last donation date, any conditions, availability…', maxLines: 3),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              onPressed: () { HapticFeedback.mediumImpact(); setState(() => _sent = true); },
              style: ElevatedButton.styleFrom(backgroundColor: kGreen, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.volunteer_activism_rounded, size: 18),
              label: const Text('Confirm Donation Offer', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Post a Need Sheet ────────────────────────────────────────────────────────
class _PostNeedSheet extends StatefulWidget {
  final void Function(BloodNeed need) onSubmit;
  const _PostNeedSheet({required this.onSubmit});

  @override
  State<_PostNeedSheet> createState() => _PostNeedSheetState();
}

class _PostNeedSheetState extends State<_PostNeedSheet> {
  final _nameCtrl = TextEditingController();
  final _hospitalCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _unitsCtrl = TextEditingController(text: '1');
  String _selectedBT = 'O+';
  UrgencyLevel _urgency = UrgencyLevel.high;

  @override
  void dispose() {
    for (final c in [_nameCtrl, _hospitalCtrl, _areaCtrl, _contactCtrl, _noteCtrl, _unitsCtrl]) c.dispose();
    super.dispose();
  }

  void _submit() {
    final need = BloodNeed(
      id: 'n_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.isEmpty ? 'Anonymous' : _nameCtrl.text,
      bloodType: _selectedBT,
      hospital: _hospitalCtrl.text.isEmpty ? 'Hospital' : _hospitalCtrl.text,
      area: _areaCtrl.text.isEmpty ? 'Coimbatore' : _areaCtrl.text,
      distance: double.parse((1 + (DateTime.now().millisecondsSinceEpoch % 70) / 10).toStringAsFixed(1)),
      urgency: _urgency,
      postedAt: 'Just now',
      avatarEmoji: '🏥',
      unitsNeeded: int.tryParse(_unitsCtrl.text) ?? 1,
      contact: _contactCtrl.text,
      note: _noteCtrl.text,
    );
    widget.onSubmit(need);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
      decoration: const BoxDecoration(color: kCard, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetHandle(),
            _SheetTitle('Post a Blood Need'),
            _FieldLabel('Patient / Hospital Name'),
            const SizedBox(height: 6),
            _StyledTextField(controller: _nameCtrl, hint: 'e.g. Arun Kumar / KMCH', icon: Icons.person_outline_rounded),
            const SizedBox(height: 14),
            _FieldLabel('Blood Type Needed'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: kBloodTypes.where((b) => b != 'All').map((bt) {
                final sel = _selectedBT == bt;
                return GestureDetector(
                  onTap: () => setState(() => _selectedBT = bt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? kRed : kBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: sel ? kRed : const Color(0xFFEDD5D5), width: 1.5),
                    ),
                    child: Text(bt, style: TextStyle(color: sel ? Colors.white : kTextSoft, fontWeight: FontWeight.w800, fontSize: 13)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            _FieldLabel('Hospital'),
            const SizedBox(height: 6),
            _StyledTextField(controller: _hospitalCtrl, hint: 'e.g. Coimbatore Medical College', icon: Icons.local_hospital_outlined),
            const SizedBox(height: 14),
            _FieldLabel('Area'),
            const SizedBox(height: 6),
            _StyledTextField(controller: _areaCtrl, hint: 'e.g. Gandhipuram', icon: Icons.location_on_outlined),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Units Needed'),
                      const SizedBox(height: 6),
                      _StyledTextField(controller: _unitsCtrl, hint: '1', keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Contact Number'),
                      const SizedBox(height: 6),
                      _StyledTextField(controller: _contactCtrl, hint: '+91 XXXXX', keyboardType: TextInputType.phone),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _FieldLabel('Urgency Level'),
            const SizedBox(height: 8),
            _UrgencySelector(selected: _urgency, onChanged: (u) => setState(() => _urgency = u)),
            const SizedBox(height: 14),
            _FieldLabel('Additional Notes'),
            const SizedBox(height: 6),
            _StyledTextField(controller: _noteCtrl, hint: 'Any details for potential donors…', maxLines: 3),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(backgroundColor: kRed, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: const Icon(Icons.water_drop_rounded, size: 18),
                label: const Text('Post Blood Need', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Register Donor Sheet ─────────────────────────────────────────────────────
class _RegisterDonorSheet extends StatefulWidget {
  final String myBloodType;
  const _RegisterDonorSheet({required this.myBloodType});

  @override
  State<_RegisterDonorSheet> createState() => _RegisterDonorSheetState();
}

class _RegisterDonorSheetState extends State<_RegisterDonorSheet> {
  final _nameCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  bool _available = true;
  bool _done = false;

  @override
  void dispose() { _nameCtrl.dispose(); _areaCtrl.dispose(); _contactCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
      decoration: const BoxDecoration(color: kCard, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: _done
          ? _buildSuccess('Registered! ❤️', 'You are now listed as a donor.\nPeople who need ${widget.myBloodType} can find you.', true)
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetHandle(),
          _SheetTitle('Register as a Donor'),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(10), border: Border.all(color: kGreenMid.withOpacity(0.5))),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: kGreen, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('Your profile (${widget.myBloodType}) will be visible to people in need. You can update availability anytime.', style: const TextStyle(color: kGreen, fontSize: 11, height: 1.5))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _FieldLabel('Full Name'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _nameCtrl, hint: 'Your name', icon: Icons.person_outline_rounded),
          const SizedBox(height: 14),
          _FieldLabel('Area'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _areaCtrl, hint: 'e.g. Gandhipuram', icon: Icons.location_on_outlined),
          const SizedBox(height: 14),
          _FieldLabel('Contact Number'),
          const SizedBox(height: 6),
          _StyledTextField(controller: _contactCtrl, hint: '+91 XXXXX XXXXX', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: 14),
          _FieldLabel('Availability'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _available = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _available ? kGreenLight : kBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _available ? kGreen : const Color(0xFFEDD5D5), width: _available ? 1.5 : 1),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.circle, size: 8, color: _available ? kGreen : kTextSoft),
                      const SizedBox(width: 6),
                      Text('Available Now', style: TextStyle(color: _available ? kGreen : kTextSoft, fontWeight: FontWeight.w700, fontSize: 12)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _available = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !_available ? kRedLight : kBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: !_available ? kRed : const Color(0xFFEDD5D5), width: !_available ? 1.5 : 1),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.schedule_rounded, size: 12, color: !_available ? kRed : kTextSoft),
                      const SizedBox(width: 6),
                      Text('Unavailable', style: TextStyle(color: !_available ? kRed : kTextSoft, fontWeight: FontWeight.w700, fontSize: 12)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              onPressed: () { HapticFeedback.mediumImpact(); setState(() => _done = true); },
              style: ElevatedButton.styleFrom(backgroundColor: kGreen, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.favorite_rounded, size: 18),
              label: const Text('Register as Donor', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared success state ─────────────────────────────────────────────────────
Widget _buildSuccess(String title, String sub, bool green) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 16),
      Container(
        width: 72, height: 72,
        decoration: BoxDecoration(color: green ? kGreenLight : kGreenLight, shape: BoxShape.circle),
        child: Icon(Icons.check_rounded, color: green ? kGreen : kGreen, size: 36),
      ),
      const SizedBox(height: 20),
      Text(title, style: const TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      Text(sub, textAlign: TextAlign.center, style: const TextStyle(color: kTextSoft, fontSize: 13, height: 1.5)),
      const SizedBox(height: 28),
    ],
  );
}

// ─── Shared small widgets ─────────────────────────────────────────────────────
class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: const Color(0xFFEDD5D5), borderRadius: BorderRadius.circular(2))),
  );
}

class _SheetTitle extends StatelessWidget {
  final String text;
  const _SheetTitle(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(text, style: const TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.w900)),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.2));
}

class _DonorSummaryRow extends StatelessWidget {
  final String emoji, name, sub, bloodType;
  const _DonorSummaryRow({required this.emoji, required this.name, required this.sub, required this.bloodType});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(12)),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 26)),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 14)),
            Text(sub, style: const TextStyle(color: kTextSoft, fontSize: 11)),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(10)),
          child: Text(bloodType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
        ),
      ],
    ),
  );
}

class _CompatNotice extends StatelessWidget {
  final bool compat, isDonor;
  final String myBt, targetBt;
  const _CompatNotice({required this.compat, required this.myBt, required this.targetBt, required this.isDonor});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: compat ? kGreenLight : kOrangeLight,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: compat ? kGreenMid.withOpacity(0.5) : const Color(0xFFFFB300).withOpacity(0.4)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(compat ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded, size: 16, color: compat ? kGreen : kOrange),
        const SizedBox(width: 8),
        Expanded(child: Text(
          compat
              ? isDonor
                  ? 'Your blood type ($myBt) is compatible — you can donate to $targetBt.'
                  : 'Your $myBt is compatible with $targetBt. You can donate to this patient!'
              : 'Your blood type ($myBt) may not directly match $targetBt. You can still reach out.',
          style: TextStyle(color: compat ? kGreen : kOrange, fontSize: 11, fontWeight: FontWeight.w600, height: 1.4),
        )),
      ],
    ),
  );
}

class _UrgencySelector extends StatelessWidget {
  final UrgencyLevel selected;
  final ValueChanged<UrgencyLevel> onChanged;
  const _UrgencySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) => Row(
    children: UrgencyLevel.values.map((u) {
      final sel = selected == u;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(u),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            margin: EdgeInsets.only(right: u != UrgencyLevel.values.last ? 8.0 : 0),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: sel ? u.bgColor : kBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: sel ? u.color : const Color(0xFFEDD5D5), width: sel ? 2 : 1),
            ),
            child: Text(u.label, textAlign: TextAlign.center, style: TextStyle(color: sel ? u.color : kTextSoft, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ),
      );
    }).toList(),
  );
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final int maxLines;
  final TextInputType? keyboardType;

  const _StyledTextField({required this.controller, required this.hint, this.icon, this.maxLines = 1, this.keyboardType});

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    maxLines: maxLines,
    keyboardType: keyboardType,
    style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: kTextSoft.withOpacity(0.5), fontSize: 13),
      prefixIcon: icon != null ? Icon(icon, size: 18, color: kTextSoft) : null,
      filled: true,
      fillColor: kBg,
      contentPadding: EdgeInsets.symmetric(horizontal: icon != null ? 0 : 14, vertical: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEDD5D5))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEDD5D5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kRed, width: 1.8)),
    ),
  );
}

class _DistBadge extends StatelessWidget {
  final double dist;
  const _DistBadge({required this.dist});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: kBg, borderRadius: BorderRadius.circular(6)),
    child: Text('$dist km', style: const TextStyle(color: kTextSoft, fontSize: 10, fontWeight: FontWeight.w700)),
  );
}

class _CompatBadge extends StatelessWidget {
  final String text;
  const _CompatBadge({required this.text});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(6)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_outline_rounded, size: 10, color: kGreen),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: kGreen, fontSize: 9, fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class _AvailPill extends StatelessWidget {
  final bool available;
  const _AvailPill({required this.available});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: available ? kGreenLight : const Color(0xFFFCE4EC),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: available ? kGreenMid.withOpacity(0.4) : const Color(0xFFEC407A).withOpacity(0.4)),
    ),
    child: Row(
      children: [
        Icon(Icons.circle, size: 7, color: available ? kGreen : const Color(0xFFC62828)),
        const SizedBox(width: 5),
        Text(available ? 'Available' : 'Unavailable', style: TextStyle(color: available ? kGreen : const Color(0xFFC62828), fontWeight: FontWeight.w700, fontSize: 11)),
      ],
    ),
  );
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _StatItem({required this.icon, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Flexible(child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11), overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: kTextSoft.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 28, color: const Color(0xFFF0E0E0), margin: const EdgeInsets.symmetric(horizontal: 4));
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({required this.icon, required this.label, required this.filled, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? kRed;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: filled ? c : Colors.transparent, borderRadius: BorderRadius.circular(10), border: Border.all(color: c, width: 1.5)),
        child: Row(
          children: [
            Icon(icon, size: 14, color: filled ? Colors.white : c),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(color: filled ? Colors.white : c, fontWeight: FontWeight.w800, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _BigSwitch extends StatelessWidget {
  final bool value;
  final Color activeColor;
  const _BigSwitch({required this.value, required this.activeColor});
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 220),
    width: 44, height: 24,
    decoration: BoxDecoration(color: value ? activeColor : const Color(0xFFCCBBBB), borderRadius: BorderRadius.circular(12)),
    child: AnimatedAlign(
      duration: const Duration(milliseconds: 220),
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(width: 20, height: 20, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
    ),
  );
}

class _MiniSwitch extends StatelessWidget {
  final bool value;
  const _MiniSwitch({required this.value});
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: 28, height: 16,
    decoration: BoxDecoration(color: value ? kRed : const Color(0xFFCCBBBB), borderRadius: BorderRadius.circular(8)),
    child: AnimatedAlign(
      duration: const Duration(milliseconds: 200),
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(width: 12, height: 12, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
    ),
  );
}
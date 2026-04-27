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
const kBlue = Color(0xFF1565C0);
const kBlueLight = Color(0xFFE3F2FD);
const kCard = Color(0xFFFFFFFF);
const kText = Color(0xFF1A0A0A);
const kTextSoft = Color(0xFF7B5B5B);
const kBg = Color(0xFFF7F2F2);

// ─── Models ───────────────────────────────────────────────────────────────────
enum DonationStatus { completed, scheduled, cancelled }

extension DonationStatusExt on DonationStatus {
  String get label =>
      name[0].toUpperCase() + name.substring(1);

  Color get color => this == DonationStatus.completed
      ? kGreen
      : this == DonationStatus.scheduled
          ? kBlue
          : kTextSoft;

  Color get bgColor => this == DonationStatus.completed
      ? kGreenLight
      : this == DonationStatus.scheduled
          ? kBlueLight
          : const Color(0xFFF7F2F2);

  IconData get icon => this == DonationStatus.completed
      ? Icons.check_circle_rounded
      : this == DonationStatus.scheduled
          ? Icons.schedule_rounded
          : Icons.cancel_rounded;
}

class DonationRecord {
  final String id;
  final String date;
  final String hospital;
  final String area;
  final String bloodType;
  final double unitsDonated;
  final DonationStatus status;
  final String recipientNote;
  final String certificateId;
  final int livesSaved;

  const DonationRecord({
    required this.id,
    required this.date,
    required this.hospital,
    required this.area,
    required this.bloodType,
    required this.unitsDonated,
    required this.status,
    required this.recipientNote,
    required this.certificateId,
    required this.livesSaved,
  });
}

class DonorProfile {
  final String name;
  final String bloodType;
  final String area;
  final String contact;
  final bool available;
  final DateTime registeredOn;

  const DonorProfile({
    required this.name,
    required this.bloodType,
    required this.area,
    required this.contact,
    required this.available,
    required this.registeredOn,
  });
}

// ─── Mock Data ────────────────────────────────────────────────────────────────
final List<DonationRecord> kDonationHistory = [
  const DonationRecord(
    id: 'd1',
    date: '15 Jan 2025',
    hospital: 'Coimbatore Medical College',
    area: 'Peelamedu',
    bloodType: 'O+',
    unitsDonated: 1,
    status: DonationStatus.completed,
    recipientNote: 'Donated to an accident victim. Lives saved: 3.',
    certificateId: 'BL-2025-0115',
    livesSaved: 3,
  ),
  const DonationRecord(
    id: 'd2',
    date: '10 Oct 2024',
    hospital: 'PSG Hospitals',
    area: 'Peelamedu',
    bloodType: 'O+',
    unitsDonated: 1,
    status: DonationStatus.completed,
    recipientNote: 'Used for a surgery patient. Smooth donation experience.',
    certificateId: 'BL-2024-1010',
    livesSaved: 3,
  ),
  const DonationRecord(
    id: 'd3',
    date: '02 Jul 2024',
    hospital: 'KMCH',
    area: 'Avanashi Road',
    bloodType: 'O+',
    unitsDonated: 1,
    status: DonationStatus.completed,
    recipientNote: 'Matched with a thalassemia patient.',
    certificateId: 'BL-2024-0702',
    livesSaved: 3,
  ),
  const DonationRecord(
    id: 'd4',
    date: '20 Mar 2024',
    hospital: 'GEM Hospital',
    area: 'RS Puram',
    bloodType: 'O+',
    unitsDonated: 1,
    status: DonationStatus.completed,
    recipientNote: 'Emergency donation for a road accident case.',
    certificateId: 'BL-2024-0320',
    livesSaved: 3,
  ),
  const DonationRecord(
    id: 'd5',
    date: '05 Nov 2023',
    hospital: 'Lakshmi Hospital',
    area: 'Gandhipuram',
    bloodType: 'O+',
    unitsDonated: 1,
    status: DonationStatus.completed,
    recipientNote: 'Donated at blood drive camp. Recipient not disclosed.',
    certificateId: 'BL-2023-1105',
    livesSaved: 3,
  ),
  const DonationRecord(
    id: 'd6',
    date: '12 Jun 2023',
    hospital: 'Lions Club Blood Drive',
    area: 'Gandhipuram',
    bloodType: 'O+',
    unitsDonated: 1,
    status: DonationStatus.completed,
    recipientNote: 'Camp donation — distributed to 3 patients.',
    certificateId: 'BL-2023-0612',
    livesSaved: 3,
  ),
  const DonationRecord(
    id: 'd7',
    date: '28 Feb 2023',
    hospital: 'RSM Medical Camp',
    area: 'RS Puram',
    bloodType: 'O+',
    unitsDonated: 1,
    status: DonationStatus.completed,
    recipientNote: 'Anonymous donation. Tested & cleared.',
    certificateId: 'BL-2023-0228',
    livesSaved: 3,
  ),
  const DonationRecord(
    id: 'd8',
    date: '26 Apr 2025',
    hospital: 'Coimbatore Medical College',
    area: 'Peelamedu',
    bloodType: 'O+',
    unitsDonated: 1,
    status: DonationStatus.scheduled,
    recipientNote: 'Scheduled for an upcoming surgery patient.',
    certificateId: '',
    livesSaved: 0,
  ),
];

// ─── Page ─────────────────────────────────────────────────────────────────────
class DonationHistoryPage extends StatefulWidget {
  /// Pass null if the user has NOT registered as a donor yet.
  /// Pass a [DonorProfile] if they have.
  final DonorProfile? donorProfile;

  /// Called when the user registers or updates their donor status from this page.
  final void Function(DonorProfile profile)? onDonorRegistered;

  const DonationHistoryPage({
    super.key,
    this.donorProfile,
    this.onDonorRegistered,
  });

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  DonorProfile? _profile;
  DonationStatus? _filterStatus;
  String _sortBy = 'Newest';

  static const _sorts = ['Newest', 'Oldest'];

  @override
  void initState() {
    super.initState();
    _profile = widget.donorProfile;
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<DonationRecord> get _filtered {
    var list = List<DonationRecord>.from(kDonationHistory);
    if (_filterStatus != null) {
      list = list.where((d) => d.status == _filterStatus).toList();
    }
    if (_sortBy == 'Newest') {
      list = list.reversed.toList();
    }
    return list;
  }

  int get _totalCompleted =>
      kDonationHistory.where((d) => d.status == DonationStatus.completed).length;
  int get _totalLivesSaved => _totalCompleted * 3;
  int get _scheduled =>
      kDonationHistory.where((d) => d.status == DonationStatus.scheduled).length;

  void _openRegisterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RegisterDonorSheet(
        existing: _profile,
        onSaved: (p) {
          setState(() => _profile = p);
          widget.onDonorRegistered?.call(p);
        },
      ),
    );
  }

  void _openCertificate(DonationRecord d) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CertificateSheet(record: d),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          _buildSliverHeader(),
        ],
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _buildHistoryTab(),
                  _buildDonorStatusTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sliver Header ─────────────────────────────────────────────────────────
  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 220,
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
              width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Text('Donation History', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
            child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A0000), Color(0xFFB71C1C), Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -30, right: -30, child: _DecorCircle(size: 160, opacity: 0.07)),
          Positioned(top: 40, right: 80, child: _DecorCircle(size: 80, opacity: 0.05)),
          Positioned(bottom: -20, left: -20, child: _DecorCircle(size: 120, opacity: 0.06)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary stats
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        _HeaderStat('$_totalCompleted', 'Donations\nCompleted'),
                        _HeaderDiv(),
                        _HeaderStat('$_totalLivesSaved', 'Lives\nImpacted'),
                        _HeaderDiv(),
                        _HeaderStat('$_scheduled', 'Upcoming\nScheduled'),
                        _HeaderDiv(),
                        _HeaderStat(
                          _profile != null ? '✓' : '—',
                          'Donor\nStatus',
                          accent: _profile != null ? const Color(0xFF66BB6A) : null,
                        ),
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

  // ── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabCtrl,
        labelColor: kRed,
        unselectedLabelColor: kTextSoft,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        indicatorColor: kRed,
        indicatorWeight: 2.5,
        tabs: const [
          Tab(text: 'Donation History'),
          Tab(text: 'My Donor Status'),
        ],
      ),
    );
  }

  // ── History Tab ───────────────────────────────────────────────────────────
  Widget _buildHistoryTab() {
    final records = _filtered;
    return Column(
      children: [
        _buildFilterSortBar(),
        Expanded(
          child: records.isEmpty
              ? _buildEmptyState('📋', 'No donations yet', 'Your donation history will appear here.')
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _DonationCard(
                    record: records[i],
                    index: i,
                    onViewCertificate: records[i].status == DonationStatus.completed
                        ? () => _openCertificate(records[i])
                        : null,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterSortBar() {
    return Container(
      color: kBg,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          // Filter chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _filterStatus == null,
                    onTap: () => setState(() => _filterStatus = null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Completed',
                    selected: _filterStatus == DonationStatus.completed,
                    color: kGreen,
                    onTap: () => setState(() => _filterStatus = _filterStatus == DonationStatus.completed ? null : DonationStatus.completed),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Scheduled',
                    selected: _filterStatus == DonationStatus.scheduled,
                    color: kBlue,
                    onTap: () => setState(() => _filterStatus = _filterStatus == DonationStatus.scheduled ? null : DonationStatus.scheduled),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Sort
          GestureDetector(
            onTap: () => setState(() => _sortBy = _sortBy == 'Newest' ? 'Oldest' : 'Newest'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFEDD5D5))),
              child: Row(
                children: [
                  const Icon(Icons.swap_vert_rounded, size: 14, color: kTextSoft),
                  const SizedBox(width: 4),
                  Text(_sortBy, style: const TextStyle(color: kTextSoft, fontWeight: FontWeight.w700, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Donor Status Tab ──────────────────────────────────────────────────────
  Widget _buildDonorStatusTab() {
    if (_profile == null) {
      return _buildNotRegisteredState();
    }
    return _buildRegisteredState();
  }

  Widget _buildNotRegisteredState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(color: kRedLight, shape: BoxShape.circle),
            child: const Icon(Icons.volunteer_activism_rounded, color: kRed, size: 40),
          ),
          const SizedBox(height: 20),
          const Text('Not Registered as Donor', style: TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            'Register to appear in the donor directory.\nPeople who need your blood type can find and contact you.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kTextSoft.withOpacity(0.8), fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 28),
          // Benefits
          _BenefitRow(icon: Icons.search_rounded, color: kBlue, title: 'Be Discoverable', sub: 'Appear when someone searches for your blood type'),
          const SizedBox(height: 12),
          _BenefitRow(icon: Icons.notifications_rounded, color: kOrange, title: 'Get Alerts', sub: 'Receive urgent requests near you instantly'),
          const SizedBox(height: 12),
          _BenefitRow(icon: Icons.star_rounded, color: const Color(0xFFF57F17), title: 'Earn Badges', sub: 'Unlock achievements for each donation you complete'),
          const SizedBox(height: 12),
          _BenefitRow(icon: Icons.privacy_tip_rounded, color: kGreen, title: 'Full Control', sub: 'Toggle availability anytime, remove yourself anytime'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton.icon(
              onPressed: _openRegisterSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed, foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.favorite_rounded, size: 18),
              label: const Text('Register as a Donor', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisteredState() {
    final p = _profile!;
    final daysSince = DateTime.now().difference(p.registeredOn).inDays;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _buildStatusCard(p, daysSince),
          const SizedBox(height: 20),
          // Profile details
          _buildSectionLabel('📋 Your Donor Profile'),
          const SizedBox(height: 12),
          _buildProfileCard(p),
          const SizedBox(height: 20),
          // Visibility stats
          _buildSectionLabel('📊 Your Reach'),
          const SizedBox(height: 12),
          _buildReachCard(),
          const SizedBox(height: 20),
          // Actions
          _buildSectionLabel('⚙️ Manage'),
          const SizedBox(height: 12),
          _buildManageCard(p),
        ],
      ),
    );
  }

  Widget _buildStatusCard(DonorProfile p, int daysSince) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: p.available
              ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32), const Color(0xFF388E3C)]
              : [const Color(0xFF4A4A4A), const Color(0xFF616161)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: (p.available ? kGreen : Colors.grey).withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          Positioned(top: -20, right: -20, child: _DecorCircle(size: 110, opacity: 0.12)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                    child: const Center(child: Text('👤', style: TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.water_drop_rounded, size: 12, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(p.bloodType, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 10),
                            const Icon(Icons.location_on_rounded, size: 12, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(p.area, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 7, color: p.available ? const Color(0xFF66BB6A) : Colors.white38),
                        const SizedBox(width: 5),
                        Text(p.available ? 'Active' : 'Inactive', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 14),
              Row(
                children: [
                  _StatusStat('$_totalCompleted', 'Donations'),
                  _StatusStat('$_totalLivesSaved', 'Lives\nSaved'),
                  _StatusStat('$daysSince days', 'Active\nDuration'),
                  _StatusStat(p.available ? 'Yes' : 'No', 'Accepting\nRequests'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(DonorProfile p) {
    return Container(
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          _ProfileRow(icon: Icons.person_rounded, color: kBlue, label: 'Name', value: p.name),
          const Divider(color: Color(0xFFF0E0E0), height: 1, indent: 56, endIndent: 16),
          _ProfileRow(icon: Icons.water_drop_rounded, color: kRed, label: 'Blood Type', value: p.bloodType),
          const Divider(color: Color(0xFFF0E0E0), height: 1, indent: 56, endIndent: 16),
          _ProfileRow(icon: Icons.location_on_rounded, color: kOrange, label: 'Area', value: p.area),
          const Divider(color: Color(0xFFF0E0E0), height: 1, indent: 56, endIndent: 16),
          _ProfileRow(icon: Icons.phone_rounded, color: kGreen, label: 'Contact', value: p.contact.isEmpty ? 'Not set' : p.contact),
          const Divider(color: Color(0xFFF0E0E0), height: 1, indent: 56, endIndent: 16),
          _ProfileRow(
            icon: Icons.calendar_today_rounded, color: kTextSoft,
            label: 'Registered', value: '${p.registeredOn.day}/${p.registeredOn.month}/${p.registeredOn.year}',
          ),
        ],
      ),
    );
  }

  Widget _buildReachCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          Row(
            children: [
              _ReachStat(value: '12', label: 'Times\nViewed', color: kBlue),
              _ReachDiv(),
              _ReachStat(value: '4', label: 'Requests\nReceived', color: kOrange),
              _ReachDiv(),
              _ReachStat(value: '3', label: 'Donations\nCompleted', color: kGreen),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF0E0E0), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 13, color: kTextSoft),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Your profile is visible to people searching for ${_profile!.bloodType} donors in your area.',
                  style: TextStyle(color: kTextSoft.withOpacity(0.8), fontSize: 11, height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManageCard(DonorProfile p) {
    return Container(
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          _ManageRow(
            icon: p.available ? Icons.pause_circle_rounded : Icons.play_circle_rounded,
            color: p.available ? kOrange : kGreen,
            label: p.available ? 'Pause Donations' : 'Resume Donations',
            sub: p.available ? 'Temporarily hide yourself from search results' : 'Make yourself discoverable again',
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _profile = DonorProfile(
                  name: p.name, bloodType: p.bloodType, area: p.area,
                  contact: p.contact, available: !p.available, registeredOn: p.registeredOn,
                );
              });
              widget.onDonorRegistered?.call(_profile!);
            },
          ),
          const Divider(color: Color(0xFFF0E0E0), height: 1, indent: 56, endIndent: 16),
          _ManageRow(
            icon: Icons.edit_rounded,
            color: kBlue,
            label: 'Edit Donor Profile',
            sub: 'Update area, contact, or blood type',
            onTap: _openRegisterSheet,
          ),
          const Divider(color: Color(0xFFF0E0E0), height: 1, indent: 56, endIndent: 16),
          _ManageRow(
            icon: Icons.share_rounded,
            color: const Color(0xFF6A1B9A),
            label: 'Share My Donor Card',
            sub: 'Let friends know you are a donor',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Donor card link copied!'),
                  backgroundColor: kRedDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
          const Divider(color: Color(0xFFF0E0E0), height: 1, indent: 56, endIndent: 16),
          _ManageRow(
            icon: Icons.delete_outline_rounded,
            color: kRed,
            label: 'Remove from Donor List',
            sub: 'You will no longer appear in searches',
            onTap: () => _confirmRemove(),
          ),
        ],
      ),
    );
  }

  void _confirmRemove() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove from Donor List?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
        content: const Text('You will no longer be visible to people looking for blood. You can re-register anytime.', style: TextStyle(height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _profile = null);
            },
            style: ElevatedButton.styleFrom(backgroundColor: kRed, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Remove', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) => Text(text, style: const TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.2));

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
}

// ─── Donation Card ────────────────────────────────────────────────────────────
class _DonationCard extends StatefulWidget {
  final DonationRecord record;
  final int index;
  final VoidCallback? onViewCertificate;

  const _DonationCard({required this.record, required this.index, this.onViewCertificate});

  @override
  State<_DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<_DonationCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _scale;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 350 + widget.index * 50));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.94, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    Future.delayed(Duration(milliseconds: widget.index * 55), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = widget.record;
    final isScheduled = r.status == DonationStatus.scheduled;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(16),
            border: isScheduled ? Border.all(color: const Color(0xFF90CAF9), width: 1.5) : null,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              // Main row
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date column
                    _DateColumn(date: r.date),
                    const SizedBox(width: 14),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(r.hospital, style: const TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 14), overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              _StatusPill(status: r.status),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, size: 11, color: kTextSoft),
                              const SizedBox(width: 2),
                              Text(r.area, style: const TextStyle(color: kTextSoft, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _InfoChip(Icons.water_drop_rounded, r.bloodType, kRed),
                              const SizedBox(width: 8),
                              _InfoChip(Icons.science_rounded, '${r.unitsDonated} unit', kTextSoft),
                              if (r.livesSaved > 0) ...[
                                const SizedBox(width: 8),
                                _InfoChip(Icons.favorite_rounded, '≈${r.livesSaved} lives', kGreen),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Expand button
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFF0E0E0), width: 1))),
                  child: Row(
                    children: [
                      Icon(Icons.expand_more_rounded, size: 16, color: kTextSoft.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(_expanded ? 'Show less' : 'Show details', style: TextStyle(color: kTextSoft.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      if (widget.onViewCertificate != null)
                        GestureDetector(
                          onTap: widget.onViewCertificate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: kRedLight, borderRadius: BorderRadius.circular(8)),
                            child: const Row(
                              children: [
                                Icon(Icons.workspace_premium_rounded, size: 12, color: kRed),
                                SizedBox(width: 4),
                                Text('Certificate', style: TextStyle(color: kRed, fontSize: 11, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Expanded details
              AnimatedSize(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                        decoration: BoxDecoration(
                          color: kBg,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (r.recipientNote.isNotEmpty) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.notes_rounded, size: 13, color: kTextSoft),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text(r.recipientNote, style: TextStyle(color: kTextSoft.withOpacity(0.85), fontSize: 12, height: 1.5))),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                            if (r.certificateId.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.tag_rounded, size: 13, color: kTextSoft),
                                  const SizedBox(width: 6),
                                  Text('Certificate ID: ', style: TextStyle(color: kTextSoft.withOpacity(0.7), fontSize: 11)),
                                  Text(r.certificateId, style: const TextStyle(color: kText, fontSize: 11, fontWeight: FontWeight.w700)),
                                ],
                              ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Certificate Sheet ────────────────────────────────────────────────────────
class _CertificateSheet extends StatelessWidget {
  final DonationRecord record;
  const _CertificateSheet({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      decoration: const BoxDecoration(color: kCard, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFEDD5D5), borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          // Certificate body
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF8B0000), Color(0xFFD32F2F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: kRed.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 8))],
            ),
            child: Stack(
              children: [
                Positioned(top: -15, right: -15, child: _DecorCircle(size: 100, opacity: 0.12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        const Text('DONATION CERTIFICATE', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 2)),
                        const Spacer(),
                        Text(record.certificateId, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text('This certifies that', style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('Arjun Krishnan', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
                    const SizedBox(height: 12),
                    Text('successfully donated', style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                          child: Text(record.bloodType, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 10),
                        Text('blood on', style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 13)),
                        const SizedBox(width: 6),
                        Text(record.date, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.local_hospital_rounded, size: 13, color: Colors.white60),
                        const SizedBox(width: 6),
                        Text('${record.hospital}, ${record.area}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.favorite_rounded, size: 14, color: Colors.white60),
                        const SizedBox(width: 6),
                        Text('≈ ${record.livesSaved} lives potentially saved', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Certificate downloaded!'), backgroundColor: kRedDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
                  },
                  style: OutlinedButton.styleFrom(foregroundColor: kRed, side: const BorderSide(color: kRed, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 13)),
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('Download', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Certificate shared!'), backgroundColor: kRedDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: kRed, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 13)),
                  icon: const Icon(Icons.share_rounded, size: 16),
                  label: const Text('Share', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Register Donor Sheet ─────────────────────────────────────────────────────
class _RegisterDonorSheet extends StatefulWidget {
  final DonorProfile? existing;
  final void Function(DonorProfile profile) onSaved;
  const _RegisterDonorSheet({this.existing, required this.onSaved});

  @override
  State<_RegisterDonorSheet> createState() => _RegisterDonorSheetState();
}

class _RegisterDonorSheetState extends State<_RegisterDonorSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _areaCtrl;
  late TextEditingController _contactCtrl;
  String _bloodType = 'O+';
  bool _available = true;
  bool _done = false;

  static const _bts = ['A+', 'A−', 'B+', 'B−', 'O+', 'O−', 'AB+', 'AB−'];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _areaCtrl = TextEditingController(text: e?.area ?? '');
    _contactCtrl = TextEditingController(text: e?.contact ?? '');
    _bloodType = e?.bloodType ?? 'O+';
    _available = e?.available ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _areaCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  void _save() {
    HapticFeedback.mediumImpact();
    final profile = DonorProfile(
      name: _nameCtrl.text.trim().isEmpty ? 'Anonymous Donor' : _nameCtrl.text.trim(),
      bloodType: _bloodType,
      area: _areaCtrl.text.trim().isEmpty ? 'Coimbatore' : _areaCtrl.text.trim(),
      contact: _contactCtrl.text.trim(),
      available: _available,
      registeredOn: widget.existing?.registeredOn ?? DateTime.now(),
    );
    widget.onSaved(profile);
    setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 40),
      decoration: const BoxDecoration(color: kCard, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: _done ? _buildDone() : _buildForm(),
    );
  }

  Widget _buildDone() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Container(
          width: 72, height: 72,
          decoration: const BoxDecoration(color: kGreenLight, shape: BoxShape.circle),
          child: const Icon(Icons.favorite_rounded, color: kGreen, size: 36),
        ),
        const SizedBox(height: 20),
        Text(widget.existing != null ? 'Profile Updated!' : 'Registered!', style: const TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(
          widget.existing != null
              ? 'Your donor profile has been updated.'
              : 'You are now listed as a donor.\nPeople searching for $_bloodType can find you.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: kTextSoft, fontSize: 13, height: 1.6),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity, height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: kGreen, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: const Color(0xFFEDD5D5), borderRadius: BorderRadius.circular(2)))),
          Text(widget.existing != null ? 'Edit Donor Profile' : 'Register as a Donor', style: const TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(widget.existing != null ? 'Update your donor details below.' : 'Your profile will be visible to people in need.', style: TextStyle(color: kTextSoft.withOpacity(0.8), fontSize: 12)),
          const SizedBox(height: 18),
          _FLabel('Full Name'),
          const SizedBox(height: 6),
          _FField(controller: _nameCtrl, hint: 'Your full name', icon: Icons.person_outline_rounded),
          const SizedBox(height: 14),
          _FLabel('Blood Type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _bts.map((bt) {
              final sel = _bloodType == bt;
              return GestureDetector(
                onTap: () => setState(() => _bloodType = bt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: sel ? kRed : kBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: sel ? kRed : const Color(0xFFEDD5D5), width: 1.5),
                  ),
                  child: Text(bt, style: TextStyle(color: sel ? Colors.white : kTextSoft, fontWeight: FontWeight.w800, fontSize: 13)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          _FLabel('Area'),
          const SizedBox(height: 6),
          _FField(controller: _areaCtrl, hint: 'e.g. Gandhipuram, Coimbatore', icon: Icons.location_on_outlined),
          const SizedBox(height: 14),
          _FLabel('Contact Number'),
          const SizedBox(height: 6),
          _FField(controller: _contactCtrl, hint: '+91 XXXXX XXXXX', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: 14),
          _FLabel('Availability'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _available = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _available ? kGreenLight : kBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _available ? kGreen : const Color(0xFFEDD5D5), width: _available ? 1.5 : 1),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.circle, size: 8, color: _available ? kGreen : kTextSoft),
                      const SizedBox(width: 6),
                      Text('Available', style: TextStyle(color: _available ? kGreen : kTextSoft, fontWeight: FontWeight.w700, fontSize: 12)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _available = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
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
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.existing != null ? kBlue : kGreen,
                foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: Icon(widget.existing != null ? Icons.save_rounded : Icons.favorite_rounded, size: 18),
              label: Text(widget.existing != null ? 'Save Changes' : 'Register as Donor', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class _FLabel extends StatelessWidget {
  final String text;
  const _FLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.2));
}

class _FField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  const _FField({required this.controller, required this.hint, required this.icon, this.keyboardType});

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: kTextSoft.withOpacity(0.5), fontSize: 13),
      prefixIcon: Icon(icon, size: 18, color: kTextSoft),
      filled: true, fillColor: kBg,
      contentPadding: const EdgeInsets.symmetric(vertical: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEDD5D5))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEDD5D5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kRed, width: 1.8)),
    ),
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? kRed;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? c.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? c : const Color(0xFFEDD5D5), width: 1.5),
        ),
        child: Text(label, style: TextStyle(color: selected ? c : kTextSoft, fontWeight: FontWeight.w700, fontSize: 12)),
      ),
    );
  }
}

class _DateColumn extends StatelessWidget {
  final String date;
  const _DateColumn({required this.date});

  @override
  Widget build(BuildContext context) {
    final parts = date.split(' ');
    final day = parts.isNotEmpty ? parts[0] : '';
    final monthYear = parts.length >= 3 ? '${parts[1]}\n${parts[2]}' : '';
    return Container(
      width: 46,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: kRedLight, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(day, style: const TextStyle(color: kRed, fontWeight: FontWeight.w900, fontSize: 16, height: 1)),
          Text(monthYear, textAlign: TextAlign.center, style: const TextStyle(color: kRed, fontSize: 9, fontWeight: FontWeight.w600, height: 1.3)),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final DonationStatus status;
  const _StatusPill({required this.status});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: status.bgColor, borderRadius: BorderRadius.circular(8)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status.icon, size: 10, color: status.color),
        const SizedBox(width: 4),
        Text(status.label, style: TextStyle(color: status.color, fontSize: 10, fontWeight: FontWeight.w800)),
      ],
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(this.icon, this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value;
  const _ProfileRow({required this.icon, required this.color, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 17, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: kText, fontWeight: FontWeight.w700, fontSize: 13))),
        Text(value, style: const TextStyle(color: kTextSoft, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _ManageRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, sub;
  final VoidCallback onTap;
  const _ManageRow({required this.icon, required this.color, required this.label, required this.sub, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: label.contains('Remove') ? kRed : kText, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 2),
              Text(sub, style: TextStyle(color: kTextSoft.withOpacity(0.7), fontSize: 11)),
            ],
          )),
          Icon(Icons.chevron_right_rounded, color: kTextSoft.withOpacity(0.4), size: 20),
        ],
      ),
    ),
  );
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, sub;
  const _BenefitRow({required this.icon, required this.color, required this.title, required this.sub});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))]),
    child: Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(11)),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: kText, fontWeight: FontWeight.w800, fontSize: 13)),
            const SizedBox(height: 2),
            Text(sub, style: TextStyle(color: kTextSoft.withOpacity(0.8), fontSize: 11, height: 1.4)),
          ],
        )),
      ],
    ),
  );
}

class _HeaderStat extends StatelessWidget {
  final String value, label;
  final Color? accent;
  const _HeaderStat(this.value, this.label, {this.accent});
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: TextStyle(color: accent ?? Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1)),
    const SizedBox(height: 3),
    Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.w600, height: 1.3)),
  ]));
}

class _HeaderDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 30, color: Colors.white.withOpacity(0.18), margin: const EdgeInsets.symmetric(horizontal: 4));
}

class _StatusStat extends StatelessWidget {
  final String value, label;
  const _StatusStat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, height: 1)),
    const SizedBox(height: 3),
    Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.w600, height: 1.3)),
  ]));
}

class _ReachStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _ReachStat({required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900, height: 1)),
    const SizedBox(height: 4),
    Text(label, textAlign: TextAlign.center, style: TextStyle(color: kTextSoft.withOpacity(0.8), fontSize: 10, height: 1.3)),
  ]));
}

class _ReachDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 32, color: const Color(0xFFF0E0E0), margin: const EdgeInsets.symmetric(horizontal: 4));
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const _DecorCircle({required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(opacity), width: 1.5)),
  );
}
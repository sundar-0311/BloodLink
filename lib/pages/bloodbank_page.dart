import 'package:flutter/material.dart';

const _kRed = Color(0xFFD32F2F);
const _kRedDark = Color(0xFF8B0000);
const _kRedLight = Color(0xFFFFCDD2);
const _kCard = Color(0xFFFFFFFF);
const _kBg = Color(0xFFF7F2F2);
const _kText = Color(0xFF1A0A0A);
const _kTextSoft = Color(0xFF7B5B5B);

class BloodBank {
  final String id;
  final String name;
  final String address;
  final String city;
  final double distance;
  final String phone;
  final String timings;
  final bool isOpen;
  final bool is24x7;
  final double rating;
  final int reviewCount;
  final Map<String, String> availability;
  final String type;
  final bool hasHomeDelivery;
  final bool acceptsWalkIn;

  const BloodBank({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.distance,
    required this.phone,
    required this.timings,
    required this.isOpen,
    required this.is24x7,
    required this.rating,
    required this.reviewCount,
    required this.availability,
    required this.type,
    required this.hasHomeDelivery,
    required this.acceptsWalkIn,
  });
}

const List<BloodBank> kBloodBanks = [
  BloodBank(
    id: '1',
    name: 'Coimbatore Medical College Blood Bank',
    address: 'Coimbatore Medical College, Avinashi Road',
    city: 'Coimbatore',
    distance: 1.2,
    phone: '0422-2301393',
    timings: '8:00 AM – 8:00 PM',
    isOpen: true,
    is24x7: false,
    rating: 4.3,
    reviewCount: 128,
    availability: {
      'A+': 'available',
      'A−': 'low',
      'B+': 'available',
      'B−': 'unavailable',
      'O+': 'available',
      'O−': 'low',
      'AB+': 'available',
      'AB−': 'unavailable',
    },
    type: 'Government',
    hasHomeDelivery: false,
    acceptsWalkIn: true,
  ),
  BloodBank(
    id: '2',
    name: 'G.Kuppuswamy Naidu Memorial Blood Bank',
    address: 'Pappanaickenpalayam, Near Bus Stand',
    city: 'Coimbatore',
    distance: 2.8,
    phone: '0422-4303090',
    timings: '24 × 7',
    isOpen: true,
    is24x7: true,
    rating: 4.6,
    reviewCount: 214,
    availability: {
      'A+': 'available',
      'A−': 'available',
      'B+': 'low',
      'B−': 'available',
      'O+': 'available',
      'O−': 'available',
      'AB+': 'low',
      'AB−': 'available',
    },
    type: 'Private',
    hasHomeDelivery: true,
    acceptsWalkIn: true,
  ),
  BloodBank(
    id: '3',
    name: 'PSG Hospitals Blood Bank',
    address: 'Peelamedu, Avinashi Road',
    city: 'Coimbatore',
    distance: 4.1,
    phone: '0422-4345678',
    timings: '9:00 AM – 6:00 PM',
    isOpen: false,
    is24x7: false,
    rating: 4.1,
    reviewCount: 87,
    availability: {
      'A+': 'available',
      'A−': 'unavailable',
      'B+': 'available',
      'B−': 'low',
      'O+': 'low',
      'O−': 'unavailable',
      'AB+': 'available',
      'AB−': 'unavailable',
    },
    type: 'Private',
    hasHomeDelivery: false,
    acceptsWalkIn: true,
  ),
  BloodBank(
    id: '4',
    name: 'Red Cross Society Blood Bank',
    address: 'Race Course Road, Coimbatore',
    city: 'Coimbatore',
    distance: 3.5,
    phone: '0422-2393333',
    timings: '8:00 AM – 5:00 PM',
    isOpen: true,
    is24x7: false,
    rating: 4.4,
    reviewCount: 162,
    availability: {
      'A+': 'available',
      'A−': 'available',
      'B+': 'available',
      'B−': 'available',
      'O+': 'available',
      'O−': 'low',
      'AB+': 'available',
      'AB−': 'available',
    },
    type: 'NGO',
    hasHomeDelivery: true,
    acceptsWalkIn: true,
  ),
  BloodBank(
    id: '5',
    name: 'Sri Ramakrishna Hospital Blood Bank',
    address: 'Sidhapudur, Coimbatore',
    city: 'Coimbatore',
    distance: 5.6,
    phone: '0422-4500000',
    timings: '24 × 7',
    isOpen: true,
    is24x7: true,
    rating: 4.7,
    reviewCount: 305,
    availability: {
      'A+': 'available',
      'A−': 'available',
      'B+': 'available',
      'B−': 'available',
      'O+': 'low',
      'O−': 'available',
      'AB+': 'available',
      'AB−': 'low',
    },
    type: 'Private',
    hasHomeDelivery: true,
    acceptsWalkIn: true,
  ),
];

class BloodBankPage extends StatefulWidget {
  const BloodBankPage({super.key});

  @override
  State<BloodBankPage> createState() => _BloodBankPageState();
}

class _BloodBankPageState extends State<BloodBankPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedType = 'All';
  String _selectedBloodType = 'Any';
  bool _onlyOpen = false;
  bool _only24x7 = false;
  late TabController _tabController;

  final List<String> _typeFilters = ['All', 'Government', 'Private', 'NGO'];
  final List<String> _bloodTypes = [
    'Any', 'A+', 'A−', 'B+', 'B−', 'O+', 'O−', 'AB+', 'AB−'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<BloodBank> get _filteredBanks {
    return kBloodBanks.where((bank) {
      if (_searchQuery.isNotEmpty &&
          !bank.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !bank.address.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedType != 'All' && bank.type != _selectedType) return false;
      if (_onlyOpen && !bank.isOpen) return false;
      if (_only24x7 && !bank.is24x7) return false;
      if (_selectedBloodType != 'Any') {
        final status = bank.availability[_selectedBloodType];
        if (status == null || status == 'unavailable') return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(innerBoxIsScrolled),
        ],
        body: Column(
          children: [
            _buildFilters(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildListView(),
                  _buildMapPlaceholder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool collapsed) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      stretch: true,
      backgroundColor: _kRedDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: collapsed
          ? const Text(
              'Blood Banks',
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
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.07), width: 1.5),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.06), width: 1.5),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
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
                            child: const Icon(Icons.local_hospital_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Blood Banks',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  '${_filteredBanks.length} found near Coimbatore',
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
                      const SizedBox(height: 14),
                      _buildSearchBar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(fontSize: 13, color: _kText),
        decoration: InputDecoration(
          hintText: 'Search blood banks...',
          hintStyle: TextStyle(color: _kTextSoft.withOpacity(0.7), fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, color: _kTextSoft, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                  child: const Icon(Icons.close_rounded,
                      color: _kTextSoft, size: 18),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                ..._typeFilters.map((type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: type,
                        selected: _selectedType == type,
                        onTap: () => setState(() => _selectedType = type),
                        color: _kRed,
                      ),
                    )),
                const SizedBox(width: 4),
                _ToggleChip(
                  label: '🟢 Open Now',
                  active: _onlyOpen,
                  onTap: () => setState(() => _onlyOpen = !_onlyOpen),
                ),
                const SizedBox(width: 8),
                _ToggleChip(
                  label: '🕐 24×7',
                  active: _only24x7,
                  onTap: () => setState(() => _only24x7 = !_only24x7),
                ),
              ],
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
                    color: _kTextSoft,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                ..._bloodTypes.map((bt) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _FilterChip(
                        label: bt,
                        selected: _selectedBloodType == bt,
                        onTap: () => setState(() => _selectedBloodType = bt),
                        color: const Color(0xFFAD1457),
                        compact: true,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: _kRed,
        unselectedLabelColor: _kTextSoft,
        indicatorColor: _kRed,
        indicatorWeight: 3,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
        tabs: const [
          Tab(icon: Icon(Icons.list_rounded, size: 18), text: 'List View'),
          Tab(icon: Icon(Icons.map_rounded, size: 18), text: 'Map View'),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final banks = _filteredBanks;
    if (banks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏥', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              'No blood banks found',
              style: TextStyle(
                color: _kText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try changing your filters',
              style: TextStyle(color: _kTextSoft, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      physics: const BouncingScrollPhysics(),
      itemCount: banks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) => _BloodBankCard(bank: banks[i]),
    );
  }

  Widget _buildMapPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _kRedLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.map_rounded, color: _kRed, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'Map View Coming Soon',
            style: TextStyle(
              color: _kText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Interactive map with real-time blood bank locations will be available in the next update.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kTextSoft,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _tabController.animateTo(0),
            icon: const Icon(Icons.list_rounded, size: 18),
            label: const Text('View as List'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _kRed,
              side: const BorderSide(color: _kRed, width: 1.5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _BloodBankCard extends StatefulWidget {
  final BloodBank bank;
  const _BloodBankCard({required this.bank});

  @override
  State<_BloodBankCard> createState() => _BloodBankCardState();
}

class _BloodBankCardState extends State<_BloodBankCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final bank = widget.bank;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: _expanded
              ? Border.all(color: _kRed.withOpacity(0.3), width: 1.5)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: bank.isOpen
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.local_hospital_rounded,
                          color: bank.isOpen
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    bank.name,
                                    style: const TextStyle(
                                      color: _kText,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.5,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _TypeBadge(type: bank.type),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    size: 11, color: _kTextSoft),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    bank.address,
                                    style: const TextStyle(
                                        color: _kTextSoft, fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(bank),
                  const SizedBox(height: 12),
                  _buildAvailabilityRow(bank),
                  const SizedBox(height: 12),
                  _buildActionButtons(),
                ],
              ),
            ),
            if (_expanded) ...[
              Divider(
                  color: Colors.grey.withOpacity(0.15),
                  thickness: 1,
                  height: 0),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Blood Availability',
                      style: TextStyle(
                        color: _kText,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: bank.availability.entries
                          .map((e) => _AvailabilityBadge(
                              type: e.key, status: e.value))
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Facilities',
                      style: TextStyle(
                        color: _kText,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _FacilityChip(
                          label: 'Walk-in',
                          active: bank.acceptsWalkIn,
                          icon: Icons.directions_walk_rounded,
                        ),
                        _FacilityChip(
                          label: 'Home Delivery',
                          active: bank.hasHomeDelivery,
                          icon: Icons.local_shipping_rounded,
                        ),
                        _FacilityChip(
                          label: '24×7',
                          active: bank.is24x7,
                          icon: Icons.nightlight_round,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined,
                            size: 14, color: _kTextSoft),
                        const SizedBox(width: 6),
                        Text(
                          bank.phone,
                          style: const TextStyle(
                            color: _kText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: _kTextSoft,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BloodBank bank) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _InfoPill(
            icon: bank.isOpen ? Icons.circle : Icons.cancel_outlined,
            label: bank.isOpen ? 'Open Now' : 'Closed',
            color: bank.isOpen
                ? const Color(0xFF2E7D32)
                : const Color(0xFFC62828),
            bgColor: bank.isOpen
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFCE4EC),
          ),
          const SizedBox(width: 6),
          _InfoPill(
            icon: Icons.schedule_rounded,
            label: bank.is24x7 ? '24 × 7' : bank.timings,
            color: const Color(0xFF1565C0),
            bgColor: const Color(0xFFE3F2FD),
          ),
          const SizedBox(width: 6),
          _InfoPill(
            icon: Icons.near_me_rounded,
            label: '${bank.distance} km',
            color: const Color(0xFF6A1B9A),
            bgColor: const Color(0xFFF3E5F5),
          ),
          const SizedBox(width: 10),
          _StarRating(rating: bank.rating, count: bank.reviewCount),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.phone_rounded,
            label: 'Call',
            color: const Color(0xFF2E7D32),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.directions_rounded,
            label: 'Directions',
            color: const Color(0xFF1565C0),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.bookmark_add_rounded,
            label: 'Save',
            color: _kRed,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityRow(BloodBank bank) {
    final criticalTypes = bank.availability.entries
        .where((e) => e.value == 'low' || e.value == 'unavailable')
        .take(4)
        .toList();

    if (criticalTypes.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded,
                color: Color(0xFF2E7D32), size: 13),
            SizedBox(width: 5),
            Text(
              'All blood types available',
              style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 11,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }

    final extraCount = bank.availability.entries
        .where((e) => e.value == 'low' || e.value == 'unavailable')
        .length - 4;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          const Text(
            'Alerts:',
            style: TextStyle(
                color: _kTextSoft,
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          ...criticalTypes.map((e) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _MiniAvailBadge(type: e.key, status: e.value),
              )),
          if (extraCount > 0)
            Text(
              '+$extraCount more',
              style: TextStyle(
                  color: _kTextSoft.withOpacity(0.7), fontSize: 10),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;
  final bool compact;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14,
          vertical: compact ? 5 : 7,
        ),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontSize: compact ? 11 : 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToggleChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF2E7D32).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? const Color(0xFF2E7D32)
                : _kTextSoft.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF2E7D32) : _kTextSoft,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> colors = {
      'Government': const Color(0xFF1565C0),
      'Private': const Color(0xFF6A1B9A),
      'NGO': const Color(0xFF2E7D32),
    };
    final color = colors[type] ?? _kTextSoft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  final int count;
  const _StarRating({required this.rating, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: Color(0xFFFFA000), size: 14),
        const SizedBox(width: 3),
        Text(
          '$rating',
          style: const TextStyle(
            color: _kText,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          '($count)',
          style: TextStyle(color: _kTextSoft.withOpacity(0.7), fontSize: 10),
        ),
      ],
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  final String type;
  final String status;
  const _AvailabilityBadge({required this.type, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg, text;
    switch (status) {
      case 'available':
        bg = const Color(0xFFE8F5E9);
        text = const Color(0xFF2E7D32);
        break;
      case 'low':
        bg = const Color(0xFFFFF3E0);
        text = const Color(0xFFE65100);
        break;
      default:
        bg = const Color(0xFFFCE4EC);
        text = const Color(0xFFC62828);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: text.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            status == 'available'
                ? '✓'
                : status == 'low'
                    ? '⚠'
                    : '✗',
            style: TextStyle(color: text, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _MiniAvailBadge extends StatelessWidget {
  final String type;
  final String status;
  const _MiniAvailBadge({required this.type, required this.status});

  @override
  Widget build(BuildContext context) {
    final isLow = status == 'low';
    final color =
        isLow ? const Color(0xFFE65100) : const Color(0xFFC62828);
    final bg = isLow ? const Color(0xFFFFF3E0) : const Color(0xFFFCE4EC);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$type ${isLow ? '⚠' : '✗'}',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  final String label;
  final bool active;
  final IconData icon;

  const _FacilityChip(
      {required this.label, required this.active, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: active
                ? const Color(0xFF2E7D32)
                : _kTextSoft.withOpacity(0.5),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: active
                  ? const Color(0xFF2E7D32)
                  : _kTextSoft.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
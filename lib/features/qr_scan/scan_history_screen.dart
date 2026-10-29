import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

enum ScanStatus { verified, denied, expired }

class ScanHistoryItem {
  final String id;
  final String name;
  final String date;
  final String time;
  final ScanStatus status;
  final String imageAsset;
  final Patient patient;

  const ScanHistoryItem({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.status,
    required this.imageAsset,
    required this.patient,
  });

  String get formattedTimestamp => '$date •\n$time';
  String get singleLineTimestamp => '$date • $time';
}

class ScanHistoryScreen extends StatefulWidget {
  final List<ScanHistoryItem>? customItems;

  const ScanHistoryScreen({super.key, this.customItems});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex =
      0; // 0: All History, 1: Today, 2: This Week, 3: Status
  ScanStatus? _selectedStatusFilter;
  int _bottomNavIndex = 0;

  late final List<ScanHistoryItem> _allItems;

  @override
  void initState() {
    super.initState();
    _allItems = widget.customItems ?? _buildDefaultHistoryItems();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static List<ScanHistoryItem> _buildDefaultHistoryItems() {
    // Correlate with existing mock patients where available to preserve rich clinical profile data
    final sarahPatient = MockData.patients.firstWhere(
      (p) => p.name.contains('Sarah'),
      orElse: () => MockData.patients[0],
    );
    final marcusPatient = MockData.patients.firstWhere(
      (p) => p.name.contains('Marcus'),
      orElse: () => MockData.patients[1],
    );

    const elenaPatient = Patient(
      id: 'p-elena-rodriguez',
      name: 'Elena Rodriguez',
      age: 34,
      gender: 'Female',
      bloodGroup: 'O+',
      careId: 'CID-5521-MIA',
      allergies: ['Penicillin'],
      chronicConditions: ['Asthma'],
      scheduledTime: '09:45 AM',
      primaryComplaint: 'Cardiovascular scan follow-up',
    );

    const davidPatient = Patient(
      id: 'p-david-wilson',
      name: 'David Wilson',
      age: 48,
      gender: 'Male',
      bloodGroup: 'A-',
      careId: 'CID-9381-CHI',
      allergies: ['Sulfa'],
      chronicConditions: ['Hypertension'],
      scheduledTime: '02:15 PM',
      primaryComplaint: 'Hypertension check',
    );

    const amaraPatient = Patient(
      id: 'p-amara-okafor',
      name: 'Amara Okafor',
      age: 29,
      gender: 'Female',
      bloodGroup: 'B+',
      careId: 'CID-1940-ATL',
      allergies: [],
      chronicConditions: [],
      scheduledTime: '11:05 AM',
      primaryComplaint: 'General consultation',
    );

    return [
      const ScanHistoryItem(
        id: 'scan-1',
        name: 'Elena Rodriguez',
        date: 'May 12, 2024',
        time: '09:45 AM',
        status: ScanStatus.verified,
        imageAsset: 'assets/images/patient_elena_rodriguez.png',
        patient: elenaPatient,
      ),
      ScanHistoryItem(
        id: 'scan-2',
        name: 'Marcus Chen',
        date: 'May 12, 2024',
        time: '08:30 AM',
        status: ScanStatus.denied,
        imageAsset: 'assets/images/patient_marcus_chen.png',
        patient: marcusPatient,
      ),
      ScanHistoryItem(
        id: 'scan-3',
        name: 'Sarah Jenkins',
        date: 'May 11, 2024',
        time: '04:20 PM',
        status: ScanStatus.expired,
        imageAsset: 'assets/images/patient_sarah_jenkins.png',
        patient: sarahPatient,
      ),
      const ScanHistoryItem(
        id: 'scan-4',
        name: 'David Wilson',
        date: 'May 11, 2024',
        time: '02:15 PM',
        status: ScanStatus.verified,
        imageAsset: 'assets/images/patient_david_wilson.png',
        patient: davidPatient,
      ),
      const ScanHistoryItem(
        id: 'scan-5',
        name: 'Amara Okafor',
        date: 'May 11, 2024',
        time: '11:05 AM',
        status: ScanStatus.verified,
        imageAsset: 'assets/images/patient_amara_okafor.png',
        patient: amaraPatient,
      ),
    ];
  }

  List<ScanHistoryItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    return _allItems.where((item) {
      final matchesQuery =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.date.toLowerCase().contains(query) ||
          item.time.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      // Filter chip logic
      switch (_selectedFilterIndex) {
        case 1: // Today: May 12, 2024
          return item.date.contains('May 12, 2024');
        case 2: // This Week: all mock scans are within the week
          return true;
        case 3: // Status filter
          if (_selectedStatusFilter != null) {
            return item.status == _selectedStatusFilter;
          }
          return true;
        case 0:
        default:
          return true;
      }
    }).toList();
  }

  void _onFilterTap(int index) {
    setState(() {
      if (index == 3) {
        // Toggle or cycle status filter
        if (_selectedFilterIndex != 3) {
          _selectedFilterIndex = 3;
          _selectedStatusFilter = ScanStatus.verified;
        } else {
          // Cycle through Verified -> Denied -> Expired -> All
          if (_selectedStatusFilter == ScanStatus.verified) {
            _selectedStatusFilter = ScanStatus.denied;
          } else if (_selectedStatusFilter == ScanStatus.denied) {
            _selectedStatusFilter = ScanStatus.expired;
          } else {
            _selectedStatusFilter = null;
            _selectedFilterIndex = 0;
          }
        }
      } else {
        _selectedFilterIndex = index;
        _selectedStatusFilter = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Top App Bar matching Figma node 10:891
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        behavior: HitTestBehavior.opaque,
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 22,
                              color: Color(0xFF28006D),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Scan History',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF28006D),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.notificationCenter,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox(
                      width: 32,
                      height: 36,
                      child: Center(
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 24,
                          color: Color(0xFF28006D),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient matching Figma node 10:866
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.6, -1.0),
                  end: Alignment(0.6, 1.0),
                  colors: [
                    Color(0xFFFFF7ED), // rgb(255, 247, 237)
                    Color(0xFFF5F3FF), // rgb(245, 243, 255)
                    Color(0xFFF8F9FA),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 130),
              children: [
                // Search & Filter Section (node 10:904)
                _buildSearchAndFilterSection(),

                const SizedBox(height: 32),

                // Recent Scans Section (node 10:921)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Recent Scans',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF494552),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Scans List
                if (filteredList.isEmpty)
                  _buildEmptyState()
                else
                  ...filteredList.map((item) => _buildScanCard(item)),

                const SizedBox(height: 16),

                // Summary Stats Section (node 10:1010)
                _buildSummaryStatsSection(),
              ],
            ),
          ),

          // Floating Action Button for New Scan (node 10:899)
          Positioned(
            right: 24,
            bottom: 104,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cameraPermission);
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF28006D),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000), // rgba(0,0,0,0.1)
                      blurRadius: 15,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_a_photo_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation Shell (node 10:867)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNav(
              currentIndex: _bottomNavIndex,
              onTap: (index) {
                setState(() {
                  _bottomNavIndex = index;
                });
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                } else if (index == 1) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.patientDirectory,
                  );
                } else if (index == 2) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.appointmentsOverview,
                  );
                } else if (index == 3) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.doctorProfile,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Search input & Filter chips
  Widget _buildSearchAndFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input (node 10:906)
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBC4D4)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(
                Icons.search_rounded,
                size: 20,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    color: Color(0xFF191C1D),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search patients or dates...',
                    hintStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.cancel,
                      size: 18,
                      color: Color(0xFF7A7583),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Filter Chips (node 10:910)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildFilterChip(
                label: 'All History',
                index: 0,
                isSelected: _selectedFilterIndex == 0,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                label: 'Today',
                index: 1,
                isSelected: _selectedFilterIndex == 1,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                label: 'This Week',
                index: 2,
                isSelected: _selectedFilterIndex == 2,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                label: _selectedStatusFilter == null
                    ? 'Status'
                    : 'Status: ${_statusName(_selectedStatusFilter!)}',
                index: 3,
                isSelected: _selectedFilterIndex == 3,
                hasDropdown: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _statusName(ScanStatus status) {
    switch (status) {
      case ScanStatus.verified:
        return 'Verified';
      case ScanStatus.denied:
        return 'Denied';
      case ScanStatus.expired:
        return 'Expired';
    }
  }

  Widget _buildFilterChip({
    required String label,
    required int index,
    required bool isSelected,
    bool hasDropdown = false,
  }) {
    return GestureDetector(
      onTap: () => _onFilterTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF28006D) : const Color(0xFFE7E8E9),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: isSelected ? Colors.white : const Color(0xFF494552),
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF494552),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Scan Card Item (node 10:925, 10:942, 10:959, 10:976, 10:993)
  Widget _buildScanCard(ScanHistoryItem item) {
    Color dotColor;
    Color badgeBg;
    Color badgeTextColor;
    IconData badgeIcon;
    String badgeText;

    switch (item.status) {
      case ScanStatus.verified:
        dotColor = const Color(0xFF006971);
        badgeBg = const Color(0xFF76F1FF);
        badgeTextColor = const Color(0xFF006D76);
        badgeIcon = Icons.check_circle_rounded;
        badgeText = 'Verified';
        break;
      case ScanStatus.denied:
        dotColor = const Color(0xFFBA1A1A);
        badgeBg = const Color(0xFFFFDAD6);
        badgeTextColor = const Color(0xFF93000A);
        badgeIcon = Icons.cancel_rounded;
        badgeText = 'Denied';
        break;
      case ScanStatus.expired:
        dotColor = const Color(0xFF7A7583);
        badgeBg = const Color(0xFFE1E3E4);
        badgeTextColor = const Color(0xFF494552);
        badgeIcon = Icons.history_rounded;
        badgeText = 'Expired';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.patientProfile,
            arguments: item.patient,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(17),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with capsule pill and status dot (node 10:927)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: const Color(0xFFEDEEEF),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: Image.asset(
                        item.imageAsset,
                        width: 46,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFE9ECEF),
                            child: const Center(
                              child: Icon(
                                Icons.person_rounded,
                                size: 26,
                                color: Color(0xFF7A7583),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Patient Name and Date/Time (node 10:930)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                        height: 1.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.formattedTimestamp,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF494552),
                        height: 1.35,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Status Badge and Chevron (node 10:935)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(badgeIcon, size: 13, color: badgeTextColor),
                        const SizedBox(width: 4),
                        Text(
                          badgeText,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: badgeTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFF7A7583),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Summary Stats Section (node 10:1010)
  Widget _buildSummaryStatsSection() {
    return Row(
      children: [
        // SCANNED Card (node 10:1011)
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF3F1D8B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Opacity(
                  opacity: 0.8,
                  child: Text(
                    'SCANNED',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFAB8EFD),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '124',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFAB8EFD),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // SUCCESS Card (node 10:1016)
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE7E8E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Opacity(
                  opacity: 0.8,
                  child: Text(
                    'SUCCESS',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF494552),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '98%',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // ISSUES Card (node 10:1021)
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE7E8E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Opacity(
                  opacity: 0.8,
                  child: Text(
                    'ISSUES',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF494552),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '2',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBA1A1A),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Color(0xFFCBC4D4),
          ),
          const SizedBox(height: 12),
          const Text(
            'No matching scan records',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF494552),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try searching with a different patient name or date.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: Color(0xFF7A7583),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

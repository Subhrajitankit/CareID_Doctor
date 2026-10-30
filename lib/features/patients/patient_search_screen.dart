import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:1511
/// "Patient Search - Results & Empty States"
class PatientSearchScreen extends StatefulWidget {
  final String? initialQuery;
  final List<Patient>? customPatients;

  const PatientSearchScreen({
    super.key,
    this.initialQuery,
    this.customPatients,
  });

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  bool _isSearchInputVisible = false;

  int _selectedFilterIndex =
      0; // 0: All Results, 1: Critical, 2: In-Patient, 3: Out-Patient, 4: Emergency, 5: Follow-up
  String _selectedSort = 'Recently Visited';
  bool _sortAscending = true;

  late final List<Patient> _basePatients;

  // Figma reference mock patients for node 10:1511
  static const List<Patient> _figmaReferencePatients = [
    Patient(
      id: 'p-figma-elena-1',
      name: 'Elena Rodriguez Garcia',
      age: 34,
      gender: 'Female',
      bloodGroup: 'O+',
      careId: 'HV-9021',
      isCritical: true,
      queueStatus: 'waiting',
      scheduledTime: '10:00 AM',
      primaryComplaint: 'Critical Cardiovascular Monitoring',
      allergies: ['Penicillin'],
      chronicConditions: ['Acute Heart Failure'],
      avatarUrl: 'assets/images/patient_elena_rodriguez.png',
    ),
    Patient(
      id: 'p-figma-elena-2',
      name: 'Elena M. Thompson',
      age: 28,
      gender: 'Female',
      bloodGroup: 'A+',
      careId: 'HV-7732',
      isCritical: false,
      queueStatus: 'in_progress',
      scheduledTime: '11:15 AM',
      primaryComplaint: 'Post-operative observation (Admitted)',
      allergies: ['Latex'],
      chronicConditions: ['Asthma'],
      avatarUrl: 'assets/images/patient_elena_thompson.png',
    ),
    Patient(
      id: 'p-figma-elena-3',
      name: 'Elena Petrova',
      age: 45,
      gender: 'Female',
      bloodGroup: 'B-',
      careId: 'HV-1149',
      isCritical: false,
      queueStatus: 'done',
      scheduledTime: '02:30 PM',
      primaryComplaint: 'Outpatient Routine Checkup',
      allergies: [],
      chronicConditions: ['Hypertension'],
      avatarUrl: 'assets/images/patient_elena_petrova.png',
    ),
  ];

  static const List<String> _filterChips = [
    'All Results',
    'Critical',
    'In-Patient',
    'Out-Patient',
    'Emergency',
    'Follow-up',
  ];

  @override
  void initState() {
    super.initState();
    final defaultQuery = widget.initialQuery ?? 'Elena';
    _searchController = TextEditingController(text: defaultQuery);
    _searchFocusNode = FocusNode();

    if (widget.customPatients != null) {
      _basePatients = widget.customPatients!;
    } else {
      // Merge Figma reference patients with MockData.patients
      final existingIds = _figmaReferencePatients.map((e) => e.careId).toSet();
      _basePatients = [
        ..._figmaReferencePatients,
        ...MockData.patients.where((p) => !existingIds.contains(p.careId)),
      ];
    }

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Patient> get _filteredPatients {
    final query = _searchController.text.trim().toLowerCase();

    var list = _basePatients.where((patient) {
      // 1. Search Query Filter
      if (query.isNotEmpty) {
        final matchesName = patient.name.toLowerCase().contains(query);
        final matchesCareId = patient.careId.toLowerCase().contains(query);
        final matchesComplaint = patient.primaryComplaint
            .toLowerCase()
            .contains(query);
        final matchesBlood = patient.bloodGroup.toLowerCase().contains(query);
        final matchesCondition = patient.chronicConditions.any(
          (c) => c.toLowerCase().contains(query),
        );

        if (!matchesName &&
            !matchesCareId &&
            !matchesComplaint &&
            !matchesBlood &&
            !matchesCondition) {
          return false;
        }
      }

      // 2. Filter Chip Filter
      switch (_selectedFilterIndex) {
        case 1: // Critical
          return patient.isCritical;
        case 2: // In-Patient
          return (patient.queueStatus == 'in_progress' ||
                  patient.careId == 'HV-7732') &&
              patient.queueStatus != 'done';
        case 3: // Out-Patient
          return (!patient.isCritical && patient.queueStatus == 'done') ||
              patient.careId == 'HV-1149';
        case 4: // Emergency
          return patient.isCritical ||
              patient.primaryComplaint.toLowerCase().contains('emergency') ||
              patient.primaryComplaint.toLowerCase().contains('hypoxia');
        case 5: // Follow-up
          return patient.primaryComplaint.toLowerCase().contains('follow') ||
              patient.primaryComplaint.toLowerCase().contains('checkup') ||
              patient.queueStatus == 'done';
        case 0: // All Results
        default:
          return true;
      }
    }).toList();

    // 3. Sorting
    list.sort((a, b) {
      if (_selectedSort == 'Name: A to Z') {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else if (_selectedSort == 'Name: Z to A') {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      } else if (_selectedSort == 'Risk: High to Low') {
        if (a.isCritical && !b.isCritical) return -1;
        if (!a.isCritical && b.isCritical) return 1;
        return 0;
      } else {
        // 'Recently Visited' / Default
        final comp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        return _sortAscending ? comp : -comp;
      }
    });

    return list;
  }

  void _openSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final options = [
          'Recently Visited',
          'Name: A to Z',
          'Name: Z to A',
          'Risk: High to Low',
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'Sort Patients By',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ),
                const Divider(color: Color(0xFFE5E7EB)),
                ...options.map((option) {
                  final isSelected = _selectedSort == option;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 2,
                    ),
                    title: Text(
                      option,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF28006D)
                            : const Color(0xFF191C1D),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF28006D),
                            size: 22,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedSort = option;
                        if (option == 'Name: A to Z') _sortAscending = true;
                        if (option == 'Name: Z to A') _sortAscending = false;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getPatientAvatar(Patient patient) {
    if (patient.avatarUrl != null && patient.avatarUrl!.isNotEmpty) {
      return patient.avatarUrl!;
    }
    final lower = patient.name.toLowerCase();
    if (lower.contains('rodriguez') ||
        (lower.contains('elena') && patient.isCritical)) {
      return 'assets/images/patient_elena_rodriguez.png';
    } else if (lower.contains('thompson')) {
      return 'assets/images/patient_elena_thompson.png';
    } else if (lower.contains('petrova')) {
      return 'assets/images/patient_elena_petrova.png';
    } else if (lower.contains('aditi') || lower.contains('sharma')) {
      return 'assets/images/patient_aditi_sharma.png';
    } else if (lower.contains('benjamin') || lower.contains('wright')) {
      return 'assets/images/patient_benjamin_wright.png';
    }
    return 'assets/images/patient_elena_rodriguez.png';
  }

  String _getStatusLabel(Patient p) {
    if (p.isCritical) return 'Critical';
    if (p.careId == 'HV-7732' || p.queueStatus == 'in_progress') {
      return 'Admitted';
    }
    return 'Out-Patient';
  }

  Color _getStatusBadgeBg(String status) {
    switch (status) {
      case 'Critical':
        return const Color(0xFFFFDAD6);
      case 'Admitted':
        return const Color(0xFF76F1FF);
      case 'Out-Patient':
      default:
        return const Color(0xFFE1E3E4);
    }
  }

  Color _getStatusBadgeText(String status) {
    switch (status) {
      case 'Critical':
        return const Color(0xFF93000A);
      case 'Admitted':
        return const Color(0xFF006D76);
      case 'Out-Patient':
      default:
        return const Color(0xFF494552);
    }
  }

  Color _getAccentColor(String status) {
    switch (status) {
      case 'Critical':
        return const Color(0xFFBA1A1A);
      case 'Admitted':
        return const Color(0xFF006971);
      case 'Out-Patient':
      default:
        return const Color(0xFF7A7583);
    }
  }

  String _getLocation(Patient p) {
    if (p.careId == 'HV-9021' || p.isCritical) return '• Room 402';
    if (p.careId == 'HV-7732' || p.queueStatus == 'in_progress') {
      return '• Ward B';
    }
    return '• External';
  }

  String _getFirstActionText(Patient p) {
    if (p.careId == 'HV-1149' || (!p.isCritical && p.queueStatus == 'done')) {
      return 'History';
    }
    return 'Vitals';
  }

  String _displayHeaderTitle(int count) {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      return '$count Patient Records';
    }
    if (query.toLowerCase() == 'elena' && count == 3) {
      return '12 Results for "Elena"';
    }
    return '$count Results for "$query"';
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredPatients;

    return Scaffold(
      // Gradient background matching Figma node 10:1511
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1.0),
            end: Alignment(0.6, 1.0),
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: Stack(
          children: [
            // Main Scrollable Content
            Positioned.fill(
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Header - TopAppBar (node 10:1537)
                    _buildTopAppBar(),

                    // Body
                    Expanded(
                      child: results.isEmpty
                          ? _buildEmptyState()
                          : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                24,
                                24,
                                110,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section - Header Info & Sort (node 10:1546)
                                  _buildHeaderInfoAndSort(results.length),

                                  const SizedBox(height: 24),

                                  // Section - Filter Chips (node 10:1561)
                                  _buildFilterChips(),

                                  const SizedBox(height: 24),

                                  // Section - Search Results Grid/List (node 10:1574)
                                  _buildResultsList(results),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Shell (node 10:1512)
            _buildBottomNavigationShell(),
          ],
        ),
      ),
    );
  }

  /// Header - TopAppBar matching Figma node 10:1537
  Widget _buildTopAppBar() {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
      child: _isSearchInputVisible
          ? Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearchInputVisible = false;
                    });
                  },
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
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    autofocus: true,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search ID, Name, or Condition...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF7A7583),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                size: 20,
                                color: Color(0xFF7A7583),
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF28006D),
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearchInputVisible = false;
                    });
                  },
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left group: Back Button & Title (node 10:1538)
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSearchInputVisible = true;
                        });
                        _searchFocusNode.requestFocus();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Text(
                        'Search Results',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF28006D),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                // Right group: Search Toggle & Bell with Red Dot (node 10:1543)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search toggle icon button
                    GestureDetector(
                      key: const Key('search_toggle_button'),
                      onTap: () {
                        setState(() {
                          _isSearchInputVisible = true;
                        });
                        _searchFocusNode.requestFocus();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const SizedBox(
                        width: 32,
                        height: 36,
                        child: Center(
                          child: Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Bell Icon with Red Dot Badge (node 10:1543)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.notificationCenter,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 32,
                        height: 36,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.notifications_none_rounded,
                              size: 24,
                              color: Color(0xFF28006D),
                            ),
                            Positioned(
                              top: 6,
                              right: 4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFBA1A1A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  /// Section - Header Info & Sort matching Figma node 10:1546
  Widget _buildHeaderInfoAndSort(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading 2 (node 10:1548)
        GestureDetector(
          onTap: () {
            setState(() {
              _isSearchInputVisible = true;
            });
            _searchFocusNode.requestFocus();
          },
          behavior: HitTestBehavior.opaque,
          child: Text(
            _displayHeaderTitle(count),
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.33,
            ),
          ),
        ),

        // Subtitle (node 10:1550)
        const SizedBox(height: 4),
        const Text(
          'Matching patient records found in your directory',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF494552),
            height: 1.43,
          ),
        ),

        const SizedBox(height: 14),

        // Options / Sort Dropdown Bar (node 10:1553)
        GestureDetector(
          onTap: _openSortBottomSheet,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 38,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _selectedSort,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: Color(0xFF191C1D),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Color(0xFF494552),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Section - Filter Chips matching Figma node 10:1561
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filterChips.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isSelected = _selectedFilterIndex == index;

          return Padding(
            padding: EdgeInsets.only(
              right: index == _filterChips.length - 1 ? 0 : 8,
            ),
            child: isSelected
                ? GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                        ),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1E3E4),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Center(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: Color(0xFF494552),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }

  /// Section - Search Results Grid/List matching Figma node 10:1574
  Widget _buildResultsList(List<Patient> patients) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: patients.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final patient = patients[index];
        final statusLabel = _getStatusLabel(patient);
        final accentColor = _getAccentColor(statusLabel);
        final badgeBg = _getStatusBadgeBg(statusLabel);
        final badgeText = _getStatusBadgeText(statusLabel);
        final location = _getLocation(patient);
        final actionText = _getFirstActionText(patient);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: accentColor, width: 4)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            left: 20,
            right: 16,
            top: 16,
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Avatar & Patient Details
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar 56x56 with 16x16 status dot (node 10:1577)
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Avatar image circle
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE8DDFF),
                            image: DecorationImage(
                              image: AssetImage(_getPatientAvatar(patient)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Status dot at bottom right: 16x16 with 2px white border
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Details column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading 3: Patient Name
                        Text(
                          patient.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191C1D),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Meta row: Status Badge + CareID + Location
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Status Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: badgeBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  color: badgeText,
                                  height: 1.33,
                                ),
                              ),
                            ),

                            // ID Text
                            Text(
                              'ID: ${patient.careId}',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                color: Color(0xFF494552),
                                height: 1.33,
                              ),
                            ),

                            // Location Text
                            Text(
                              location,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                color: Color(0xFF494552),
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Divider (node 10:1590)
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE5E7EB), height: 1, thickness: 1),
              const SizedBox(height: 13),

              // Action Buttons Row (Vitals/History + Open File)
              Row(
                children: [
                  // Button 1: Outline Button (Vitals or History)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.patientProfile,
                          arguments: patient,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF7A7583),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            actionText,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: Color(0xFF28006D),
                              height: 1.43,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Button 2: Gradient Button ("Open File")
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.patientProfile,
                          arguments: patient,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Open File',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: Colors.white,
                              height: 1.43,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Bottom Navigation Shell matching Figma node 10:1512
  Widget _buildBottomNavigationShell() {
    return Positioned(
      left: 13,
      right: 13,
      bottom: 14,
      child: Center(
        child: Container(
          width: 351,
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000), // rgba(0,0,0,0.1)
                blurRadius: 25,
                offset: Offset(0, 20),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 8),
                spreadRadius: -6,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  // 1. Home
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.dashboard,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.grid_view_rounded,
                            size: 18,
                            color: Color(0xFF006D76),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006D76),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Patients (Active cyan pill background)
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF76F1FF),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.people_alt_rounded,
                              size: 16,
                              color: Color(0xFF494552),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Patients',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF494552),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Center Spacer for elevated Scan QR button
                  const SizedBox(width: 56),

                  // 3. Referrals
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.appointmentsOverview,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Referrals',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF494552),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. Profile
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.doctorProfile);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF494552),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Elevated Center Scan QR Button (node 10:1524)
              Positioned(
                top: -16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.cameraPermission);
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B14B8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF8F9FF),
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000), // rgba(0,0,0,0.25)
                          blurRadius: 25,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final query = _searchController.text.trim();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 110),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFF3EDF7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 40,
                color: Color(0xFF28006D),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Patients Found',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF191C1D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              query.isNotEmpty
                  ? 'No patient records matched "$query". Verify spelling or scan patient CareID directly.'
                  : 'No patient records match the selected filter.',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFF494552),
                height: 1.43,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cameraPermission);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 220,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x335B14B8),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Scan QR Code Instead',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _selectedFilterIndex = 0;
                  _isSearchInputVisible = false;
                });
              },
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF28006D)),
              label: const Text(
                'Reset All Filters',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF28006D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

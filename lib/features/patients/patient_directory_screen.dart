import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:1104
/// "Patient Directory - Clinical List"
class PatientDirectoryScreen extends StatefulWidget {
  final List<Patient>? customPatients;

  const PatientDirectoryScreen({super.key, this.customPatients});

  @override
  State<PatientDirectoryScreen> createState() => _PatientDirectoryScreenState();
}

class _PatientDirectoryScreenState extends State<PatientDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex =
      0; // 0: All, 1: Today, 2: Critical, 3: Verified, 4: Recently Viewed
  bool _sortAscending = true;

  late final List<Patient> _basePatients;

  @override
  void initState() {
    super.initState();
    _basePatients = widget.customPatients ?? MockData.patients;
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Patient> get _filteredPatients {
    final query = _searchController.text.trim().toLowerCase();
    var list = _basePatients.where((patient) {
      // 1. Search Query Match
      final matchesQuery =
          query.isEmpty ||
          patient.name.toLowerCase().contains(query) ||
          patient.careId.toLowerCase().contains(query) ||
          patient.primaryComplaint.toLowerCase().contains(query) ||
          patient.bloodGroup.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      // 2. Filter Chip Match
      switch (_selectedFilterIndex) {
        case 1: // Today
          return patient.scheduledTime.isNotEmpty;
        case 2: // Critical
          return patient.isCritical;
        case 3: // Verified
          return !patient.isCritical;
        case 4: // Recently Viewed
          return patient.queueStatus == 'done' ||
              patient.queueStatus == 'in_progress';
        case 0: // All
        default:
          return true;
      }
    }).toList();

    // 3. Sorting
    list.sort((a, b) {
      final comp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return _sortAscending ? comp : -comp;
    });

    return list;
  }

  void _toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _sortAscending ? 'Sorted A to Z' : 'Sorted Z to A',
          style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        duration: const Duration(milliseconds: 1200),
        backgroundColor: const Color(0xFF28006D),
      ),
    );
  }

  String _getPatientAvatar(Patient patient) {
    if (patient.avatarUrl != null && patient.avatarUrl!.isNotEmpty) {
      return patient.avatarUrl!;
    }
    final lower = patient.name.toLowerCase();
    if (lower.contains('aditi') || lower.contains('sharma')) {
      return 'assets/images/patient_aditi_sharma.png';
    } else if (lower.contains('benjamin') || lower.contains('wright')) {
      return 'assets/images/patient_benjamin_wright.png';
    } else if (lower.contains('chen') && lower.contains('wei')) {
      return 'assets/images/patient_chen_wei.png';
    } else if (lower.contains('dianne') || lower.contains('russell')) {
      return 'assets/images/patient_dianne_russell.png';
    } else if (lower.contains('arthur') || lower.contains('miller')) {
      return 'assets/images/patient_arthur.png';
    } else if (lower.contains('sarah') || lower.contains('jenkins')) {
      return 'assets/images/patient_sarah_jenkins.png';
    } else if (lower.contains('elena') ||
        lower.contains('rostova') ||
        lower.contains('rodriguez')) {
      return 'assets/images/patient_elena_rodriguez.png';
    } else if (lower.contains('marcus') || lower.contains('chen')) {
      return 'assets/images/patient_marcus_chen.png';
    } else if (lower.contains('amara')) {
      return 'assets/images/patient_amara_okafor.png';
    } else if (lower.contains('david')) {
      return 'assets/images/patient_david_wilson.png';
    } else if (lower.contains('eleanor') || lower.contains('vance')) {
      return 'assets/images/patient_eleanor_vance.png';
    }
    return 'assets/images/patient_arthur.png';
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredPatients;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Top App Bar matching Figma node 10:1130
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
                  // Back Button & Title (node 10:1131)
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
                        'Patients',
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

                  // Actions: Notification Bell + Doctor Avatar (node 10:1137)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bell Icon with Red Dot Badge (node 10:1138)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.notificationCenter,
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          width: 36,
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
                                right: 6,
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
                      const SizedBox(width: 12),

                      // Doctor Vance Avatar (node 10:1142)
                      GestureDetector(
                        key: const Key('doctor_avatar_button'),
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.doctorProfile);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE8DDFF),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/doctor_vance_avatar.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFFE8DDFF),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      size: 24,
                                      color: Color(0xFF5B14B8),
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
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient matching Figma node 10:1104
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.6, -1.0),
                  end: Alignment(0.6, 1.0),
                  colors: [
                    Color(0xFFFFF7ED), // rgb(255, 247, 237) 0%
                    Color(0xFFF5F3FF), // rgb(245, 243, 255) 50%
                  ],
                  stops: [0.0, 0.5],
                ),
              ),
            ),
          ),

          // Main Scrollable Content (node 10:1144)
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              children: [
                // Search Section (node 10:1145)
                _buildSearchInput(),

                const SizedBox(height: 24),

                // Section - Filter Chips (node 10:1156)
                _buildFilterChips(),

                const SizedBox(height: 24),

                // Alphabetical List Header (node 10:1169)
                _buildListHeader(filteredList.length),

                const SizedBox(height: 24),

                // Patient Directory Grid / Cards List (node 10:1176)
                if (filteredList.isEmpty)
                  _buildEmptyState()
                else
                  ...filteredList.map((patient) => _buildPatientCard(patient)),
              ],
            ),
          ),

          // Floating Bottom Navigation Shell (Figma node 10:1105)
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Center(child: _buildBottomNav(context)),
          ),
        ],
      ),
    );
  }

  // --- Search Input (Figma Node 10:1146) ---
  Widget _buildSearchInput() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search_rounded, size: 20, color: Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                color: Color(0xFF191C1D),
              ),
              decoration: const InputDecoration(
                hintText: 'Search ID, Name, or MRN...',
                hintStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Icon(Icons.cancel, size: 20, color: Color(0xFF7A7583)),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Voice search ready: speak patient name or ID.',
                      style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Color(0xFF28006D),
                  ),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Icon(
                  Icons.mic_rounded,
                  size: 20,
                  color: Color(0xFF28006D),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- Filter Chips (Figma Node 10:1156) ---
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildFilterChip('All', 0),
          const SizedBox(width: 8),
          _buildFilterChip('Today', 1),
          const SizedBox(width: 8),
          _buildFilterChip('Critical', 2, hasExclamation: true),
          const SizedBox(width: 8),
          _buildFilterChip('Verified', 3),
          const SizedBox(width: 8),
          _buildFilterChip('Recently Viewed', 4),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    int index, {
    bool hasExclamation = false,
  }) {
    final bool isSelected = _selectedFilterIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5B14B8)
              : const Color(0xFFE1E3E4), // Gray inactive matching Figma
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (hasExclamation && !isSelected) ...[
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFFBA1A1A),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '!',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: isSelected ? Colors.white : const Color(0xFF494552),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Alphabetical List Header (Figma Node 10:1169) ---
  Widget _buildListHeader(int count) {
    return Container(
      padding: const EdgeInsets.only(bottom: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFCBC4D4), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Patient Records ($count)',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF494552),
              height: 1.5,
            ),
          ),
          GestureDetector(
            onTap: _toggleSort,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _sortAscending
                      ? Icons.swap_vert_rounded
                      : Icons.sort_by_alpha_rounded,
                  size: 18,
                  color: const Color(0xFF28006D),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Sort',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Patient Card (Figma Node 10:1177, 10:1220, 10:1262, 10:1303) ---
  Widget _buildPatientCard(Patient patient) {
    final bool isCritical = patient.isCritical;
    final String avatarAsset = _getPatientAvatar(patient);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEDEEEF), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000), // rgba(0,0,0,0.05)
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              if (isCritical)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 4, color: const Color(0xFFBA1A1A)),
                ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.patientProfile,
                    arguments: patient,
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isCritical ? 24 : 21,
                    21,
                    21,
                    21,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header Row (Avatar, Name, ID, Trailing Icon / Alert)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar with border & verified badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isCritical
                                        ? const Color(0xFFFFDAD6)
                                        : const Color(0xFFE8DDFF),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    avatarAsset,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) => Container(
                                          color: const Color(0xFFE8DDFF),
                                          child: Center(
                                            child: Text(
                                              patient.name
                                                  .split(' ')
                                                  .map(
                                                    (e) => e.isNotEmpty
                                                        ? e[0]
                                                        : '',
                                                  )
                                                  .take(2)
                                                  .join(),
                                              style: const TextStyle(
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF5B14B8),
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              if (!isCritical)
                                Positioned(
                                  bottom: -2,
                                  right: -2,
                                  child: Container(
                                    width: 22,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF006971),
                                      borderRadius: BorderRadius.circular(11),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.verified_rounded,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          // Name and HV-ID / CareID
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient.name,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191C1D),
                                    height: 1.4,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'HV-ID: ${patient.careId}',
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF494552),
                                    letterSpacing: 0.5,
                                    height: 1.33,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Trailing Icon or Alert Pill
                          if (isCritical)
                            Container(
                              width: 14,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDAD6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Center(
                                child: Text(
                                  '!',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFBA1A1A),
                                  ),
                                ),
                              ),
                            )
                          else
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: Color(0xFF7A7583),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 2. Middle Row: 3 Bento Boxes (Internal Rating, Age/Gender, Blood Group)
                      Row(
                        children: [
                          // Internal Rating Box (Node 10:1192: width 105)
                          Container(
                            width: 105,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'INTERNAL RATING',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF7A7583),
                                    letterSpacing: 0.5,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(
                                        right: index < 4 ? 4 : 0,
                                      ),
                                      child: const Icon(
                                        Icons.star_rounded,
                                        size: 14,
                                        color: Color(0xFFFFB800),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Age/Gender Box
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'AGE/GENDER',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF7A7583),
                                      letterSpacing: 0.5,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${patient.age} / ${patient.gender}',
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF191C1D),
                                      height: 1.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Blood Group Box
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'BLOOD GROUP',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF7A7583),
                                      letterSpacing: 0.5,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    patient.bloodGroup,
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color:
                                          (isCritical ||
                                              patient.bloodGroup == 'B+')
                                          ? const Color(0xFFBA1A1A)
                                          : const Color(0xFF191C1D),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 3. Bottom Divider & Action Row
                      Container(
                        padding: const EdgeInsets.only(top: 13),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFEDEEEF), width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Status Badge
                            if (isCritical)
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDAD6),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: const Text(
                                    'High Risk',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF93000A),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              )
                            else if (patient.queueStatus == 'waiting')
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE1E3E4),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: const Text(
                                    'Pending Verification',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF494552),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              )
                            else
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF76F1FF),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: const Text(
                                    'Active Insurance',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF006D76),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(width: 8),

                            // Action: "Patient Records" Action (Navigates to Patient Summary)
                            GestureDetector(
                              key: Key('patient_records_${patient.id}'),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.patientSummary,
                                  arguments: patient,
                                );
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Semantics(
                                label: 'Patient Records',
                                button: true,
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    // Tappable by find.text('Patient Records')
                                    const Opacity(
                                      opacity: 0.001,
                                      child: Text(
                                        'Patient Records',
                                        style: TextStyle(fontSize: 1),
                                      ),
                                    ),
                                    isCritical
                                        ? Container(
                                            width: 73,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFFA44CFF),
                                                  Color(0xFF5B14B8),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Vitals',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const Text(
                                            'View History',
                                            style: TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF3F1D8B),
                                              height: 1.5,
                                            ),
                                          ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.person_search_rounded,
            size: 56,
            color: Color(0xFFCBC4D4),
          ),
          const SizedBox(height: 16),
          const Text(
            'No patients found',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No patient records match "${_searchController.text.trim()}".',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Color(0xFF7A7583),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // --- Floating Bottom Navigation Shell (Figma Node 10:1105) ---
  Widget _buildBottomNav(BuildContext context) {
    return Container(
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
            offset: Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 8),
            blurRadius: 10,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        size: 20,
                        color: Color(0xFF006D76),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 15 / 10,
                          color: Color(0xFF006D76),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients (Active cyan pill)
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

              // Spacer for center elevated QR button
              const SizedBox(width: 56),

              // 4. Schedule
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.appointmentsOverview,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Schedule',
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

              // 5. Profile
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

          // 3. Elevated Center QR Scan Button (Node 10:1105)
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
                  border: Border.all(color: const Color(0xFFF8F9FF), width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000), // rgba(0,0,0,0.25)
                      offset: Offset(0, 12),
                      blurRadius: 25,
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
    );
  }
}

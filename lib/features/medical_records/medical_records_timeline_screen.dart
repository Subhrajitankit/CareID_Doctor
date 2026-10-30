import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';
import 'filter_records_bottom_sheet.dart';
import 'share_record_modal.dart';

/// Medical Records Timeline Screen
/// Exact Figma Source of Truth: Node 10:1887 ("Medical Records - Timeline & Vault")
/// CAREID-AIO-FIGMA: https://www.figma.com/design/9nUU700n9WAPQAXoGT17N6/CAREID-AIO-FIGMA?node-id=10-1887&m=dev
class MedicalRecordsTimelineScreen extends StatefulWidget {
  final Patient? patientArg;

  const MedicalRecordsTimelineScreen({super.key, this.patientArg});

  @override
  State<MedicalRecordsTimelineScreen> createState() =>
      _MedicalRecordsTimelineScreenState();
}

class _MedicalRecordsTimelineScreenState
    extends State<MedicalRecordsTimelineScreen> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  /// Categories matching Figma node 10:1932 + mock data categories
  final List<String> _categories = [
    'All Records',
    'Medical',
    'Dental',
    'Vision',
    'Clinical Notes',
    'Lab Reports',
    'Pet',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Resolve current patient from direct widget argument or ModalRoute settings
  Patient? _resolvePatient(BuildContext context) {
    if (widget.patientArg != null) return widget.patientArg;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Patient) return args;
    if (args is Map<String, dynamic>) {
      if (args['patient'] is Patient) return args['patient'] as Patient;
      if (args['patientId'] is String) {
        final pid = args['patientId'] as String;
        try {
          return MockData.patients.firstWhere((p) => p.id == pid);
        } catch (_) {}
      }
    }
    if (args is String) {
      try {
        return MockData.patients.firstWhere(
          (p) => p.id == args || p.careId == args,
        );
      } catch (_) {}
    }
    return null;
  }

  /// Get medical records filtered by category and search query
  List<MedicalRecordItem> _getFilteredRecords(Patient? patient) {
    List<MedicalRecordItem> source = MockData.records;

    // If patient is specified and has records, filter by patientId
    if (patient != null) {
      final patientRecords = source
          .where((r) => r.patientId == patient.id)
          .toList();
      if (patientRecords.isNotEmpty) {
        source = patientRecords;
      }
    }

    // Filter by Category
    List<MedicalRecordItem> categoryFiltered;
    if (_selectedCategoryIndex == 0) {
      categoryFiltered = source;
    } else {
      final selectedCat = _categories[_selectedCategoryIndex];
      categoryFiltered = source.where((r) {
        final catLower = r.category.toLowerCase();
        final selectedLower = selectedCat.toLowerCase();
        if (selectedLower == 'medical') {
          return catLower.contains('cardiology') ||
              catLower.contains('lab') ||
              catLower.contains('general') ||
              catLower.contains('medical') ||
              catLower.contains('imaging');
        }
        if (selectedLower == 'lab reports') {
          return catLower.contains('lab');
        }
        if (selectedLower == 'clinical notes') {
          return catLower.contains('clinical') || catLower.contains('notes');
        }
        return catLower.contains(selectedLower);
      }).toList();
    }

    // Filter by Search Query
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return categoryFiltered;
    }

    return categoryFiltered.where((r) {
      return r.title.toLowerCase().contains(query) ||
          r.doctor.toLowerCase().contains(query) ||
          r.facility.toLowerCase().contains(query) ||
          r.summary.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query);
    }).toList();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterRecordsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final patient = _resolvePatient(context);
    final records = _getFilteredRecords(patient);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Figma node 10:1887 background gradient:
        // linear-gradient(107.82deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.8, -0.6),
            end: Alignment(0.8, 0.6),
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header - TopAppBar (Figma Node 10:1913)
              _buildTopAppBar(context),

              // Main Scrollable Area with Floating Bottom Nav
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Scrollable Timeline Content
                    Positioned.fill(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            // Page Title → Heading 2 (Figma Node 10:1922, 10:1923)
                            _buildPageTitle(),

                            const SizedBox(height: 24),

                            // Search Bar & Filter (Figma Node 10:1924)
                            _buildSearchBar(),

                            const SizedBox(height: 24),

                            // Filter Chips (Figma Node 10:1932)
                            _buildFilterChips(),

                            const SizedBox(height: 20),

                            // Timeline Section (Figma Node 10:1943)
                            _buildTimelineSection(records),
                          ],
                        ),
                      ),
                    ),

                    // Floating Bottom Navigation Shell (Figma Node 10:1888)
                    Positioned(
                      bottom: 14 + MediaQuery.of(context).padding.bottom,
                      child: _buildBottomNav(context),
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

  // ==========================================
  // Header - TopAppBar (Figma Node 10:1913)
  // Height: 56px, px: 24px, py: 8px, background: #F8F9FA
  // ==========================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Back Button (Node 10:1914)
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Color(0xFF28006D),
              ),
            ),
          ),

          // Center: CareID Logo (Node 10:1917, 10:1918)
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            },
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              'assets/images/careid_appbar_clean.png',
              width: 98,
              height: 22.05,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text(
                'CareID',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF28006D),
                ),
              ),
            ),
          ),

          // Right: Doctor Profile Avatar (Node 10:1919, 10:1920)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.doctorProfile);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/doctor_profile_avatar_appbar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFFE8DDFF),
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: Color(0xFF28006D),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Page Title → Heading 2 (Figma Node 10:1922, 10:1923)
  // Text: "Health  Records", 40px, Bold, #5B14B8
  // ==========================================
  Widget _buildPageTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Health  Records',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.8,
          color: Color(0xFF5B14B8),
        ),
      ),
    );
  }

  // ==========================================
  // Search Bar & Filter (Figma Node 10:1924)
  // Input: rounded 9999px, #FFFFFF, border rgba(203,196,212,0.5)
  // Filter icon button (Node 10:1925)
  // ==========================================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Search Input Box (Node 10:1926)
          Expanded(
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: const Color(0x80CBC4D4), // rgba(203,196,212,0.5)
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000), // rgba(0,0,0,0.05)
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  // Search Icon (Node 10:1930)
                  const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Color(0x99494552), // rgba(73,69,82,0.6)
                  ),
                  const SizedBox(width: 12),
                  // Text Field
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF191C1D),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Search records, labs, doctors...',
                        hintStyle: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Color(0x99494552),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
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
                        child: Icon(
                          Icons.cancel,
                          size: 18,
                          color: Color(0xFF7A7583),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Filter Button (Node 10:1925)
          GestureDetector(
            onTap: _openFilterSheet,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(
                Icons.tune_rounded,
                size: 24,
                color: Color(0xFF494552),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Filter Chips (Figma Node 10:1932)
  // Selected: #006971, text white
  // Unselected: #FFFFFF, border rgba(203,196,212,0.4), text #494552
  // ==========================================
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(_categories.length, (index) {
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 20 : 21,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF006971) : Colors.white,
                  borderRadius: BorderRadius.circular(9999),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: const Color(
                            0x66CBC4D4,
                          ), // rgba(203,196,212,0.4)
                          width: 1,
                        ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000), // rgba(0,0,0,0.05)
                      offset: Offset(0, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: isSelected ? Colors.white : const Color(0xFF494552),
                    height: 1.42,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==========================================
  // Timeline Section (Figma Node 10:1943)
  // Vertical timeline line (Node 10:1944)
  // Record Items (Node 10:1945, 10:1983, 10:2021)
  // ==========================================
  Widget _buildTimelineSection(List<MedicalRecordItem> records) {
    if (records.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.folder_open_rounded,
                size: 48,
                color: Color(0xFF7A7583),
              ),
              SizedBox(height: 12),
              Text(
                'No Health Records Found',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191C1D),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Try adjusting your search query or category filters.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xFF494552),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          final isFirst = index == 0;
          final isLast = index == records.length - 1;
          final isToday =
              record.date.toLowerCase().contains('today') || isFirst;

          return _buildTimelineItem(
            context: context,
            record: record,
            isToday: isToday,
            isLast: isLast,
          );
        },
      ),
    );
  }

  /// Single Timeline Item matching Figma Node 10:1945 / 10:1983 / 10:2021
  Widget _buildTimelineItem({
    required BuildContext context,
    required MedicalRecordItem record,
    required bool isToday,
    required bool isLast,
  }) {
    final categoryInfo = _getCategoryVisuals(record.category);
    final isArchived =
        record.flags.contains('Archived') ||
        record.category.toLowerCase().contains('pet');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left: Timeline Tree Node & Vertical Line (Node 10:1944, 10:1982)
          SizedBox(
            width: 24,
            child: Column(
              children: [
                const SizedBox(height: 4), // align with date text
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isToday
                        ? const Color(0xFF006971)
                        : const Color(0xFFCBC4D4),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8F9FA),
                      width: 4,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right: Date & Record Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Label (Node 10:1948, 10:1986, 10:2024)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      record.date,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                        letterSpacing: 0.1,
                        color: isToday
                            ? const Color(0xFF006971)
                            : const Color(0xFF494552),
                        height: 1.42,
                      ),
                    ),
                  ),

                  // Record Card (Node 10:1949, 10:1987, 10:2025)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.medicalRecordDetails,
                        arguments: record,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(21),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(
                            0x33CBC4D4,
                          ), // rgba(203,196,212,0.2)
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000), // rgba(0,0,0,0.05)
                            offset: Offset(0, 1),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Category Icon + Title/Subtitle + Verified Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Icon Container (Node 10:1952)
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0x1A3F1D8B,
                                  ), // rgba(63,29,139,0.1)
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  categoryInfo.icon,
                                  size: 20,
                                  color: const Color(0xFF3F1D8B),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Title & Category Subtitle (Node 10:1955)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title (Node 10:1957)
                                    Text(
                                      record.title,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF191C1D),
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    // Category Subtitle (Node 10:1959)
                                    Text(
                                      categoryInfo.label,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF494552),
                                        height: 1.42,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Badge: Verified (Node 10:1960) or Archived (Node 10:2036)
                              if (isArchived)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDEEEF),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: const Text(
                                    'Archived',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                      color: Color(0xFF494552),
                                      height: 1.33,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0x8076F1FF,
                                    ), // rgba(118,241,255,0.5)
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.verified_rounded,
                                        size: 13,
                                        color: Color(0xFF006D76),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                          color: Color(0xFF006D76),
                                          height: 1.33,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                          // Divider (Node 10:1965)
                          Container(
                            height: 1,
                            color: const Color(
                              0x33CBC4D4,
                            ), // rgba(203,196,212,0.2)
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                          ),

                          // Bottom Row: Facility & Physician (Node 10:1966, 10:1974)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Facility Column
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.apartment_rounded,
                                        size: 15,
                                        color: Color(0xFF494552),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Facility',
                                            style: TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                              color: Color(0xFF494552),
                                              height: 1.33,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            record.facility,
                                            style: const TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF191C1D),
                                              height: 1.42,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Physician Column
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.medical_services_outlined,
                                        size: 15,
                                        color: Color(0xFF494552),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Physician',
                                            style: TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                              color: Color(0xFF494552),
                                              height: 1.33,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            record.doctor,
                                            style: const TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF191C1D),
                                              height: 1.42,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Document Action Row
                          if (record.hasDocument) ...[
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.documentViewer,
                                      arguments: record,
                                    );
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.picture_as_pdf_rounded,
                                        size: 15,
                                        color: Color(0xFF5B14B8),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'View PDF Document',
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF5B14B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) =>
                                          ShareRecordModal(record: record),
                                    );
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: const Icon(
                                    Icons.share_outlined,
                                    size: 16,
                                    color: Color(0xFF494552),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
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

  /// Maps medical record category to icon and user-facing label
  _CategoryVisuals _getCategoryVisuals(String category) {
    final catLower = category.toLowerCase();
    if (catLower.contains('lab')) {
      return _CategoryVisuals(
        icon: Icons.science_outlined,
        label: 'Lab Report',
      );
    }
    if (catLower.contains('imaging') ||
        catLower.contains('mri') ||
        catLower.contains('x-ray') ||
        catLower.contains('scan')) {
      return _CategoryVisuals(
        icon: Icons.document_scanner_outlined,
        label: 'Imaging Scan',
      );
    }
    if (catLower.contains('rx') ||
        catLower.contains('prescription') ||
        catLower.contains('medication')) {
      return _CategoryVisuals(
        icon: Icons.medication_outlined,
        label: 'Prescription (RX)',
      );
    }
    if (catLower.contains('cardiology') || catLower.contains('ecg')) {
      return _CategoryVisuals(
        icon: Icons.monitor_heart_outlined,
        label: 'Cardiology',
      );
    }
    if (catLower.contains('dental')) {
      return _CategoryVisuals(
        icon: Icons.medical_services_outlined,
        label: 'Dental',
      );
    }
    if (catLower.contains('vision')) {
      return _CategoryVisuals(icon: Icons.visibility_outlined, label: 'Vision');
    }
    return _CategoryVisuals(icon: Icons.assignment_outlined, label: category);
  }

  // ==========================================
  // Floating Bottom Navigation Shell (Figma Node 10:1888)
  // Width: 351px, Height: 82px, Rounded: 9999px
  // ==========================================
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
              // 1. Home (Node 10:1911, 10:1912)
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
                          color: Color(0xFF006D76),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients (Node 10:1905)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.patientDirectory,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF76F1FF), // Cyan active pill
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(height: 1),
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
              ),

              // Spacer for Center Action Button
              const SizedBox(width: 56),

              // 4. Schedule (Node 10:1890)
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

              // 5. Profile (Node 10:1895)
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

          // Center Action Button (Node 10:1900, 10:1901)
          Positioned(
            top: -24,
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
                      offset: Offset(0, 25),
                      blurRadius: 50,
                      spreadRadius: -12,
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

class _CategoryVisuals {
  final IconData icon;
  final String label;

  _CategoryVisuals({required this.icon, required this.label});
}

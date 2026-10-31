import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';
import 'filter_records_bottom_sheet.dart';

/// Dental Records Screen
/// Exact Figma Source of Truth: Node 10:7623 ("Dental Records - Timeline")
/// CAREID-AIO-FIGMA: https://www.figma.com/design/9nUU700n9WAPQAXoGT17N6/CAREID-AIO-FIGMA?node-id=10-7623&m=dev
class DentalRecordsScreen extends StatefulWidget {
  final Patient? patientArg;

  const DentalRecordsScreen({super.key, this.patientArg});

  @override
  State<DentalRecordsScreen> createState() => _DentalRecordsScreenState();
}

class _DentalRecordsScreenState extends State<DentalRecordsScreen> {
  int _selectedCategoryIndex = 2; // "Dental" is active (Node 10:7676)
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  /// Categories matching Figma node 10:7669
  final List<String> _categories = [
    'All Records',
    'Medical',
    'Dental',
    'Vision',
    'Clinical Notes',
    'Lab Reports',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
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

  Patient _resolvePatient(BuildContext context) {
    if (widget.patientArg != null) return widget.patientArg!;
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
    return MockData.patients.first;
  }

  List<_DentalTimelineItem> _getDentalTimelineItems(Patient patient) {
    // Exact records shown in Figma Node 10:7623
    final List<_DentalTimelineItem> defaultItems = [
      _DentalTimelineItem(
        record: MedicalRecordItem(
          id: 'dental-1',
          patientId: patient.id,
          title: 'Routine Cleaning & Exam',
          category: 'Dental',
          date: 'Nov 12, 2023',
          doctor: 'Dr. Mark Thompson',
          facility: 'Smile Dental Clinic',
          summary:
              'Bi-annual prophylaxis, scaling, and comprehensive oral cavity examination.',
          flags: ['Verified', 'Prevention'],
        ),
        subtitle: 'Prevention',
        status: 'Verified',
        isVerified: true,
        isLatest: true,
        iconData: Icons.health_and_safety_outlined,
      ),
      _DentalTimelineItem(
        record: MedicalRecordItem(
          id: 'dental-2',
          patientId: patient.id,
          title: 'Panoramic X-Ray',
          category: 'Dental',
          date: 'June 15, 2023',
          doctor: 'Dr. Mark Thompson',
          facility: 'Smile Dental Clinic',
          summary:
              'Full mouth series and panoramic radiograph evaluating third molars.',
          flags: ['Verified', 'Diagnostic Imaging'],
        ),
        subtitle: 'Diagnostic Imaging',
        status: 'Verified',
        isVerified: true,
        isLatest: false,
        iconData: Icons.image_outlined,
      ),
      _DentalTimelineItem(
        record: MedicalRecordItem(
          id: 'dental-3',
          patientId: patient.id,
          title: 'Wisdom Tooth Extraction',
          category: 'Dental',
          date: 'Jan 20, 2023',
          doctor: 'Dr. Sarah Lee',
          facility: 'City Oral Surgery',
          summary:
              'Surgical removal of impacted lower third molars under local anesthesia.',
          flags: ['Archived', 'Oral Surgery'],
        ),
        subtitle: 'Oral Surgery',
        status: 'Archived',
        isVerified: false,
        isLatest: false,
        iconData: Icons.medical_services_outlined,
      ),
    ];

    // If search is active, filter items
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return defaultItems;

    return defaultItems.where((item) {
      final r = item.record;
      return r.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query) ||
          r.doctor.toLowerCase().contains(query) ||
          r.facility.toLowerCase().contains(query) ||
          r.date.toLowerCase().contains(query);
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
    final dentalItems = _getDentalTimelineItems(patient);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Figma Node 10:7623 background gradient:
        // linear-gradient(106.43deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main Scrollable Canvas
              Positioned.fill(
                child: Column(
                  children: [
                    // 1. Header - TopAppBar (Figma Node 10:7650)
                    _buildTopAppBar(context),

                    // Scrollable Timeline Body
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 2. Heading: "Dental Records" (Figma Node 10:7660)
                            _buildScreenHeading(),
                            const SizedBox(height: 24),

                            // 3. Search Bar with Filter (Figma Node 10:7661)
                            _buildSearchBar(),
                            const SizedBox(height: 24),

                            // 4. Horizontal Category Chips (Figma Node 10:7669)
                            _buildCategoryChips(),
                            const SizedBox(height: 32),

                            // 5. Timeline Section (Figma Node 10:7680)
                            _buildTimelineSection(dentalItems),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 6. Floating Bottom Navigation Shell (Figma Node 10:7624)
              Positioned(
                bottom: 14 + MediaQuery.of(context).padding.bottom,
                child: _buildBottomNav(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. Header - TopAppBar (Figma Node 10:7650)
  // Height: 56px, background: #F8F9FA, px: 24px, py: 8px
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
          // Left: Go back button (Node 10:7652)
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

          // Center: CareID Logo (Node 10:7656)
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
              errorBuilder: (context, error, stackTrace) => const Text(
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

          // Right: Doctor Profile Picture (Node 10:7657)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.doctorProfile);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 37,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/doctor_profile_avatar_appbar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE1E3E4),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF494552),
                      size: 22,
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
  // 2. Heading (Figma Node 10:7660)
  // Text: "Dental Records", 40px bold #5B14B8
  // ==========================================
  Widget _buildScreenHeading() {
    return const Text(
      'Dental Records',
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: Color(0xFF5B14B8),
        height: 1.2,
        letterSpacing: -0.8,
      ),
    );
  }

  // ==========================================
  // 3. Search Bar with Filter Icon (Figma Node 10:7661)
  // Full pill, white, border rgba(203,196,212,0.5)
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
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
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search,
            size: 20,
            color: Color(0x99494552), // rgba(73,69,82,0.6)
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                color: Color(0xFF191C1D),
              ),
              decoration: const InputDecoration(
                hintText: 'Search records, labs, doctors...',
                hintStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
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
              onTap: () => _searchController.clear(),
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Color(0xFF494552),
                ),
              ),
            ),
          GestureDetector(
            onTap: _openFilterSheet,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.only(left: 4, right: 18),
              child: Icon(
                Icons.tune_rounded,
                size: 22,
                color: Color(0xFF494552),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. Horizontal Category Chips (Figma Node 10:7669)
  // Height: 38px, Dental is Active (#006971)
  // ==========================================
  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_categories.length, (index) {
          final isSelected = _selectedCategoryIndex == index;
          final title = _categories[index];

          return Padding(
            padding: EdgeInsets.only(
              right: index < _categories.length - 1 ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                if (index == 0 || index == 1) {
                  // Navigate to Medical Records Timeline
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.medicalRecords,
                  );
                } else if (index == 3) {
                  // Navigate to Vision Records
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.visionRecords,
                  );
                } else {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
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
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF494552),
                    ),
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
  // 5. Timeline Section (Figma Node 10:7680)
  // Vertical line at left: 31px, node indicators, cards
  // ==========================================
  Widget _buildTimelineSection(List<_DentalTimelineItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: const [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFFCBC4D4),
              ),
              SizedBox(height: 12),
              Text(
                'No matching dental records found.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  color: Color(0xFF494552),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Left Vertical Divider Line (Figma Node 10:7681)
        Positioned(
          left: 7,
          top: 24,
          bottom: 24,
          child: Container(
            width: 2,
            color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
          ),
        ),

        // Timeline Cards List
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) => _buildTimelineCard(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildTimelineCard(_DentalTimelineItem item) {
    final record = item.record;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Node Indicator (Figma Node 10:7722 / 10:7763 / 10:7802)
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: item.isLatest
                  ? const Color(0xFF006971)
                  : const Color(0xFFCBC4D4),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF8F9FA), width: 4),
            ),
          ),
          const SizedBox(width: 16),

          // Main Card Content Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Label above card (Node 10:7686 / 10:7727 / 10:7768)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    record.date,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: item.isLatest
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: item.isLatest
                          ? const Color(0xFF006971)
                          : const Color(0xFF494552),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),

                // Card Container (Node 10:7687 / 10:7728 / 10:7769)
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
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0x33CBC4D4), // rgba(203,196,212,0.2)
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000), // rgba(0,0,0,0.05)
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header Row (Node 10:7688)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Icon Box (Node 10:7690)
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
                                item.iconData,
                                size: 20,
                                color: const Color(0xFF3F1D8B),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Title & Subtitle
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record.title,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF191C1D),
                                      height: 1.3,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subtitle,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF494552),
                                      letterSpacing: 0.04,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Status Badge (Node 10:7698 / 10:7780)
                            _buildStatusBadge(item),
                          ],
                        ),

                        // Horizontal Divider (Node 10:7703)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            color: const Color(
                              0x33CBC4D4,
                            ), // rgba(203,196,212,0.2)
                          ),
                        ),

                        // Metadata Row: Facility & Physician (Node 10:7703)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Facility
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.business_outlined,
                                      size: 14,
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
                                          'FACILITY',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF494552),
                                            letterSpacing: 0.5,
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
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Right: Physician
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.person_outline_rounded,
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
                                          'PHYSICIAN',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF494552),
                                            letterSpacing: 0.5,
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
                                            height: 1.3,
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(_DentalTimelineItem item) {
    if (item.isVerified) {
      // Verified badge (Node 10:7698)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0x8076F1FF), // rgba(118,241,255,0.5)
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle, size: 13, color: Color(0xFF006D76)),
            SizedBox(width: 4),
            Text(
              'Verified',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF006D76),
                letterSpacing: 0.08,
              ),
            ),
          ],
        ),
      );
    }

    // Archived badge (Node 10:7780)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          color: Color(0xFF494552),
        ),
      ),
    );
  }

  // ==========================================
  // 6. Floating Bottom Navigation Shell (Figma Node 10:7624)
  // Width: 327px, Height: ~64-72px, Rounded: 9999px
  // ==========================================
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      width: 351,
      height: 64,
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
          ),
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 8),
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
              // Home Tab
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF006D76),
                      ),
                    ),
                  ],
                ),
              ),

              // Patients Tab (Active cyan pill)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.patientDirectory);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF76F1FF),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.people_alt_rounded,
                        size: 18,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Patients',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Spacer for Floating QR Button
              const SizedBox(width: 44),

              // Schedule Tab
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.appointmentsOverview);
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF494552),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Tab
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.doctorProfile);
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF494552),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Center Floating Scanner Button (Node 10:7636)
          Positioned(
            top: -20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cameraPermission);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B14B8),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF8F9FF), width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000), // rgba(0,0,0,0.25)
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DentalTimelineItem {
  final MedicalRecordItem record;
  final String subtitle;
  final String status;
  final bool isVerified;
  final bool isLatest;
  final IconData iconData;

  const _DentalTimelineItem({
    required this.record,
    required this.subtitle,
    required this.status,
    required this.isVerified,
    required this.isLatest,
    required this.iconData,
  });
}

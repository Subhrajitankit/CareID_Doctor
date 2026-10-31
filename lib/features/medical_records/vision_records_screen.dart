import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';
import 'filter_records_bottom_sheet.dart';

/// Vision Records Screen
/// Exact Figma Source of Truth: Node 10:7803 ("Vision Records - Timeline")
/// CAREID-AIO-FIGMA: https://www.figma.com/design/9nUU700n9WAPQAXoGT17N6/CAREID-AIO-FIGMA?node-id=10-7803&m=dev
class VisionRecordsScreen extends StatefulWidget {
  final Patient? patientArg;

  const VisionRecordsScreen({super.key, this.patientArg});

  @override
  State<VisionRecordsScreen> createState() => _VisionRecordsScreenState();
}

class _VisionRecordsScreenState extends State<VisionRecordsScreen> {
  int _selectedCategoryIndex = 3; // "Vision" is active (Node 10:7859)
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  bool _isNavigating = false;

  /// Categories matching Figma node 10:7849 + PET category button
  final List<String> _categories = [
    'All Records',
    'Medical',
    'Dental',
    'Vision',
    'PET',
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
      if (args['record'] is MedicalRecordItem) {
        final rec = args['record'] as MedicalRecordItem;
        try {
          return MockData.patients.firstWhere((p) => p.id == rec.patientId);
        } catch (_) {}
      }
    }
    if (args is MedicalRecordItem) {
      try {
        return MockData.patients.firstWhere((p) => p.id == args.patientId);
      } catch (_) {}
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

  List<_VisionTimelineItem> _getVisionTimelineItems(Patient patient) {
    // Exact records shown in Figma Node 10:7803
    final List<_VisionTimelineItem> defaultItems = [
      _VisionTimelineItem(
        record: MedicalRecordItem(
          id: 'vision-1',
          patientId: patient.id,
          title: 'Comprehensive Eye Exam',
          category: 'Vision',
          date: 'Dec 05, 2023',
          doctor: 'Dr. Alice Wong',
          facility: 'ClearView Optometry',
          summary:
              'Visual acuity assessment, refraction check, slit-lamp examination, and IOP measurement.',
          flags: ['Verified', 'Standard Checkup'],
        ),
        subtitle: 'Standard Checkup',
        status: 'Verified',
        isVerified: true,
        isLatest: true,
        iconData: Icons.remove_red_eye_outlined,
      ),
      _VisionTimelineItem(
        record: MedicalRecordItem(
          id: 'vision-2',
          patientId: patient.id,
          title: 'Contact Lens Fitting',
          category: 'Vision',
          date: 'Dec 05, 2023',
          doctor: 'Dr. Alice Wong',
          facility: 'ClearView Optometry',
          summary:
              'Corneal curvature topography, tear film stability testing, and trial lens evaluation.',
          flags: ['Verified', 'Specialized Exam'],
        ),
        subtitle: 'Specialized Exam',
        status: 'Verified',
        isVerified: true,
        isLatest: false,
        iconData: Icons.center_focus_strong_outlined,
      ),
      _VisionTimelineItem(
        record: MedicalRecordItem(
          id: 'vision-3',
          patientId: patient.id,
          title: 'Retinal Imaging',
          category: 'Vision',
          date: 'May 12, 2023',
          doctor: 'Dr. James Carter',
          facility: 'Vision Care Center',
          summary:
              'Digital ultra-widefield retinal fundus photography evaluating macula and vasculature.',
          flags: ['Verified', 'Advanced Diagnostics'],
        ),
        subtitle: 'Advanced Diagnostics',
        status: 'Verified',
        isVerified: true,
        isLatest: false,
        iconData: Icons.document_scanner_outlined,
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
    final visionItems = _getVisionTimelineItems(patient);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Figma Node 10:7803 background gradient:
        // linear-gradient(107.03deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
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
                    // 1. Header - TopAppBar (Figma Node 10:7830)
                    _buildTopAppBar(context, patient),

                    // Scrollable Timeline Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 24,
                          bottom: 130, // Clearance for floating bottom nav
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 2. Heading (Figma Node 10:7840)
                            _buildScreenHeading(),
                            const SizedBox(height: 24),

                            // 3. Search Bar with Filter (Figma Node 10:7841)
                            _buildSearchBar(),
                            const SizedBox(height: 24),

                            // 4. Horizontal Category Chips (Figma Node 10:7849)
                            _buildCategoryChips(context, patient),
                            const SizedBox(height: 32),

                            // 5. Timeline Section (Figma Node 10:7860)
                            _buildTimelineSection(visionItems),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 6. Floating Bottom Navigation Shell (Figma Node 10:7804)
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
  // 1. Header - TopAppBar (Figma Node 10:7830)
  // Height: 56px, background: #F8F9FA, px: 24px, py: 8px
  // ==========================================
  Widget _buildTopAppBar(BuildContext context, [Patient? patient]) {
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
          // Left: Go back button (Node 10:7832)
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.medicalRecords,
                  arguments: patient,
                );
              }
            },
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

          // Center: CareID Logo (Node 10:7836)
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

          // Right: Doctor Profile Picture (Node 10:7837)
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
  // 2. Heading (Figma Node 10:7840)
  // Text: "Vision Records", 40px bold #5B14B8
  // ==========================================
  Widget _buildScreenHeading() {
    return const Text(
      'Vision Records',
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
  // 3. Search Bar with Filter Icon (Figma Node 10:7841)
  // Full pill, white, border rgba(203,196,212,0.5)
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      height: 54,
      width: double.infinity,
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
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          // Search Icon (Node 10:7845)
          const Icon(Icons.search, size: 20, color: Color(0xFF494552)),
          const SizedBox(width: 12),

          // Search Input
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF191C1D),
              ),
              decoration: const InputDecoration(
                hintText: 'Search records, labs, doctors...',
                hintStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0x99494552), // rgba(73,69,82,0.6)
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          // Clear button if searching
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.cancel, size: 18, color: Color(0xFF7A7583)),
              ),
            ),

          // Filter Button (Node 10:7847)
          GestureDetector(
            onTap: _openFilterSheet,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: const Icon(
                Icons.tune_rounded,
                size: 20,
                color: Color(0xFF494552),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. Horizontal Category Chips (Figma Node 10:7849)
  // "Vision" is active (#006971)
  // ==========================================
  Widget _buildCategoryChips(BuildContext context, Patient patient) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(_categories.length, (index) {
          final isSelected = _selectedCategoryIndex == index;
          final title = _categories[index];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                if (title == 'All Records' || title == 'Medical') {
                  if (_isNavigating) return;
                  _isNavigating = true;
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.medicalRecords,
                    arguments: patient,
                  );
                } else if (title == 'Dental') {
                  if (_isNavigating) return;
                  _isNavigating = true;
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.dentalRecords,
                    arguments: patient,
                  );
                } else if (title == 'Vision') {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                } else if (title == 'PET') {
                  if (_isNavigating) return;
                  _isNavigating = true;
                  Navigator.pushNamed(
                    context,
                    AppRoutes.petRecords,
                    arguments: patient,
                  ).then((_) {
                    if (mounted) {
                      setState(() {
                        _isNavigating = false;
                      });
                    }
                  });
                } else {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                }
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
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF494552),
                      letterSpacing: 0.1,
                      height: 1.42,
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
  // 5. Timeline Section (Figma Node 10:7860)
  // Continuous vertical track with node dots and cards
  // ==========================================
  Widget _buildTimelineSection(List<_VisionTimelineItem> items) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFF7A7583),
              ),
              SizedBox(height: 12),
              Text(
                'No Vision Records Found',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191C1D),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Try adjusting your search query or filters.',
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

    return Stack(
      children: [
        // Continuous Vertical Timeline Divider (Node 10:7861)
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

  Widget _buildTimelineCard(_VisionTimelineItem item) {
    final record = item.record;

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Node Indicator (Figma Node 10:7902 / 10:7943)
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
                // Date Label above card (Node 10:7866 / 10:7907 / 10:7948)
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

                // Card Container (Node 10:7867 / 10:7908 / 10:7949)
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
                        // Card Header Row (Node 10:7868)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Icon Box (Node 10:7870)
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

                            // Verified Badge (Node 10:7878 / 10:7919 / 10:7960)
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
                                    'VERIFIED',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF006D76),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Divider (Node 10:7883)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          height: 1,
                          color: const Color(
                            0x33CBC4D4,
                          ), // rgba(203,196,212,0.2)
                        ),

                        // Facility & Physician Metadata Row (Node 10:7884)
                        Row(
                          children: [
                            // Facility
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
                                          'FACILITY',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 12,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Physician
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
                                          'PHYSICIAN',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 12,
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

  // ==========================================
  // 6. Floating Bottom Navigation Shell (Figma Node 10:7804)
  // Width: 351px, Height: 64px, Rounded: 9999px
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

              const SizedBox(width: 44), // Space for center QR button
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

          // Center Raised QR Scanner Button (Node 10:7816)
          Positioned(
            top: -20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cameraPermission);
              },
              behavior: HitTestBehavior.opaque,
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
                      offset: Offset(0, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper model for Vision Records timeline item
class _VisionTimelineItem {
  final MedicalRecordItem record;
  final String subtitle;
  final String status;
  final bool isVerified;
  final bool isLatest;
  final IconData iconData;

  const _VisionTimelineItem({
    required this.record,
    required this.subtitle,
    required this.status,
    required this.isVerified,
    required this.isLatest,
    required this.iconData,
  });
}

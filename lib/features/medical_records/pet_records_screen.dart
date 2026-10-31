import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';
import 'filter_records_bottom_sheet.dart';

/// PET Records Screen
/// Exact Figma Source of Truth: Node 10:7985 ("Pet Records - Timeline")
/// CAREID-AIO-FIGMA: https://www.figma.com/design/9nUU700n9WAPQAXoGT17N6/CAREID-AIO-FIGMA?node-id=10-7985&m=dev
class PetRecordsScreen extends StatefulWidget {
  final Patient? patientArg;

  const PetRecordsScreen({super.key, this.patientArg});

  @override
  State<PetRecordsScreen> createState() => _PetRecordsScreenState();
}

class _PetRecordsScreenState extends State<PetRecordsScreen> {
  int _selectedCategoryIndex = 2; // "Pets" is active (Node 10:8039)
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  bool _isNavigating = false;

  /// Categories matching Figma node 10:8032:
  /// All Records, Medical, Pets (active), Dental, Vision, Clinical Notes, Lab Reports
  final List<String> _categories = [
    'All Records',
    'Medical',
    'Pets',
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

  List<_PetTimelineItem> _getPetTimelineItems(Patient patient) {
    // Exact records shown in Figma Node 10:7985
    final List<_PetTimelineItem> defaultItems = [
      _PetTimelineItem(
        record: MedicalRecordItem(
          id: 'pet-1',
          patientId: patient.id,
          title: 'Annual Vaccination - Buddy',
          category: 'Pet',
          date: 'Jan 10, 2024',
          doctor: 'Dr. Kevin Miller',
          facility: 'Paws & Claws Vet',
          summary:
              'Routine annual core vaccinations administered including rabies and DHPP boosters. Patient in good health.',
          flags: ['Verified', 'Vaccination Record'],
        ),
        subtitle: 'Vaccination Record',
        status: 'Verified',
        isVerified: true,
        isLatest: true,
        iconData: Icons.vaccines_outlined,
      ),
      _PetTimelineItem(
        record: MedicalRecordItem(
          id: 'pet-2',
          patientId: patient.id,
          title: 'Flea & Tick Prevention',
          category: 'Pet',
          date: 'Jan 10, 2024',
          doctor: 'Dr. Kevin Miller',
          facility: 'Paws & Claws Vet',
          summary:
              'Oral parasiticide preventive prescribed and initial dose administered. Next dose in 30 days.',
          flags: ['Verified', 'Routine Preventive'],
        ),
        subtitle: 'Routine Preventive',
        status: 'Verified',
        isVerified: true,
        isLatest: false,
        iconData: Icons.shield_outlined,
      ),
      _PetTimelineItem(
        record: MedicalRecordItem(
          id: 'pet-3',
          patientId: patient.id,
          title: 'Dental Scaling (Canine)',
          category: 'Pet',
          date: 'Aug 22, 2023',
          doctor: 'Dr. Susan Gray',
          facility: 'Pet Health Center',
          summary:
              'Full ultrasonic dental scaling and subgingival curettage under general anesthesia. Gingival score: healthy.',
          flags: ['Verified', 'Specialized Treatment'],
        ),
        subtitle: 'Specialized Treatment',
        status: 'Verified',
        isVerified: true,
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
    final petItems = _getPetTimelineItems(patient);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                    // 1. Header - TopAppBar (Figma Node 10:8013)
                    _buildTopAppBar(context),

                    // Scrollable Timeline Body
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 2. Large Heading: "Pet Records" (Figma Node 10:8023)
                            _buildHeading(),
                            const SizedBox(height: 24),

                            // 3. Search Bar with Filter (Figma Node 10:8025)
                            _buildSearchBar(),
                            const SizedBox(height: 24),

                            // 4. Horizontal Category Chips (Figma Node 10:8032)
                            _buildCategoryChips(context, patient),
                            const SizedBox(height: 32),

                            // 5. Timeline Section (Figma Node 10:8045)
                            _buildTimelineSection(petItems),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 6. Floating Bottom Navigation Shell (Figma Node 10:7986)
              Positioned(bottom: 24, child: _buildBottomNav(context)),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. TopAppBar (Figma Node 10:8013)
  // Height: 56px, #F8F9FA, shadow, back, logo, avatar
  // ==========================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button (Node 10:8015)
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF28006D),
                size: 24,
              ),
            ),
          ),

          // Center CareID Logo (Node 10:8019)
          Image.asset(
            'assets/images/careid_logo.png',
            height: 26,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Care',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003882),
                      ),
                    ),
                    TextSpan(
                      text: 'ID',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00A2D3),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Doctor Profile Picture (Node 10:8020)
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
  // 2. Large Heading (Figma Node 10:8023)
  // Text: "Pet Records", 36-40px bold #5B14B8
  // ==========================================
  Widget _buildHeading() {
    return const Text(
      'Pet Records',
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
  // 3. Search Bar with Filter Icon (Figma Node 10:8025)
  // Full pill, white, border rgba(203,196,212,0.5)
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      height: 48,
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
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 10),
            child: Icon(
              Icons.search_rounded,
              size: 20,
              color: Color(0xFF494552),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
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
              padding: EdgeInsets.only(left: 4, right: 16),
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
  // 4. Horizontal Category Chips (Figma Node 10:8032)
  // Height: 38px, Pets is Active (#006971)
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
                  if (_isNavigating) return;
                  _isNavigating = true;
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.visionRecords,
                    arguments: patient,
                  );
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
  // 5. Timeline Section (Figma Node 10:8045)
  // Continuous vertical track with node dots and cards
  // ==========================================
  Widget _buildTimelineSection(List<_PetTimelineItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: const [
              Icon(Icons.pets_outlined, size: 48, color: Color(0xFFCBC4D4)),
              SizedBox(height: 12),
              Text(
                'No pet records found',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF494552),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Try adjusting your search terms',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  color: Color(0xFF7A7583),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Left Vertical Timeline Track (Node 10:8046)
        Positioned(
          left: 7,
          top: 10,
          bottom: 10,
          child: Container(
            width: 2,
            color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
          ),
        ),

        // Timeline Cards Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final record = item.record;
            final isFirst = index == 0;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : 32,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Node Dot Indicator (Node 10:8087 / 10:8128 / 10:8169)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isFirst
                            ? const Color(0xFF006971)
                            : const Color(0xFFCBC4D4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF8F9FA),
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Main Content: Date Header + Record Card
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Header (Node 10:8051 / 10:8092 / 10:8133)
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 8),
                          child: Text(
                            record.date,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: isFirst
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isFirst
                                  ? const Color(0xFF006971)
                                  : const Color(0xFF494552),
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),

                        // Record Card (Node 10:8052 / 10:8093 / 10:8134)
                        GestureDetector(
                          onTap: () {
                            if (_isNavigating) return;
                            _isNavigating = true;
                            final patient = _resolvePatient(context);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.medicalRecordDetails,
                              arguments: {'patient': patient, 'record': record},
                            ).then((_) {
                              if (mounted) {
                                setState(() {
                                  _isNavigating = false;
                                });
                              }
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(20),
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
                                // Title Row with Icon & Verified Badge
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Record Icon in soft purple container (Node 10:8055)
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0x1A3F1D8B,
                                        ), // rgba(63,29,139,0.1)
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        item.iconData,
                                        size: 20,
                                        color: const Color(0xFF5B14B8),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Title & Subtitle
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            record.title,
                                            style: const TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF191C1D),
                                              height: 1.3,
                                              letterSpacing: 0.04,
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

                                    // Verified Badge (Node 10:8063 / 10:8104 / 10:8145)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0x8076F1FF,
                                        ), // rgba(118,241,255,0.5)
                                        borderRadius: BorderRadius.circular(
                                          9999,
                                        ),
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
                                              color: Color(0xFF006D76),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Divider (Node 10:8068)
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  height: 1,
                                  color: const Color(
                                    0x1ACBC4D4,
                                  ), // rgba(203,196,212,0.1)
                                ),

                                // Facility & Physician Metadata Row (Node 10:8068)
                                Row(
                                  children: [
                                    // Facility
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Icon(
                                              Icons.domain_outlined,
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
                                                  'Facility',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
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
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF191C1D),
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 2),
                                            child: Icon(
                                              Icons.medical_services_outlined,
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
                                                  'Physician',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
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
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF191C1D),
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
          }),
        ),
      ],
    );
  }

  // ==========================================
  // 6. Floating Bottom Navigation Shell (Figma Node 10:7986)
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

          // Center Raised QR Scanner Button (Node 10:7998)
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
                child: const Center(
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 28,
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

class _PetTimelineItem {
  final MedicalRecordItem record;
  final String subtitle;
  final String status;
  final bool isVerified;
  final bool isLatest;
  final IconData iconData;

  const _PetTimelineItem({
    required this.record,
    required this.subtitle,
    required this.status,
    required this.isVerified,
    required this.isLatest,
    required this.iconData,
  });
}

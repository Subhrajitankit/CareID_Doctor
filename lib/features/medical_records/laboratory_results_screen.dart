import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Laboratory Results Summary Screen
/// Matches Figma Node 10:2299 ("Laboratory Results Summary")
class LaboratoryResultsScreen extends StatefulWidget {
  final Patient? patientArg;

  const LaboratoryResultsScreen({super.key, this.patientArg});

  @override
  State<LaboratoryResultsScreen> createState() =>
      _LaboratoryResultsScreenState();
}

class _LaboratoryResultsScreenState extends State<LaboratoryResultsScreen> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Patient _resolvePatient(BuildContext context) {
    if (widget.patientArg != null) return widget.patientArg!;
    final routeArg = ModalRoute.of(context)?.settings.arguments;
    if (routeArg is Patient) return routeArg;
    return MockData.patients.first;
  }

  @override
  Widget build(BuildContext context) {
    final patient = _resolvePatient(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Figma Node 10:2299 Background gradient:
        // linear-gradient(104.32deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
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
                    // 1. Header - TopAppBar (Figma Node 10:2325)
                    _buildTopAppBar(context),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 110),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 2. Header Section (Figma Node 10:2334)
                            _buildHeaderSection(context, patient),
                            const SizedBox(height: 16),

                            // 3. Meta Info Card (Figma Node 10:2349)
                            _buildMetaInfoCard(),
                            const SizedBox(height: 24),

                            // 4. Lab Results Data Table Card (Figma Node 10:2371)
                            _buildLabResultsTableCard(),
                            const SizedBox(height: 24),

                            // 5. Clinical Alerts Card (Figma Node 10:2475)
                            _buildClinicalAlertsCard(),
                            const SizedBox(height: 24),

                            // 6. Physician Notes / Draft Interpretation (Figma Node 10:2492)
                            _buildPhysicianNotesCard(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 7. Floating Bottom Navigation Shell (Figma Node 10:2300)
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
  // 1. Header - TopAppBar (Figma Node 10:2325)
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
          // Left: Back Button (Node 10:2327)
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

          // Center: CareID Logo (Node 10:2330, 10:2331)
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

          // Right: Doctor Profile Picture (Node 10:2332)
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
  // 2. Header Section (Figma Node 10:2334)
  // Height: ~158px
  // ==========================================
  Widget _buildHeaderSection(BuildContext context, Patient patient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtitle: Patient Info (Node 10:2337)
        Text(
          'Patient: ${patient.name} (ID: #${patient.id.replaceAll('p', '8824')})',
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF494552),
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 4),

        // Title: Comprehensive Metabolic Panel (Node 10:2339)
        const Text(
          'Comprehensive\nMetabolic Panel',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5B14B8),
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),

        // Action Buttons Row (Node 10:2340)
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Export PDF Button (Node 10:2341)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Exporting PDF laboratory report...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000), // rgba(0,0,0,0.05)
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.file_download_outlined,
                      size: 14,
                      color: Color(0xFF191C1D),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Export PDF',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF191C1D),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add Clinical Note Button (Node 10:2345)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addAddendum);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Clinical Note',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 3. Meta Info Card (Figma Node 10:2349)
  // Background: #F8F9FA, Border: rgba(203,196,212,0.3), Rounded: 12px
  // ==========================================
  Widget _buildMetaInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetaField(label: 'Collected', value: 'Oct 24, 2023 - 08:30 AM'),
          const SizedBox(height: 20),
          _buildMetaField(label: 'Received', value: 'Oct 24, 2023 - 10:15 AM'),
          const SizedBox(height: 20),
          _buildMetaField(
            label: 'Ordering Physician',
            value: 'Dr. Sarah Jenkins',
          ),
          const SizedBox(height: 20),
          _buildMetaField(label: 'Lab Facility', value: 'Core Diagnostics Lab'),
        ],
      ),
    );
  }

  Widget _buildMetaField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF494552),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1D),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. Lab Results Data Table Card (Figma Node 10:2371)
  // Background: #F8F9FA, Rounded: 12px
  // ==========================================
  Widget _buildLabResultsTableCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header (Node 10:2372)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              color: Colors.white,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const Text(
                        'Lab Results',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Normal Badge (Node 10:2376)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0x4D76F1FF,
                              ), // rgba(118,241,255,0.3)
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(0xFF006971),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '12 Normal',
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
                          const SizedBox(width: 8),

                          // Critical Badge (Node 10:2379)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDAD6),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(0xFFBA1A1A),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '2 Critical',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF93000A),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0x4DCBC4D4)),

            // Horizontally Scrollable Table Canvas (Figma Node 10:2383)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 700,
                child: Column(
                  children: [
                    // Table Header Row (Node 10:2384)
                    Container(
                      height: 52,
                      color: const Color(0xFFF3F4F5),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 150,
                            child: Text(
                              'Test Name',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF494552),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(
                              'Result',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF494552),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              'Reference Range',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF494552),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: Text(
                              'Status',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF494552),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              '6mo Trend',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF494552),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0x33CBC4D4),
                    ),

                    // Row 1: Glucose (Normal)
                    _buildTableRow(
                      testName: 'Glucose',
                      result: '92 mg/dL',
                      refRange: '70 - 99 mg/dL',
                      status: 'Normal',
                      isCritical: false,
                    ),

                    // Row 2: BUN (Normal)
                    _buildTableRow(
                      testName: 'BUN',
                      result: '14 mg/dL',
                      refRange: '6 - 20 mg/dL',
                      status: 'Normal',
                      isCritical: false,
                      isAltBg: true,
                    ),

                    // Row 3: Creatinine (Critical High)
                    _buildTableRow(
                      testName: 'Creatinine',
                      result: '1.5 mg/dL',
                      refRange: '0.6 - 1.2 mg/dL',
                      status: 'High',
                      isCritical: true,
                      isUpTrend: true,
                    ),

                    // Row 4: Sodium (Normal)
                    _buildTableRow(
                      testName: 'Sodium',
                      result: '140 mEq/L',
                      refRange: '135 - 145 mEq/L',
                      status: 'Normal',
                      isCritical: false,
                      isAltBg: true,
                    ),

                    // Row 5: Potassium (Critical Low)
                    _buildTableRow(
                      testName: 'Potassium',
                      result: '3.1 mEq/L',
                      refRange: '3.5 - 5.1 mEq/L',
                      status: 'Low',
                      isCritical: true,
                      isUpTrend: false,
                    ),

                    // Row 6: Calcium (Normal)
                    _buildTableRow(
                      testName: 'Calcium',
                      result: '9.5 mg/dL',
                      refRange: '8.5 - 10.2 mg/dL',
                      status: 'Normal',
                      isCritical: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow({
    required String testName,
    required String result,
    required String refRange,
    required String status,
    required bool isCritical,
    bool isAltBg = false,
    bool isUpTrend = false,
  }) {
    final bgColor = isCritical
        ? const Color(0x33FFDAD6) // rgba(255, 218, 214, 0.2)
        : (isAltBg ? const Color(0x80FFFFFF) : Colors.transparent);

    return Container(
      height: 56,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Test Name with Alert Triangle if Critical
          SizedBox(
            width: 150,
            child: Row(
              children: [
                if (isCritical) ...[
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Color(0xFFBA1A1A),
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    testName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCritical
                          ? const Color(0xFFBA1A1A)
                          : const Color(0xFF191C1D),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Result
          SizedBox(
            width: 120,
            child: Text(
              result,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: isCritical ? FontWeight.w600 : FontWeight.w500,
                color: isCritical
                    ? const Color(0xFFBA1A1A)
                    : const Color(0xFF191C1D),
              ),
            ),
          ),

          // Reference Range
          SizedBox(
            width: 180,
            child: Text(
              refRange,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF494552),
              ),
            ),
          ),

          // Status Badge
          SizedBox(
            width: 110,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCritical ? 10 : 11,
                  vertical: isCritical ? 2 : 3,
                ),
                decoration: BoxDecoration(
                  color: isCritical
                      ? const Color(0xFFBA1A1A)
                      : const Color(0x1A006971), // rgba(0,105,113,0.1)
                  borderRadius: BorderRadius.circular(9999),
                  border: isCritical
                      ? null
                      : Border.all(
                          color: const Color(0x33006971), // rgba(0,105,113,0.2)
                        ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isCritical ? Colors.white : const Color(0xFF006971),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),

          // 6mo Trend Sparkline
          SizedBox(
            width: 80,
            height: 24,
            child: CustomPaint(
              size: const Size(80, 24),
              painter: _SparklinePainter(
                isCritical: isCritical,
                isUpTrend: isUpTrend,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. Clinical Alerts Card (Figma Node 10:2475)
  // Background: rgba(255, 218, 214, 0.1), Border: #FFDAD6
  // ==========================================
  Widget _buildClinicalAlertsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0x1AFFDAD6), // rgba(255, 218, 214, 0.1)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFDAD6), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Round Warning Icon (Node 10:2476)
          Row(
            children: const [
              Icon(Icons.error_rounded, size: 20, color: Color(0xFFBA1A1A)),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Clinical Alerts',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBA1A1A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Alert Bullet 1 (Creatinine)
          _buildAlertBullet(
            boldTitle: 'Creatinine',
            description:
                ' indicates declining renal function compared to previous test (1.2 mg/dL on Apr 12). Recommend follow-up GFR.',
          ),
          const SizedBox(height: 12),

          // Alert Bullet 2 (Hypokalemia)
          _buildAlertBullet(
            boldTitle: 'Hypokalemia',
            description:
                ' noted (3.1 mEq/L). Evaluate current diuretic dosage.',
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBullet({
    required String boldTitle,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFBA1A1A),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                color: Color(0xFF191C1D),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: boldTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: description,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 6. Physician Notes / Draft Interpretation (Figma Node 10:2492)
  // Background: #F8F9FA, Rounded: 12px
  // ==========================================
  Widget _buildPhysicianNotesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Node 10:2493)
          Row(
            children: const [
              Icon(Icons.edit_note_rounded, size: 22, color: Color(0xFF28006D)),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Draft Interpretation',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Textarea (Node 10:2497)
          Container(
            height: 128,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
            ),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _notesController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                color: Color(0xFF191C1D),
              ),
              decoration: const InputDecoration(
                hintText: 'Enter clinical interpretation here...',
                hintStyle: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Buttons Row (Node 10:2500)
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // Save Draft Button (Node 10:2501)
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Draft interpretation saved.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: const Text(
                    'Save Draft',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF28006D),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),

              // Sign & Finalize Button (Node 10:2503)
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Report signed and finalized successfully.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF28006D),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'Sign & Finalize',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. Floating Bottom Navigation Shell (Figma Node 10:2300)
  // Width: 351px, Height: ~64px, Rounded: 9999px
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

          // Center Floating Scanner Button (Node 10:2312, 10:2313)
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

/// Custom Sparkline Trend Painter
class _SparklinePainter extends CustomPainter {
  final bool isCritical;
  final bool isUpTrend;

  const _SparklinePainter({required this.isCritical, this.isUpTrend = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCritical ? const Color(0xFFBA1A1A) : const Color(0xFF006971)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    if (isCritical) {
      if (isUpTrend) {
        // Creatinine trending up: 0,20 -> 16,19.2 -> 32,16 -> 48,12 -> 64,8 -> 80,4
        path.moveTo(0, size.height * 0.85);
        path.lineTo(size.width * 0.2, size.height * 0.8);
        path.lineTo(size.width * 0.4, size.height * 0.65);
        path.lineTo(size.width * 0.6, size.height * 0.5);
        path.lineTo(size.width * 0.8, size.height * 0.35);
        path.lineTo(size.width, size.height * 0.15);
        canvas.drawPath(path, paint);

        final dotPaint = Paint()
          ..color = const Color(0xFFBA1A1A)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(size.width, size.height * 0.15),
          3.0,
          dotPaint,
        );
      } else {
        // Potassium trending down
        path.moveTo(0, size.height * 0.2);
        path.lineTo(size.width * 0.2, size.height * 0.3);
        path.lineTo(size.width * 0.4, size.height * 0.45);
        path.lineTo(size.width * 0.6, size.height * 0.6);
        path.lineTo(size.width * 0.8, size.height * 0.75);
        path.lineTo(size.width, size.height * 0.9);
        canvas.drawPath(path, paint);

        final dotPaint = Paint()
          ..color = const Color(0xFFBA1A1A)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(size.width, size.height * 0.9), 3.0, dotPaint);
      }
    } else {
      // Normal stable waveform: 0,16 -> 16,14.4 -> 32,17.6 -> 48,15.2 -> 64,16.8 -> 80,12
      path.moveTo(0, size.height * 0.65);
      path.lineTo(size.width * 0.2, size.height * 0.6);
      path.lineTo(size.width * 0.4, size.height * 0.7);
      path.lineTo(size.width * 0.6, size.height * 0.62);
      path.lineTo(size.width * 0.8, size.height * 0.68);
      path.lineTo(size.width, size.height * 0.5);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.isCritical != isCritical ||
      oldDelegate.isUpTrend != isUpTrend;
}

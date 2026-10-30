import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';
import 'share_record_modal.dart';

/// Medical Record Details Screen
/// Exact Figma Source of Truth: Node 10:2057 ("Medical Record Details")
/// CAREID-AIO-FIGMA: https://www.figma.com/design/9nUU700n9WAPQAXoGT17N6/CAREID-AIO-FIGMA?node-id=10-2057&m=dev
class MedicalRecordDetailsScreen extends StatelessWidget {
  final MedicalRecordItem? recordArg;

  const MedicalRecordDetailsScreen({super.key, this.recordArg});

  /// Dynamically resolves the MedicalRecordItem from widget prop, ModalRoute argument, or MockData
  MedicalRecordItem _resolveRecord(BuildContext context) {
    if (recordArg != null) return recordArg!;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is MedicalRecordItem) return args;
    if (args is String) {
      try {
        return MockData.records.firstWhere((r) => r.id == args);
      } catch (_) {}
    }
    if (args is Map<String, dynamic>) {
      if (args['record'] is MedicalRecordItem) {
        return args['record'] as MedicalRecordItem;
      }
      if (args['id'] is String) {
        try {
          return MockData.records.firstWhere((r) => r.id == args['id']);
        } catch (_) {}
      }
    }
    return MockData.records.first;
  }

  @override
  Widget build(BuildContext context) {
    final record = _resolveRecord(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Figma Node 10:2057 background gradient:
        // linear-gradient(99.05deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
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
              // Header - TopAppBar (Figma Node 10:2083)
              _buildTopAppBar(context, record),

              // Scrollable Canvas with Floating Bottom Nav
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Main Content Canvas (Figma Node 10:2099)
                    Positioned.fill(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Document Thumbnail Preview (Figma Node 10:2101)
                            _buildDocumentPreviewCard(context, record),
                            const SizedBox(height: 24),

                            // 2. Details Header & Metadata Card (Figma Node 10:2128)
                            _buildDetailsHeaderCard(context, record),
                            const SizedBox(height: 24),

                            // 3. Clinical Notes & Findings Card (Figma Node 10:2166)
                            _buildClinicalNotesCard(context, record),
                            const SizedBox(height: 24),

                            // 4. AI Summary / Extracted Insights (Figma Node 10:2197)
                            _buildAiInsightsCard(),
                            const SizedBox(height: 24),

                            // 5. Related Records / Previous Reports (Figma Node 10:2222)
                            _buildRelatedRecordsCard(context),
                          ],
                        ),
                      ),
                    ),

                    // Floating Bottom Navigation Shell (Figma Node 10:2058)
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
  // Header - TopAppBar (Figma Node 10:2083)
  // Height: 72px, px: 24px, py: 8px, background: #F8F9FA
  // ==========================================
  Widget _buildTopAppBar(BuildContext context, MedicalRecordItem record) {
    return Container(
      height: 72,
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
          // Left Group: Back Button + Title (Node 10:2084)
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(width: 12),
                const Flexible(
                  child: Text(
                    'Record  Details',
                    overflow: TextOverflow.ellipsis,
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
          ),
          const SizedBox(width: 8),

          // Right Group: Share + Document + Doctor Avatar (Node 10:2090)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Share Button (Node 10:2091)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => ShareRecordModal(record: record),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36,
                  height: 34,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: Color(0xFF494552),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Document Viewer Button (Node 10:2094)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.documentViewer,
                    arguments: record,
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 18,
                    color: Color(0xFF494552),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Doctor Profile Avatar (Node 10:2097, 10:2098)
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
                    border: Border.all(
                      color: const Color(0xFFCBC4D4),
                      width: 1,
                    ),
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
        ],
      ),
    );
  }

  // ==========================================
  // 1. Document Thumbnail Preview (Figma Node 10:2101)
  // Outer card: 342w x 503h, padding: 21px
  // Inner document sheet: 300w x 420h (aspectRatio: 1 / 1.4)
  // Abstract lines, 6-bar medical data chart (#006971, #BA1A1A)
  // Metadata pill: "2 Pages • PDF • 1.2 MB"
  // ==========================================
  Widget _buildDocumentPreviewCard(
    BuildContext context,
    MedicalRecordItem record,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
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
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Document Sheet Preview Container (Node 10:2109)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.documentViewer,
                arguments: record,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: AspectRatio(
              aspectRatio: 1 / 1.4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E3E4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Bar (Node 10:2110: w=266, h=24)
                      Container(
                        width: double.infinity,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E8E9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Line 1 (Node 10:2111: w=234, h=12)
                      FractionallySizedBox(
                        widthFactor: 0.88,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7E8E9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Line 2 (Node 10:2112: w=250, h=12)
                      FractionallySizedBox(
                        widthFactor: 0.94,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7E8E9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Line 3 (Node 10:2113: w=202, h=12)
                      FractionallySizedBox(
                        widthFactor: 0.76,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7E8E9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Chart Graphic Container (Node 10:2114: w=266, h=128)
                      Container(
                        width: double.infinity,
                        height: 128,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        decoration: BoxDecoration(
                          color: const Color(0x1A3F1D8B), // rgba(63,29,139,0.1)
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(
                              0x333F1D8B,
                            ), // rgba(63,29,139,0.2)
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildChartBar(
                              47.19 / 128,
                              const Color(0x66006971),
                            ),
                            const SizedBox(width: 4),
                            _buildChartBar(
                              82.59 / 128,
                              const Color(0x99006971),
                            ),
                            const SizedBox(width: 4),
                            _buildChartBar(
                              106.19 / 128,
                              const Color(0x80BA1A1A),
                            ),
                            const SizedBox(width: 4),
                            _buildChartBar(
                              35.39 / 128,
                              const Color(0x4D006971),
                            ),
                            const SizedBox(width: 4),
                            _buildChartBar(
                              70.80 / 128,
                              const Color(0x80006971),
                            ),
                            const SizedBox(width: 4),
                            _buildChartBar(
                              94.39 / 128,
                              const Color(0xCC006971),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Document Metadata Pill: "2 Pages • PDF • 1.2 MB" (Node 10:2124)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEEF),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.description_outlined,
                    size: 12,
                    color: Color(0xFF494552),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '2 Pages • PDF • 1.2 MB',
                    style: TextStyle(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(double heightFactor, Color color) {
    return Expanded(
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 2. Details Header & Metadata Card (Figma Node 10:2128)
  // Title, Facility, Open Full Document, Key Metadata Grid
  // ==========================================
  Widget _buildDetailsHeaderCard(
    BuildContext context,
    MedicalRecordItem record,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
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
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag & Date Row (Node 10:2131)
          Row(
            children: [
              // "VERIFIED" Badge (Node 10:2132)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF76F1FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'VERIFIED',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: Color(0xFF006D76),
                    height: 1.33,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Added Date (Node 10:2134)
              Expanded(
                child: Text(
                  'Added on ${record.date}, 09:15 AM',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Color(0xFF494552),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Heading 2: Record Title (Node 10:2136, 10:2137)
          Text(
            record.title,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: Color(0xFF191C1D),
            ),
          ),
          const SizedBox(height: 8),

          // Facility Location Row (Node 10:2138)
          Row(
            children: [
              const Icon(
                Icons.apartment_rounded,
                size: 15,
                color: Color(0xFF494552),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record.facility,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF494552),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Button: "Open Full Document" (Node 10:2142)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.documentViewer,
                arguments: record,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF006971),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Open Full Document',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Divider (Node 10:2147)
          Container(
            height: 1,
            color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
            margin: const EdgeInsets.only(top: 24, bottom: 24),
          ),

          // Key Metadata Grid (Node 10:2147, 10:2148)
          // 1. ORDERING PHYSICIAN
          const Text(
            'ORDERING PHYSICIAN',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              color: Color(0xFF494552),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            record.doctor,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // 2. DEPARTMENT
          const Text(
            'DEPARTMENT',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              color: Color(0xFF494552),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            record.category,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // 3. PRIMARY DIAGNOSIS CONTEXT
          const Text(
            'PRIMARY DIAGNOSIS CONTEXT',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              color: Color(0xFF494552),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDAD6),
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                color: const Color(0x33BA1A1A), // rgba(186,26,26,0.2)
                width: 1,
              ),
            ),
            child: Text(
              record.flags.isNotEmpty ? record.flags.first : 'Hyperlipidemia',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: Color(0xFF93000A),
                height: 1.33,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. Clinical Notes & Findings Card (Figma Node 10:2166)
  // Heading, Summary Narrative, Key Findings, Recommendation, Add Addendum
  // ==========================================
  Widget _buildClinicalNotesCard(
    BuildContext context,
    MedicalRecordItem record,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
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
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Node 10:2167)
          Container(
            padding: const EdgeInsets.only(bottom: 13),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.notes_rounded, size: 18, color: Color(0xFF191C1D)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Clinical Notes',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Narrative Text (Node 10:2172, 10:2173)
          Text(
            record.summary,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFF494552),
              height: 1.625,
            ),
          ),
          const SizedBox(height: 16),

          // Key Findings Header (Node 10:2174, 10:2175)
          const Text(
            'Key Findings:',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF494552),
              height: 1.625,
            ),
          ),
          const SizedBox(height: 8),

          // Findings List (Node 10:2176)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBulletItem('Total Cholesterol: 245 mg/dL (High)'),
                _buildBulletItem('LDL: 160 mg/dL (High)'),
                _buildBulletItem('HDL: 42 mg/dL (Borderline Low)'),
                _buildBulletItem('Triglycerides: 215 mg/dL (High)'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recommendation (Node 10:2189, 10:2190)
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                color: Color(0xFF494552),
                height: 1.625,
              ),
              children: [
                TextSpan(
                  text: 'Recommendation: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'Increase Atorvastatin to 40mg daily. Discussed lifestyle modifications including dietary changes (Mediterranean diet) and increased cardiovascular exercise. Schedule follow-up lipid panel in 3 months.',
                ),
              ],
            ),
          ),

          // Existing Addendums (if any)
          if (record.addendums.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Appended Addendums:',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF28006D),
              ),
            ),
            const SizedBox(height: 8),
            ...record.addendums.map(
              (addendum) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0x33CBC4D4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    addendum,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
              ),
            ),
          ],

          // Divider (Node 10:2191)
          Container(
            height: 1,
            color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
            margin: const EdgeInsets.only(top: 20, bottom: 16),
          ),

          // Add Addendum Action Button (Node 10:2192)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.addAddendum,
                  arguments: record,
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 20,
                      color: Color(0xFF28006D),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Addendum',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF28006D),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF494552),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                color: Color(0xFF494552),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. AI Extracted Insights Card (Figma Node 10:2197)
  // Sparkles icon, LDL Trend, Critical Values, Medication Match
  // ==========================================
  Widget _buildAiInsightsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0x0D3F1D8B), // rgba(63,29,139,0.05)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x333F1D8B), // rgba(63,29,139,0.2)
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Node 10:2198)
          Row(
            children: const [
              Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: Color(0xFF28006D),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Extracted Insights',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. LDL Trend (Node 10:2203)
          Container(
            padding: const EdgeInsets.only(bottom: 9),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0x33CBC4D4), // rgba(203,196,212,0.2)
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'LDL Trend',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      color: Color(0xFF494552),
                      height: 1.5,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: Color(0xFFBA1A1A),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+12%',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        color: Color(0xFFBA1A1A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Critical Values (Node 10:2210)
          Container(
            padding: const EdgeInsets.only(bottom: 9),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0x33CBC4D4), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Critical Values',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      color: Color(0xFF494552),
                      height: 1.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDAD6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '2 Identified',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF93000A),
                      height: 1.33,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Medication Match (Node 10:2215)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Medication Match',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    color: Color(0xFF494552),
                    height: 1.5,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.verified_rounded,
                    size: 15,
                    color: Color(0xFF006971),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Aligned',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      color: Color(0xFF006971),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. Related Records / Previous Reports Card (Figma Node 10:2222)
  // ==========================================
  Widget _buildRelatedRecordsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
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
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Node 10:2223)
          const Text(
            'Previous Reports',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Report 1: Jun 12, 2023 (Node 10:2226)
          _buildPreviousReportItem(
            context: context,
            title: 'Lipid Panel',
            date: 'Jun 12, 2023',
          ),
          const SizedBox(height: 12),

          // Report 2: Jan 05, 2023 (Node 10:2235)
          _buildPreviousReportItem(
            context: context,
            title: 'Lipid Panel',
            date: 'Jan 05, 2023',
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousReportItem({
    required BuildContext context,
    required String title,
    required String date,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.documentViewer,
          arguments: MockData.records.first,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            // File Icon Box (Node 10:2227)
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE1E3E4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 20,
                color: Color(0xFF494552),
              ),
            ),
            const SizedBox(width: 12),

            // Title & Date (Node 10:2230)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
                      height: 1.5,
                    ),
                  ),
                  Text(
                    date,
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
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Floating Bottom Navigation Shell (Figma Node 10:2058)
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
              // 1. Home (Node 10:2081, 10:2082)
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

              // 2. Patients (Node 10:2075)
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
                        horizontal: 12,
                        vertical: 4,
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

              // 4. Schedule (Node 10:2060)
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

              // 5. Profile (Node 10:2065)
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

          // Center Action Button (Node 10:2070, 10:2071)
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

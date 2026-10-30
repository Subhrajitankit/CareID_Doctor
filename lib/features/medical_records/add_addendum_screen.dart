import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Add Addendum Screen
/// Exact Figma Source of Truth: Node 10:7439 ("Add Addendum Screen")
/// CAREID-AIO-FIGMA: https://www.figma.com/design/9nUU700n9WAPQAXoGT17N6/CAREID-AIO-FIGMA?node-id=10-7439&m=dev
class AddAddendumScreen extends StatefulWidget {
  final MedicalRecordItem? recordArg;

  const AddAddendumScreen({super.key, this.recordArg});

  @override
  State<AddAddendumScreen> createState() => _AddAddendumScreenState();
}

class _AddAddendumScreenState extends State<AddAddendumScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Resolves the MedicalRecordItem from widget prop, ModalRoute argument, or fallback
  MedicalRecordItem _resolveRecord(BuildContext context) {
    if (widget.recordArg != null) return widget.recordArg!;
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

  void _submitAddendum(MedicalRecordItem record) {
    final text = _notesController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter clinical addendum notes')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Append to existing record's addendums list
    final timestamp =
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
    record.addendums.add('[$timestamp] Dr. Sarah Jenkins: $text');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Addendum digitally signed by ${MockData.doctorName} and recorded to vault.',
        ),
        backgroundColor: const Color(0xFF006971),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final record = _resolveRecord(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Figma Node 10:7439 background gradient:
        // linear-gradient(111.22deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
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
              // Header (Figma Node 10:7476)
              _buildHeader(context),

              // Scrollable Canvas with Floating Bottom Nav
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Main Content Scrollable Canvas (Figma Node 10:7441)
                    Positioned.fill(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 130),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Appended to Record Summary Card (Figma Node 10:7442)
                            _buildAppendedRecordCard(record),
                            const SizedBox(height: 24),

                            // 2. Addendum Details Form Section (Figma Node 10:7457)
                            _buildAddendumDetailsSection(),
                            const SizedBox(height: 24),

                            // 3. Action Buttons: Save Addendum & Cancel (Figma Node 10:7469)
                            _buildActionButtons(context, record),
                          ],
                        ),
                      ),
                    ),

                    // Floating Bottom Navigation Shell (Figma Node 10:7486)
                    Positioned(
                      bottom: 24 + MediaQuery.of(context).padding.bottom,
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
  // Header (Figma Node 10:7476)
  // Height: 56px, bg: #F8F9FA, px: 24px, py: 8px
  // Back button, "Add Addendum" title, Doctor avatar
  // ==========================================
  Widget _buildHeader(BuildContext context) {
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
          // Left Group: Back Button + Title (Node 10:7477)
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
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Add Addendum',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0391,
                      color: Color(0xFF28006D),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right Group: Doctor Profile Picture (Node 10:7484)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE1E3E4),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/doctor_profile_avatar_appbar.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person, color: Color(0xFF494552), size: 24),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 1. Appended to Record Summary Card (Figma Node 10:7442)
  // Section: 327w x 154h, p=20px, rounded=12px, bg=white
  // Icon + "APPENDED TO RECORD", Title, Facility, "VERIFIED" badge
  // ==========================================
  Widget _buildAppendedRecordCard(MedicalRecordItem record) {
    return Container(
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
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Icon + "APPENDED TO RECORD" (Node 10:7443)
          Row(
            children: const [
              Icon(
                Icons.description_outlined,
                size: 14,
                color: Color(0xFF494552),
              ),
              SizedBox(width: 8),
              Text(
                'APPENDED TO RECORD',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  color: Color(0xFF494552),
                  height: 1.33,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Heading 2: Record Title + Date (Node 10:7448, 10:7450)
          Text(
            '${record.title} - ${record.date}',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.33,
            ),
          ),
          const SizedBox(height: 4),

          // Facility & Department (Node 10:7451, 10:7452)
          Text(
            '${record.facility} • ${record.category}',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF494552),
              height: 1.43,
            ),
          ),
          const SizedBox(height: 12),

          // "VERIFIED" Badge (Node 10:7455, 10:7456)
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
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: Color(0xFF006D76),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. Addendum Details Form Section (Figma Node 10:7457)
  // Label: Note icon + "Addendum Details"
  // Textarea: 327w x 334h, rounded 12px, border rgba(203,196,212,0.4), p=16px
  // Helper note below: "Note: This addendum will be permanently attached..."
  // ==========================================
  Widget _buildAddendumDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (Node 10:7458)
        Row(
          children: const [
            Icon(Icons.edit_note_rounded, size: 18, color: Color(0xFF28006D)),
            SizedBox(width: 8),
            Text(
              'Addendum Details',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.0313,
                color: Color(0xFF28006D),
                height: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Textarea Box with Inner Shadow & Border (Node 10:7462)
        Container(
          width: double.infinity,
          height: 334,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0x66CBC4D4), // rgba(203,196,212,0.4)
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // inset rgba(0,0,0,0.05)
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: TextField(
            controller: _notesController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFF191C1D),
              height: 1.625,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: 'Enter the clinical addendum here...',
              hintStyle: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF9CA3AF),
                height: 1.625,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Helper Note (Node 10:7466, 10:7468)
        const Text(
          'Note: This addendum will be permanently attached to the lipid profile record.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.normal,
            color: Color(0xFF494552),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. Action Buttons: Save Addendum & Cancel (Figma Node 10:7469)
  // Button 1: Save Addendum (Node 10:7470: h=52px, bg=#006971, rounded 9999px)
  // Button 2: Cancel (Node 10:7473: h=50px, border rgba(40,0,109,0.2), rounded 9999px)
  // ==========================================
  Widget _buildActionButtons(BuildContext context, MedicalRecordItem record) {
    return Column(
      children: [
        // Button 1: "Save Addendum" (Node 10:7470)
        GestureDetector(
          onTap: _isSubmitting ? null : () => _submitAddendum(record),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF006971),
              borderRadius: BorderRadius.circular(9999),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33006971), // rgba(0,105,113,0.2)
                  offset: Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Save Addendum',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0313,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),

        // Button 2: "Cancel" (Node 10:7473)
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                color: const Color(0x3328006D), // rgba(40,0,109,0.2)
                width: 1,
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF28006D),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Floating Bottom Navigation Shell (Figma Node 10:7486)
  // Width: 351px, Height: 82px, Rounded: 9999px, bg: white
  // Center FAB: 64x64, bg=#5B14B8
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
            color: Color(0x14000000), // rgba(0,0,0,0.08)
            offset: Offset(0, 10),
            blurRadius: 15,
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
              // 1. Home (Node 10:7487)
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
                          letterSpacing: 0.0977,
                          color: Color(0xFF006D76),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients (Node 10:7492)
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
                        vertical: 6,
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
                              letterSpacing: 0.0781,
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

              // 3. Schedule (Node 10:7498)
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

              // 4. Profile (Node 10:7503)
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
                          letterSpacing: 0.1563,
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

          // Center Action Button (Node 10:7508, 10:7509)
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
                      color: Color(0x26000000), // rgba(0,0,0,0.15)
                      offset: Offset(0, 10),
                      blurRadius: 15,
                      spreadRadius: -3,
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

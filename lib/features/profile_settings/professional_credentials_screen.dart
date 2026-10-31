import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Professional Credentials Screen — Pixel-perfect reproduction of Figma node 10:8170
/// (CAREID-AIO-FIGMA)
///
/// Single source of truth for visual design: Figma node 10:8170
/// Single source of truth for business logic/data: CAREiD Doctor codebase
class ProfessionalCredentialsScreen extends StatefulWidget {
  final String? deaLicense;
  final String? educationCredits;
  final String? certifications;
  final String? npdbStatus;
  final String? npiNumber;
  final String? einNumber;
  final String? lastSyncTime;

  const ProfessionalCredentialsScreen({
    super.key,
    this.deaLicense,
    this.educationCredits,
    this.certifications,
    this.npdbStatus,
    this.npiNumber,
    this.einNumber,
    this.lastSyncTime,
  });

  @override
  State<ProfessionalCredentialsScreen> createState() =>
      _ProfessionalCredentialsScreenState();
}

class _ProfessionalCredentialsScreenState
    extends State<ProfessionalCredentialsScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Dynamic values matching Figma frame 10:8170 defaults
    final deaLicense =
        widget.deaLicense ??
        args?['deaLicense'] as String? ??
        'Active: AM774219';
    final educationCredits =
        widget.educationCredits ??
        args?['educationCredits'] as String? ??
        '12 Credits YTD';
    final certifications =
        widget.certifications ??
        args?['certifications'] as String? ??
        'ABIM Certified';
    final npdbStatus =
        widget.npdbStatus ?? args?['npdbStatus'] as String? ?? 'No Flags Found';
    final npiNumber =
        widget.npiNumber ?? args?['npiNumber'] as String? ?? '1982736450';
    final einNumber =
        widget.einNumber ?? args?['einNumber'] as String? ?? 'XX-XXX8842';
    final lastSyncTime =
        widget.lastSyncTime ??
        args?['lastSyncTime'] as String? ??
        'Last sync: Oct 24, 2024 at 10:45 AM';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.95, -0.3),
            end: Alignment(0.95, 0.3),
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
              // 1. Header - TopAppBar (Node 10:8213)
              _buildTopAppBar(context),

              // 2. Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section: Title & Subtitle (Node 10:8224)
                      _buildHeaderSection(),
                      const SizedBox(height: 24),

                      // 2x3 Bento Grid of Credential Cards (Node 10:8233)
                      _buildCredentialsGrid(
                        deaLicense: deaLicense,
                        educationCredits: educationCredits,
                        certifications: certifications,
                        npdbStatus: npdbStatus,
                        npiNumber: npiNumber,
                        einNumber: einNumber,
                      ),
                      const SizedBox(height: 24),

                      // Card: Identity Verification (Node 10:8288)
                      _buildIdentityVerificationCard(),
                      const SizedBox(height: 20),

                      // Footer Verification Status & Sync (Node 10:8309)
                      _buildFooterStatus(lastSyncTime),
                      const SizedBox(height: 24),

                      // Floating Update Credentials Action Pill Bar (Node 10:8200)
                      _buildUpdateCredentialsBar(context),

                      // Spacing for floating bottom navigation shell
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Center(heightFactor: 1.0, child: _buildBottomNav(context)),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. Header - TopAppBar (Figma Node 10:8213, 10:8214)
  // Height: 64px, Background: #F3F4F5, Shadow: 0 1px 1px rgba(0,0,0,0.05)
  // ==========================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F5),
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
          // Left: Go Back Button (Node 10:8216, 10:8217)
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.doctorProfile,
                );
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 48,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Color(0xFF28006D),
              ),
            ),
          ),

          // Center: CareID Logo (Node 10:8220)
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

          // Right: Doctor Profile Avatar (Node 10:8221, 10:8222)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE7E8E9), width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/doctor_profile_avatar_topbar.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Image.asset(
                  'assets/images/doctor_vance_avatar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.person,
                    size: 22,
                    color: Color(0xFF494552),
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
  // Header Section: Title & Subtitle (Figma Node 10:8224)
  // Icon in rgba(40,0,109,0.1) container + Title 20px bold + Subtitle 14px
  // ==========================================
  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Icon Box (Node 10:8225, 10:8226)
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0x1A28006D), // rgba(40,0,109,0.1)
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.badge_outlined,
              size: 20,
              color: Color(0xFF28006D),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Title and Subtitle (Node 10:8228)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Professional Credentials',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191C1D),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Review your active medical licenses and IDs',
                style: TextStyle(
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
      ],
    );
  }

  // ==========================================
  // 2x3 Bento Grid of Credential Cards (Figma Node 10:8233)
  // Row 1: DEA License (Blue) | Education Credit (Emerald)
  // Row 2: Certifications (Orange) | NPDB: Letters (Purple)
  // Row 3: Personal NPI (Rose) | EIN Number (Cyan)
  // ==========================================
  Widget _buildCredentialsGrid({
    required String deaLicense,
    required String educationCredits,
    required String certifications,
    required String npdbStatus,
    required String npiNumber,
    required String einNumber,
  }) {
    return Column(
      children: [
        // Row 1
        Row(
          children: [
            // Card 1: DEA License (Node 10:8234)
            Expanded(
              child: _buildBentoCard(
                bgColor: const Color(0xFFEFF6FF),
                borderColor: const Color(0xFFDBEAFE),
                iconBgColor: const Color(0x333B82F6), // rgba(59,130,246,0.2)
                iconColor: const Color(0xFF3B82F6),
                icon: Icons.assignment_ind_outlined,
                title: 'DEA License',
                value: deaLicense,
                valueColor: const Color(0xFF1D4ED8),
              ),
            ),
            const SizedBox(width: 16),

            // Card 2: Education Credit (Node 10:8243)
            Expanded(
              child: _buildBentoCard(
                bgColor: const Color(0xFFECFDF5),
                borderColor: const Color(0xFFD1FAE5),
                iconBgColor: const Color(0x3310B981), // rgba(16,185,129,0.2)
                iconColor: const Color(0xFF10B981),
                icon: Icons.school_outlined,
                title: 'Education Credit',
                value: educationCredits,
                valueColor: const Color(0xFF047857),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 2
        Row(
          children: [
            // Card 3: Certifications (Node 10:8252)
            Expanded(
              child: _buildBentoCard(
                bgColor: const Color(0xFFFFF7ED),
                borderColor: const Color(0xFFFFEDD5),
                iconBgColor: const Color(0x33F97316), // rgba(249,115,22,0.2)
                iconColor: const Color(0xFFF97316),
                icon: Icons.workspace_premium_outlined,
                title: 'Certifications',
                value: certifications,
                valueColor: const Color(0xFFC2410C),
              ),
            ),
            const SizedBox(width: 16),

            // Card 4: NPDB: Letters (Node 10:8261)
            Expanded(
              child: _buildBentoCard(
                bgColor: const Color(0xFFFAF5FF),
                borderColor: const Color(0xFFF3E8FF),
                iconBgColor: const Color(0x33A855F7), // rgba(168,85,247,0.2)
                iconColor: const Color(0xFFA855F7),
                icon: Icons.shield_outlined,
                title: 'NPDB: Letters',
                value: npdbStatus,
                valueColor: const Color(0xFF7E22CE),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Row 3
        Row(
          children: [
            // Card 5: Personal NPI (Node 10:8270)
            Expanded(
              child: _buildBentoCard(
                bgColor: const Color(0xFFFFF1F2),
                borderColor: const Color(0xFFFFE4E6),
                iconBgColor: const Color(0x33F43F5E), // rgba(244,63,94,0.2)
                iconColor: const Color(0xFFF43F5E),
                icon: Icons.person_outline_rounded,
                title: 'Personal NPI',
                value: npiNumber,
                valueColor: const Color(0xFFBE123C),
              ),
            ),
            const SizedBox(width: 16),

            // Card 6: EIN Number (Node 10:8279)
            Expanded(
              child: _buildBentoCard(
                bgColor: const Color(0xFFECFEFF),
                borderColor: const Color(0xFFCFFAFE),
                iconBgColor: const Color(0x3306B6D4), // rgba(6,182,212,0.2)
                iconColor: const Color(0xFF06B6D4),
                icon: Icons.business_outlined,
                title: 'EIN Number',
                value: einNumber,
                valueColor: const Color(0xFF0E7490),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoCard({
    required Color bgColor,
    required Color borderColor,
    required Color iconBgColor,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
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
          // Icon Container (size 32x32, rounded 8px)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 16)),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF191C1D),
              height: 1.42,
            ),
          ),
          const SizedBox(height: 4),

          // Value
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Card: Identity Verification (Figma Node 10:8288)
  // Background: white, Border: #E1E3E4, Rounded: 16px, Shadow: 0 2px 4px rgba(0,0,0,0.05)
  // Face Recognition + ID Card Scan
  // ==========================================
  Widget _buildIdentityVerificationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
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
          // Header: Icon + Identity Verification
          Row(
            children: const [
              Icon(
                Icons.verified_user_outlined,
                size: 18,
                color: Color(0xFF28006D),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Identity Verification',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.1,
                    color: Color(0xFF191C1D),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 1: Face Recognition
          _buildVerificationRow(
            label: 'Face Recognition',
            isVerified: true,
            hasDivider: true,
          ),

          // Row 2: ID Card Scan
          _buildVerificationRow(
            label: 'ID Card Scan',
            isVerified: true,
            hasDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationRow({
    required String label,
    required bool isVerified,
    required bool hasDivider,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: hasDivider
            ? const Border(
                bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Green dot + Label
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF006971),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF494552),
                      height: 1.42,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right: VERIFIED pill badge (Node 10:8300, 10:8307)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x1A006971), // rgba(0,105,113,0.1)
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'VERIFIED',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Color(0xFF006971),
                height: 1.33,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Footer Verification Status & Sync (Figma Node 10:8309)
  // Verification Status: Full Access Approved
  // Last sync: Oct 24, 2024 at 10:45 AM
  // ==========================================
  Widget _buildFooterStatus(String lastSyncTime) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Verification Status: Full Access Approved',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Color(0xFF7A7583),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            lastSyncTime,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Color(0xFF7A7583),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Update Credentials Pill Action Bar (Figma Node 10:8200)
  // White pill container + Purple gradient button + Dropdown chevron button
  // ==========================================
  Widget _buildUpdateCredentialsBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // rgba(0,0,0,0.1)
            offset: Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
          ),
        ],
      ),
      child: Row(
        children: [
          // Gradient Pill Button (Node 10:8203)
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showUpdateModal(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Update Credentials',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.42,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Options Chevron Button (Node 10:8209, 10:8210)
          GestureDetector(
            onTap: () {
              _showUpdateModal(context);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 48,
              height: 44,
              alignment: Alignment.center,
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
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
  // Update Credentials Modal Sheet
  // ==========================================
  void _showUpdateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E3E4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Update Clinical Credentials',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Submit revised medical licenses, certifications, or registration documents for administrative board verification.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF494552),
                  height: 1.42,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Credential upload portal initiated!',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28006D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                      child: const Text('Upload Document'),
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

  // ==========================================
  // Floating Bottom Navigation Shell (Figma Node 10:8171)
  // Width: 351px, Height: 82px, Rounded: 9999px
  // Tab 4 (Profile) is active with Cyan Highlight Pill (#76F1FF)
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
              // 1. Home (Node 10:8172)
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
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients (Node 10:8177)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.patientDirectory,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 20,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Patients',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Spacer for elevated Action Button
              const SizedBox(width: 56),

              // 3. Schedule (Node 10:8187)
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
                        size: 20,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Profile (Node 10:8192) - ACTIVE HIGHLIGHT
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.doctorProfile,
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
                            Icons.person_outline_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(height: 1),
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
                ),
              ),
            ],
          ),

          // Center Elevated QR Floating Button (Node 10:8182, 10:8183)
          Positioned(
            top: -18,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cameraPermission);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B14B8),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF8F9FF), width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000), // rgba(0,0,0,0.25)
                      offset: Offset(0, 10),
                      blurRadius: 20,
                      spreadRadius: -4,
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

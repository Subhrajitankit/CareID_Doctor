import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Doctor Profile Screen — Pixel-perfect reproduction of Figma node 10:2982
/// (CAREID-AIO-FIGMA)
///
/// Single source of truth for visual design: Figma node 10:2982
/// Single source of truth for business logic/data: CAREiD Doctor codebase
class DoctorProfileScreen extends StatefulWidget {
  final String? doctorName;
  final String? specialty;
  final String? licenseNumber;
  final String? hospitalName;

  const DoctorProfileScreen({
    super.key,
    this.doctorName,
    this.specialty,
    this.licenseNumber,
    this.hospitalName,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int _selectedMenuIndex = 0; // 0: Professional Info

  @override
  Widget build(BuildContext context) {
    // Dynamic doctor data with Figma fallback
    final doctorName = widget.doctorName ?? 'Dr. Richard  Malouf';
    final specialty = widget.specialty ?? 'Senior Cardiologist';
    final licenseNumber = widget.licenseNumber ?? 'MED-884920-XC';
    final hospitalName = widget.hospitalName ?? 'Metropolitan General Hospital';

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
              // 1. Top AppBar matching Figma Node 10:2983
              _buildTopAppBar(context),

              // 2. Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      // Card 1: Profile Card (Node 10:2995)
                      _buildProfileCard(
                        doctorName: doctorName,
                        specialty: specialty,
                        licenseNumber: licenseNumber,
                      ),
                      const SizedBox(height: 24),

                      // Card 2: Settings Navigation (Node 10:3037)
                      _buildSettingsNavCard(context),
                      const SizedBox(height: 12),

                      // Version string (Node 10:3095)
                      _buildAppVersion(),
                      const SizedBox(height: 24),

                      // Card 3: Detail Views — Professional Information (Node 10:3098)
                      _buildProfessionalInfoCard(
                        context,
                        licenseNumber: licenseNumber,
                        hospitalName: hospitalName,
                      ),
                      const SizedBox(height: 24),

                      // Action CTA Buttons (Node 10:3188)
                      _buildActionButtons(context),

                      // Extra spacing for floating bottom navigation shell
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
  // 1. Header - TopAppBar (Figma Node 10:2983, 10:2984)
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
          // Left: Go Back Button (Node 10:2986, 10:2987)
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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

          // Center: CareID Logo (Node 10:2990)
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

          // Right: Doctor Profile Avatar (Node 10:2991, 10:2992)
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
  // Card 1: Profile Card (Figma Node 10:2995)
  // Background: white, Rounded: 20px, Shadow: 0 2px 8px rgba(0,0,0,0.05)
  // Quick Stats row with 1px borders
  // ==========================================
  Widget _buildProfileCard({
    required String doctorName,
    required String specialty,
    required String licenseNumber,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Top Section with Doctor Hero & Status
          Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Top Right: Status Indicator (Node 10:3013)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1A006971), // rgba(0,105,113,0.1)
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: const Color(0x33006971), // rgba(0,105,113,0.2)
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF006971),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'AVAILABLE',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: Color(0xFF006971),
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Center Column: Hero Avatar, Name, Specialization, Reg Number
                Column(
                  children: [
                    const SizedBox(height: 8),

                    // Doctor Hero Avatar (Node 10:2998, 10:2999)
                    Container(
                      width: 137,
                      height: 140,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF8F9FA),
                          width: 4,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000), // rgba(0,0,0,0.05)
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/doctor_profile_hero.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Image.asset(
                            'assets/images/doctor_vance_avatar.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.person,
                              size: 64,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Doctor Name + Verified Badge (Node 10:3001, 10:3003, 10:3004)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            doctorName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          size: 20,
                          color: Color(0xFF006971),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Senior Cardiologist (Node 10:3008)
                    Text(
                      specialty,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF494552),
                        height: 1.42,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Registration Badge (Node 10:3009, 10:3010, 10:3012)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEEEF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.badge_outlined,
                            size: 14,
                            color: Color(0xFF494552),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Reg: $licenseNumber',
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
              ],
            ),
          ),

          // Bottom: Quick Stats (Node 10:3017)
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE1E3E4), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Stat 1: Today's Patients (Node 10:3018)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '12',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF28006D),
                            height: 1.33,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Today's\nPatients",
                          textAlign: TextAlign.center,
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

                // Stat 2: Completed (Node 10:3024)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Color(0xFFE1E3E4), width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '8',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF006971),
                            height: 1.33,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Completed',
                          textAlign: TextAlign.center,
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

                // Stat 3: Pending with Red Alert Dot (Node 10:3030)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Color(0xFFE1E3E4), width: 1),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Red Alert Badge Dot (Node 10:3036)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFBA1A1A),
                            ),
                          ),
                        ),

                        // Stat 3 Content
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  '4',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191C1D),
                                    height: 1.33,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Pending',
                                  textAlign: TextAlign.center,
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
  // Card 2: Settings Navigation Menu (Figma Node 10:3037)
  // 5 rows separated by 1px #E1E3E4 dividers
  // Row 1: Professional Info (Selected state with purple left border)
  // ==========================================
  Widget _buildSettingsNavCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Row 1: Professional Info (Node 10:3039) - SELECTED STATE
          _buildNavItem(
            isSelected: _selectedMenuIndex == 0,
            icon: Icons.medical_services_outlined,
            iconColor: const Color(0xFF28006D),
            iconBgColor: const Color(0x1A28006D), // rgba(40,0,109,0.1)
            title: 'Professional Info',
            subtitle: 'Credentials & affiliations',
            onTap: () {
              setState(() => _selectedMenuIndex = 0);
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E3E4)),

          // Row 2: Account Settings (Node 10:3050)
          _buildNavItem(
            isSelected: _selectedMenuIndex == 1,
            icon: Icons.manage_accounts_outlined,
            iconColor: const Color(0xFF494552),
            iconBgColor: const Color(0xFFE7E8E9),
            title: 'Account Settings',
            subtitle: 'Preferences & notifications',
            onTap: () {
              setState(() => _selectedMenuIndex = 1);
              Navigator.pushNamed(context, AppRoutes.settingsHub);
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E3E4)),

          // Row 3: Security & Privacy (Node 10:3061)
          _buildNavItem(
            isSelected: _selectedMenuIndex == 2,
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF494552),
            iconBgColor: const Color(0xFFE7E8E9),
            title: 'Security & Privacy',
            subtitle: 'Logins & active sessions',
            onTap: () {
              setState(() => _selectedMenuIndex = 2);
              Navigator.pushNamed(context, AppRoutes.securityPrivacy);
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E3E4)),

          // Row 4: Help & Support (Node 10:3072)
          _buildNavItem(
            isSelected: _selectedMenuIndex == 3,
            icon: Icons.help_outline_rounded,
            iconColor: const Color(0xFF494552),
            iconBgColor: const Color(0xFFE7E8E9),
            title: 'Help & Support',
            subtitle: 'FAQs & contact',
            onTap: () {
              setState(() => _selectedMenuIndex = 3);
              Navigator.pushNamed(context, AppRoutes.supportInfo);
            },
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E3E4)),

          // Row 5: Referrals (Node 10:3083)
          _buildNavItem(
            isSelected: _selectedMenuIndex == 4,
            icon: Icons.group_outlined,
            iconColor: const Color(0xFF494552),
            iconBgColor: const Color(0xFFE7E8E9),
            title: 'Referrals',
            subtitle: 'Refer a Doctor',
            onTap: () {
              setState(() => _selectedMenuIndex = 4);
              _showReferralDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required bool isSelected,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: isSelected ? 20 : 24,
          right: 20,
          top: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x4DE1E3E4) // rgba(225,227,228,0.3)
              : Colors.white,
          border: isSelected
              ? const Border(
                  left: BorderSide(color: Color(0xFF28006D), width: 4),
                )
              : null,
        ),
        child: Row(
          children: [
            // Icon in circle (Node 10:3040, 10:3051)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBgColor,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),

            // Title & Subtitle (Node 10:3044, 10:3046)
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
                    subtitle,
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

            // Trailing Chevron (Node 10:3048)
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF7A7583),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Version Footer (Figma Node 10:3095, 10:3097)
  // Health Vault 360 Doctor App v3.4.1 (Build 892)
  // ==========================================
  Widget _buildAppVersion() {
    return const Center(
      child: Text(
        'Health Vault 360 Doctor App v3.4.1 (Build 892)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: Color(0xFF7A7583),
          height: 1.33,
        ),
      ),
    );
  }

  // ==========================================
  // Card 3: Detail Views — Professional Information (Figma Node 10:3098)
  // Background: white, Rounded: 20px, Shadow: 0 2px 4px rgba(0,0,0,0.05)
  // Subsections: Medical License, Expiry Alert, More Info, Hospital Affiliations, Consultation Hours
  // ==========================================
  Widget _buildProfessionalInfoCard(
    BuildContext context, {
    required String licenseNumber,
    required String hospitalName,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Section Header (Node 10:3099, 10:3100, 10:3102)
          Row(
            children: const [
              Icon(
                Icons.medical_services_outlined,
                size: 20,
                color: Color(0xFF28006D),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Professional Information',
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
          const SizedBox(height: 16),

          // Subsection 1: Medical License (Node 10:3104)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.badge_outlined,
                            size: 16,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Medical License',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: Color(0xFF494552),
                                height: 1.42,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit Medical License')),
                        );
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Color(0xFF494552),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  licenseNumber,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF191C1D),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'State Medical Board',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7A7583),
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Subsection 2: Expiry Alert (Node 10:3118)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0x4DFFDAD6), // rgba(255,218,214,0.3)
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0x33BA1A1A), // rgba(186,26,26,0.2)
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.event_busy_rounded,
                      size: 18,
                      color: Color(0xFF93000A),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'License Expiring Soon',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF93000A),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Renewal required by Oct 31, 2024',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF494552),
                    height: 1.42,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening License Renewal Portal...'),
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
                      color: const Color(0xFFBA1A1A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Renew Now',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: Colors.white,
                        height: 1.42,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Subsection 3: More information Gradient Button (Node 10:3131, 10:3132)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.professionalCredentials);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                ),
              ),
              child: const Center(
                child: Text(
                  'More information',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: Colors.white,
                    height: 1.42,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Subsection 4: Hospital Affiliations (Node 10:3133)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.local_hospital_outlined,
                      size: 16,
                      color: Color(0xFF494552),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Hospital Affiliations',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: Color(0xFF494552),
                          height: 1.42,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Inner Hospital Box (Node 10:3139)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFE1E3E4),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.domain_rounded,
                          size: 21,
                          color: Color(0xFF28006D),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospitalName,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF191C1D),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Department of Cardiology • Primary',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF494552),
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
          ),
          const SizedBox(height: 16),

          // Subsection 5: Consultation Hours (Node 10:3148)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Consultation Hours',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: Color(0xFF494552),
                                height: 1.42,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.appointmentsOverview,
                        );
                      },
                      child: const Text(
                        'Edit Schedule',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF28006D),
                          height: 1.42,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Consultation days list with dividers
                _buildDayRow('Monday', '09:00 AM - 05:00 PM'),
                _buildDayRow('Tuesday', '09:00 AM - 05:00 PM'),
                _buildDayRow('Wednesday', '09:00 AM - 01:00 PM'),
                _buildDayRow('Thursday', '09:00 AM - 05:00 PM'),
                _buildDayRow('Friday', '09:00 AM - 05:00 PM'),
                _buildDayRow(
                  'Weekend',
                  'Off Duty',
                  isOffDuty: true,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(
    String day,
    String hours, {
    bool isOffDuty = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFE1E3E4), width: 1),
              ),
      ),
      child: Opacity(
        opacity: isOffDuty ? 0.5 : 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF191C1D),
                height: 1.42,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                hours,
                textAlign: TextAlign.end,
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
    );
  }

  // ==========================================
  // Action CTA Buttons Area (Figma Node 10:3188)
  // Row 1: Book an Appointment + Chat
  // Row 2: View Shared Records (5) + Directory
  // ==========================================
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Row 1: Book an Appointment + Chat (Node 10:3189)
        Row(
          children: [
            // Primary Button: Book an Appointment (Node 10:3190)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.appointmentsOverview);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF28006D),
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3328006D), // rgba(40,0,109,0.2)
                        offset: Offset(0, 10),
                        blurRadius: 15,
                        spreadRadius: -3,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Book an Appointment',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.42,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Secondary Button: Chat (Node 10:3196)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Starting Clinician Chat...')),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000), // rgba(0,0,0,0.05)
                      offset: Offset(0, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 16,
                      color: Color(0xFF28006D),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Chat',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF28006D),
                        height: 1.42,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Row 2: View Shared Records (5) + Directory (Node 10:3201)
        Row(
          children: [
            // View Shared Records (5) (Node 10:3202)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.medicalRecords);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000), // rgba(0,0,0,0.05)
                        offset: Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.description_outlined,
                        size: 14,
                        color: Color(0xFF28006D),
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'View Shared Records (5)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF28006D),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Directory Button (Node 10:3207)
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.patientDirectory,
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Center(
                  child: Text(
                    'Directory',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF494552),
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // Floating Bottom Navigation Shell (Figma Node 10:3209)
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
              // 1. Home (Node 10:3210)
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

              // 2. Patients (Node 10:3215)
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

              // 3. Schedule (Node 10:3225)
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

              // 4. Profile (Node 10:3230) - ACTIVE HIGHLIGHT
              Expanded(
                child: GestureDetector(
                  onTap: () {}, // Already on Profile
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

          // Center Elevated QR Floating Button (Node 10:3220, 10:3221)
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

  // ==========================================
  // Referral Action Modal
  // ==========================================
  void _showReferralDialog(BuildContext context) {
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
                'Refer a Clinician',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Invite a doctor to join the CareID Clinical Network. Verified referrals receive priority hospital liaison credentials.',
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
                            content: Text('Referral link copied to clipboard!'),
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
                      child: const Text('Share Link'),
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
}

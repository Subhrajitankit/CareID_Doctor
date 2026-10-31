import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Doctor Settings Hub Screen — Pixel-perfect reproduction of Figma node 10:3847
/// (CAREID-AIO-FIGMA)
///
/// Single source of truth for visual design: Figma node 10:3847
/// Single source of truth for business logic/data: CAREiD Doctor codebase
class DoctorSettingsHubScreen extends StatefulWidget {
  final String? doctorName;
  final String? subtitle;
  final String? regNumber;
  final String? hospitalName;
  final String? specialty;
  final String? yearsExperience;
  final String? consultationFee;
  final String? languages;
  final String? bio;
  final String? status;
  final String? patientsToday;
  final String? avgRating;

  const DoctorSettingsHubScreen({
    super.key,
    this.doctorName,
    this.subtitle,
    this.regNumber,
    this.hospitalName,
    this.specialty,
    this.yearsExperience,
    this.consultationFee,
    this.languages,
    this.bio,
    this.status,
    this.patientsToday,
    this.avgRating,
  });

  @override
  State<DoctorSettingsHubScreen> createState() =>
      _DoctorSettingsHubScreenState();
}

class _DoctorSettingsHubScreenState extends State<DoctorSettingsHubScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Dynamic values matching Figma node 10:3847 defaults
    final doctorName =
        widget.doctorName ??
        args?['doctorName'] as String? ??
        'Dr. Sarah Jenkins,\nMD';
    final subtitle =
        widget.subtitle ??
        args?['subtitle'] as String? ??
        'Senior Cardiologist • HV360 Verified';
    final regNumber =
        widget.regNumber ??
        args?['regNumber'] as String? ??
        'Reg No: MED-8942-TX';
    final hospitalName =
        widget.hospitalName ??
        args?['hospitalName'] as String? ??
        'City General Hospital';
    final specialty =
        widget.specialty ??
        args?['specialty'] as String? ??
        'Cardiology, Internal Medicine';
    final yearsExperience =
        widget.yearsExperience ??
        args?['yearsExperience'] as String? ??
        '14 Years';
    final consultationFee =
        widget.consultationFee ??
        args?['consultationFee'] as String? ??
        '\$150.00 USD';
    final languages =
        widget.languages ?? args?['languages'] as String? ?? 'English, Spanish';
    final bio =
        widget.bio ??
        args?['bio'] as String? ??
        'Board-certified cardiologist specializing in preventive cardiology and echocardiography. Committed to delivering patient-centered care and leveraging digital health tools for better patient outcomes.';
    final status =
        widget.status ??
        args?['status'] as String? ??
        'Accepting Consultations';
    final patientsToday =
        widget.patientsToday ?? args?['patientsToday'] as String? ?? '24';
    final avgRating =
        widget.avgRating ?? args?['avgRating'] as String? ?? '4.9';

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
              // 1. Mobile Header (Node 10:3877)
              _buildHeader(context),

              // 2. Scrollable Body (Node 10:3883)
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      // Section 3.1: Profile Header Card (Node 10:3884)
                      _buildProfileHeaderCard(
                        context,
                        doctorName: doctorName,
                        subtitle: subtitle,
                        regNumber: regNumber,
                        hospitalName: hospitalName,
                      ),
                      const SizedBox(height: 24),

                      // Section 3.2: Professional Information Card (Node 10:3911)
                      _buildProfessionalInfoCard(
                        specialty: specialty,
                        yearsExperience: yearsExperience,
                        consultationFee: consultationFee,
                        languages: languages,
                        bio: bio,
                      ),
                      const SizedBox(height: 24),

                      // Section 3.3: Current Status Card (Node 10:3946)
                      _buildCurrentStatusCard(
                        status: status,
                        patientsToday: patientsToday,
                        avgRating: avgRating,
                      ),
                      const SizedBox(height: 24),

                      // Section 3.4: Availability Card (Node 10:3966)
                      _buildAvailabilityCard(),
                      const SizedBox(height: 24),

                      // Section 3.5: Settings Module Cards (Node 10:3985)
                      _buildSettingsModules(context),
                      const SizedBox(height: 24),

                      // Section 3.6: Sign Out Action Button (Node 10:4020)
                      _buildSignOutButton(context),

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
  // 1. Mobile Header (Figma Node 10:3877)
  // Height: 64px, Background: #F8F9FA, DropShadow: 0 1px 1px rgba(0,0,0,0.05)
  // Back button + Centered "Profile" title + 32px right spacer
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
          // Back Button (Node 10:3878)
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

          // Title: Profile (Node 10:3881)
          const Text(
            'Profile',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF28006D),
              height: 1.4,
            ),
          ),

          // Right Spacer (Node 10:3882, 32px)
          const SizedBox(width: 32, height: 32),
        ],
      ),
    );
  }

  // ==========================================
  // Section 3.1: Profile Header Card (Figma Node 10:3884)
  // Avatar with verified badge, Doctor Name, Subtitle, Reg Badge, Hospital Badge, Edit Profile Button
  // ==========================================
  Widget _buildProfileHeaderCard(
    BuildContext context, {
    required String doctorName,
    required String subtitle,
    required String regNumber,
    required String hospitalName,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F5), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Doctor Avatar with Verified Badge (Node 10:3885)
          SizedBox(
            width: 128,
            height: 128,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Circular Avatar with 4px #F8F9FA border
                Container(
                  width: 128,
                  height: 128,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF8F9FA),
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/doctor_sarah_jenkins.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Image.asset(
                        'assets/images/patient_sarah_jenkins.png',
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

                // Bottom-right Teal Badge (Node 10:3888)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006971),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF8F9FA),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Doctor Name (Node 10:3894)
          Text(
            doctorName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle: Senior Cardiologist • HV360 Verified (Node 10:3897)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Color(0xFF494552),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Badges: Reg No & Hospital (Node 10:3899)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // Reg No Badge (Node 10:3900)
              Container(
                height: 26,
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E3E4),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                ),
                child: Text(
                  regNumber,
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

              // Hospital Badge (Node 10:3902)
              Container(
                height: 26,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x1A006971), // rgba(0,105,113,0.1)
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.apartment_rounded,
                      size: 14,
                      color: Color(0xFF006971),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hospitalName,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xFF006971),
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Edit Profile Button (Node 10:3906)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile opened')),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44,
              width: double.infinity,
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
                  Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: Colors.white,
                      height: 1.42,
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

  // ==========================================
  // Section 3.2: Professional Information Card (Figma Node 10:3911)
  // Specialty, Experience, Consultation Fee, Languages, Bio
  // ==========================================
  Widget _buildProfessionalInfoCard({
    required String specialty,
    required String yearsExperience,
    required String consultationFee,
    required String languages,
    required String bio,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F5), width: 1),
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
          // Header: Icon + "Professional Information" (Node 10:3913)
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0x1A28006D), // rgba(40,0,109,0.1)
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.medical_services_outlined,
                    size: 20,
                    color: Color(0xFF28006D),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
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
          const SizedBox(height: 24),

          // Field 1: Specialty (Node 10:3920)
          _buildInfoField(label: 'Specialty', value: specialty),
          const SizedBox(height: 16),

          // Field 2: Years of Experience (Node 10:3925)
          _buildInfoField(label: 'Years of Experience', value: yearsExperience),
          const SizedBox(height: 16),

          // Field 3: Consultation Fee (Standard) (Node 10:3930)
          _buildInfoField(
            label: 'Consultation Fee (Standard)',
            value: consultationFee,
          ),
          const SizedBox(height: 16),

          // Field 4: Languages Spoken (Node 10:3935)
          _buildInfoField(label: 'Languages Spoken', value: languages),
          const SizedBox(height: 16),

          // Field 5: Bio (Node 10:3940)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bio',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Color(0xFF7A7583),
                  height: 1.33,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bio,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF191C1D),
                    height: 1.62,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Color(0xFF7A7583),
            height: 1.33,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF191C1D),
              height: 1.42,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Section 3.3: Current Status Card (Figma Node 10:3946)
  // Deep Purple #28006D, Green status dot, 24 Patients Today, 4.9 Avg Rating
  // ==========================================
  Widget _buildCurrentStatusCard({
    required String status,
    required String patientsToday,
    required String avgRating,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF28006D),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading: Current Status (Node 10:3950)
          const Text(
            'Current Status',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Status Row: Green dot + Accepting Consultations (Node 10:3951)
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF006971),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  status,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: Colors.white,
                    height: 1.42,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Horizontal Divider (Node 10:3955)
          Container(
            height: 1,
            width: double.infinity,
            color: const Color(0x33E8DDFF), // rgba(232,221,255,0.2)
          ),
          const SizedBox(height: 20),

          // Two Stat Columns (Node 10:3956, 10:3961)
          Row(
            children: [
              // Stat 1: Patients Today
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientsToday,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Patients Today',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xCCE8DDFF),
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),

              // Stat 2: Avg Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      avgRating,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Avg Rating',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xCCE8DDFF),
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
    );
  }

  // ==========================================
  // Section 3.4: Availability Card (Figma Node 10:3966)
  // Mon-Fri, Sat, Sun Availability schedule
  // ==========================================
  Widget _buildAvailabilityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F5), width: 1),
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
          // Heading: Availability (Node 10:3968)
          const Text(
            'Availability',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Row 1: Mon - Fri (Node 10:3970)
          _buildAvailabilityRow(
            day: 'Mon - Fri',
            time: '09:00 - 17:00',
            hasDivider: true,
            isUnavailable: false,
          ),

          // Row 2: Sat (Node 10:3975)
          _buildAvailabilityRow(
            day: 'Sat',
            time: '10:00 - 14:00',
            hasDivider: true,
            isUnavailable: false,
          ),

          // Row 3: Sun (Node 10:3980)
          _buildAvailabilityRow(
            day: 'Sun',
            time: 'Unavailable',
            hasDivider: false,
            isUnavailable: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityRow({
    required String day,
    required String time,
    required bool hasDivider,
    required bool isUnavailable,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: hasDivider
            ? const Border(
                bottom: BorderSide(color: Color(0xFFE1E3E4), width: 1),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF494552),
              height: 1.42,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              color: isUnavailable
                  ? const Color(0xFF7A7583)
                  : const Color(0xFF191C1D),
              height: 1.42,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Section 3.5: Settings Module Cards (Figma Node 10:3985)
  // Account Settings, Security & Privacy, Help & Support
  // ==========================================
  Widget _buildSettingsModules(BuildContext context) {
    return Column(
      children: [
        // Module 1: Account Settings (Node 10:3986)
        _buildModuleCard(
          context,
          icon: Icons.manage_accounts_outlined,
          title: 'Account Settings',
          subtitle:
              'Manage your email, password, connected devices, and primary clinic details.',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account Settings active')),
            );
          },
        ),
        const SizedBox(height: 24),

        // Module 2: Security & Privacy (Node 10:3997)
        _buildModuleCard(
          context,
          icon: Icons.shield_outlined,
          title: 'Security & Privacy',
          subtitle:
              'Configure 2FA, review audit logs, and manage patient data sharing permissions.',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.securityPrivacy);
          },
        ),
        const SizedBox(height: 24),

        // Module 3: Help & Support (Node 10:4008)
        _buildModuleCard(
          context,
          icon: Icons.help_outline_rounded,
          title: 'Help & Support',
          subtitle:
              'Access the clinical knowledge base, contact technical support, or report an issue.',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.supportInfo);
          },
        ),
      ],
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF3F4F5), width: 1),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0x1A28006D), // rgba(40,0,109,0.1)
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            size: 20,
                            color: const Color(0xFF28006D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191C1D),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF494552),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
    );
  }

  // ==========================================
  // Section 3.6: Sign Out Action Button (Figma Node 10:4020, 10:4021)
  // Border: 1px solid #BA1A1A, Text & Icon #BA1A1A
  // ==========================================
  Widget _buildSignOutButton(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          _showSignOutDialog(context);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFBA1A1A), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 13),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.logout_rounded, size: 16, color: Color(0xFFBA1A1A)),
            SizedBox(width: 8),
            Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Color(0xFFBA1A1A),
                height: 1.42,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out of CAREiD Doctor?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Floating Bottom Navigation Shell (Figma Node 10:3848)
  // Width: 351px, Height: 80px, Rounded: 9999px
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
              // 1. Home (Node 10:3849)
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

              // 2. Patients (Node 10:3854)
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

              // 3. Schedule (Node 10:3864)
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

              // 4. Profile (Node 10:3869) - ACTIVE HIGHLIGHT
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

          // Center Elevated QR Floating Button (Node 10:3859, 10:3860)
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

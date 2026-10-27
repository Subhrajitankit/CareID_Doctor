import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _selectedQueueTab = 0; // 0: Waiting, 1: In Progress, 2: Done

  List<Patient> get _filteredPatients {
    // In Figma node 10:322, the default queue view displays Arthur Miller,
    // Sarah Jenkins, and Liam Carter.
    switch (_selectedQueueTab) {
      case 0:
        return [
          ...MockData.patients.where((p) => p.name == 'Arthur Miller'),
          ...MockData.patients.where((p) => p.name == 'Sarah Jenkins'),
          const Patient(
            id: 'p5',
            name: 'Liam Carter',
            age: 38,
            gender: 'Male',
            bloodGroup: 'B+',
            careId: 'CID-3301-NY',
            allergies: [],
            chronicConditions: ['Post-Op Cardiac'],
            queueStatus: 'waiting',
            scheduledTime: '10:15 AM',
            primaryComplaint: 'Post-Op Check',
            isCritical: false,
          ),
        ];
      case 1:
        return [
          ...MockData.patients.where((p) => p.name == 'Sarah Jenkins'),
          ...MockData.patients.where((p) => p.name == 'Elena Rostova'),
        ];
      case 2:
        return MockData.patients.where((p) => p.queueStatus == 'done').toList();
      default:
        return MockData.patients;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildTopAppBar(context),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: Top Greeting (Figma 10:360)
                _buildGreetingSection(),
                const SizedBox(height: 31),

                // Section 2: Stats Row (Figma 10:365)
                _buildStatsSection(context),
                const SizedBox(height: 31),

                // Section 3: Primary Quick Actions (Figma 10:393)
                _buildQuickActionsSection(context),
                const SizedBox(height: 32),

                // Section 4: Live Queue (Figma 10:413)
                _buildLiveQueueSection(context),
                const SizedBox(height: 32),

                // Section 5: Pending Tasks (Figma 10:469)
                _buildPendingTasksSection(context),
                const SizedBox(height: 32),

                // Section 6: Recently Viewed (Figma 10:493)
                _buildRecentlyViewedSection(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavShell(context),
    );
  }

  // --- Top App Bar (Figma Node 10:350) ---
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(bottom: BorderSide(color: Color(0xFFCBC4D4), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left: Doctor Avatar (Figma 10:351, 40x40 circle)
                Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.doctorProfile),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE8DDFF),
                        border: Border.all(
                          color: const Color(0x3328006D),
                          width: 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/doctor_vance_avatar.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              'assets/images/splash_doctor.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.person_rounded,
                                    color: Color(0xFF28006D),
                                    size: 24,
                                  ),
                            ),
                      ),
                    ),
                  ),
                ),

                // Center: CareID Horizontal Brand Wordmark (Figma 10:354, 98x22)
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/careid_appbar_clean.png',
                    width: 98,
                    height: 22,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Care',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF191C1D),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'ID',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF00A3AD),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFF00A3AD),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.fingerprint_rounded,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right: Notification Bell Button (Figma 10:355, 40x40 circle)
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.notificationCenter,
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            size: 24,
                            color: Color(0xFF28006D),
                          ),
                          // Red badge indicator (Figma 10:358, 8x8 circle)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBA1A1A),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF8F9FA),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Section 1: Top Greeting (Figma Node 10:360) ---
  Widget _buildGreetingSection() {
    final doctorDisplayName = MockData.doctorName.startsWith('Dr. ')
        ? MockData.doctorName.substring(4)
        : MockData.doctorName;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
            ).createShader(bounds),
            child: Text(
              'Good Morning, Dr.\n$doctorDisplayName',
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 32,
                fontWeight: FontWeight.w600,
                height: 40 / 32,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${MockData.doctorTitle} • ${MockData.doctorHospital}',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 24 / 16,
              color: Color(0xFF494552),
            ),
          ),
        ],
      ),
    );
  }

  // --- Section 2: Stats Row (Figma Node 10:365) ---
  Widget _buildStatsSection(BuildContext context) {
    return Column(
      children: [
        // Stat 1: Today's Patients (Figma 10:366)
        _buildStatCard(
          icon: Icons.people_alt_rounded,
          iconBg: const Color(0xFFE8DDFF),
          iconColor: const Color(0xFF28006D),
          label: "TODAY'S PATIENTS",
          value: '12',
          valueColor: const Color(0xFF28006D),
          bgColor: Colors.white,
          borderColor: const Color(0xFFCBC4D4),
          onTap: () => Navigator.pushNamed(context, AppRoutes.patientDirectory),
        ),
        const SizedBox(height: 16),

        // Stat 2: Review Referrals (Figma 10:375)
        _buildStatCard(
          icon: Icons.access_time_rounded,
          iconBg: const Color(0xFF87F3FF),
          iconColor: const Color(0xFF006971),
          label: 'REVIEW REFERRALS',
          value: '3',
          valueColor: const Color(0xFF006971),
          bgColor: Colors.white,
          borderColor: const Color(0xFFCBC4D4),
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.referralDashboard),
        ),
        const SizedBox(height: 16),

        // Stat 3: Critical (Figma 10:384)
        _buildStatCard(
          icon: Icons.priority_high_rounded,
          iconBg: const Color(0xFFBA1A1A),
          iconColor: Colors.white,
          label: 'CRITICAL',
          value: '1',
          valueColor: const Color(0xFFBA1A1A),
          labelColor: const Color(0xFF93000A),
          bgColor: const Color(0xFFFFDAD6),
          borderColor: const Color(0x1ABA1A1A),
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.notificationCenter),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
    Color labelColor = const Color(0xFF494552),
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(21),
            child: Row(
              children: [
                // 48x48 Circular Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(icon, color: iconColor, size: 22)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                        height: 16 / 12,
                        color: labelColor,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 32 / 24,
                        color: valueColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Section 3: Primary Quick Actions (Figma Node 10:393) ---
  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      children: [
        // Button 1: Find Patient (Figma 10:394, Gradient)
        Container(
          height: 61,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
            ),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 15,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.patientSearch),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_search_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Patient',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 28 / 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Search by Name or ID',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              color: Color(0xCCFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Button 2: Scan QR (Figma 10:403, Solid Teal)
        Container(
          height: 61,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF006971),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 15,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.cameraPermission),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scan QR',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 28 / 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Launch visit interface',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              color: Color(0xCCFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Section 4: Live Queue (Figma Node 10:413) ---
  Widget _buildLiveQueueSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Queue Header & Filter Tabs (Figma 10:414)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Title "Live Queue" & "View All"
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Live\nQueue',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 28 / 20,
                    color: Color(0xFF191C1D),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.appointmentsOverview,
                  ),
                  child: const Text(
                    'View\nAll',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 18 / 14,
                      color: Color(0xFF28006D),
                    ),
                  ),
                ),
              ],
            ),

            // Right: Filter Tabs (Waiting, In Progress, Done)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEEEF),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQueueTabItem('Waiting', 0),
                  _buildQueueTabItem('In Progress', 1),
                  _buildQueueTabItem('Done', 2),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Patient Queue Cards
        if (_filteredPatients.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            alignment: Alignment.center,
            child: const Text(
              'No patients in this queue',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                color: Color(0xFF494552),
              ),
            ),
          )
        else
          ..._filteredPatients.map(
            (patient) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPatientCard(context, patient),
            ),
          ),
      ],
    );
  }

  Widget _buildQueueTabItem(String title, int index) {
    final bool isSelected = _selectedQueueTab == index;
    final String displayTitle = title == 'In Progress' ? 'In\nProgress' : title;
    return GestureDetector(
      onTap: () => setState(() => _selectedQueueTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: title == 'In Progress' ? 12 : 14,
          vertical: title == 'In Progress' ? 4 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          displayTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            height: 1.15,
            color: isSelected
                ? const Color(0xFF28006D)
                : const Color(0xFF494552),
          ),
        ),
      ),
    );
  }

  Color _getPatientAvatarBg(String name) {
    if (name.contains('Arthur')) return const Color(0xFFD3E4FD);
    if (name.contains('Sarah')) return const Color(0xFFE8DDFF);
    if (name.contains('Liam')) return const Color(0xFFCCE8E9);
    return const Color(0xFFEDEEEF);
  }

  Color _getPatientAvatarTextColor(String name) {
    if (name.contains('Arthur')) return const Color(0xFF00468B);
    if (name.contains('Sarah')) return const Color(0xFF28006D);
    if (name.contains('Liam')) return const Color(0xFF004F55);
    return const Color(0xFF28006D);
  }

  String _getPatientSubtitle(Patient patient) {
    if (patient.name == 'Arthur Miller') {
      return 'Scheduled: 09:00\nAM • Tachycardia';
    }
    if (patient.name == 'Sarah Jenkins') {
      return 'Scheduled: 09:30 AM •\nAnnual Review';
    }
    if (patient.name == 'Liam Carter') {
      return 'Scheduled: 10:15 AM •\nPost-Op Check';
    }
    return 'Scheduled: ${patient.scheduledTime}\n${patient.primaryComplaint.split('&').first.trim()}';
  }

  Widget _buildPatientAvatar(Patient patient) {
    String? assetPath;
    if (patient.name == 'Arthur Miller') {
      assetPath = 'assets/images/patient_arthur.png';
    } else if (patient.name == 'Sarah Jenkins') {
      assetPath = 'assets/images/patient_sarah.png';
    } else if (patient.name == 'Liam Carter') {
      assetPath = 'assets/images/patient_liam.png';
    }

    if (assetPath != null) {
      return ClipOval(
        child: Image.asset(
          assetPath,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildInitialAvatar(patient),
        ),
      );
    }
    return _buildInitialAvatar(patient);
  }

  Widget _buildInitialAvatar(Patient patient) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: _getPatientAvatarBg(patient.name),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          patient.name
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join(),
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _getPatientAvatarTextColor(patient.name),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, Patient patient) {
    final isCritical = patient.isCritical;
    final subtitle = _getPatientSubtitle(patient);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            if (isCritical)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 4, color: const Color(0xFFBA1A1A)),
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.patientProfile,
                  arguments: patient,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isCritical ? 24 : 21,
                    20,
                    20,
                    20,
                  ),
                  child: Row(
                    children: [
                      // Avatar with Critical Badge Dot (Figma 10:430, 10:433)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _buildPatientAvatar(patient),
                          if (isCritical)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFBA1A1A),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFF8F9FA),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Patient Details (Figma 10:436, 10:450, 10:461)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    patient.name,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF191C1D),
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                if (isCritical) ...[
                                  const SizedBox(width: 8),
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
                                      'CRITICAL',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                        color: Color(0xFFBA1A1A),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                                color: Color(0xFF494552),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Start Button (Figma 10:444 & 10:455)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.patientProfile,
                          arguments: patient,
                        ),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: isCritical
                                ? const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFA44CFF),
                                      Color(0xFF5B14B8),
                                    ],
                                  )
                                : null,
                            color: isCritical ? null : const Color(0xFFEDEEEF),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Start',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isCritical
                                  ? Colors.white
                                  : const Color(0xFF28006D),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Section 5: Pending Tasks (Figma Node 10:469) ---
  Widget _buildPendingTasksSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Checkmark icon + "Pending Tasks"
          const Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 20,
                color: Color(0xFF191C1D),
              ),
              SizedBox(width: 8),
              Text(
                'Pending Tasks',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191C1D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Task 1: Review Lab Report (Figma 10:475)
          _buildPendingTaskItem(
            context: context,
            title: 'Review Lab Report',
            count: '2',
            icon: Icons.biotech_rounded,
            iconBg: const Color(0xFFE8DDFF),
            iconColor: const Color(0xFF28006D),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.referralDashboard),
          ),
          const SizedBox(height: 8),

          // Task 2: Sign Prescriptions (Figma 10:484)
          _buildPendingTaskItem(
            context: context,
            title: 'Sign Prescriptions',
            count: '4',
            icon: Icons.description_outlined,
            iconBg: const Color(0xFF87F3FF),
            iconColor: const Color(0xFF006971),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.referralDashboard),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTaskItem({
    required BuildContext context,
    required String title,
    required String count,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                // 40x40 Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Icon(icon, color: iconColor, size: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ),
                // 24x24 Circle Count Badge (Figma 10:482, 10:491)
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3F1D8B),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    count,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFAB8EFD),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Section 6: Recently Viewed (Figma Node 10:493) ---
  Widget _buildRecentlyViewedSection(BuildContext context) {
    final recentPatients = [
      {
        'name': 'E. Rose',
        'id': '#9832',
        'isHighlight': true,
        'image': 'assets/images/recent_rose.png',
        'bg': const Color(0xFFE8DDFF),
        'textColor': const Color(0xFF28006D),
      },
      {
        'name': 'D. Smith',
        'id': '#1204',
        'isHighlight': false,
        'image': 'assets/images/recent_smith.png',
        'bg': const Color(0xFFD3E4FD),
        'textColor': const Color(0xFF00468B),
      },
      {
        'name': 'T. Baker',
        'id': '#5512',
        'isHighlight': false,
        'image': 'assets/images/recent_baker.png',
        'bg': const Color(0xFFFFE0B2),
        'textColor': const Color(0xFFE65100),
      },
      {
        'name': 'J. Doe',
        'id': '#4409',
        'isHighlight': false,
        'image': 'assets/images/recent_doe.png',
        'bg': const Color(0xFFE2E8F0),
        'textColor': const Color(0xFF475569),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Recently Viewed',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: recentPatients.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = recentPatients[index];
              final isHighlight = item['isHighlight'] as bool;
              final name = item['name'] as String;
              final id = item['id'] as String;
              final bg = item['bg'] as Color;
              final textColor = item['textColor'] as Color;
              final image = item['image'] as String;

              return GestureDetector(
                onTap: () {
                  if (MockData.patients.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.patientProfile,
                      arguments:
                          MockData.patients[index % MockData.patients.length],
                    );
                  }
                },
                child: SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      // 64x64 Circle Avatar Container (Figma 10:498, 10:506, etc.)
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isHighlight
                                ? const Color(0xFF28006D)
                                : const Color(0xFFCBC4D4),
                            width: 2,
                          ),
                          color: bg,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            image,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Text(
                                    name
                                        .replaceAll('.', '')
                                        .split(' ')
                                        .map((e) => e[0])
                                        .join(),
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF191C1D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        id,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Bottom Navigation Shell (Figma Node 10:323, 10:324) ---
  Widget _buildBottomNavShell(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
              // 0: Home (Selected Pill in Figma 10:325)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF76F1FF),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.grid_view_rounded,
                      size: 18,
                      color: Color(0xFF006D76),
                    ),
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

              // 1: Patients (Figma 10:330)
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.patientDirectory),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 20,
                        color: Color(0xFF494552),
                      ),
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

              // Center Spacer for Floating Elevated Scan QR button
              const SizedBox(width: 56),

              // 2: Schedule (Figma 10:335)
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.appointmentsOverview,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Color(0xFF494552),
                      ),
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
              ),

              // 3: Profile (Figma 10:340)
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.doctorProfile),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 18,
                        color: Color(0xFF494552),
                      ),
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
              ),
            ],
          ),

          // Center Elevated Button (Figma 10:345, 10:346)
          Positioned(
            top: -24,
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.cameraPermission),
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
                      blurRadius: 50,
                      offset: Offset(0, 25),
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

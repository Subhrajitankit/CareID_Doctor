import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/clinical_models.dart';

/// Pixel-accurate implementation of Figma Node 10:1635
/// "Patient Profile - Medical Overview"
class PatientProfileScreen extends StatefulWidget {
  final Patient? patientArg;

  const PatientProfileScreen({super.key, this.patientArg});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  int _selectedTabIndex = 0;

  static const List<String> _tabs = [
    'Overview',
    'Records',
    'Labs',
    'Prescriptions',
    'Insurance',
    'Timeline',
  ];

  static const Patient _defaultEleanorPatient = Patient(
    id: 'p-eleanor-thompson',
    name: 'Eleanor Thompson',
    age: 42,
    gender: 'Female',
    bloodGroup: 'B+',
    careId: 'CR-8829-4410-X',
    isCritical: false,
    queueStatus: 'in_progress',
    scheduledTime: '10:30 AM',
    primaryComplaint: 'Hypertension & Type 2 Diabetes Management',
    allergies: ['Penicillin', 'Latex', 'Peanuts'],
    chronicConditions: ['Hypertension', 'Type 2 Diabetes'],
    avatarUrl: 'assets/images/patient_eleanor_profile.png',
  );

  String _getAvatarImage(Patient patient) {
    if (patient.avatarUrl != null && patient.avatarUrl!.isNotEmpty) {
      return patient.avatarUrl!;
    }
    final lower = patient.name.toLowerCase();
    if (lower.contains('eleanor') || lower.contains('thompson')) {
      return 'assets/images/patient_eleanor_profile.png';
    } else if (lower.contains('elena') || lower.contains('rodriguez')) {
      return 'assets/images/patient_elena_rodriguez.png';
    } else if (lower.contains('sarah')) {
      return 'assets/images/patient_sarah_jenkins.png';
    } else if (lower.contains('arthur')) {
      return 'assets/images/patient_arthur.png';
    }
    return 'assets/images/patient_eleanor_profile.png';
  }

  @override
  Widget build(BuildContext context) {
    final patient =
        widget.patientArg ??
        (ModalRoute.of(context)?.settings.arguments as Patient?) ??
        _defaultEleanorPatient;

    return Scaffold(
      // Gradient background matching Figma node 10:1635
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1.0),
            end: Alignment(0.6, 1.0),
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: Stack(
          children: [
            // Main Content Area
            Positioned.fill(
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Top App Bar (Node 10:1661)
                    _buildTopAppBar(context),

                    // Scrollable Cards List
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 358),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 1. Patient Header Card (Node 10:1674)
                                _buildPatientHeaderCard(patient),

                                const SizedBox(height: 16),

                                // 2. Scrollable Tabs (Node 10:1694)
                                _buildScrollableTabs(context),

                                const SizedBox(height: 16),

                                // 3. Clinical Alerts - Known Allergies (Node 10:1708)
                                _buildClinicalAlertsCard(patient),

                                const SizedBox(height: 16),

                                // 4. Behavioural Figures - Other Relevant Info (Node 10:1728)
                                _buildOtherRelevantInfoCard(patient),

                                const SizedBox(height: 16),

                                // 5. Latest Vitals Bento Grid (Node 10:1753)
                                _buildLatestVitalsSection(),

                                const SizedBox(height: 16),

                                // 6. Internal Review Comments (Node 10:1797)
                                _buildInternalReviewCommentsCard(context),

                                const SizedBox(height: 16),

                                // 7. Current Medications (Node 10:1814)
                                _buildCurrentMedicationsCard(context),

                                const SizedBox(height: 16),

                                // 8. Insurance Summary (Node 10:1840)
                                _buildInsuranceCard(),

                                const SizedBox(height: 16),

                                // 9. Care Team & Contacts (Node 10:1856)
                                _buildCareTeamCard(),

                                const SizedBox(height: 24),

                                // 10. Action Buttons (Nodes 10:1885 & 10:1881)
                                _buildActionButtons(context, patient),

                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating Bottom Navigation Shell (Node 10:1636)
            Positioned(
              left: 0,
              right: 0,
              bottom: 18,
              child: Center(child: _buildBottomNav(context)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TOP APP BAR (Node 10:1661)
  // ==========================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(bottom: BorderSide(color: Color(0xFFCBC4D4), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button (Node 10:1662)
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
              color: Color(0xFF191C1D),
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.maybePop(context),
            tooltip: 'Back',
          ),
          const SizedBox(width: 8),

          // Title (Node 10:1666)
          const Expanded(
            child: Text(
              'Patient Profile',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 28 / 20,
                color: Color(0xFF191C1D),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),

          // Right Action Icons (Node 10:1667)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notification Bell with Badge (Node 10:1668)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 22,
                      color: Color(0xFF191C1D),
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.notificationCenter,
                      );
                    },
                    tooltip: 'Notifications',
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 10,
                      height: 10,
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
              const SizedBox(width: 8),

              // Doctor Profile Avatar (Node 10:1672)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/doctor_profile_avatar_appbar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFFE8DDFF),
                      child: const Icon(
                        Icons.person,
                        size: 18,
                        color: Color(0xFF28006D),
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
  // CARD 1: PATIENT HEADER CARD (Node 10:1674)
  // ==========================================
  Widget _buildPatientHeaderCard(Patient patient) {
    final avatarPath = _getAvatarImage(patient);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Top Right Corner Radial Overlay (Node 10:1675)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 128,
                height: 128,
                decoration: const BoxDecoration(
                  color: Color(0x0D28006D), // rgba(40,0,109,0.05)
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                  ),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Box (Node 10:1676)
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE1E3E4),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        avatarPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: const Color(0xFFE8DDFF),
                          child: const Icon(
                            Icons.person,
                            size: 48,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Name and Verified Checkmark (Node 10:1678)
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          patient.name,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 32 / 24,
                            color: Color(0xFF191C1D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Verified badge (Node 10:1681)
                      const Icon(
                        Icons.verified,
                        size: 20,
                        color: Color(0xFF006971),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Care ID (Node 10:1683)
                  Row(
                    children: [
                      const Icon(
                        Icons.badge_outlined,
                        size: 15,
                        color: Color(0xFF494552),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          patient.careId.startsWith('CR-')
                              ? patient.careId
                              : 'CR-${patient.careId}',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 20 / 14,
                            color: Color(0xFF494552),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Demographic Pills (Node 10:1687)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Age Pill (Node 10:1688)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1E3E4),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: const Color(0xFFCBC4D4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${patient.age} Years',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            height: 16 / 12,
                            color: Color(0xFF494552),
                          ),
                        ),
                      ),

                      // Gender Pill (Node 10:1690)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1E3E4),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: const Color(0xFFCBC4D4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          patient.gender,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            height: 16 / 12,
                            color: Color(0xFF494552),
                          ),
                        ),
                      ),

                      // Blood Group Pill (Node 10:1692)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF76F1FF),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: const Color(
                              0x33006971,
                            ), // rgba(0,105,113,0.2)
                            width: 1,
                          ),
                        ),
                        child: Text(
                          patient.bloodGroup.contains('Positive')
                              ? patient.bloodGroup
                              : '${patient.bloodGroup} Positive',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            height: 16 / 12,
                            color: Color(0xFF006D76),
                          ),
                        ),
                      ),
                    ],
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
  // SCROLLABLE TABS (Node 10:1694)
  // ==========================================
  Widget _buildScrollableTabs(BuildContext context) {
    return Container(
      height: 38,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE1E3E4), width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final tabTitle = _tabs[index];
            final isSelected = _selectedTabIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
                if (tabTitle == 'Records') {
                  Navigator.pushNamed(context, AppRoutes.medicalRecords);
                } else if (tabTitle == 'Prescriptions') {
                  Navigator.pushNamed(context, AppRoutes.prescriptionBuilder);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? const Color(0xFF28006D)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabTitle,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.1,
                    height: 20 / 14,
                    color: isSelected
                        ? const Color(0xFF28006D)
                        : const Color(0xFF494552),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ==========================================
  // CARD 2: CLINICAL ALERTS / ALLERGIES (Node 10:1708)
  // ==========================================
  Widget _buildClinicalAlertsCard(Patient patient) {
    final allergies = patient.allergies.isNotEmpty
        ? patient.allergies
        : const ['Penicillin', 'Latex', 'Peanuts'];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x66FFDAD6), // rgba(255,218,214,0.4)
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFDAD6), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(21),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Icon Circle Badge (Node 10:1709)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFBA1A1A),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (Node 10:1714)
                const Text(
                  'Known Allergies',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 24 / 16,
                    color: Color(0xFF93000A),
                  ),
                ),

                const SizedBox(height: 10),

                // Allergy Chips (Node 10:1715)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allergies.map((allergy) {
                    IconData icon = Icons.medication_rounded;
                    if (allergy.toLowerCase().contains('latex')) {
                      icon = Icons.shield_outlined;
                    } else if (allergy.toLowerCase().contains('peanut')) {
                      icon = Icons.spa_outlined;
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDAD6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0x33BA1A1A), // rgba(186,26,26,0.2)
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 13, color: const Color(0xFF93000A)),
                          const SizedBox(width: 5),
                          Text(
                            allergy,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              height: 16 / 12,
                              color: Color(0xFF93000A),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 3: OTHER RELEVANT INFO (Node 10:1728)
  // ==========================================
  Widget _buildOtherRelevantInfoCard(Patient patient) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6CC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0CC59), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (Node 10:1730)
          const Text(
            'Other Relevant Info',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 24 / 16,
              color: Color(0xFFF59E0B),
            ),
          ),

          const SizedBox(height: 14),

          // 1. Weight Row (Node 10:1732)
          _buildInfoRow(label: 'Weight', pillText: 'Not recorded'),

          const SizedBox(height: 10),

          // 2. Height Row (Node 10:1737)
          _buildInfoRow(label: 'Height', pillText: 'Not recorded'),

          const SizedBox(height: 10),

          // 3. Behaviour Row (Node 10:1742)
          _buildInfoRow(label: 'Behavoiour', pillText: 'Normal'),

          const SizedBox(height: 10),

          // 4. Blood Type Row (Node 10:1747)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Blood Type',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          height: 20 / 14,
                          color: Color(0xFF494552),
                        ),
                      ),
                      Text(
                        patient.bloodGroup.contains('Positive')
                            ? patient.bloodGroup
                            : '${patient.bloodGroup} Positive',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE68A),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'Recorded',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      height: 16 / 12,
                      color: Color(0xFF92400E),
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

  Widget _buildInfoRow({required String label, required String pillText}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                height: 20 / 14,
                color: Color(0xFF494552),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE68A),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Text(
              pillText,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                height: 16 / 12,
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION 5: LATEST VITALS BENTO GRID (Node 10:1753)
  // ==========================================
  Widget _buildLatestVitalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Heading (Node 10:1755)
        const Text(
          'Latest Vitals',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 24 / 16,
            color: Color(0xFF191C1D),
          ),
        ),

        const SizedBox(height: 12),

        // Row 1: Blood Pressure & Heart Rate
        Row(
          children: [
            // 1. Blood Pressure (Node 10:1757)
            Expanded(
              child: Container(
                height: 112,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDAD6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.favorite_outline,
                          size: 16,
                          color: Color(0xFFBA1A1A),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'BLOOD PRESSURE',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: Color(0xFF494552),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '120/80',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'mmHg',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 14),

            // 2. Heart Rate (Node 10:1767)
            Expanded(
              child: Container(
                height: 112,
                decoration: BoxDecoration(
                  color: const Color(0x26006971), // rgba(0,105,113,0.15)
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.show_chart_rounded,
                          size: 16,
                          color: Color(0xFF006971),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'HEART RATE',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: Color(0xFF494552),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '72',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'bpm',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Row 2: Temp & SpO2
        Row(
          children: [
            // 3. Temp (Node 10:1776)
            Expanded(
              child: Container(
                height: 112,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8DDFF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.thermostat_outlined,
                          size: 16,
                          color: Color(0xFF28006D),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'TEMP',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: Color(0xFF494552),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '98.6',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '°F',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 14),

            // 4. SpO2 (Node 10:1786)
            Expanded(
              child: Container(
                height: 112,
                decoration: BoxDecoration(
                  color: const Color(0x8076F1FF), // rgba(118,241,255,0.5)
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.air_rounded,
                          size: 16,
                          color: Color(0xFF006971),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'SPO2',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: Color(0xFF494552),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '98',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '%',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
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
  // CARD 5: INTERNAL REVIEW COMMENTS (Node 10:1797)
  // ==========================================
  Widget _buildInternalReviewCommentsCard(BuildContext context) {
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading (Node 10:1798)
          Row(
            children: const [
              Icon(
                Icons.mode_comment_outlined,
                size: 20,
                color: Color(0xFF191C1D),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Internal Review Comments',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 24 / 16,
                    color: Color(0xFF191C1D),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Empty State Container (Node 10:1802)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            child: Column(
              children: [
                // Header Row (Node 10:1803)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF28006D),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'No internal comments yet',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 20 / 14,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Add a note for the care team to review before the next visit.',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Add Comment Action Button (Node 10:1810)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.addAddendum);
                    },
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF28006D),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Add internal comment',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 6: CURRENT MEDICATIONS (Node 10:1814)
  // ==========================================
  Widget _buildCurrentMedicationsCard(BuildContext context) {
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
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Node 10:1815)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(
                      Icons.medication_outlined,
                      size: 22,
                      color: Color(0xFF28006D),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Current Medications',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 24 / 16,
                          color: Color(0xFF191C1D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.prescriptionBuilder);
                },
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    height: 16 / 12,
                    color: Color(0xFF28006D),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Medication 1: Lisinopril (Node 10:1823)
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Lisinopril',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 24 / 16,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      Text(
                        '10mg • Once daily',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Color(0xFF494552),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Medication 2: Metformin (Node 10:1831)
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E3E4), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Metformin',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 24 / 16,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      Text(
                        '500mg • Twice daily with meals',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Color(0xFF494552),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 7: INSURANCE SUMMARY (Node 10:1840)
  // ==========================================
  Widget _buildInsuranceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading (Node 10:1841)
          Row(
            children: const [
              Icon(Icons.shield_outlined, size: 20, color: Color(0xFF006971)),
              SizedBox(width: 8),
              Text(
                'Insurance',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 24 / 16,
                  color: Color(0xFF191C1D),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Insurance Details Row (Node 10:1846)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Premium Global Care',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        height: 20 / 14,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Policy: #PGC-992-AX',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        color: Color(0xFF494552),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF76F1FF),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 13,
                      color: Color(0xFF006D76),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Active',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        height: 16 / 12,
                        color: Color(0xFF006D76),
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
  // CARD 8: CARE TEAM & CONTACTS (Node 10:1856)
  // ==========================================
  Widget _buildCareTeamCard() {
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
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading (Node 10:1858)
          const Text(
            'Care Team & Contacts',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 24 / 16,
              color: Color(0xFF191C1D),
            ),
          ),

          const SizedBox(height: 16),

          // Primary Physician (Node 10:1860)
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF3F1D8B),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'PRIMARY PHYSICIAN',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                        height: 16 / 12,
                        color: Color(0xFF494552),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Dr. Sarah Jenkins',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        height: 20 / 14,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Emergency Contact (Node 10:1869)
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE1E3E4),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.phone_outlined,
                    color: Color(0xFF494552),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'EMERGENCY CONTACT',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                        height: 16 / 12,
                        color: Color(0xFF494552),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Mark Thompson (Husband)',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        height: 20 / 14,
                        color: Color(0xFF191C1D),
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
  // ACTION BUTTONS (Nodes 10:1885 & 10:1881)
  // ==========================================
  Widget _buildActionButtons(BuildContext context, Patient patient) {
    return Column(
      children: [
        // 1. Refer a Doctor Gradient Capsule (Node 10:1885)
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.createReferral);
            },
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                ),
                borderRadius: BorderRadius.circular(9999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x335B14B8),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Refer a Doctor',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 24 / 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 2. View Health Records Outlined Capsule (Node 10:1881)
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.medicalRecords);
            },
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: const Color(0xFF7A7583), width: 1),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.folder_open_outlined,
                      size: 20,
                      color: Color(0xFF191C1D),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'View Health Records',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        height: 20 / 14,
                        color: Color(0xFF191C1D),
                      ),
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

  // ==========================================
  // FLOATING BOTTOM NAVIGATION (Node 10:1636)
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
              // 1. Home (Node 10:1660)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.dashboard,
                      (route) => false,
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
                          height: 15 / 10,
                          color: Color(0xFF006D76),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients (Active cyan pill) (Node 10:1653)
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF76F1FF),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.people_alt_rounded,
                          size: 16,
                          color: Color(0xFF494552),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Patients',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            height: 15 / 10,
                            color: Color(0xFF494552),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Spacer for center elevated QR button
              const SizedBox(width: 56),

              // 4. Schedule (Node 10:1638)
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
                          fontWeight: FontWeight.w500,
                          height: 15 / 10,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Profile (Node 10:1643)
              Expanded(
                child: GestureDetector(
                  onTap: () {},
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
                          fontWeight: FontWeight.w500,
                          height: 15 / 10,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Elevated Center QR Scan Button (Node 10:1648)
          Positioned(
            top: -16,
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
                      offset: Offset(0, 12),
                      blurRadius: 25,
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

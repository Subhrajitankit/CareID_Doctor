import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:6655
/// "Care ID Doctor - Cancel Appointment"
class CancelAppointmentScreen extends StatefulWidget {
  final Appointment? appointmentArg;

  const CancelAppointmentScreen({super.key, this.appointmentArg});

  @override
  State<CancelAppointmentScreen> createState() =>
      _CancelAppointmentScreenState();
}

class _CancelAppointmentScreenState extends State<CancelAppointmentScreen> {
  // Selected clinical reason: default "Physician Availability / Emergency"
  String _selectedReason = 'Physician Availability / Emergency';

  final List<String> _reasons = [
    'Physician Availability / Emergency',
    'Emergency Clinical Duty',
    'Patient Mutual Request',
    'Clinical Schedule Conflict',
    'Facility / Equipment Unavailable',
    'Other Administrative Reason',
  ];

  late final TextEditingController _explanationController;

  // Care Continuity Protocol states
  bool _autoPromptRebook = true;
  bool _returnReferral = true;

  @override
  void initState() {
    super.initState();
    _explanationController = TextEditingController(
      text: 'Physician called to emergency cardiac catheterization lab.',
    );
  }

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rawArg =
        widget.appointmentArg ?? ModalRoute.of(context)?.settings.arguments;

    Appointment apt;
    if (rawArg is Appointment) {
      apt = rawArg;
    } else if (rawArg is Map) {
      apt = (rawArg['appointment'] as Appointment?) ?? MockData.appointments[0];
    } else {
      apt = MockData.appointments[0];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildTopAppBar(context),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2, // Schedule active tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.patientDirectory);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.appointmentsOverview);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.doctorProfile);
              break;
          }
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
              Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Navigation Header Context Bar (Node 10:6658)
                _buildHeaderContextBar(context),
                const SizedBox(height: 20),

                // 2. Appointment Context Card (Node 10:6671)
                _buildAppointmentContextCard(apt),
                const SizedBox(height: 20),

                // 3. Operational & Clinical Warning Box (Node 10:6701)
                _buildWarningBox(),
                const SizedBox(height: 20),

                // 4. Mandatory Reason Section (Node 10:6713)
                _buildMandatoryReasonSection(),
                const SizedBox(height: 20),

                // 5. Patient Care Continuity Guidance (Node 10:6761)
                _buildCareContinuityCard(),
                const SizedBox(height: 20),

                // 6. Decision Actions Container (Node 10:6786)
                _buildDecisionActions(context, apt),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top App Bar (Node 10:6795) ---
  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F5),
          border: Border(
            bottom: BorderSide(color: Color(0xFFCBC4D4), width: 1.0),
          ),
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
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left: Back button (Node 10:6798)
                Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                  ),
                ),

                // Center: CareID Logo (Node 10:6802)
                Center(
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

                // Right: Bell + Doctor Profile Avatar (Node 10:6803)
                Positioned(
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bell Icon Button (Node 10:6804)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.notificationCenter,
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 22,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Doctor Profile Avatar (Node 10:6807)
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE1E3E4),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/doctor_vance_avatar.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: const Color(0xFF006971),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'DV',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
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
          ),
        ),
      ),
    );
  }

  // --- 1. Screen Navigation Header Context Bar (Node 10:6658) ---
  Widget _buildHeaderContextBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Circular Back Button (Node 10:6659)
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFEDEEEF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 20,
              color: Color(0xFF191C1D),
            ),
          ),
        ),

        // Center Title Column (Node 10:6662)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'CLINICAL SCHEDULE',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF494552),
                letterSpacing: 0.6,
                height: 1.33,
              ),
            ),
            Text(
              'Cancel Appointment',
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

        // Right Help / Policy Button (Node 10:6667)
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFEDEEEF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.help_outline_rounded,
            size: 18,
            color: Color(0xFF191C1D),
          ),
        ),
      ],
    );
  }

  // --- 2. Appointment Context Card (Node 10:6671) ---
  Widget _buildAppointmentContextCard(Appointment apt) {
    final patient = apt.patient;

    // Initials for avatar: First letter of first name and first letter of last name
    final nameParts = patient.name.trim().split(RegExp(r'\s+'));
    final initials = nameParts.length > 1
        ? '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase()
        : (nameParts.isNotEmpty && nameParts.first.isNotEmpty
              ? nameParts.first[0].toUpperCase()
              : 'RS');

    final displayName = patient.name.isNotEmpty
        ? patient.name
        : 'Robert J. Sterling';
    final ageStr = patient.age > 0 ? '${patient.age}y' : '45y';
    final genderStr = patient.gender.isNotEmpty ? patient.gender : 'Male';
    final careIdStr = patient.careId.isNotEmpty ? patient.careId : '#8472-9901';

    final dateStr = apt.date.isNotEmpty ? apt.date : 'Wednesday, Oct 18, 2026';
    final timeStr = apt.time.isNotEmpty ? apt.time : '10:30 AM';
    final typeStr = apt.type.isNotEmpty
        ? apt.type
        : 'In-Person Clinical Review (Cardiology)';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Patient Info + Imminent Badge (Node 10:6672)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar + Name details
              Flexible(
                child: Row(
                  children: [
                    // Avatar Initials Circle (Node 10:6674)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DDFF),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials.isNotEmpty ? initials : 'RS',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF21005D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$ageStr, $genderStr • CID\n$careIdStr',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF494552),
                              letterSpacing: 0.5,
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Imminent Badge (Node 10:6681)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDADA),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4C0010),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'IMMINENT',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF920028),
                            letterSpacing: -0.3,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          '(In 2h)',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF920028),
                            letterSpacing: -0.3,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Appointment Metadata Strip (Node 10:6684)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date & Time Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.event_outlined,
                      size: 16,
                      color: Color(0xFF006971),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$dateStr • $timeStr (45 Mins)',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF191C1D),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Location Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF006971),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mount Sinai Hospital • Heart Center (Suite 400)',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF191C1D),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Clinical Type Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.medical_services_outlined,
                      size: 16,
                      color: Color(0xFF006971),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      typeStr,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF191C1D),
                        height: 1.4,
                      ),
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

  // --- 3. Operational & Clinical Warning Box (Node 10:6701) ---
  Widget _buildWarningBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x99FFDAD6), // rgba(255, 218, 214, 0.6)
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Warning Icon (Node 10:6703)
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF74001E),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.shield_outlined,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Critical Schedule Release Notice',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF93000A),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF494552),
                      height: 1.6,
                      letterSpacing: 0.5,
                    ),
                    children: const [
                      TextSpan(
                        text:
                            'Releasing this slot will cancel the patient consultation and notify the hospital outpatient triage desk. If this appointment was scheduled through an inbound referral, the referring physician (',
                      ),
                      TextSpan(
                        text: 'Dr. Sarah Jenkins',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      TextSpan(text: ') will be notified.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. Mandatory Reason Section (Node 10:6713) ---
  Widget _buildMandatoryReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: Title + "Mandatory" badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Flexible(
              child: Text(
                'Select Clinical / Administrative Reason',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191C1D),
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Mandatory',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4C0010),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Radiogroup - Reason Selectable Chips (Node 10:6719)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _reasons.map((reason) {
            final isSelected = reason == _selectedReason;

            if (isSelected) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedReason = reason),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFA44CFF), // #A44CFF
                          Color(0xFF5B14B8), // #5B14B8
                        ],
                      ),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            reason,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 0.1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedReason = reason),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          reason,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF191C1D),
                            letterSpacing: 0.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),

        // Clinical Explanation / Triage Directives (Node 10:6750)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Flexible(
              child: Text(
                'Clinical Explanation / Triage Directives',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF494552),
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '(Visible to Care Team)',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF006971),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Explanation Textarea Container (Node 10:6756)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: _explanationController,
            maxLines: 3,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF191C1D),
              height: 1.4,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: 'Enter clinical explanation...',
              hintStyle: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- 5. Patient Care Continuity Guidance (Node 10:6761) ---
  Widget _buildCareContinuityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Care Continuity Protocol',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF28006D),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Toggle 1: Auto-prompt patient to re-book (Node 10:6764)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Auto-prompt patient to re-book',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF191C1D),
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Sends digital priority invitation via Care ID',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF494552),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Custom Switch Toggle
              GestureDetector(
                onTap: () =>
                    setState(() => _autoPromptRebook = !_autoPromptRebook),
                child: Container(
                  width: 44,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _autoPromptRebook
                        ? const Color(0xFF006971)
                        : const Color(0xFFCBC4D4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  alignment: _autoPromptRebook
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal Divider (Node 10:6773)
          const Divider(height: 1, color: Color(0xFFEDEEEF)),
          const SizedBox(height: 16),

          // Checkbox 2: Return referral (Node 10:6774)
          GestureDetector(
            onTap: () => setState(() => _returnReferral = !_returnReferral),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Checkbox
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _returnReferral
                        ? const Color(0xFF28006D)
                        : const Color(0xFFE1E3E4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: _returnReferral
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // Label & Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Return referral to Dr. Sarah Jenkins',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF191C1D),
                          letterSpacing: 0.1,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Route back to primary queue for immediate re-assignment',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF494552),
                          letterSpacing: 0.5,
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
    );
  }

  // --- 6. Decision Actions Container (Node 10:6786) ---
  Widget _buildDecisionActions(BuildContext context, Appointment apt) {
    return Column(
      children: [
        // Continue to Cancel Button (Node 10:6787)
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF4C0010), // #4C0010
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.cancellationConfirmation,
                  arguments: apt,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Continue to Cancel',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Keep Appointment Button (Node 10:6793)
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEDEEEF),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () => Navigator.maybePop(context),
              child: const Center(
                child: Text(
                  'Keep Appointment',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF191C1D),
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

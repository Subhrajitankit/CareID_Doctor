import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:6834
/// "Care ID Doctor - Cancellation Confirmation"
class CancellationConfirmationScreen extends StatelessWidget {
  final Appointment? appointmentArg;

  const CancellationConfirmationScreen({super.key, this.appointmentArg});

  @override
  Widget build(BuildContext context) {
    final rawArg = appointmentArg ?? ModalRoute.of(context)?.settings.arguments;

    Appointment apt;
    String recordedReason = 'Physician Emergency Duty';
    String physicianRemarks =
        '“Doctor called into emergency cardiac catheterization lab. Slot release verified by Department Attending.”';
    bool autoPromptActive = true;
    bool returnReferralEnabled = true;

    if (rawArg is Appointment) {
      apt = rawArg;
    } else if (rawArg is Map) {
      apt = (rawArg['appointment'] as Appointment?) ?? MockData.appointments[0];
      if (rawArg['reason'] != null) {
        recordedReason = rawArg['reason'].toString();
      }
      if (rawArg['remarks'] != null) {
        physicianRemarks = rawArg['remarks'].toString();
      }
      if (rawArg['autoPrompt'] != null) {
        autoPromptActive = rawArg['autoPrompt'] as bool;
      }
      if (rawArg['returnReferral'] != null) {
        returnReferralEnabled = rawArg['returnReferral'] as bool;
      }
    } else {
      apt = MockData.appointments[0];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildTopAppBar(context),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2, // Schedule tab active
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
                // 1. Top Sub-Header & Breadcrumb (Node 10:6837)
                _buildHeaderBreadcrumb(context),
                const SizedBox(height: 16),

                // 2. Main Warning Container (Node 10:6931)
                _buildMainWarningCard(),
                const SizedBox(height: 16),

                // 3. Detailed Appointment Summary Card (Node 10:6849)
                _buildDetailedAppointmentSummaryCard(apt),
                const SizedBox(height: 16),

                // 4. Cancellation Reason Card (Node 10:6895)
                _buildCancellationReasonCard(
                  recordedReason,
                  physicianRemarks,
                  autoPromptActive,
                  returnReferralEnabled,
                ),
                const SizedBox(height: 16),

                // 5. Governance Notice (Node 10:6925)
                _buildGovernanceNotice(apt),
                const SizedBox(height: 24),

                // 6. Bottom CTA Actions (Node 10:6947)
                _buildBottomCtaActions(context, apt),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top App Bar (Node 10:6956) ---
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
                // Left: Back button (Node 10:6959)
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

                // Center: CareID Logo (Node 10:6963)
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

                // Right: Bell + Doctor Profile Avatar (Node 10:6964)
                Positioned(
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bell Icon Button (Node 10:6965)
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

                      // Doctor Profile Avatar (Node 10:6968)
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

  // --- 1. Top Sub-Header & Breadcrumb (Node 10:6837) ---
  Widget _buildHeaderBreadcrumb(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Back button + Title
        Flexible(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7E8E9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 20,
                    color: Color(0xFF191C1D),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'CLINICAL SCHEDULE • STEP 2 OF 2',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF494552),
                        letterSpacing: 0.6,
                        height: 1.33,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Confirm Cancellation',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                        height: 1.25,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Right: "FINAL REVIEW" badge (Node 10:6847)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDAD6),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: const Text(
            'FINAL REVIEW',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF93000A),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. Main Warning Container (Node 10:6931) ---
  Widget _buildMainWarningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x66FFDAD6), // rgba(255, 218, 214, 0.4)
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular warning icon
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFDAD6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 22,
                  color: Color(0xFFBA1A1A),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Cancel Appointment?',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFBA1A1A),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Are you sure you want to cancel this appointment? Releasing this clinical slot will immediately notify the hospital outpatient triage desk and dispatch an automated notification to the patient.',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF494552),
                        height: 1.62,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Audit Alert Strip (Node 10:6942)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xB3FFFFFF), // rgba(255, 255, 255, 0.7)
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.access_time_rounded,
                  size: 15,
                  color: Color(0xFFBA1A1A),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Permanent Slot Release — Action will be recorded in the hospital scheduling registry.',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFBA1A1A),
                      letterSpacing: -0.3,
                      height: 1.33,
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

  // --- 3. Detailed Appointment Summary Card (Node 10:6849) ---
  Widget _buildDetailedAppointmentSummaryCard(Appointment apt) {
    final patient = apt.patient;

    // Initials: First letter of first name and last name
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
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Profile Header (Node 10:6851)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x99F3F4F5), // rgba(243, 244, 245, 0.6)
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar + Details
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8DDFF),
                          borderRadius: BorderRadius.circular(9999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initials,
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

                // PENDING Badge (Node 10:6861)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDADA),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'PENDING',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF920028),
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Clinical Details Grid (Node 10:6863)
          // 1. Date & Scheduled Time
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date & Scheduled Time',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF494552),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                        ),
                        children: [
                          TextSpan(text: '$dateStr • $timeStr '),
                          const TextSpan(
                            text: '(45 Mins)',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF494552),
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
          const SizedBox(height: 12),

          // 2. Location & Facility
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
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location & Facility',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF494552),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                        ),
                        children: [
                          TextSpan(
                            text: 'Mount Sinai Hospital • Heart Center ',
                          ),
                          TextSpan(
                            text: '(Suite 400, Room 412)',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF494552),
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
          const SizedBox(height: 12),

          // 3. Encounter Protocol
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Encounter Protocol',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF494552),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      typeStr,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Provenance Badge (Node 10:6889)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEEF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.verified_outlined,
                  size: 16,
                  color: Color(0xFF006971),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF191C1D),
                        letterSpacing: 0.5,
                      ),
                      children: [
                        TextSpan(text: 'Referred Patient • '),
                        TextSpan(
                          text: 'Dr. Sarah Jenkins',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: ' (Cardiology) '),
                        TextSpan(
                          text: '#REF-4491',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF494552),
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

  // --- 4. Cancellation Reason Card (Node 10:6895) ---
  Widget _buildCancellationReasonCard(
    String reason,
    String remarks,
    bool autoPromptActive,
    bool returnReferralEnabled,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'RECORDED CLINICAL / ADMINISTRATIVE REASON',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF494552),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),

          // Reason Tag (Node 10:6898)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF28006D),
              borderRadius: BorderRadius.circular(9999),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
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
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Doctor Remarks Box (Node 10:6903)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Physician Remarks & Justification',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF494552),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  remarks,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF191C1D),
                    height: 1.62,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Auto-Triage Directives Checklist (Node 10:6908)
          // Directive 1: Auto-prompt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.phonelink_ring_rounded,
                        size: 15,
                        color: Color(0xFF006971),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Auto-prompt patient to re-book via Care ID',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF191C1D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: autoPromptActive
                        ? const Color(0xFF76F1FF)
                        : const Color(0xFFEDEEEF),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    autoPromptActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: autoPromptActive
                          ? const Color(0xFF006D76)
                          : const Color(0xFF494552),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Directive 2: Return referral
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.sync_alt_rounded,
                        size: 15,
                        color: Color(0xFF006971),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Return referral ticket to cardiology queue',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF191C1D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: returnReferralEnabled
                        ? const Color(0xFF76F1FF)
                        : const Color(0xFFEDEEEF),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    returnReferralEnabled ? 'Enabled' : 'Disabled',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: returnReferralEnabled
                          ? const Color(0xFF006D76)
                          : const Color(0xFF494552),
                      letterSpacing: 0.5,
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

  // --- 5. Governance Notice (Node 10:6926) ---
  Widget _buildGovernanceNotice(Appointment apt) {
    final patientName = apt.patient.name.isNotEmpty
        ? apt.patient.name
        : 'Robert J. Sterling';
    final aptId = apt.id.isNotEmpty
        ? (apt.id.startsWith('#')
              ? apt.id.toUpperCase()
              : '#APT-${apt.id.toUpperCase()}')
        : '#APT-88204-NY';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.shield_outlined,
              size: 18,
              color: Color(0xFF191C1D),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF494552),
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Care ID Clinical Governance Protocol:\n',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                  const TextSpan(text: 'Cancelling releases provider slot '),
                  TextSpan(
                    text: '$aptId ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                  const TextSpan(
                    text:
                        'into hospital pool and dispatches encrypted SMS and app notification to patient ',
                  ),
                  TextSpan(
                    text: '$patientName.',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
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

  // --- 6. Bottom CTA Actions (Node 10:6947) ---
  Widget _buildBottomCtaActions(BuildContext context, Appointment apt) {
    return Column(
      children: [
        // Primary CTA Button: Confirm Cancellation (Node 10:6948)
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF4C0010), // #4C0010
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
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.appointmentCancelled,
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
                    'Confirm Cancellation',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Secondary Cancel/Keep Button (Node 10:6954)
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFE1E3E4),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
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

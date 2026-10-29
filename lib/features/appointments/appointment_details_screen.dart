import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:4923
/// "Care ID Doctor - Appointment Details & Clinical Context"
class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment? appointmentArg;

  const AppointmentDetailsScreen({super.key, this.appointmentArg});

  @override
  Widget build(BuildContext context) {
    final apt =
        appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildTopAppBar(context),
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
          bottom: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Navigation & Action Row (Figma Node 10:4941)
                _buildTopActionRow(context),
                const SizedBox(height: 12),

                // Title & Subtitle Header (Figma Node 10:4950)
                _buildTitleHeader(),
                const SizedBox(height: 16),

                // Card 1: Top Status Hero (Figma Node 10:4956)
                _buildTopStatusHero(context, apt),
                const SizedBox(height: 16),

                // Card 2: Critical Clinical Alerts (Figma Node 10:4996)
                _buildClinicalAlertsBanner(apt),
                const SizedBox(height: 16),

                // Card 3: Patient Identity & Summary (Figma Node 10:5020)
                _buildPatientSummaryCard(context, apt),
                const SizedBox(height: 16),

                // Card 4: Specification & Logistics Bento (Figma Node 10:5064)
                _buildSpecificationBento(apt),
                const SizedBox(height: 16),

                // Card 5: Clinical Actions (Figma Node 10:5138)
                _buildClinicalActions(context, apt),
                const SizedBox(height: 16),

                // Note: Clinical Governance Policy Note (Figma Node 10:5159)
                _buildGovernancePolicyNote(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top App Bar (Figma Node 10:4925) ---
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
              color: Color(0x0D000000), // rgba(0,0,0,0.05)
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
                // Left: Back button (Node 10:4928)
                Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                  ),
                ),

                // Center: CareID Logo (Node 10:4932)
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

                // Right: Bell + Doctor Profile Avatar (Node 10:4933)
                Positioned(
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bell Icon Button (Node 10:4934)
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

                      // Doctor Profile Avatar (Node 10:4937)
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.doctorProfile,
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE1E3E4),
                              width: 2.0,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/doctor_vance_avatar.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFFE8DDFF),
                                    child: const Icon(
                                      Icons.person,
                                      size: 22,
                                      color: Color(0xFF28006D),
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

  // --- Top Navigation & Action Row (Figma Node 10:4941) ---
  Widget _buildTopActionRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Print Icon Button (Node 10:4943)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preparing appointment summary printout...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDEEEF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.print_outlined,
                  size: 18,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // More Options Icon Button (Node 10:4946)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment options'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDEEEF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Header Title & Subtitle (Figma Node 10:4950) ---
  Widget _buildTitleHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment Details',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
            color: Color(0xFF28006D),
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Encounter schedule & clinician authorization',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF494552),
          ),
        ),
      ],
    );
  }

  // --- Top Status Hero Card (Figma Node 10:4956) ---
  Widget _buildTopStatusHero(BuildContext context, Appointment apt) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Status pill + In 2 Hours indicator (Node 10:4957)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Pill badge: CONFIRMED • UPCOMING (Node 10:4958)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x4D76F1FF), // rgba(118,241,255,0.3)
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: Color(0xFF006D76),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'CONFIRMED • UPCOMING',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF006D76),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              // In 2 Hours indicator (Node 10:4963)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF006971),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'In 2 Hours',
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
            ],
          ),
          const SizedBox(height: 12),

          // Time & APT ID Row (Node 10:4967)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Today, ${apt.time}',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: Color(0xFF28006D),
                ),
              ),
              const Text(
                '#APT-88204-NY',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Color(0xFF494552),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Duration info (Node 10:4970)
          const Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 15,
                color: Color(0xFF494552),
              ),
              SizedBox(width: 6),
              Text(
                '45-minute In-Person Evaluation',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF494552),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Referral Inbound Card Context (Figma Node 10:4975)
          Container(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8DDFF),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    size: 16,
                    color: Color(0xFF28006D),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge row: Referred Patient + Ref #REF-4491 (Node 10:4982)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF28006D),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: const Text(
                              'Referred Patient',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ref #REF-4491',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Doctor Jenkins attribution (Node 10:4988)
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF191C1D),
                          ),
                          children: [
                            TextSpan(text: 'From '),
                            TextSpan(
                              text: 'Dr. Sarah Jenkins',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF28006D),
                              ),
                            ),
                            TextSpan(text: ' (Cardiology)'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Link: View Inbound Referral Packet (Node 10:4990)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.referralDetails,
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View Inbound Referral Packet',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                color: Color(0xFF006971),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 11,
                              color: Color(0xFF006971),
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
        ],
      ),
    );
  }

  // --- Critical Clinical Alerts Card (Figma Node 10:4996) ---
  Widget _buildClinicalAlertsBanner(Appointment apt) {
    return Container(
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
          // Header (Node 10:4997)
          const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: Color(0xFFBA1A1A),
              ),
              SizedBox(width: 8),
              Text(
                'Critical Clinical Alerts',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191C1D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Two Alert Chips Row (Node 10:5002)
          Row(
            children: [
              // Severe Allergy Chip (Node 10:5003)
              Expanded(
                child: Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDAD6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.emergency_rounded,
                        size: 16,
                        color: Color(0xFFBA1A1A),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SEVERE ALLERGY',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                color: Color(0xFFBA1A1A),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Penicillin (Anap...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                                color: Color(0xFF93000A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Known Condition Chip (Node 10:5011)
              Expanded(
                child: Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x6687F3FF), // rgba(135,243,255,0.4)
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.show_chart_rounded,
                        size: 16,
                        color: Color(0xFF006971),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'KNOWN CONDITION',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                color: Color(0xFF006971),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Stage 1 Hypert...',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                                color: Color(0xFF001F23),
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
      ),
    );
  }

  // --- Patient Identity & Summary Card (Figma Node 10:5020) ---
  Widget _buildPatientSummaryCard(BuildContext context, Appointment apt) {
    final patientName = apt.patient.name.isNotEmpty
        ? apt.patient.name
        : 'Robert J. Sterling';
    final careId = apt.patient.careId.isNotEmpty
        ? apt.patient.careId
        : '#8472-9901';

    return Container(
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
          // Top Identity Row (Node 10:5021)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 64x64 Circle Avatar with Verified Check Badge (Node 10:5023)
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/patient_sterling.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFEDEEEF),
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: Color(0xFF494552),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF006971),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.check,
                        size: 9,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Details: Name, Blood Group, Age, Care ID, Tags (Node 10:5028)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Blood Group Pill Row (Node 10:5029)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            patientName,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0x3376F1FF,
                            ), // rgba(118,241,255,0.2)
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: const Text(
                            'O Pos (+)',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF006971),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Demographics & CareID (Node 10:5034)
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                        ),
                        children: [
                          TextSpan(
                            text:
                                '${apt.patient.gender.isNotEmpty ? apt.patient.gender : 'Male'}, ${apt.patient.age > 0 ? apt.patient.age : 45} yrs • Care ID: ',
                          ),
                          TextSpan(
                            text: careId.startsWith('#') ? careId : '#$careId',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tags: Insured • BlueCross + EHR Pre-authorized (Node 10:5037)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDEEEF),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 12,
                                color: Color(0xFF494552),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Insured • BlueCross',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.4,
                                  color: Color(0xFF494552),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8DDFF),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: const Text(
                            'EHR Pre-authorized',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4,
                              color: Color(0xFF21005D),
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
          const SizedBox(height: 14),

          // Emergency Contact Block (Figma Node 10:5044)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.contact_phone_outlined,
                      size: 20,
                      color: Color(0xFF494552),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Contact',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            color: Color(0xFF494552),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Sarah Sterling (Wife)',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191C1D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Call Pill Button (Node 10:5053)
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dialing Sarah Sterling (Wife)...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x99E8DDFF), // rgba(232,221,255,0.6)
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, size: 12, color: Color(0xFF28006D)),
                        SizedBox(width: 4),
                        Text(
                          'Call',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Shortcut Link: View Full Patient Medical Profile (Node 10:5058)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.patientProfile,
                arguments: apt.patient,
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'View Full Patient Medical Profile',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                        color: Color(0xFF28006D),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Color(0xFF28006D),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Specification & Logistics Bento (Figma Node 10:5064) ---
  Widget _buildSpecificationBento(Appointment apt) {
    return Container(
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
          // Header Row: Specification & Logistics + Room 412 (Node 10:5065)
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Specification & Logistics',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Room 412',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Color(0xFF494552),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Box 1: Schedule (Node 10:5071)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFFE7E8E9),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 15,
                    color: Color(0xFF191C1D),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Wednesday, Oct 18, 2026',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '10:30 AM – 11:15 AM (45 Mins)',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
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
          const SizedBox(height: 12),

          // Box 2: Facility Location (Node 10:5083)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFFE7E8E9),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.local_hospital_outlined,
                    size: 16,
                    color: Color(0xFF191C1D),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Facility Location',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Mount Sinai Hospital • Heart Center',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Suite 400, 1190 5th Ave, New York, NY',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
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
          const SizedBox(height: 12),

          // Box 3: Chief Complaint (Node 10:5095)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 15,
                      color: Color(0xFF28006D),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Chief Complaint',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Color(0xFF28006D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  apt.notes.isNotEmpty
                      ? '“${apt.notes}”'
                      : '“Persistent lower back pain radiating to left leg, ongoing for 3 weeks. Lipid panel follow-up.”',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    color: Color(0xFF191C1D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Box 4: Pre-authorized Vault Records (Node 10:5103)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0x3387F3FF), // rgba(135,243,255,0.2)
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Lock icon + Title + "5 Shared" badge (Node 10:5104)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 18,
                            color: Color(0xFF001F23),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pre-authorized Vault Records',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF001F23),
                              ),
                              maxLines: 2,
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
                        color: const Color(0xFF006971),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Text(
                        '5 Shared',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Record Row 1 (Node 10:5113)
                _buildVaultRecordRow(
                  icon: Icons.description_outlined,
                  title: 'CBC & Comprehensive Lipid P...',
                  date: 'Oct 10',
                ),
                const SizedBox(height: 6),

                // Record Row 2 (Node 10:5121)
                _buildVaultRecordRow(
                  icon: Icons.image_outlined,
                  title: 'Lumbar Spine MRI & Dental OF...',
                  date: 'Sep 28',
                ),
                const SizedBox(height: 6),

                // Record Row 3 (Node 10:5129)
                _buildVaultRecordRow(
                  icon: Icons.feed_outlined,
                  title: 'Cardiology SOAP Note (Dr. Jer...',
                  date: 'Sep 20',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildVaultRecordRow({
    required IconData icon,
    required String title,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF494552)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF191C1D),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Color(0xFF006971),
            ),
          ),
        ],
      ),
    );
  }

  // --- Clinical Actions Card (Figma Node 10:5138) ---
  Widget _buildClinicalActions(BuildContext context, Appointment apt) {
    return Container(
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
          // Section Heading (Node 10:5139)
          const Text(
            'Clinical Actions',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
            ),
          ),
          const SizedBox(height: 12),

          // Primary Action: Start Clinical Visit (Node 10:5141)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.patientProfile,
                arguments: apt.patient,
              );
            },
            child: Container(
              height: 52,
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
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle_outline_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Start Clinical Visit',
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
          const SizedBox(height: 12),

          // Secondary Row: Reschedule + Cancel Visit (Node 10:5147)
          Row(
            children: [
              // Reschedule Button (Node 10:5148)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.rescheduleAppointment,
                      arguments: apt,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEEEF),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                          color: Color(0xFF28006D),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Reschedule',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Cancel Visit Button (Node 10:5153)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.cancelAppointment,
                      arguments: apt,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDAD6),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          size: 15,
                          color: Color(0xFFBA1A1A),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Cancel Visit',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            color: Color(0xFFBA1A1A),
                          ),
                        ),
                      ],
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

  // --- Clinical Governance Policy Note (Figma Node 10:5159) ---
  Widget _buildGovernancePolicyNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 18,
            color: Color(0xFF191C1D),
          ),
          SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  height: 1.5,
                  letterSpacing: 0.2,
                  color: Color(0xFF494552),
                ),
                children: [
                  TextSpan(
                    text: 'Care ID Clinical Governance Protocol: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                  TextSpan(
                    text:
                        'Rescheduling or cancellation notifies the patient immediately via push notification and SMS, updating provider slot availability across the hospital directory.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

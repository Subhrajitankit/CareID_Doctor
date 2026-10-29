import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:5909
/// "Care ID Doctor - Reschedule Success"
class RescheduleSuccessScreen extends StatelessWidget {
  final Appointment? appointmentArg;

  const RescheduleSuccessScreen({super.key, this.appointmentArg});

  @override
  Widget build(BuildContext context) {
    final apt =
        appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

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
            colors: [Color(0xFFFFF7ED), Color(0xFFF5F3FF), Color(0xFFF8F9FA)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Sub-Header Banner (Node 10:5913)
                _buildSubHeaderBanner(context),
                const SizedBox(height: 16),

                // 2. Primary Hero Success Card (Node 10:5924)
                _buildHeroSuccessCard(context),
                const SizedBox(height: 20),

                // 3. Appointment Details Card (Node 10:5945)
                _buildAppointmentDetailsCard(context, apt),
                const SizedBox(height: 20),

                // 4. Governance & Audit Trail Card (Node 10:6020)
                _buildAuditTrailCard(context, apt),
                const SizedBox(height: 24),

                // 5. Action Deck (Node 10:6058)
                _buildActionDeck(context, apt),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top App Bar (Node 10:6072) ---
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
                // Left: Back button (Node 10:6075)
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

                // Center: CareID Logo (Node 10:6079)
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

                // Right: Bell + Doctor Profile Avatar (Node 10:6080)
                Positioned(
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bell Icon Button (Node 10:6081)
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

                      // Doctor Profile Avatar (Node 10:6084)
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
                                  const Icon(
                                    Icons.person_rounded,
                                    size: 24,
                                    color: Color(0xFF28006D),
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

  // --- 1. Sub-Header Banner (Node 10:5913) ---
  Widget _buildSubHeaderBanner(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Cyan circular badge + "ENCOUNTER UPDATED"
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF76F1FF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.event_available_rounded,
                  size: 16,
                  color: Color(0xFF006971),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'ENCOUNTER UPDATED',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Color(0xFF006971),
              ),
            ),
          ],
        ),

        // Right: Circular Dismiss Button (Node 10:5920)
        GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.appointmentsOverview,
              (route) => route.settings.name == AppRoutes.dashboard,
            );
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE7E8E9),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: Color(0xFF191C1D),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. Primary Hero Success Card (Node 10:5924) ---
  Widget _buildHeroSuccessCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 264),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Top Right Blur Accent (Node 10:5935)
            Positioned(
              top: -48,
              right: -48,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 144,
                  height: 144,
                  decoration: const BoxDecoration(
                    color: Color(0x3376F1FF), // rgba(118,241,255,0.2)
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Bottom Left Blur Accent (Node 10:5936)
            Positioned(
              bottom: -40,
              left: -40,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: const BoxDecoration(
                    color: Color(0x33E8DDFF), // rgba(232,221,255,0.2)
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Center Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Success Icon: 64px Dark Teal with 80px Soft Ring (Node 10:5938)
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer soft overlay ring (Node 10:5939)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Color(0x6676F1FF), // rgba(118,241,255,0.4)
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Inner dark teal circle (Node 10:5940)
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF006971),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x4D006971),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Status Pill: CONFIRMED • RESCHEDULED (Node 10:5926)
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
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF006971),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'CONFIRMED • RESCHEDULED',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: Color(0xFF006D76),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Heading (Node 10:5932)
                  const Text(
                    'Appointment Rescheduled',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                      color: Color(0xFF28006D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle (Node 10:5934)
                  const Text(
                    'Slot re-allocation successfully committed to hospital clinical registry and synchronized with patient Care ID vault.',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: Color(0xFF494552),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. Appointment Details Card (Node 10:5945) ---
  Widget _buildAppointmentDetailsCard(BuildContext context, Appointment apt) {
    final patientName = apt.patient.name.isNotEmpty
        ? apt.patient.name
        : 'Robert J. Sterling';
    final patientAge = apt.patient.age > 0 ? apt.patient.age : 45;
    final patientGender = apt.patient.gender.isNotEmpty
        ? apt.patient.gender[0].toUpperCase()
        : 'M';
    final careId = apt.patient.careId.isNotEmpty
        ? apt.patient.careId
        : '8472-9901';
    final aptId = apt.id.isNotEmpty ? apt.id.toUpperCase() : '88204-NY';

    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Info Row (Node 10:5946)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar + Name + Age + Care ID
              Expanded(
                child: Row(
                  children: [
                    // Patient Avatar (Node 10:5948)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE7E8E9),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/patient_sterling.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.person_rounded,
                                size: 28,
                                color: Color(0xFF494552),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name + Age Pill + CareID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  patientName,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191C1D),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDEEEF),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  '$patientAge${'y, '}$patientGender',
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                    color: Color(0xFF494552),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Care ID #$careId',
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
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Appointment ID Pill (Node 10:5958)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEEEF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#APT-$aptId',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    color: Color(0xFF494552),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date, Time & Location Block (Node 10:5960)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. New Date & Time (Node 10:5961)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF28006D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.calendar_today_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Date & Time',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: Color(0xFF494552),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            apt.date.isNotEmpty
                                ? apt.date
                                : 'Saturday, Oct 21, 2026',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${apt.time.isNotEmpty ? apt.time : "10:30 AM"} – 11:15 AM EST ',
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF28006D),
                                  ),
                                ),
                                const TextSpan(
                                  text: '(45 Mins)',
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
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 2. Location & Desk (Node 10:5974)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF006971),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.domain_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location & Desk',
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
                            'Mount Sinai Heart Center',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Suite 400 • Check-in Kiosk 2, Room 412',
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
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Two Grid Metric Cards Side by Side (Node 10:5986)
          Row(
            children: [
              // Left Card: Visit Type (Node 10:5987)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services_outlined,
                            size: 14,
                            color: Color(0xFF006971),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'VISIT TYPE',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'In-Person Review',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Calendar Dispatched',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF006971),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Right Card: Referral (Node 10:5999)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.swap_horiz_rounded,
                            size: 14,
                            color: Color(0xFF28006D),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'REFERRAL',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Dr. Sarah Jenkins',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '#REF-4491',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Express QR Patient Pass Bar (Node 10:6011)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x4D76F1FF), // rgba(118,241,255,0.3)
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 18,
                        color: Color(0xFF006971),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Express QR Patient Pass',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF191C1D),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'SYNCED • V2.4',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: Color(0xFF006971),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. Governance & Audit Trail Card (Node 10:6020) ---
  Widget _buildAuditTrailCard(BuildContext context, Appointment apt) {
    final reasonText = apt.notes.isNotEmpty
        ? apt.notes
        : 'Physician Emergency Duty';

    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title + Live Audit Indicator (Node 10:6021)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Governance & Audit Trail',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF006971),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Live Audit',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Color(0xFF006971),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Audit Item 1: Dispatch Confirmed (Node 10:6028)
          _buildAuditItem(
            icon: Icons.notifications_active_rounded,
            iconBg: const Color(0xFF76F1FF),
            iconColor: const Color(0xFF006971),
            title: 'Dispatch Confirmed',
            subtitle:
                'Encrypted patient SMS & in-app push alert dispatched with updated express QR pass.',
          ),
          const SizedBox(height: 14),

          // Audit Item 2: Hospital EHR Synchronized (Node 10:6038)
          _buildAuditItem(
            icon: Icons.sync_rounded,
            iconBg: const Color(0xFFE8DDFF),
            iconColor: const Color(0xFF28006D),
            title: 'Hospital EHR Synchronized',
            subtitle: 'Epic/Cerner scheduling bridge updated at 10:32 AM.',
          ),
          const SizedBox(height: 14),

          // Audit Item 3: Reschedule Justification (Node 10:6048)
          _buildAuditItem(
            icon: Icons.assignment_late_rounded,
            iconBg: const Color(0xFFE7E8E9),
            iconColor: const Color(0xFF494552),
            title: 'Reschedule Justification',
            subtitle: reasonText,
          ),
        ],
      ),
    );
  }

  Widget _buildAuditItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Center(child: Icon(icon, size: 14, color: iconColor)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  height: 1.4,
                  color: Color(0xFF494552),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 5. Action Deck (Node 10:6058) ---
  Widget _buildActionDeck(BuildContext context, Appointment apt) {
    final patientName = apt.patient.name.isNotEmpty
        ? apt.patient.name
        : 'Robert J. Sterling';

    return Column(
      children: [
        // Primary Gradient Button: "View Appointment Details" (Node 10:6059)
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.reviewReschedule,
              arguments: apt,
            );
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
              ),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View Appointment Details',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Secondary Button: "Back to Appointments Overview" (Node 10:6064)
        GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.appointmentsOverview,
              (route) => route.settings.name == AppRoutes.dashboard,
            );
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(9999),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Back to Appointments Overview',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF28006D),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Tertiary Link: "View [Patient] Profile" (Node 10:6067)
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.patientProfile,
              arguments: apt.patient,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View $patientName Profile',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF006971),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.open_in_new_rounded,
                  size: 14,
                  color: Color(0xFF006971),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

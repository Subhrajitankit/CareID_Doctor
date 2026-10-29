import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:708
/// "Care ID Doctor - Verification Success"
class QrVerificationSuccessScreen extends StatelessWidget {
  final Patient? patientArg;

  const QrVerificationSuccessScreen({super.key, this.patientArg});

  String _formatBloodGroup(String bg) {
    if (bg.isEmpty) return 'B Positive';
    if (bg.toUpperCase() == 'B+' || bg.toUpperCase() == 'B POSITIVE') {
      return 'B Positive';
    }
    if (bg.toUpperCase() == 'A+' || bg.toUpperCase() == 'A POSITIVE') {
      return 'A Positive';
    }
    if (bg.toUpperCase() == 'O+' || bg.toUpperCase() == 'O POSITIVE') {
      return 'O Positive';
    }
    if (bg.toUpperCase() == 'AB+' || bg.toUpperCase() == 'AB POSITIVE') {
      return 'AB Positive';
    }
    return bg;
  }

  String _formatHvId(String careId) {
    final clean = careId.replaceAll('#', '').trim();
    if (clean.toUpperCase().startsWith('HV-ID:')) return clean;
    if (clean.isEmpty) return 'HV-ID: 8821-990-212';
    return 'HV-ID: $clean';
  }

  @override
  Widget build(BuildContext context) {
    final rawPatient =
        patientArg ??
        (ModalRoute.of(context)?.settings.arguments as Patient?) ??
        const Patient(
          id: 'p-eleanor',
          name: 'Eleanor Vance',
          age: 42,
          gender: 'Female',
          bloodGroup: 'B Positive',
          careId: '8821-990-212',
          allergies: [],
          chronicConditions: [],
        );

    final patientName = rawPatient.name;
    final hvId = _formatHvId(rawPatient.careId);
    final bloodGroup = _formatBloodGroup(rawPatient.bloodGroup);
    final patientAge = '${rawPatient.age} Years';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildTopAppBar(context),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0, // Home tab active as shown in Figma
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
        width: double.infinity,
        height: double.infinity,
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // 1. Success Header Area (Node 10:747)
                const SizedBox(height: 12),
                _buildSuccessHeader(),
                const SizedBox(height: 28),

                // 2. Central Verification Card (Node 10:759)
                _buildCentralVerificationCard(
                  context: context,
                  patient: rawPatient,
                  patientName: patientName,
                  hvId: hvId,
                  bloodGroup: bloodGroup,
                  patientAge: patientAge,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top App Bar (Node 10:733) ---
  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8F9FA),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button (Node 10:735)
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 22,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ),

                // CareID Logo (Node 10:739)
                Image.asset(
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

                // Notification Bell (Node 10:740)
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- 1. Success Header (Node 10:747) ---
  Widget _buildSuccessHeader() {
    return Column(
      children: [
        // Verified Success Icon Badge (Node 10:750)
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: const Color(0xFF006971),
            shape: BoxShape.circle,
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
          alignment: Alignment.center,
          child: const Icon(
            Icons.verified_user_rounded,
            size: 52,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        // Title: Patient Verified (Node 10:756)
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
          ).createShader(bounds),
          child: const Text(
            'Patient Verified',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Color is masked by shader
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),

        // Subtitle (Node 10:758)
        const Text(
          'Secure identity check complete. Encrypted\nhealth records are now accessible for your\nclinical review.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF494552),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // --- 2. Central Verification Card (Node 10:759) ---
  Widget _buildCentralVerificationCard({
    required BuildContext context,
    required Patient patient,
    required String patientName,
    required String hvId,
    required String bloodGroup,
    required String patientAge,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 448),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBC4D4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Patient Profile Header (Node 10:760)
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Avatar with cyan ring (Node 10:767)
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF76F1FF),
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/patient_eleanor_vance.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE8DDFF),
                        alignment: Alignment.center,
                        child: const Text(
                          'EV',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Verified Badge at bottom right of avatar (Node 10:768)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006971),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Patient Name (Node 10:762)
          Text(
            patientName,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // HV-ID (Node 10:764)
          Text(
            hvId,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A7583),
              letterSpacing: 0.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Divider
          const Divider(color: Color(0xFFCBC4D4), height: 1, thickness: 1),
          const SizedBox(height: 20),

          // Clinical Quick Info Grid (Node 10:770)
          Row(
            children: [
              // Blood Group Tile (Node 10:771)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Blood Group',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            size: 16,
                            color: Color(0xFFBA1A1A),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              bloodGroup,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF191C1D),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Patient Age Tile (Node 10:778)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient Age',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 15,
                            color: Color(0xFF006971),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              patientAge,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF191C1D),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Access Badge Banner (Node 10:785)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0x1A3F1D8B), // rgba(63, 29, 139, 0.1)
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF3F1D8B)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.lock_rounded,
                        size: 18,
                        color: Color(0xFF28006D),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Verified Doctor Access',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF28006D),
                          ),
                          maxLines: 1,
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
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF28006D),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFCFBDFF),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons (Node 10:793)
          // Primary Button: Open Patient Profile (Node 10:794)
          Container(
            width: double.infinity,
            height: 56,
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
              boxShadow: const [
                BoxShadow(
                  color: Color(0x335B14B8),
                  blurRadius: 10,
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
                    AppRoutes.patientProfile,
                    arguments: patient,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Open Patient Profile',
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
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Secondary Button: Scan Another QR (Node 10:798)
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: const Color(0xFF7A7583)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(9999),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.cameraPermission,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 20,
                      color: Color(0xFF28006D),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Scan Another QR',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF28006D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

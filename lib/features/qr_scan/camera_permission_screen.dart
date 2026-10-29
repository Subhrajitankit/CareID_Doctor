import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';

/// Exact implementation of Figma Node 10:529
/// "Care ID Doctor - Camera Permission"
class CameraPermissionScreen extends StatelessWidget {
  const CameraPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Main White Card (Node 10:564)
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 448),
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Illustration Area: Concentric scanning circles (Node 10:571)
                      SizedBox(
                        width: 192,
                        height: 192,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer concentric circle (Node 10:573)
                            Container(
                              width: 192,
                              height: 192,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0x333F1D8B),
                                  width: 2,
                                ),
                              ),
                            ),
                            // Inner concentric circle (Node 10:574)
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0x1A3F1D8B),
                                  width: 2,
                                ),
                              ),
                            ),
                            // Center scanner container with scan line (Node 10:575)
                            Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                color: const Color(0x1A3F1D8B),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/camera_permission_scanner.png',
                                    width: 96,
                                    height: 96,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.camera_alt_rounded,
                                              size: 54,
                                              color: Color(0xFF5B14B8),
                                            ),
                                  ),
                                  // Scan line effect (Node 10:577)
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    height: 4,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0x00006971),
                                            Color(0xFF006971),
                                            Color(0x00006971),
                                          ],
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
                      const SizedBox(height: 28),

                      // Heading 2: Camera Access Required (Node 10:566)
                      const Text(
                        'Camera Access\nRequired',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                          height: 1.33,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Supporting Text (Node 10:569)
                      const Text(
                        'Allow camera access to scan secure Health Vault QR codes and instantly retrieve patient medical records.',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                          height: 1.625,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),

                      // Actions (Node 10:578)
                      // Primary Button: Allow Camera (Node 10:579)
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
                              color: Color(0x333F1D8B),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Color(0x333F1D8B),
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
                                AppRoutes.qrProcessing,
                              );
                            },
                            child: const Center(
                              child: Text(
                                'Allow Camera',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Secondary Button: Not Now (Node 10:582)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.maybePop(context),
                            child: const Center(
                              child: Text(
                                'Not Now',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF494552),
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Privacy Badge (Node 10:585)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x1A76F1FF), // rgba(118,241,255,0.1)
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: const Color(0x1A006971), // rgba(0,105,113,0.1)
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.verified_user_rounded,
                        size: 14,
                        color: Color(0xFF006D76),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Secure, encrypted connection',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF006D76),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top App Bar (Node 10:554) ---
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
                // Back Button (Node 10:556)
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

                // CareID Logo (Node 10:559)
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

                // Notification Bell (Node 10:560)
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
}

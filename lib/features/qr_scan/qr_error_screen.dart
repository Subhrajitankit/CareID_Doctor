import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';

/// Exact implementation of Figma Node 10:802
/// "Care ID Doctor - QR Error States"
class QrErrorScreen extends StatelessWidget {
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onManualSearch;

  const QrErrorScreen({
    super.key,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
    this.onManualSearch,
  });

  @override
  Widget build(BuildContext context) {
    // Extract route arguments if provided
    final args = ModalRoute.of(context)?.settings.arguments;
    String displayTitle = errorTitle ?? 'QR Code Expired';
    String displayMessage =
        errorMessage ??
        'This code is no longer valid or not\nrecognized by the system.';

    if (args is Map) {
      if (args.containsKey('title') && args['title'] is String) {
        displayTitle = args['title'] as String;
      }
      if (args.containsKey('message') && args['message'] is String) {
        displayMessage = args['message'] as String;
      }
    } else if (args is String && args.isNotEmpty) {
      displayMessage = args;
    }

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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),

                // 1. Hero Illustration Container (Figma Node 10:839)
                _buildIllustrationCard(),
                const SizedBox(height: 28),

                // 2. Title & Subtitle (Figma Node 10:846)
                _buildHeadingSection(displayTitle, displayMessage),
                const SizedBox(height: 32),

                // 3. Action Buttons Cluster (Figma Node 10:852)
                _buildActionButtons(context),
                const SizedBox(height: 24),

                // 4. Help Hint (Figma Node 10:862)
                _buildHelpHint(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top App Bar (Figma Node 10:827) ---
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
                // Back Button (Node 10:829)
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

                // CareID Logo (Node 10:833)
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

                // Notification Bell (Node 10:834)
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

  // --- Hero Illustration Container (Figma Node 10:839) ---
  Widget _buildIllustrationCard() {
    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Background Glow Decor (Node 10:840)
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFDAD6).withValues(alpha: 0.6),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),

            // Main Illustration Image Container (Node 10:841)
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 15,
                    spreadRadius: -3,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    spreadRadius: -4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Image.asset(
                  'assets/images/qr_expired_hologram.png',
                  width: 272,
                  height: 272,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 272,
                    height: 272,
                    color: const Color(0xFFF7F2FA),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 72,
                        color: Color(0xFFBA1A1A),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Floating Semantic Badges (Figma Node 10:843)
            Positioned(
              top: -12,
              right: -12,
              child: Container(
                width: 54,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 10,
                      offset: Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 25,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Headings Section (Figma Node 10:846) ---
  Widget _buildHeadingSection(String title, String message) {
    return Column(
      children: [
        // Title with Purple Gradient (Node 10:848)
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
          ).createShader(bounds),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Subtitle (Node 10:850)
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF494552),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // --- Action Buttons Cluster (Figma Node 10:852) ---
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary "Try Again" Button (Node 10:853)
        GestureDetector(
          onTap:
              onRetry ??
              () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.cameraPermission,
                );
              },
          child: Container(
            width: double.infinity,
            height: 56,
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
                  spreadRadius: -1,
                  offset: Offset(0, 4),
                ),
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 4,
                  spreadRadius: -2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Try Again',
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
        const SizedBox(height: 16),

        // Secondary "Manual Patient Search" Button (Node 10:858)
        GestureDetector(
          onTap:
              onManualSearch ??
              () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.patientSearch,
                );
              },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF76F1FF),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_rounded, color: Color(0xFF006D76), size: 20),
                SizedBox(width: 8),
                Text(
                  'Manual Patient Search',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF006D76),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Help Hint (Figma Node 10:862) ---
  Widget _buildHelpHint() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.help_outline_rounded, size: 14, color: Color(0xFF7A7583)),
        SizedBox(width: 6),
        Flexible(
          child: Text(
            'Need help? Contact hospital administration',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7A7583),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

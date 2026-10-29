import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';

/// Exact implementation of Figma Node 10:1026
/// "Care ID Doctor - Access Denied"
class AccessDeniedScreen extends StatefulWidget {
  final VoidCallback? onRequestAccess;
  final VoidCallback? onBack;

  const AccessDeniedScreen({super.key, this.onRequestAccess, this.onBack});

  @override
  State<AccessDeniedScreen> createState() => _AccessDeniedScreenState();
}

class _AccessDeniedScreenState extends State<AccessDeniedScreen> {
  int _bottomNavIndex = 0;
  bool _isActionInProgress = false;
  Timer? _actionTimer;

  @override
  void dispose() {
    _actionTimer?.cancel();
    super.dispose();
  }

  void _handleRequestAccess() {
    if (widget.onRequestAccess != null) {
      widget.onRequestAccess!();
      return;
    }
    if (_isActionInProgress) return;
    setState(() => _isActionInProgress = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Access request submitted for clinical compliance review.',
          style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
        ),
        backgroundColor: Color(0xFF5B14B8),
        duration: Duration(seconds: 3),
      ),
    );

    _actionTimer?.cancel();
    _actionTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isActionInProgress = false);
      }
    });
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Top App Bar matching Figma node 10:1051
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button (node 10:1053)
                  GestureDetector(
                    onTap: _handleBack,
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 22,
                          color: Color(0xFF28006D),
                        ),
                      ),
                    ),
                  ),

                  // CareID Logo (node 10:1055)
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

                  // Notification Bell (node 10:1056)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.notificationCenter,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox(
                      width: 32,
                      height: 36,
                      child: Center(
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 22,
                          color: Color(0xFF28006D),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient (node 10:1026)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.6, -1.0),
                  end: Alignment(0.6, 1.0),
                  colors: [
                    Color(0xFFFFF7ED), // rgb(255, 247, 237)
                    Color(0xFFF5F3FF), // rgb(245, 243, 255)
                    Color(0xFFF8F9FA),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Main Scrollable Content (node 10:1058)
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
              children: [
                // Illustration & Main Message Bento Card (node 10:1061)
                _buildMainCard(),

                const SizedBox(height: 16),

                // Context Sidebar Security Info Card (node 10:1080)
                _buildSecurityInfoCard(),

                const SizedBox(height: 16),

                // Visual Accent Card (node 10:1097)
                _buildVisualAccentCard(),
              ],
            ),
          ),

          // Bottom Navigation Shell (node 10:1027)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNav(
              currentIndex: _bottomNavIndex,
              onTap: (index) {
                setState(() => _bottomNavIndex = index);
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashboard,
                    );
                    break;
                  case 1:
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.patientDirectory,
                    );
                    break;
                  case 2:
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.appointmentsOverview,
                    );
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.doctorProfile,
                    );
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Main Message Bento Card (Figma Node 10:1061) ---
  Widget _buildMainCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Badge Container (node 10:1063)
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFFFDAD6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Icon(
                Icons.lock_person_rounded,
                size: 44,
                color: Color(0xFF93000A),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Heading 2 (node 10:1068)
          const Text(
            'Access\nRestricted',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              color: Color(0xFF191C1D),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),

          // Body Description (node 10:1071)
          const Text(
            'You do not currently have permission to view this patient\'s records. Medical data privacy protocols require explicit authorization for non-attending physicians.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF494552),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),

          // Primary Button: "Request Access" (node 10:1073)
          GestureDetector(
            onTap: _handleRequestAccess,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A5B14B8),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Request Access',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Secondary Button: "Back" (node 10:1077)
          GestureDetector(
            onTap: _handleBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF7A7583), width: 1),
              ),
              child: const Center(
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF28006D),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Security Protocol Card (Figma Node 10:1080) ---
  Widget _buildSecurityInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8E9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (node 10:1081)
          const Row(
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 20,
                color: Color(0xFF006D76),
              ),
              SizedBox(width: 12),
              Text(
                'Security Protocol',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF191C1D),
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Item 1: HIPAA Compliance (node 10:1087)
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFF494552),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'HIPAA compliance requires just-in-time access control for all PII/PHI data.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF494552),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Item 2: Audit Trail (node 10:1092)
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.history_rounded,
                  size: 16,
                  color: Color(0xFF494552),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Access requests are logged and audited by the hospital compliance committee.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF494552),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Visual Accent Card (Figma Node 10:1097) ---
  Widget _buildVisualAccentCard() {
    return Container(
      width: double.infinity,
      height: 192,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Hospital Scene Image (node 10:1098)
            Image.asset(
              'assets/images/access_denied_hospital_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFE2E4E8),
                child: const Center(
                  child: Icon(
                    Icons.local_hospital_rounded,
                    size: 48,
                    color: Color(0xFF7A7583),
                  ),
                ),
              ),
            ),

            // Purple Tint Overlay (node 10:1099)
            Container(color: const Color(0xFF28006D).withValues(alpha: 0.1)),

            // Bottom Dark Gradient Overlay (node 10:1100)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0x99000000), // rgba(0,0,0,0.6)
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Bottom Text Label (node 10:1101)
            const Positioned(
              left: 24,
              bottom: 24,
              child: Opacity(
                opacity: 0.9,
                child: Text(
                  'CONFIDENTIAL INFORMATION',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    color: Colors.white,
                    height: 1.33,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

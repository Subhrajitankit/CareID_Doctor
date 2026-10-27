import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class CameraPermissionScreen extends StatelessWidget {
  const CameraPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Scan Patient CareID',
          style: AppTypography.cardTitle.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.scanHistory),
            tooltip: 'Scan History',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Simulated Camera Viewfinder
          Center(
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cyanPill, width: 2.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.qr_code_2_rounded,
                    size: 150,
                    color: Color(0x33FFFFFF),
                  ),
                  Container(width: 200, height: 2, color: AppColors.cyanPill),
                ],
              ),
            ),
          ),

          // Bottom Sheet Overlay for Permission / Action
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
              decoration: const BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.purpleSurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.primaryPurple,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Point Camera at Patient QR',
                    style: AppTypography.sectionTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ask patient to open their CareID dynamic QR code. Dynamic tokens refresh every 60 seconds for security.',
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Simulate QR Code Scan',
                    icon: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.qrProcessing);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.qrError),
                        child: Text(
                          'Test Expired QR',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.criticalRed,
                          ),
                        ),
                      ),
                      const Text(' • '),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.accessDenied,
                        ),
                        child: Text(
                          'Test Access Denied',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.criticalRed,
                          ),
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
    );
  }
}

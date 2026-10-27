import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class QrErrorScreen extends StatelessWidget {
  const QrErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Verification Failed'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.warningOrange,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 54,
                      color: AppColors.warningOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'QR Token Expired or Invalid',
                  style: AppTypography.screenTitle.copyWith(
                    color: AppColors.warningOrange,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'The patient QR code has expired (60-second limit reached) or the digital signature could not be verified by the cryptographic gateway.',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primaryPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Recommended Doctor Action',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ask the patient to tap "Refresh QR" inside their CareID app, or proceed using manual patient ID search.',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Scan New QR Code',
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.cameraPermission,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Manual Patient Search',
                  isSecondary: true,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.patientSearch,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class ReportUploadSuccessScreen extends StatelessWidget {
  const ReportUploadSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.successGreen,
                      width: 2.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.verified_rounded,
                      size: 60,
                      color: AppColors.successGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Report Recorded in Vault',
                  style: AppTypography.screenTitle.copyWith(
                    color: AppColors.successGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'The lab report has been cryptographically signed and added to Arthur Miller\'s medical records timeline.',
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Record ID', style: AppTypography.bodySmall),
                          Text(
                            'REC-2026-9901',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Audit Hash', style: AppTypography.bodySmall),
                          Text(
                            '0x88f2...7c19',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 13,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'View in Medical Records',
                  icon: const Icon(
                    Icons.folder_shared_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.medicalRecords,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Return to Dashboard',
                  isSecondary: true,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.dashboard,
                      (r) => false,
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

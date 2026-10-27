import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class ReferralSuccessScreen extends StatelessWidget {
  const ReferralSuccessScreen({super.key});

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
                  width: 100,
                  height: 100,
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
                      Icons.send_and_archive_rounded,
                      size: 54,
                      color: AppColors.successGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Referral Dispatched',
                  style: AppTypography.screenTitle.copyWith(
                    color: AppColors.successGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Clinical referral packet with encrypted EHR links has been sent to the specialist department queue.',
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
                          Text(
                            'Referral Token',
                            style: AppTypography.bodySmall,
                          ),
                          Text(
                            'REF-2026-EP-094',
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
                          Text(
                            'Notification Status',
                            style: AppTypography.bodySmall,
                          ),
                          Text(
                            'Delivered to Provider',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppColors.tealButton,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Back to Referral Hub',
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.referralDashboard,
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

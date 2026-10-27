import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Restricted'),
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
                    color: AppColors.criticalBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.criticalRed, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.gpp_bad_rounded,
                      size: 54,
                      color: AppColors.criticalRed,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Clinical Access Denied',
                  style: AppTypography.screenTitle.copyWith(
                    color: AppColors.criticalRed,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'The patient has not granted consent for Cardiology record sharing or your department is outside the patient-specified authorization radius.',
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
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.textMuted,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'CareID Privacy Rule: Patient retains sovereign ownership of all clinical data.',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Emergency Clinical Override',
                  icon: const Icon(
                    Icons.crisis_alert_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Emergency Override Request Logged with Hospital Ethics Committee',
                        ),
                        backgroundColor: AppColors.criticalRed,
                      ),
                    );
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashboard,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Return to Dashboard',
                  isSecondary: true,
                  onPressed: () => Navigator.pop(context),
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

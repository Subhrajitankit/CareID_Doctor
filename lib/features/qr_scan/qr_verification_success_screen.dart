import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';

class QrVerificationSuccessScreen extends StatelessWidget {
  const QrVerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = MockData.patients[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Consent Verified'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (r) => false,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 90,
                  height: 90,
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
                      Icons.lock_open_rounded,
                      size: 48,
                      color: AppColors.successGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Access Granted',
                  style: AppTypography.screenTitle.copyWith(
                    color: AppColors.successGreen,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Emergency & Clinical Vault Session Active',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 28),

                // Patient Information Card
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: AppColors.purpleSurface,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                patient.name
                                    .split(' ')
                                    .map((e) => e[0])
                                    .take(2)
                                    .join(),
                                style: AppTypography.cardTitle.copyWith(
                                  color: AppColors.primaryPurple,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient.name,
                                  style: AppTypography.cardTitle.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${patient.age} yrs • ${patient.gender} • Blood ${patient.bloodGroup}',
                                  style: AppTypography.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  patient.careId,
                                  style: AppTypography.labelUppercase.copyWith(
                                    color: AppColors.primaryPurple,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Consent Scope', style: AppTypography.bodySmall),
                          Text(
                            'Full EHR & Imaging',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Session Validity',
                            style: AppTypography.bodySmall,
                          ),
                          Text(
                            '4 Hours (Hospital Rounds)',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                              color: AppColors.tealButton,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Open Patient Medical Chart',
                  icon: const Icon(
                    Icons.folder_shared_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.patientProfile,
                      arguments: patient,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Back to Dashboard',
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

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';

class DrugInteractionReviewScreen extends StatelessWidget {
  const DrugInteractionReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interaction Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Warning Card
                AppCard(
                  leftAccentColor: AppColors.warningOrange,
                  backgroundColor: AppColors.warningBg,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warningOrange,
                        size: 36,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Moderate Interaction Flag',
                              style: AppTypography.cardTitle.copyWith(
                                color: AppColors.warningOrange,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Metoprolol Succinate + Potassium Chloride',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.brown.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pharmacological Analysis',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 10),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Severity: Moderate',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          const StatusBadge(
                            label: 'CLINICAL OVERRIDE',
                            severity: BadgeSeverity.warning,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Beta-blockers can decrease renal excretion of potassium, potentially exacerbating hyperkalemia. However, patient has confirmed baseline hypokalemia (K+ 3.4 mEq/L). Repletion is clinically indicated with laboratory monitoring.',
                        style: AppTypography.bodyMedium.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Allergy Cross-Check', style: AppTypography.sectionTitle),
                const SizedBox(height: 10),
                AppCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.successGreen,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No Allergy Contraindications',
                              style: AppTypography.cardTitle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Patient allergy to Penicillin & Sulfa has 0% structural cross-reactivity with prescribed medications.',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Override & Proceed to Sign Rx',
                  icon: const Icon(Icons.verified, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.prescriptionPreview);
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Edit Prescribed Regimen',
                  isSecondary: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

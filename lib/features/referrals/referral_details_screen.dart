import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class ReferralDetailsScreen extends StatelessWidget {
  final ReferralItem? referralArg;

  const ReferralDetailsScreen({super.key, this.referralArg});

  @override
  Widget build(BuildContext context) {
    final referral =
        referralArg ??
        (ModalRoute.of(context)?.settings.arguments as ReferralItem?) ??
        MockData.referrals[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  leftAccentColor: referral.urgency == 'Critical'
                      ? AppColors.criticalRed
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(
                            label: referral.urgency,
                            severity: referral.urgency == 'Critical'
                                ? BadgeSeverity.critical
                                : BadgeSeverity.info,
                          ),
                          Text(referral.date, style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Target Specialist:',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        referral.targetDoctor,
                        style: AppTypography.screenTitle.copyWith(fontSize: 20),
                      ),
                      Text(
                        'Department of ${referral.specialty}',
                        style: AppTypography.bodySmall,
                      ),
                      const Divider(height: 24),
                      Text(
                        'Patient: ${referral.patient.name} (${referral.patient.careId})',
                        style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      ),
                      Text(
                        'Status: ${referral.status}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.tealButton,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Clinical Justification',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 8),
                AppCard(
                  child: Text(referral.reason, style: AppTypography.bodyLarge),
                ),
                const SizedBox(height: 20),
                Text(
                  'Doctor Clinical Notes',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 8),
                AppCard(
                  child: Text(
                    referral.clinicalNotes,
                    style: AppTypography.bodyMedium,
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'View Patient Medical Chart',
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.patientProfile,
                      arguments: referral.patient,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

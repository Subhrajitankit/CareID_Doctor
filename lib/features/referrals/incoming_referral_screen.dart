import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class IncomingReferralScreen extends StatelessWidget {
  final ReferralItem? referralArg;

  const IncomingReferralScreen({super.key, this.referralArg});

  @override
  Widget build(BuildContext context) {
    final referral =
        referralArg ??
        (ModalRoute.of(context)?.settings.arguments as ReferralItem?) ??
        MockData.referrals[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Referral Request'),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const StatusBadge(
                            label: 'INCOMING REQUEST',
                            severity: BadgeSeverity.info,
                          ),
                          Text(referral.date, style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Referring Clinician:',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'Dr. Marcus Adams, MD',
                        style: AppTypography.screenTitle.copyWith(fontSize: 20),
                      ),
                      Text(
                        'Emergency Medicine • St. Jude Hospital',
                        style: AppTypography.bodySmall,
                      ),
                      const Divider(height: 24),
                      Text(
                        'Patient: ${referral.patient.name} (${referral.patient.careId})',
                        style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      ),
                      Text(
                        'Urgency: ${referral.urgency}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.criticalRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Clinical Consultation Request',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 8),
                AppCard(
                  child: Text(referral.reason, style: AppTypography.bodyLarge),
                ),
                const SizedBox(height: 20),
                Text('Transfer Notes', style: AppTypography.sectionTitle),
                const SizedBox(height: 8),
                AppCard(
                  child: Text(
                    referral.clinicalNotes,
                    style: AppTypography.bodyMedium,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Accept Consult',
                        icon: const Icon(Icons.check, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Referral Accepted. Patient added to your clinical queue.',
                              ),
                              backgroundColor: AppColors.successGreen,
                            ),
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.dashboard,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: 'Decline / Triage',
                        isSecondary: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

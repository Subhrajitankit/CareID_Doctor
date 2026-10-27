import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class PatientSummaryScreen extends StatelessWidget {
  final Patient? patientArg;

  const PatientSummaryScreen({super.key, this.patientArg});

  @override
  Widget build(BuildContext context) {
    final patient =
        patientArg ??
        (ModalRoute.of(context)?.settings.arguments as Patient?) ??
        MockData.patients[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Quick Review'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
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
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            patient.name,
                            style: AppTypography.screenTitle.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          if (patient.isCritical)
                            const StatusBadge(
                              label: 'CRITICAL',
                              severity: BadgeSeverity.critical,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${patient.careId} • ${patient.age}M • Scheduled: ${patient.scheduledTime}',
                        style: AppTypography.bodySmall,
                      ),
                      const Divider(height: 24),
                      Text(
                        'CHIEF COMPLAINT',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        patient.primaryComplaint,
                        style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VITALS SNAPSHOT',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildVitalSummary('Blood Pressure', '142/88', true),
                          _buildVitalSummary('Heart Rate', '118 bpm', true),
                          _buildVitalSummary('SpO2', '96%', false),
                          _buildVitalSummary('Temp', '98.4°F', false),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE ALLERGIES & WARNINGS',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        patient.allergies.join(', '),
                        style: AppTypography.cardTitle.copyWith(
                          color: AppColors.criticalRed,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Chronic: ${patient.chronicConditions.join(', ')}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Write Prescription',
                  icon: const Icon(Icons.edit_document, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.prescriptionBuilder,
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Create Specialist Referral',
                  isSecondary: true,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.createReferral),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitalSummary(String label, String value, bool isCritical) {
    return Column(
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.cardTitle.copyWith(
            fontSize: 15,
            color: isCritical ? AppColors.criticalRed : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class PrescriptionHistoryScreen extends StatelessWidget {
  const PrescriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: MockData.prescriptions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final rx = MockData.prescriptions[index];
              return AppCard(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.prescriptionPreview);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rx #${rx.id}',
                          style: AppTypography.cardTitle.copyWith(fontSize: 16),
                        ),
                        const StatusBadge(
                          label: 'TRANSMITTED',
                          severity: BadgeSeverity.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patient: ${rx.patient.name} (${rx.patient.careId})',
                      style: AppTypography.bodySmall,
                    ),
                    Text(
                      'Diagnosis: ${rx.diagnosis}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(height: 20),
                    ...rx.medications.map(
                      (med) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check,
                              size: 14,
                              color: AppColors.tealButton,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${med.name} ${med.dosage} (${med.frequency})',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Prescribed on: ${rx.date}',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

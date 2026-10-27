import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent CareID Scans'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Clinical Consent Audit Trail',
                style: AppTypography.cardTitle,
              ),
              const SizedBox(height: 6),
              Text(
                'Log of all patient QR code scans and consent tokens authorized under your medical license.',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: 18),
              ...MockData.patients.map((patient) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.patientProfile,
                        arguments: patient,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              patient.name,
                              style: AppTypography.cardTitle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            const StatusBadge(
                              label: 'SESSION ACTIVE',
                              severity: BadgeSeverity.success,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${patient.careId} • Consent granted today at ${patient.scheduledTime}',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.lock_clock,
                              size: 14,
                              color: AppColors.tealButton,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Valid until 01:00 PM • St. Jude Cardiology Clinic',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                color: AppColors.tealButton,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

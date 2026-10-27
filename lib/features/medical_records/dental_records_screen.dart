import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';

class DentalRecordsScreen extends StatelessWidget {
  const DentalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dental Records Timeline')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Annual Panoramic Dental X-Ray',
                          style: AppTypography.cardTitle,
                        ),
                        const StatusBadge(
                          label: 'COMPLETED',
                          severity: BadgeSeverity.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Provider: Dr. Clara Wei, DDS • Apex Dental Clinic',
                      style: AppTypography.bodySmall,
                    ),
                    const Divider(height: 20),
                    Text(
                      'Odontogram Findings:',
                      style: AppTypography.labelUppercase.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'No active carious lesions. Enamel micro-wear noted on tooth #19 and #30. Gingival index score 0.8 (healthy).',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.successGreen,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Periodontal pocket depth < 3mm throughout',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

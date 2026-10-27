import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';

class LaboratoryResultsScreen extends StatelessWidget {
  const LaboratoryResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laboratory Results Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.uploadCenter),
            tooltip: 'Upload Lab Report',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AppCard(
                leftAccentColor: AppColors.criticalRed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comprehensive Metabolic Panel',
                          style: AppTypography.cardTitle.copyWith(fontSize: 16),
                        ),
                        const StatusBadge(
                          label: 'OUT OF RANGE',
                          severity: BadgeSeverity.critical,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Specimen collected: Oct 20, 2026 07:15 AM • Quest Diagnostics',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Analyte Breakdown', style: AppTypography.sectionTitle),
              const SizedBox(height: 12),
              _buildLabRow(
                'Potassium (K+)',
                '3.4',
                'mEq/L',
                '3.5 - 5.0',
                true,
                'Low (Hypokalemia)',
              ),
              const SizedBox(height: 10),
              _buildLabRow(
                'Sodium (Na+)',
                '138',
                'mEq/L',
                '135 - 145',
                false,
                'Normal',
              ),
              const SizedBox(height: 10),
              _buildLabRow(
                'Creatinine',
                '0.9',
                'mg/dL',
                '0.7 - 1.3',
                false,
                'Normal',
              ),
              const SizedBox(height: 10),
              _buildLabRow(
                'Blood Urea Nitrogen (BUN)',
                '18',
                'mg/dL',
                '7 - 20',
                false,
                'Normal',
              ),
              const SizedBox(height: 10),
              _buildLabRow(
                'Fasting Blood Glucose',
                '114',
                'mg/dL',
                '70 - 99',
                true,
                'Elevated',
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Prescribe Potassium Supplement',
                icon: const Icon(Icons.medication_rounded, color: Colors.white),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.prescriptionBuilder),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabRow(
    String name,
    String value,
    String unit,
    String refRange,
    bool isAbnormal,
    String status,
  ) {
    return AppCard(
      leftAccentColor: isAbnormal ? AppColors.criticalRed : null,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTypography.cardTitle.copyWith(fontSize: 14)),
              Text(
                'Ref: $refRange $unit',
                style: AppTypography.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$value $unit',
                style: AppTypography.cardTitle.copyWith(
                  fontSize: 15,
                  color: isAbnormal
                      ? AppColors.criticalRed
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              StatusBadge(
                label: status,
                severity: isAbnormal
                    ? BadgeSeverity.critical
                    : BadgeSeverity.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

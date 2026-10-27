import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';

class VisionRecordsScreen extends StatelessWidget {
  const VisionRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vision & Optical Records')),
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
                          'Retinal Photography & Refraction',
                          style: AppTypography.cardTitle,
                        ),
                        const StatusBadge(
                          label: 'STABLE',
                          severity: BadgeSeverity.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Optometrist: Dr. H. Thorne • VisionCare Specialists',
                      style: AppTypography.bodySmall,
                    ),
                    const Divider(height: 20),
                    Text(
                      'REFRACTION PRESCRIPTION',
                      style: AppTypography.labelUppercase.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildEyeParam('OD (Right)', '-1.75', '-0.50', '85°'),
                        _buildEyeParam('OS (Left)', '-2.00', '-0.25', '90°'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Fundus photography confirms clear optic nerve margins. Intraocular pressure (IOP): OD 14 mmHg, OS 15 mmHg (Normal).',
                      style: AppTypography.bodySmall,
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

  Widget _buildEyeParam(String eye, String sph, String cyl, String axis) {
    return Column(
      children: [
        Text(
          eye,
          style: AppTypography.cardTitle.copyWith(
            fontSize: 14,
            color: AppColors.primaryPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'SPH: $sph  CYL: $cyl  AXIS: $axis',
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }
}

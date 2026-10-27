import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';

class OcrReviewScreen extends StatefulWidget {
  const OcrReviewScreen({super.key});

  @override
  State<OcrReviewScreen> createState() => _OcrReviewScreenState();
}

class _OcrReviewScreenState extends State<OcrReviewScreen> {
  final TextEditingController _potassiumController = TextEditingController(
    text: '3.4',
  );
  final TextEditingController _sodiumController = TextEditingController(
    text: '138',
  );
  final TextEditingController _glucoseController = TextEditingController(
    text: '114',
  );

  @override
  void dispose() {
    _potassiumController.dispose();
    _sodiumController.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Extracted Data'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.purpleSurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.primaryPurple,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '3 lab analytes extracted with 99.4% confidence. Verify and adjust values before committing to vault.',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.deepPurpleText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Extracted Lab Values',
                      style: AppTypography.sectionTitle,
                    ),
                    const SizedBox(height: 12),
                    _buildEditableAnalyte(
                      'Potassium (K+)',
                      _potassiumController,
                      'mEq/L',
                      '3.5 - 5.0',
                      true,
                      'Low Flag Detected',
                    ),
                    const SizedBox(height: 12),
                    _buildEditableAnalyte(
                      'Sodium (Na+)',
                      _sodiumController,
                      'mEq/L',
                      '135 - 145',
                      false,
                      'Normal',
                    ),
                    const SizedBox(height: 12),
                    _buildEditableAnalyte(
                      'Fasting Blood Glucose',
                      _glucoseController,
                      'mg/dL',
                      '70 - 99',
                      true,
                      'Elevated Flag Detected',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppButton(
                  text: 'Commit Record to Patient Vault',
                  icon: const Icon(Icons.lock_rounded, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.uploadSuccess,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableAnalyte(
    String title,
    TextEditingController controller,
    String unit,
    String ref,
    bool isAbnormal,
    String flag,
  ) {
    return AppCard(
      leftAccentColor: isAbnormal ? AppColors.criticalRed : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.cardTitle.copyWith(fontSize: 15),
              ),
              StatusBadge(
                label: flag,
                severity: isAbnormal
                    ? BadgeSeverity.critical
                    : BadgeSeverity.success,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('Reference: $ref $unit', style: AppTypography.bodySmall),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Verified Value',
              suffixText: unit,
            ),
          ),
        ],
      ),
    );
  }
}

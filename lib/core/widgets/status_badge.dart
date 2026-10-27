import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum BadgeSeverity { critical, warning, success, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeSeverity severity;
  final bool isUppercase;

  const StatusBadge({
    super.key,
    required this.label,
    this.severity = BadgeSeverity.neutral,
    this.isUppercase = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (severity) {
      case BadgeSeverity.critical:
        bg = AppColors.criticalBg;
        text = AppColors.criticalRed;
        break;
      case BadgeSeverity.warning:
        bg = AppColors.warningBg;
        text = AppColors.warningOrange;
        break;
      case BadgeSeverity.success:
        bg = AppColors.successBg;
        text = AppColors.successGreen;
        break;
      case BadgeSeverity.info:
        bg = AppColors.purpleSurface;
        text = AppColors.primaryPurple;
        break;
      case BadgeSeverity.neutral:
        bg = AppColors.surfacePillGray;
        text = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isUppercase ? label.toUpperCase() : label,
        style: AppTypography.badgeSmall.copyWith(
          color: text,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

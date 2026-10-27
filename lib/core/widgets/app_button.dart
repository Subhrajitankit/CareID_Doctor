import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isSecondary;
  final bool isTeal;
  final bool isFullWidth;
  final double height;
  final String? subtitle;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isTeal = false,
    this.isFullWidth = true,
    this.height = 56,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = subtitle != null ? 64.0 : height;

    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[icon!, const SizedBox(width: 12)],
        subtitle == null
            ? Text(
                text,
                style: isSecondary
                    ? AppTypography.cardTitle.copyWith(
                        color: AppColors.primaryPurple,
                      )
                    : AppTypography.button,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: AppTypography.cardTitle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ],
              ),
      ],
    );

    if (isSecondary) {
      return SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: effectiveHeight,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
            backgroundColor: AppColors.surfaceWhite,
          ),
          child: buttonContent,
        ),
      );
    }

    final BoxDecoration decoration = BoxDecoration(
      gradient: isTeal ? null : AppColors.primaryGradient,
      color: isTeal ? AppColors.tealButton : null,
      borderRadius: BorderRadius.circular(9999),
      boxShadow: AppShadows.buttonShadow,
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: effectiveHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999),
          onTap: onPressed,
          child: Ink(
            decoration: decoration,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: buttonContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

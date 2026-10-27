import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class OcrProcessingScreen extends StatefulWidget {
  const OcrProcessingScreen({super.key});

  @override
  State<OcrProcessingScreen> createState() => _OcrProcessingScreenState();
}

class _OcrProcessingScreenState extends State<OcrProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.ocrReview);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.purpleSurface,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.document_scanner_rounded,
                    size: 36,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'AI OCR Extraction in Progress',
                style: AppTypography.sectionTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'CareID Clinical AI is parsing analytes, reference ranges, and critical flag markers from the uploaded document...',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const LinearProgressIndicator(
                backgroundColor: AppColors.surfacePillGray,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock_data.dart';

class QrProcessingScreen extends StatefulWidget {
  const QrProcessingScreen({super.key});

  @override
  State<QrProcessingScreen> createState() => _QrProcessingScreenState();
}

class _QrProcessingScreenState extends State<QrProcessingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate real-time cryptographic token verification
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.qrVerificationSuccess,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Decrypting Patient Token',
                style: AppTypography.sectionTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Verifying patient biometric consent with CareID decentralized trust ledger...',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'CID: ${MockData.patients[0].careId}',
                  style: AppTypography.labelUppercase.copyWith(
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

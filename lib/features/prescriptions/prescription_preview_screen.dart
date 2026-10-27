import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../data/mock_data.dart';

class PrescriptionPreviewScreen extends StatelessWidget {
  const PrescriptionPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = MockData.patients[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Prescription Pad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prescription shared via secure EHR link'),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Digital Rx Pad Paper Container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                MockData.doctorName,
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              Text(
                                MockData.doctorTitle,
                                style: AppTypography.bodySmall,
                              ),
                              Text(
                                MockData.doctorHospital,
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.purpleSurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '℞',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Patient: ${patient.name}',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Age/Sex: ${patient.age} / ${patient.gender[0]}',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        'CareID: ${patient.careId} • Date: Oct 26, 2026',
                        style: AppTypography.bodySmall,
                      ),
                      Text(
                        'Dx: Supraventricular Tachycardia',
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 13,
                          color: AppColors.tealButton,
                        ),
                      ),
                      const Divider(height: 24),
                      // Medication items
                      Text(
                        '1. Metoprolol Succinate 50 mg',
                        style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      ),
                      Text(
                        '   Sig: 1 tablet daily in the morning with food',
                        style: AppTypography.bodySmall,
                      ),
                      Text(
                        '   Dispense: 30 tablets • Refills: 2',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '2. Potassium Chloride ER 20 mEq',
                        style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      ),
                      Text(
                        '   Sig: 1 tablet daily with a large glass of water',
                        style: AppTypography.bodySmall,
                      ),
                      Text(
                        '   Dispense: 14 tablets • Refills: 0',
                        style: AppTypography.bodySmall,
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'License: ${MockData.doctorLicense}',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                'DEA: BV-9842104',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Dr. Vance, MD',
                                style: AppTypography.brandDoctorTitle.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Digital Signature Encrypted',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 10,
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Transmit to Pharmacy & CareID Vault',
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Prescription transmitted to Walgreens #4920 & patient app.',
                        ),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashboard,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'View Past Rx History',
                  isSecondary: true,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.prescriptionHistory);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

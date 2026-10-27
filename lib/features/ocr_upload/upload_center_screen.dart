import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';

class UploadCenterScreen extends StatefulWidget {
  const UploadCenterScreen({super.key});

  @override
  State<UploadCenterScreen> createState() => _UploadCenterScreenState();
}

class _UploadCenterScreenState extends State<UploadCenterScreen> {
  String _selectedPatient = MockData.patients[0].name;
  String _selectedCategory = 'Cardiology / ECG';
  bool _fileSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Medical Reports'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Upload & AI Extraction Center',
                  style: AppTypography.screenTitle.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  'Upload paper reports, external clinic PDFs, or lab photos. CareID AI OCR automatically converts text to structured EHR data.',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 20),

                // Upload Dropzone
                GestureDetector(
                  onTap: () {
                    setState(() => _fileSelected = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selected: external_lab_ecg_scan.pdf'),
                      ),
                    );
                  },
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _fileSelected
                            ? AppColors.primaryPurple
                            : AppColors.borderGray,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppColors.purpleSurface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cloud_upload_outlined,
                            color: AppColors.primaryPurple,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _fileSelected
                              ? 'external_lab_ecg_scan.pdf (1.4 MB)'
                              : 'Tap to Take Photo or Browse Documents',
                          style: AppTypography.cardTitle.copyWith(
                            color: _fileSelected
                                ? AppColors.primaryPurple
                                : AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Supports PDF, JPG, PNG, DICOM',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Metadata Form
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TARGET PATIENT',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedPatient,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: AppColors.primaryPurple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: MockData.patients
                            .map(
                              (p) => DropdownMenuItem(
                                value: p.name,
                                child: Text(p.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedPatient = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'REPORT TYPE / SPECIALTY',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.category_outlined,
                            color: AppColors.primaryPurple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items:
                            [
                                  'Cardiology / ECG',
                                  'Hematology & Lab Panel',
                                  'Radiology / MRI / CT',
                                  'Dental Panoramic',
                                  'Vision / Refraction',
                                ]
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Process with CareID AI OCR',
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.ocrProcessing);
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

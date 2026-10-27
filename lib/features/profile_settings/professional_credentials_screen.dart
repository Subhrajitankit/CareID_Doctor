import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class ProfessionalCredentialsScreen extends StatelessWidget {
  const ProfessionalCredentialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Credentials'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                          'Medical Practice License',
                          style: AppTypography.cardTitle,
                        ),
                        const StatusBadge(
                          label: 'ACTIVE',
                          severity: BadgeSeverity.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'New York State Department of Health',
                      style: AppTypography.bodySmall,
                    ),
                    const Divider(height: 20),
                    _buildCredRow('License Number', MockData.doctorLicense),
                    _buildCredRow('Issue Date', 'August 14, 2012'),
                    _buildCredRow('Expiration Date', 'August 31, 2028'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Board Certification',
                          style: AppTypography.cardTitle,
                        ),
                        const StatusBadge(
                          label: 'VERIFIED',
                          severity: BadgeSeverity.info,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'American Board of Internal Medicine',
                      style: AppTypography.bodySmall,
                    ),
                    const Divider(height: 20),
                    _buildCredRow(
                      'Subspecialty',
                      'Cardiovascular Disease (ABIM)',
                    ),
                    _buildCredRow(
                      'MOC Status',
                      'Meeting Maintenance of Certification',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hospital Staff Affiliation',
                          style: AppTypography.cardTitle,
                        ),
                        const StatusBadge(
                          label: 'CREDENTIALED',
                          severity: BadgeSeverity.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      MockData.doctorHospital,
                      style: AppTypography.bodySmall,
                    ),
                    const Divider(height: 20),
                    _buildCredRow('Staff ID', 'STJ-CARD-0012'),
                    _buildCredRow(
                      'Privileges',
                      'Inpatient Cardiology & Cath Lab Level 3',
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

  Widget _buildCredRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(value, style: AppTypography.cardTitle.copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}

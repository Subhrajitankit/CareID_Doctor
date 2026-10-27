import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';

class SupportAppInfoScreen extends StatelessWidget {
  const SupportAppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & App Info'),
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
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.purpleSurface,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.local_hospital_rounded,
                          size: 36,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'CAREiD Doctor Workstation',
                      style: AppTypography.screenTitle.copyWith(fontSize: 18),
                    ),
                    Text(
                      'Version 1.0.0+1 • Build 2026.10',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOSPITAL IT HELPDESK',
                      style: AppTypography.labelUppercase.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSupportRow(
                      Icons.phone_outlined,
                      'Clinical IT Hotline',
                      '+1 (800) 555-CARE (ext. 911)',
                    ),
                    _buildSupportRow(
                      Icons.email_outlined,
                      'Clinical Tech Support',
                      'support-md@stjude-health.org',
                    ),
                    _buildSupportRow(
                      Icons.location_on_outlined,
                      'Hospital Operations',
                      'Tower A, Floor 2, IT Command',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REGULATORY & SECURITY AUDIT',
                      style: AppTypography.labelUppercase.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.successGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'HIPAA Security Rule & HITECH Certified',
                          style: AppTypography.cardTitle.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'All clinical transmissions are encrypted using TLS 1.3 with AES-256-GCM hardware keys. Patient data is never stored unencrypted on mobile cache.',
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

  Widget _buildSupportRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryPurple, size: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.cardTitle.copyWith(fontSize: 13),
              ),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

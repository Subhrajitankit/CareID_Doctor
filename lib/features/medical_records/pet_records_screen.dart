import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';

class PetRecordsScreen extends StatelessWidget {
  const PetRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Companion Health (Pet CareID)')),
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
                          'Bella • Golden Retriever',
                          style: AppTypography.cardTitle,
                        ),
                        const StatusBadge(
                          label: 'VACCINATED',
                          severity: BadgeSeverity.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Veterinarian: Dr. P. Foster, DVM • City Paws Veterinary',
                      style: AppTypography.bodySmall,
                    ),
                    const Divider(height: 20),
                    Text(
                      'IMMUNIZATION & ZOONOTIC STATUS',
                      style: AppTypography.labelUppercase.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildVaccineRow(
                      'Rabies 3-Year',
                      'Administered Jun 2026',
                      'Expires Jun 2029',
                    ),
                    const SizedBox(height: 6),
                    _buildVaccineRow(
                      'DHPP + Bordetella',
                      'Administered Jun 2026',
                      'Expires Jun 2027',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Zoonotic assessment: No active dermatophyte or parasite concerns relevant to patient immuno-profile.',
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

  Widget _buildVaccineRow(String name, String date, String expiry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: AppTypography.cardTitle.copyWith(fontSize: 13)),
        Text(
          '$date ($expiry)',
          style: AppTypography.bodySmall.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

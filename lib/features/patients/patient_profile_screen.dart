import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class PatientProfileScreen extends StatelessWidget {
  final Patient? patientArg;

  const PatientProfileScreen({super.key, this.patientArg});

  @override
  Widget build(BuildContext context) {
    final patient =
        patientArg ??
        (ModalRoute.of(context)?.settings.arguments as Patient?) ??
        MockData.patients[0];

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.medicalRecords),
            tooltip: 'Share Record',
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.addAddendum),
            tooltip: 'Add Addendum',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Hero Card
                AppCard(
                  leftAccentColor: patient.isCritical
                      ? AppColors.criticalRed
                      : null,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: patient.isCritical
                                  ? AppColors.criticalBg
                                  : AppColors.purpleSurface,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                patient.name
                                    .split(' ')
                                    .map((e) => e[0])
                                    .take(2)
                                    .join(),
                                style: AppTypography.screenTitle.copyWith(
                                  color: patient.isCritical
                                      ? AppColors.criticalRed
                                      : AppColors.primaryPurple,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      patient.name,
                                      style: AppTypography.screenTitle.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (patient.isCritical)
                                      const StatusBadge(
                                        label: 'CRITICAL',
                                        severity: BadgeSeverity.critical,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${patient.age} yrs • ${patient.gender} • Blood ${patient.bloodGroup}',
                                  style: AppTypography.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  patient.careId,
                                  style: AppTypography.labelUppercase.copyWith(
                                    color: AppColors.primaryPurple,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMiniInfo(
                            'Status',
                            patient.queueStatus.toUpperCase(),
                          ),
                          _buildMiniInfo('Slot', patient.scheduledTime),
                          _buildMiniInfo('Consent', 'Active (4h)'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Clinical Quick Actions Grid
                Text('Clinical Actions', style: AppTypography.sectionTitle),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionTile(
                        icon: Icons.medication_liquid_rounded,
                        label: 'Prescribe',
                        color: AppColors.primaryPurple,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.prescriptionBuilder,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionTile(
                        icon: Icons.forward_to_inbox_rounded,
                        label: 'Refer',
                        color: AppColors.tealButton,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.createReferral,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionTile(
                        icon: Icons.upload_file_rounded,
                        label: 'Upload Lab',
                        color: AppColors.primaryPurpleLight,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.uploadCenter,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Vital Signs Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vitals (Latest Check)',
                      style: AppTypography.sectionTitle,
                    ),
                    Text(
                      'Recorded 08:45 AM',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildVitalCard(
                        title: 'BLOOD PRESSURE',
                        value: '142/88',
                        unit: 'mmHg',
                        isAbnormal: true,
                        flagText: 'Stage 1 HTN',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildVitalCard(
                        title: 'HEART RATE',
                        value: '118',
                        unit: 'bpm',
                        isAbnormal: true,
                        flagText: 'Tachycardia',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildVitalCard(
                        title: 'OXYGEN SAT (SpO2)',
                        value: '96%',
                        unit: 'Room Air',
                        isAbnormal: false,
                        flagText: 'Normal',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildVitalCard(
                        title: 'TEMPERATURE',
                        value: '98.4°F',
                        unit: 'Oral',
                        isAbnormal: false,
                        flagText: 'Afebrile',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Allergies & Chronic Conditions
                Text(
                  'Allergies & Contraindications',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: patient.allergies.isEmpty
                      ? [const Text('No known drug allergies (NKDA)')]
                      : patient.allergies.map((allergy) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.criticalBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.criticalRed.withAlpha(50),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 16,
                                  color: AppColors.criticalRed,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  allergy,
                                  style: AppTypography.cardTitle.copyWith(
                                    fontSize: 13,
                                    color: AppColors.criticalRed,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                ),
                const SizedBox(height: 24),

                // Medical Records Timeline Preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Medical Records Vault',
                      style: AppTypography.sectionTitle,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.medicalRecords,
                      ),
                      child: Text(
                        'View Vault',
                        style: AppTypography.cardTitle.copyWith(
                          fontSize: 14,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...MockData.records.take(2).map((record) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.medicalRecordDetails,
                          arguments: record,
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.purpleSurface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.description_outlined,
                              color: AppColors.primaryPurple,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.title,
                                  style: AppTypography.cardTitle.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${record.category} • ${record.date}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Patient Summary Quick Drawer Launcher
                AppButton(
                  text: 'View Quick Clinical Summary',
                  isSecondary: true,
                  icon: const Icon(
                    Icons.summarize_outlined,
                    color: AppColors.primaryPurple,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.patientSummary,
                      arguments: patient,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.cardTitle.copyWith(fontSize: 13)),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.cardTitle.copyWith(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildVitalCard({
    required String title,
    required String value,
    required String unit,
    required bool isAbnormal,
    required String flagText,
  }) {
    return AppCard(
      leftAccentColor: isAbnormal ? AppColors.criticalRed : null,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelUppercase.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppTypography.screenTitle.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isAbnormal
                      ? AppColors.criticalRed
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(unit, style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: 4),
          StatusBadge(
            label: flagText,
            severity: isAbnormal
                ? BadgeSeverity.critical
                : BadgeSeverity.success,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class PatientDirectoryScreen extends StatefulWidget {
  const PatientDirectoryScreen({super.key});

  @override
  State<PatientDirectoryScreen> createState() => _PatientDirectoryScreenState();
}

class _PatientDirectoryScreenState extends State<PatientDirectoryScreen> {
  int _selectedFilter = 0; // 0: All, 1: Critical, 2: Routine
  final String _query = '';

  List<Patient> get _filteredPatients {
    var list = MockData.patients;
    if (_selectedFilter == 1) {
      list = list.where((p) => p.isCritical).toList();
    } else if (_selectedFilter == 2) {
      list = list.where((p) => !p.isCritical).toList();
    }
    if (_query.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(_query.toLowerCase()) ||
                p.careId.toLowerCase().contains(_query.toLowerCase()),
          )
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Patient Directory'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Search & Filter Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Column(
                  children: [
                    // Search bar tap opens full search
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.patientSearch),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderGray),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Search by patient name, CareID, or phone...',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filter Chips
                    Row(
                      children: [
                        _buildFilterChip(
                          'All Patients (${MockData.patients.length})',
                          0,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip('Critical (1)', 1),
                        const SizedBox(width: 8),
                        _buildFilterChip('Routine (3)', 2),
                      ],
                    ),
                  ],
                ),
              ),

              // Patient List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
                  itemCount: _filteredPatients.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final patient = _filteredPatients[index];
                    return AppCard(
                      leftAccentColor: patient.isCritical
                          ? AppColors.criticalRed
                          : null,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.patientProfile,
                          arguments: patient,
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
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
                                style: AppTypography.cardTitle.copyWith(
                                  color: patient.isCritical
                                      ? AppColors.criticalRed
                                      : AppColors.primaryPurple,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      patient.name,
                                      style: AppTypography.cardTitle.copyWith(
                                        fontSize: 16,
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
                                  'CareID: ${patient.careId}',
                                  style: AppTypography.labelUppercase.copyWith(
                                    color: AppColors.primaryPurple,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.appointmentsOverview);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.doctorProfile);
              break;
          }
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final bool isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.borderGray,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.badgeSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

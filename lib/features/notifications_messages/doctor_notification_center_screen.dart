import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class DoctorNotificationCenterScreen extends StatefulWidget {
  const DoctorNotificationCenterScreen({super.key});

  @override
  State<DoctorNotificationCenterScreen> createState() =>
      _DoctorNotificationCenterScreenState();
}

class _DoctorNotificationCenterScreenState
    extends State<DoctorNotificationCenterScreen> {
  int _selectedFilter = 0; // 0: All, 1: Critical, 2: Updates

  List<ClinicalAlert> get _filteredAlerts {
    if (_selectedFilter == 1) {
      return MockData.alerts.where((a) => a.severity == 'critical').toList();
    } else if (_selectedFilter == 2) {
      return MockData.alerts.where((a) => a.severity != 'critical').toList();
    }
    return MockData.alerts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.patientMessages),
            tooltip: 'Patient Messages',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Filter Chips
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _buildFilterChip(
                      'All Alerts (${MockData.alerts.length})',
                      0,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip('Critical (1)', 1),
                    const SizedBox(width: 8),
                    _buildFilterChip('Updates (2)', 2),
                  ],
                ),
              ),

              // Alerts List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: _filteredAlerts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final alert = _filteredAlerts[index];
                    final isCritical = alert.severity == 'critical';

                    return AppCard(
                      leftAccentColor: isCritical
                          ? AppColors.criticalRed
                          : null,
                      onTap: () {
                        if (isCritical) {
                          Navigator.pushNamed(context, AppRoutes.labSummary);
                        } else {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.patientMessages,
                          );
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isCritical
                                  ? AppColors.criticalBg
                                  : AppColors.purpleSurface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCritical
                                  ? Icons.warning_amber_rounded
                                  : Icons.notifications_active_outlined,
                              color: isCritical
                                  ? AppColors.criticalRed
                                  : AppColors.primaryPurple,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        alert.title,
                                        style: AppTypography.cardTitle.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      alert.time,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  alert.message,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                StatusBadge(
                                  label: alert.severity.toUpperCase(),
                                  severity: isCritical
                                      ? BadgeSeverity.critical
                                      : BadgeSeverity.info,
                                ),
                              ],
                            ),
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

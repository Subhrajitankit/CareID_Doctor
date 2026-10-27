import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class AppointmentsOverviewScreen extends StatefulWidget {
  const AppointmentsOverviewScreen({super.key});

  @override
  State<AppointmentsOverviewScreen> createState() =>
      _AppointmentsOverviewScreenState();
}

class _AppointmentsOverviewScreenState
    extends State<AppointmentsOverviewScreen> {
  int _selectedDayIndex = 0;
  final List<String> _days = [
    'Today, Oct 26',
    'Tomorrow, Oct 27',
    'Wed, Oct 28',
    'Thu, Oct 29',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Appointments Schedule'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Date Horizontal Selector
              Container(
                height: 52,
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSel = _selectedDayIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDayIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.primaryPurple
                              : AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: isSel
                                ? AppColors.primaryPurple
                                : AppColors.borderGray,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _days[index],
                            style: AppTypography.badgeSmall.copyWith(
                              color: isSel
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: isSel
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Appointments List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                  itemCount: MockData.appointments.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final apt = MockData.appointments[index];
                    final bool isUrgent =
                        apt.type.contains('Urgent') || apt.patient.isCritical;

                    return AppCard(
                      leftAccentColor: isUrgent ? AppColors.criticalRed : null,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.appointmentDetails,
                          arguments: apt,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_filled_rounded,
                                    size: 16,
                                    color: AppColors.primaryPurple,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    apt.time,
                                    style: AppTypography.cardTitle.copyWith(
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              StatusBadge(
                                label: apt.type.toUpperCase(),
                                severity: isUrgent
                                    ? BadgeSeverity.critical
                                    : BadgeSeverity.info,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: AppColors.purpleSurface,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    apt.patient.name
                                        .split(' ')
                                        .map((e) => e[0])
                                        .take(2)
                                        .join(),
                                    style: AppTypography.cardTitle.copyWith(
                                      color: AppColors.primaryPurple,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      apt.patient.name,
                                      style: AppTypography.cardTitle.copyWith(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${apt.patient.careId} • ${apt.notes}',
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
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.patientDirectory);
              break;
            case 2:
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.doctorProfile);
              break;
          }
        },
      ),
    );
  }
}

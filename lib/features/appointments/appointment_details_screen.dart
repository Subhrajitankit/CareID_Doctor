import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment? appointmentArg;

  const AppointmentDetailsScreen({super.key, this.appointmentArg});

  @override
  Widget build(BuildContext context) {
    final apt =
        appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
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
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(
                            label: apt.type,
                            severity: apt.patient.isCritical
                                ? BadgeSeverity.critical
                                : BadgeSeverity.info,
                          ),
                          Text(apt.date, style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            color: AppColors.primaryPurple,
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            apt.time,
                            style: AppTypography.heroHeading.copyWith(
                              fontSize: 26,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        'PATIENT INFORMATION',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        apt.patient.name,
                        style: AppTypography.cardTitle.copyWith(fontSize: 17),
                      ),
                      Text(
                        '${apt.patient.age} yrs • ${apt.patient.gender} • CareID: ${apt.patient.careId}',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'CLINICAL VISIT REASON',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(apt.notes, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Clinical Actions', style: AppTypography.sectionTitle),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Start Clinical Consultation',
                  icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.patientProfile,
                      arguments: apt.patient,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Reschedule Appointment Slot',
                  isSecondary: true,
                  icon: const Icon(
                    Icons.edit_calendar_rounded,
                    color: AppColors.primaryPurple,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.rescheduleAppointment,
                      arguments: apt,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Cancel Appointment',
                  isSecondary: true,
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: AppColors.criticalRed,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.cancelAppointment,
                      arguments: apt,
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
}

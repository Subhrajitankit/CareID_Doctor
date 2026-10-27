import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class RescheduleSuccessScreen extends StatelessWidget {
  final Appointment? appointmentArg;

  const RescheduleSuccessScreen({super.key, this.appointmentArg});

  @override
  Widget build(BuildContext context) {
    final apt =
        appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.successGreen,
                      width: 2.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.event_available_rounded,
                      size: 54,
                      color: AppColors.successGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Appointment Rescheduled',
                  style: AppTypography.screenTitle.copyWith(
                    color: AppColors.successGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Patient ${apt.patient.name} has been moved to ${apt.date} at ${apt.time}. Calendar sync complete.',
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Updated Slot', style: AppTypography.bodySmall),
                          Text(
                            '${apt.date} • ${apt.time}',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Clinic Room', style: AppTypography.bodySmall),
                          Text(
                            'Cardiology Suite 402',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 13,
                              color: AppColors.tealButton,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'View Updated Schedule',
                  icon: const Icon(Icons.calendar_month, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.appointmentsOverview,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Back to Dashboard',
                  isSecondary: true,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.dashboard,
                      (r) => false,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

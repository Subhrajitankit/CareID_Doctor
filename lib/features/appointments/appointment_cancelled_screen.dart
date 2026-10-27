import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class AppointmentCancelledScreen extends StatelessWidget {
  final Appointment? appointmentArg;

  const AppointmentCancelledScreen({super.key, this.appointmentArg});

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
                    color: AppColors.criticalBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.criticalRed,
                      width: 2.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.cancel_rounded,
                      size: 54,
                      color: AppColors.criticalRed,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Appointment Cancelled',
                  style: AppTypography.screenTitle.copyWith(
                    color: AppColors.criticalRed,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'The appointment for ${apt.patient.name} on ${apt.date} at ${apt.time} has been officially cancelled.',
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
                          Text(
                            'Cancellation Audit ID',
                            style: AppTypography.bodySmall,
                          ),
                          Text(
                            'CAN-2026-8812',
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
                          Text(
                            'Patient Status',
                            style: AppTypography.bodySmall,
                          ),
                          Text(
                            'Notified via CareID Push',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppColors.tealButton,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Return to Appointments',
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

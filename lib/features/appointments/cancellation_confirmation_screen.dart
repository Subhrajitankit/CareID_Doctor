import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class CancellationConfirmationScreen extends StatelessWidget {
  final Appointment? appointmentArg;

  const CancellationConfirmationScreen({super.key, this.appointmentArg});

  @override
  Widget build(BuildContext context) {
    final apt =
        appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Cancellation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.criticalBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 44,
                      color: AppColors.criticalRed,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Are you sure you want to cancel this visit?',
                  style: AppTypography.screenTitle.copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cancelling a scheduled clinic visit will immediately notify the patient and release their slot to the department waitlist.',
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Patient', style: AppTypography.bodySmall),
                          Text(
                            apt.patient.name,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Slot to Release',
                            style: AppTypography.bodySmall,
                          ),
                          Text(
                            '${apt.date} • ${apt.time}',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                              color: AppColors.criticalRed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Confirm & Cancel Visit',
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.appointmentCancelled,
                      arguments: apt,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Keep Appointment',
                  isSecondary: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

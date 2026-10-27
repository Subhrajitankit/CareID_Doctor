import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class ReviewRescheduleScreen extends StatelessWidget {
  final Appointment? appointmentArg;

  const ReviewRescheduleScreen({super.key, this.appointmentArg});

  @override
  Widget build(BuildContext context) {
    final apt =
        appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Reschedule'),
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
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PROPOSED NEW SCHEDULE',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        apt.patient.name,
                        style: AppTypography.screenTitle.copyWith(fontSize: 20),
                      ),
                      Text(
                        '${apt.patient.careId} • ${apt.type}',
                        style: AppTypography.bodySmall,
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('New Date', style: AppTypography.bodySmall),
                          Text(
                            apt.date,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('New Slot Time', style: AppTypography.bodySmall),
                          Text(
                            apt.time,
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Location', style: AppTypography.bodySmall),
                          Text(
                            'St. Jude Cardiology Suite 402',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderGray),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sms_outlined,
                        color: AppColors.tealButton,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'An automated SMS notification and revised calendar invite will be pushed to the patient\'s CareID mobile app.',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Confirm & Notify Patient',
                  icon: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.rescheduleSuccess,
                      arguments: apt,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Back to Slot Selection',
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

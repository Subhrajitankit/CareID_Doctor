import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class CancelAppointmentScreen extends StatefulWidget {
  final Appointment? appointmentArg;

  const CancelAppointmentScreen({super.key, this.appointmentArg});

  @override
  State<CancelAppointmentScreen> createState() =>
      _CancelAppointmentScreenState();
}

class _CancelAppointmentScreenState extends State<CancelAppointmentScreen> {
  String _cancelReason = 'Doctor Emergency / Surgery';
  final TextEditingController _explanationController = TextEditingController(
    text: 'Unscheduled emergency cardiac intervention required in OR.',
  );

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apt =
        widget.appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Appointment'),
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
                  leftAccentColor: AppColors.criticalRed,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CANCEL VISIT FOR',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                          color: AppColors.criticalRed,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        apt.patient.name,
                        style: AppTypography.screenTitle.copyWith(fontSize: 18),
                      ),
                      Text(
                        '${apt.date} • ${apt.time} • ${apt.type}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Cancellation Reason Code',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _cancelReason,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.cancel_outlined,
                      color: AppColors.criticalRed,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items:
                      [
                            'Doctor Emergency / Surgery',
                            'Clinical Hospital Evacuation',
                            'Patient No-Show Notice',
                            'Administrative Triage Shift',
                          ]
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _cancelReason = val);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Clinical Explanation Note',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _explanationController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Proceed to Confirmation',
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.cancellationConfirmation,
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

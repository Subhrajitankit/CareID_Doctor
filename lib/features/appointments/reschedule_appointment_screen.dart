import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class RescheduleAppointmentScreen extends StatefulWidget {
  final Appointment? appointmentArg;

  const RescheduleAppointmentScreen({super.key, this.appointmentArg});

  @override
  State<RescheduleAppointmentScreen> createState() =>
      _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState
    extends State<RescheduleAppointmentScreen> {
  String _selectedReason = 'Clinical Schedule Conflict';
  final TextEditingController _notesController = TextEditingController(
    text: 'Attending emergency surgical consult in Cath Lab.',
  );

  @override
  void dispose() {
    _notesController.dispose();
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
        title: const Text('Reschedule Appointment'),
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
                        'CURRENT APPOINTMENT',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        apt.patient.name,
                        style: AppTypography.cardTitle.copyWith(fontSize: 16),
                      ),
                      Text(
                        '${apt.date} at ${apt.time} • ${apt.type}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Reason for Rescheduling',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _selectedReason,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.info_outline,
                      color: AppColors.primaryPurple,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items:
                      [
                            'Clinical Schedule Conflict',
                            'Emergency Surgery / Cath Lab',
                            'Patient Direct Request',
                            'Laboratory Results Delayed',
                          ]
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedReason = val);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Doctor Notes to Patient',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const Spacer(),
                AppButton(
                  text: 'Select New Date & Slot',
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.selectNewSlot,
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

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class SelectNewSlotScreen extends StatefulWidget {
  final Appointment? appointmentArg;

  const SelectNewSlotScreen({super.key, this.appointmentArg});

  @override
  State<SelectNewSlotScreen> createState() => _SelectNewSlotScreenState();
}

class _SelectNewSlotScreenState extends State<SelectNewSlotScreen> {
  String _selectedDate = 'Tomorrow, Oct 27';
  String _selectedSlot = '11:30 AM';

  final List<String> _slots = [
    '09:00 AM',
    '10:15 AM',
    '11:30 AM',
    '02:00 PM',
    '03:45 PM',
    '04:30 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final apt =
        widget.appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select New Slot'),
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
                Text(
                  'CHOOSE REVISED DATE',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Tomorrow, Oct 27', 'Wed, Oct 28', 'Thu, Oct 29']
                      .map((date) {
                        final isSel = _selectedDate == date;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Center(
                                child: Text(
                                  date,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              selected: isSel,
                              onSelected: (_) =>
                                  setState(() => _selectedDate = date),
                              selectedColor: AppColors.purpleSurface,
                              labelStyle: TextStyle(
                                color: isSel
                                    ? AppColors.primaryPurple
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
                const SizedBox(height: 24),
                Text(
                  'AVAILABLE CLINICAL SLOTS',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: _slots.length,
                    itemBuilder: (context, index) {
                      final slot = _slots[index];
                      final isSel = _selectedSlot == slot;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSlot = slot),
                        child: AppCard(
                          backgroundColor: isSel
                              ? AppColors.purpleSurface
                              : AppColors.surfaceWhite,
                          borderColor: isSel
                              ? AppColors.primaryPurple
                              : AppColors.borderGray,
                          padding: const EdgeInsets.all(12),
                          child: Center(
                            child: Text(
                              slot,
                              style: AppTypography.cardTitle.copyWith(
                                color: isSel
                                    ? AppColors.primaryPurple
                                    : AppColors.textPrimary,
                                fontWeight: isSel
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AppButton(
                  text: 'Review Reschedule Details',
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final updatedApt = apt.copyWith(
                      date: _selectedDate,
                      time: _selectedSlot,
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.reviewReschedule,
                      arguments: updatedApt,
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

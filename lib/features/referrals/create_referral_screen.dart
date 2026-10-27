import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';

class CreateReferralScreen extends StatefulWidget {
  const CreateReferralScreen({super.key});

  @override
  State<CreateReferralScreen> createState() => _CreateReferralScreenState();
}

class _CreateReferralScreenState extends State<CreateReferralScreen> {
  String _selectedPatient = MockData.patients[0].name;
  String _selectedSpecialty = 'Electrophysiology';
  String _selectedUrgency = 'Critical';
  final TextEditingController _reasonController = TextEditingController(
    text:
        'Recurrent supraventricular tachycardia refractory to medical management. Evaluation for catheter ablation.',
  );
  final TextEditingController _notesController = TextEditingController(
    text: 'Resting ECG attached. Potassium 3.4 mEq/L currently being repleted.',
  );

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Clinical Referral'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
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
                // Patient Selector
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELECT PATIENT',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedPatient,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: AppColors.primaryPurple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: MockData.patients
                            .map(
                              (p) => DropdownMenuItem(
                                value: p.name,
                                child: Text(p.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedPatient = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Specialty Chips
                Text(
                  'TARGET SPECIALTY',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        'Electrophysiology',
                        'Endocrinology',
                        'Cardiothoracic Surgery',
                        'Pulmonology',
                        'Neurology',
                      ].map((spec) {
                        final isSel = _selectedSpecialty == spec;
                        return ChoiceChip(
                          label: Text(spec),
                          selected: isSel,
                          onSelected: (_) =>
                              setState(() => _selectedSpecialty = spec),
                          selectedColor: AppColors.purpleSurface,
                          labelStyle: TextStyle(
                            color: isSel
                                ? AppColors.primaryPurple
                                : AppColors.textSecondary,
                            fontWeight: isSel
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),

                // Urgency Selector
                Text(
                  'CLINICAL URGENCY',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Routine', 'Urgent', 'Critical'].map((urg) {
                    final isSel = _selectedUrgency == urg;
                    final isCrit = urg == 'Critical';
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Center(child: Text(urg)),
                          selected: isSel,
                          onSelected: (_) =>
                              setState(() => _selectedUrgency = urg),
                          selectedColor: isCrit
                              ? AppColors.criticalBg
                              : AppColors.purpleSurface,
                          labelStyle: TextStyle(
                            color: isSel
                                ? (isCrit
                                      ? AppColors.criticalRed
                                      : AppColors.primaryPurple)
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Reason for Referral
                Text(
                  'REASON FOR REFERRAL',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _reasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Clinical Notes
                Text(
                  'ADDITIONAL CLINICAL CONTEXT',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Submit Clinical Referral',
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.referralSuccess,
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

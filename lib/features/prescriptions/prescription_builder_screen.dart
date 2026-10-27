import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';

class PrescriptionBuilderScreen extends StatefulWidget {
  const PrescriptionBuilderScreen({super.key});

  @override
  State<PrescriptionBuilderScreen> createState() =>
      _PrescriptionBuilderScreenState();
}

class _PrescriptionBuilderScreenState extends State<PrescriptionBuilderScreen> {
  final TextEditingController _diagnosisController = TextEditingController(
    text: 'Supraventricular Tachycardia',
  );
  final TextEditingController _drug1Name = TextEditingController(
    text: 'Metoprolol Succinate',
  );
  final TextEditingController _drug1Dose = TextEditingController(text: '50 mg');
  final TextEditingController _drug1Freq = TextEditingController(
    text: 'Once Daily (Morning)',
  );
  final TextEditingController _drug1Dur = TextEditingController(
    text: '30 Days',
  );
  final TextEditingController _drug1Inst = TextEditingController(
    text: 'Take with food. Monitor heart rate daily.',
  );

  final TextEditingController _drug2Name = TextEditingController(
    text: 'Potassium Chloride ER',
  );
  final TextEditingController _drug2Dose = TextEditingController(
    text: '20 mEq',
  );
  final TextEditingController _drug2Freq = TextEditingController(
    text: 'Once Daily',
  );
  final TextEditingController _drug2Dur = TextEditingController(
    text: '14 Days',
  );
  final TextEditingController _drug2Inst = TextEditingController(
    text: 'Take with a full glass of water.',
  );

  @override
  void dispose() {
    _diagnosisController.dispose();
    _drug1Name.dispose();
    _drug1Dose.dispose();
    _drug1Freq.dispose();
    _drug1Dur.dispose();
    _drug1Inst.dispose();
    _drug2Name.dispose();
    _drug2Dose.dispose();
    _drug2Freq.dispose();
    _drug2Dur.dispose();
    _drug2Inst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patient = MockData.patients[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('e-Prescription Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.prescriptionHistory),
            tooltip: 'Rx History',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Patient Summary Ribbon
                AppCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.purpleSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.name,
                              style: AppTypography.cardTitle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${patient.careId} • Allergies: ${patient.allergies.join(", ")}',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Diagnosis Input
                Text(
                  'CLINICAL DIAGNOSIS',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _diagnosisController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.medical_information_outlined,
                      color: AppColors.primaryPurple,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Medication #1 Card
                Text(
                  'MEDICATION ITEM #1',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 8),
                _buildMedicationCard(
                  _drug1Name,
                  _drug1Dose,
                  _drug1Freq,
                  _drug1Dur,
                  _drug1Inst,
                ),

                const SizedBox(height: 16),
                // Medication #2 Card
                Text(
                  'MEDICATION ITEM #2',
                  style: AppTypography.labelUppercase.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 8),
                _buildMedicationCard(
                  _drug2Name,
                  _drug2Dose,
                  _drug2Freq,
                  _drug2Dur,
                  _drug2Inst,
                ),

                const SizedBox(height: 28),
                AppButton(
                  text: 'Review Drug Interactions',
                  icon: const Icon(Icons.shield_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.drugInteractionReview,
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Direct Preview & Digital Sign',
                  isSecondary: true,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.prescriptionPreview);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationCard(
    TextEditingController name,
    TextEditingController dose,
    TextEditingController freq,
    TextEditingController dur,
    TextEditingController inst,
  ) {
    return AppCard(
      child: Column(
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(
              labelText: 'Drug Generic Name',
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: dose,
                  decoration: const InputDecoration(
                    labelText: 'Dosage',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: dur,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: freq,
            decoration: const InputDecoration(
              labelText: 'Frequency',
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: inst,
            decoration: const InputDecoration(
              labelText: 'Patient Instructions',
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class AddAddendumScreen extends StatefulWidget {
  final MedicalRecordItem? recordArg;

  const AddAddendumScreen({super.key, this.recordArg});

  @override
  State<AddAddendumScreen> createState() => _AddAddendumScreenState();
}

class _AddAddendumScreenState extends State<AddAddendumScreen> {
  final TextEditingController _notesController = TextEditingController();
  bool _signWithBiometrics = true;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submitAddendum() {
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter clinical addendum notes')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Addendum digitally signed by ${MockData.doctorName} and recorded to vault.',
        ),
        backgroundColor: AppColors.successGreen,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final record =
        widget.recordArg ??
        (ModalRoute.of(context)?.settings.arguments as MedicalRecordItem?) ??
        MockData.records[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clinical Addendum'),
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
                        'TARGET RECORD',
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        record.title,
                        style: AppTypography.cardTitle.copyWith(fontSize: 15),
                      ),
                      Text(
                        '${record.date} • ${record.doctor}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Addendum Clinical Notes',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: _notesController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText:
                          'Enter supplemental diagnosis, corrected readings, or subsequent telephone consultations with patient...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: _signWithBiometrics,
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: AppColors.primaryPurple,
                  title: Text(
                    'Cryptographically Sign with Provider Key',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'License: ${MockData.doctorLicense}',
                    style: AppTypography.bodySmall,
                  ),
                  onChanged: (val) => setState(() => _signWithBiometrics = val),
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Append & Sign Addendum',
                  icon: const Icon(Icons.draw_rounded, color: Colors.white),
                  onPressed: _submitAddendum,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../data/models/clinical_models.dart';

class ShareRecordModal extends StatefulWidget {
  final MedicalRecordItem record;

  const ShareRecordModal({super.key, required this.record});

  @override
  State<ShareRecordModal> createState() => _ShareRecordModalState();
}

class _ShareRecordModalState extends State<ShareRecordModal> {
  String _shareTarget = 'Dr. Stephanie Ross (Electrophysiology)';
  bool _anonymizePii = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      decoration: const BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Encrypted Clinical Sharing', style: AppTypography.sectionTitle),
          const SizedBox(height: 6),
          Text(
            'Secure peer-to-peer transmission of "${widget.record.title}" with audit logging.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 20),
          Text(
            'SELECT RECIPIENT DOCTOR / CLINIC',
            style: AppTypography.labelUppercase.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _shareTarget,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.person_pin_rounded,
                color: AppColors.primaryPurple,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            items:
                [
                      'Dr. Stephanie Ross (Electrophysiology)',
                      'Dr. Nathan Patel (Endocrinology)',
                      'Dr. Clara Wei (Apex Dental Clinic)',
                      'Hospital Emergency Command Center',
                    ]
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: AppTypography.bodyMedium),
                      ),
                    )
                    .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _shareTarget = val);
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _anonymizePii,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Anonymize Non-Clinical Identifiers (HIPAA Safe-Harbor)',
              style: AppTypography.bodySmall,
            ),
            onChanged: (val) => setState(() => _anonymizePii = val ?? false),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Send Encrypted Vault Link',
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Encrypted report shared with $_shareTarget'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

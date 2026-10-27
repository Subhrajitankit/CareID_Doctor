import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class MedicalRecordDetailsScreen extends StatelessWidget {
  final MedicalRecordItem? recordArg;

  const MedicalRecordDetailsScreen({super.key, this.recordArg});

  @override
  Widget build(BuildContext context) {
    final record =
        recordArg ??
        (ModalRoute.of(context)?.settings.arguments as MedicalRecordItem?) ??
        MockData.records[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.documentViewer,
                arguments: record,
              );
            },
            tooltip: 'View Original PDF',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(
                            label: record.category,
                            severity: BadgeSeverity.info,
                          ),
                          Text(record.date, style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        record.title,
                        style: AppTypography.screenTitle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Attending: ${record.doctor} • ${record.facility}',
                        style: AppTypography.bodySmall,
                      ),
                      if (record.flags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: record.flags.map((flag) {
                            return StatusBadge(
                              label: flag,
                              severity: BadgeSeverity.critical,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Clinical Interpretation & Findings',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 10),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.summary,
                        style: AppTypography.bodyLarge.copyWith(height: 1.6),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              color: AppColors.tealButton,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Digital cryptographic hash verified on CareID Ledger',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Addendums Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Clinical Addendums',
                      style: AppTypography.sectionTitle,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Addendum'),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.addAddendum,
                          arguments: record,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (record.addendums.isEmpty)
                  Text(
                    'No addendums appended to this record.',
                    style: AppTypography.bodySmall,
                  )
                else
                  ...record.addendums.map((addendum) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppCard(
                        backgroundColor: AppColors.surfaceMuted,
                        child: Text(
                          addendum,
                          style: AppTypography.bodyMedium.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Open Original Document Viewer',
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.documentViewer,
                      arguments: record,
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

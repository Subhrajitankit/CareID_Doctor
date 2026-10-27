import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';
import 'filter_records_bottom_sheet.dart';
import 'share_record_modal.dart';

class MedicalRecordsTimelineScreen extends StatefulWidget {
  const MedicalRecordsTimelineScreen({super.key});

  @override
  State<MedicalRecordsTimelineScreen> createState() =>
      _MedicalRecordsTimelineScreenState();
}

class _MedicalRecordsTimelineScreenState
    extends State<MedicalRecordsTimelineScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'All Records',
    'Cardiology',
    'Lab Reports',
    'Dental',
    'Vision',
    'Pet',
  ];

  List<MedicalRecordItem> get _filteredRecords {
    if (_selectedCategoryIndex == 0) {
      return MockData.records;
    }
    final cat = _categories[_selectedCategoryIndex];
    if (cat == 'Lab Reports') {
      return MockData.records.where((r) => r.category == 'Lab').toList();
    }
    return MockData.records
        .where((r) => r.category.toLowerCase().contains(cat.toLowerCase()))
        .toList();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterRecordsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _openFilterSheet,
            tooltip: 'Filter Records',
          ),
          IconButton(
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.uploadCenter),
            tooltip: 'Upload Report',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Category Tab Selector
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategoryIndex = index);
                          if (index == 2) {
                            Navigator.pushNamed(context, AppRoutes.labSummary);
                          }
                          if (index == 3) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.dentalRecords,
                            );
                          }
                          if (index == 4) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.visionRecords,
                            );
                          }
                          if (index == 5) {
                            Navigator.pushNamed(context, AppRoutes.petRecords);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryPurple
                                : AppColors.surfaceWhite,
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryPurple
                                  : AppColors.borderGray,
                            ),
                          ),
                          child: Text(
                            _categories[index],
                            style: AppTypography.badgeSmall.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Records Timeline List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  itemCount: _filteredRecords.length,
                  itemBuilder: (context, index) {
                    final record = _filteredRecords[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline Tree Line & Node
                        Column(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryPurple,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                            if (index < _filteredRecords.length - 1)
                              Container(
                                width: 2,
                                height: 130,
                                color: AppColors.borderGray,
                              ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        // Record Card
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: AppCard(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.medicalRecordDetails,
                                  arguments: record,
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          record.title,
                                          style: AppTypography.cardTitle
                                              .copyWith(fontSize: 15),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.share_outlined,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (_) => ShareRecordModal(
                                              record: record,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${record.date} • ${record.doctor} • ${record.facility}',
                                    style: AppTypography.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    record.summary,
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (record.flags.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 6,
                                      children: record.flags.map((flag) {
                                        return StatusBadge(
                                          label: flag,
                                          severity: BadgeSeverity.critical,
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.documentViewer,
                                            arguments: record,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.picture_as_pdf_rounded,
                                              size: 16,
                                              color: AppColors.primaryPurple,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'View PDF Document',
                                              style: AppTypography.bodySmall
                                                  .copyWith(
                                                    color:
                                                        AppColors.primaryPurple,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';

class FilterRecordsBottomSheet extends StatefulWidget {
  const FilterRecordsBottomSheet({super.key});

  @override
  State<FilterRecordsBottomSheet> createState() =>
      _FilterRecordsBottomSheetState();
}

class _FilterRecordsBottomSheetState extends State<FilterRecordsBottomSheet> {
  String _selectedRange = 'All Time';
  final Set<String> _selectedTypes = {'Cardiology', 'Lab Reports'};

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Clinical Records',
                style: AppTypography.sectionTitle,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedRange = 'All Time';
                    _selectedTypes.clear();
                  });
                },
                child: Text(
                  'Reset',
                  style: AppTypography.cardTitle.copyWith(
                    color: AppColors.primaryPurple,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'DATE RANGE',
            style: AppTypography.labelUppercase.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: ['Past 30 Days', 'Past 6 Months', 'Past Year', 'All Time']
                .map((range) {
                  final isSel = _selectedRange == range;
                  return ChoiceChip(
                    label: Text(range),
                    selected: isSel,
                    onSelected: (_) => setState(() => _selectedRange = range),
                    selectedColor: AppColors.purpleSurface,
                    labelStyle: TextStyle(
                      color: isSel
                          ? AppColors.primaryPurple
                          : AppColors.textSecondary,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                })
                .toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'CLINICAL SPECIALTY',
            style: AppTypography.labelUppercase.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children:
                [
                  'Cardiology',
                  'Lab Reports',
                  'Dental',
                  'Vision',
                  'Pet Records',
                  'Radiology',
                ].map((type) {
                  final isSel = _selectedTypes.contains(type);
                  return FilterChip(
                    label: Text(type),
                    selected: isSel,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedTypes.add(type);
                        } else {
                          _selectedTypes.remove(type);
                        }
                      });
                    },
                    selectedColor: AppColors.purpleSurface,
                    labelStyle: TextStyle(
                      color: isSel
                          ? AppColors.primaryPurple
                          : AppColors.textSecondary,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'Apply Record Filters',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

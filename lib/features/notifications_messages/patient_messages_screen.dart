import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../data/mock_data.dart';

class PatientMessagesScreen extends StatelessWidget {
  const PatientMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Messages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: MockData.patients.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final patient = MockData.patients[index];
              return AppCard(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening secure clinical thread with ${patient.name}',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppColors.purpleSurface,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              patient.name
                                  .split(' ')
                                  .map((e) => e[0])
                                  .take(2)
                                  .join(),
                              style: AppTypography.cardTitle.copyWith(
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                        ),
                        if (index == 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.tealButton,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                patient.name,
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '10:14 AM',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            index == 0
                                ? 'Dr. Vance, the heart palpitations subsided after morning dose.'
                                : 'Thank you for updating the prescription refill.',
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

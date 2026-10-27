import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class ReferralDashboardScreen extends StatefulWidget {
  const ReferralDashboardScreen({super.key});

  @override
  State<ReferralDashboardScreen> createState() =>
      _ReferralDashboardScreenState();
}

class _ReferralDashboardScreenState extends State<ReferralDashboardScreen> {
  int _selectedTab = 0; // 0: Outgoing, 1: Incoming

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Referrals Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.createReferral),
            tooltip: 'Create Referral',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Summary Cards
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'OUTGOING',
                        '4 Sent',
                        AppColors.primaryPurple,
                        AppColors.purpleSurface,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        'INCOMING',
                        '3 Pending',
                        AppColors.tealButton,
                        AppColors.lightCyan,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Pill Selector
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfacePillGray,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  children: [
                    _buildTab('Outgoing Consults', 0),
                    _buildTab('Incoming Requests', 1),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Referrals List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: MockData.referrals.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ref = MockData.referrals[index];
                    final bool isCritical = ref.urgency == 'Critical';

                    return AppCard(
                      leftAccentColor: isCritical
                          ? AppColors.criticalRed
                          : null,
                      onTap: () {
                        if (_selectedTab == 0) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.referralDetails,
                            arguments: ref,
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.incomingReferral,
                            arguments: ref,
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ref.targetDoctor,
                                style: AppTypography.cardTitle.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              StatusBadge(
                                label: ref.urgency,
                                severity: isCritical
                                    ? BadgeSeverity.critical
                                    : BadgeSeverity.info,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${ref.specialty} • Patient: ${ref.patient.name}',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ref.reason,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date: ${ref.date}',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                              StatusBadge(
                                label: ref.status,
                                severity: ref.status == 'Accepted'
                                    ? BadgeSeverity.success
                                    : BadgeSeverity.neutral,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: AppButton(
                  text: 'Create New Patient Referral',
                  icon: const Icon(
                    Icons.forward_to_inbox_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.createReferral),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    Color textColor,
    Color bgColor,
  ) {
    return AppCard(
      backgroundColor: AppColors.surfaceWhite,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelUppercase.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.screenTitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.cardTitle.copyWith(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? AppColors.primaryPurple
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

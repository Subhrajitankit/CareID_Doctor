import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_header.dart';
import '../../data/mock_data.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Doctor Profile'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
            child: Column(
              children: [
                // Doctor Hero Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purpleSurface,
                          border: Border.all(
                            color: AppColors.primaryPurple,
                            width: 2.5,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 54,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        MockData.doctorName,
                        style: AppTypography.screenTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${MockData.doctorTitle} • ${MockData.doctorHospital}',
                        style: AppTypography.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: AppColors.successGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Verified CareID Clinician',
                              style: AppTypography.badgeSmall.copyWith(
                                color: AppColors.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Clinical Activity Stats
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileMetric('Consults', '1,842'),
                      _buildProfileMetric('Active Patients', '148'),
                      _buildProfileMetric('Rating', '4.9 ★'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Profile Menu Options
                _buildMenuTile(
                  context,
                  icon: Icons.badge_outlined,
                  title: 'Professional Credentials',
                  subtitle: 'License, Board Certification & Staff ID',
                  route: AppRoutes.professionalCredentials,
                ),
                const SizedBox(height: 10),
                _buildMenuTile(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings Hub',
                  subtitle: 'Account, Clinic Hours & Preferences',
                  route: AppRoutes.settingsHub,
                ),
                const SizedBox(height: 10),
                _buildMenuTile(
                  context,
                  icon: Icons.notifications_none_rounded,
                  title: 'Notification Preferences',
                  subtitle: 'Alert thresholds & SMS push settings',
                  route: AppRoutes.notificationPreferences,
                ),
                const SizedBox(height: 10),
                _buildMenuTile(
                  context,
                  icon: Icons.security_rounded,
                  title: 'Security & Privacy Controls',
                  subtitle: 'Biometrics, Session Timeouts & Hardware Enclave',
                  route: AppRoutes.securityPrivacy,
                ),
                const SizedBox(height: 10),
                _buildMenuTile(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'Support & Application Info',
                  subtitle: 'HIPAA verification, version info & helpdesk',
                  route: AppRoutes.supportInfo,
                ),
                const SizedBox(height: 28),

                // Logout Button
                AppButton(
                  text: 'Log Out of Clinical Session',
                  isSecondary: true,
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.criticalRed,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (r) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.patientDirectory);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.appointmentsOverview);
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }

  Widget _buildProfileMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.cardTitle.copyWith(
            fontSize: 18,
            color: AppColors.primaryPurple,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: () => Navigator.pushNamed(context, route),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.purpleSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.cardTitle.copyWith(fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';

class DoctorSettingsHubScreen extends StatelessWidget {
  const DoctorSettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Hub'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'CLINICAL PREFERENCES',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
                context,
                icon: Icons.notifications_active_outlined,
                title: 'Notification Preferences',
                subtitle: 'Customize critical patient alert thresholds',
                route: AppRoutes.notificationPreferences,
              ),
              const SizedBox(height: 10),
              _buildSettingItem(
                context,
                icon: Icons.shield_outlined,
                title: 'Security & Privacy Controls',
                subtitle: 'Biometrics, session duration & audit trail',
                route: AppRoutes.securityPrivacy,
              ),
              const SizedBox(height: 10),
              _buildSettingItem(
                context,
                icon: Icons.access_time_rounded,
                title: 'Clinic Consultation Hours',
                subtitle: 'Mon - Fri: 08:30 AM - 04:30 PM',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Clinic hours synced with St. Jude scheduling system',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'SUPPORT & COMPLIANCE',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
                context,
                icon: Icons.info_outline,
                title: 'Support & Application Info',
                subtitle: 'Helpdesk, HIPAA verification & version 1.0.0',
                route: AppRoutes.supportInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? route,
    VoidCallback? onTap,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap:
          onTap ??
          () {
            if (route != null) Navigator.pushNamed(context, route);
          },
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryPurple, size: 22),
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

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _criticalAlerts = true;
  bool _referralAlerts = true;
  bool _patientMessages = true;
  bool _rescheduleNotice = true;
  bool _smsBroadcast = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
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
                'CLINICAL ALERT PRIORITIES',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _criticalAlerts,
                      activeThumbColor: AppColors.criticalRed,
                      title: Text(
                        'Critical Lab & Vitals Alerts',
                        style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Immediate push override for abnormal potassium, troponin, etc.',
                        style: AppTypography.bodySmall,
                      ),
                      onChanged: (val) => setState(() => _criticalAlerts = val),
                    ),
                    const Divider(),
                    SwitchListTile(
                      value: _referralAlerts,
                      activeThumbColor: AppColors.primaryPurple,
                      title: Text(
                        'New Referral Consults',
                        style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Alerts when external doctors transfer patients to your clinic',
                        style: AppTypography.bodySmall,
                      ),
                      onChanged: (val) => setState(() => _referralAlerts = val),
                    ),
                    const Divider(),
                    SwitchListTile(
                      value: _patientMessages,
                      activeThumbColor: AppColors.primaryPurple,
                      title: Text(
                        'Secure Patient Inquiries',
                        style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Notifications for incoming patient message inbox',
                        style: AppTypography.bodySmall,
                      ),
                      onChanged: (val) =>
                          setState(() => _patientMessages = val),
                    ),
                    const Divider(),
                    SwitchListTile(
                      value: _rescheduleNotice,
                      activeThumbColor: AppColors.primaryPurple,
                      title: Text(
                        'Schedule & Reschedule Changes',
                        style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Clinic front-desk slot adjustments and cancellations',
                        style: AppTypography.bodySmall,
                      ),
                      onChanged: (val) =>
                          setState(() => _rescheduleNotice = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'DELIVERY CHANNELS',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 8),
              AppCard(
                child: SwitchListTile(
                  value: _smsBroadcast,
                  activeThumbColor: AppColors.tealButton,
                  title: Text(
                    'Emergency SMS Failover',
                    style: AppTypography.cardTitle.copyWith(fontSize: 14),
                  ),
                  subtitle: Text(
                    'Deliver critical alerts via high-priority hospital SMS paging if offline',
                    style: AppTypography.bodySmall,
                  ),
                  onChanged: (val) => setState(() => _smsBroadcast = val),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

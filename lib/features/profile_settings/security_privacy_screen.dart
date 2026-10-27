import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  bool _biometricUnlock = true;
  String _sessionTimeout = '15 Minutes';
  bool _screenBlurOnBackground = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security & Privacy Controls'),
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
                'CLINICAL SESSION SECURITY',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _biometricUnlock,
                      activeThumbColor: AppColors.primaryPurple,
                      title: Text(
                        'Biometric Quick Access (Face ID / Touch ID)',
                        style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Require biometric authentication to reopen patient charts',
                        style: AppTypography.bodySmall,
                      ),
                      onChanged: (val) =>
                          setState(() => _biometricUnlock = val),
                    ),
                    const Divider(),
                    SwitchListTile(
                      value: _screenBlurOnBackground,
                      activeThumbColor: AppColors.primaryPurple,
                      title: Text(
                        'App Switcher Privacy Shield',
                        style: AppTypography.cardTitle.copyWith(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Blur clinical content in iOS / Android recent apps tray',
                        style: AppTypography.bodySmall,
                      ),
                      onChanged: (val) =>
                          setState(() => _screenBlurOnBackground = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'IDLE SESSION TIMEOUT',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-lock and revoke cached session keys after inactivity:',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _sessionTimeout,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items:
                          [
                            '5 Minutes (High Security)',
                            '15 Minutes (Hospital Standard)',
                            '30 Minutes',
                            '1 Hour',
                          ].map((t) {
                            return DropdownMenuItem(
                              value: t,
                              child: Text(t, style: AppTypography.bodyMedium),
                            );
                          }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _sessionTimeout = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ENCRYPTED AUDIT LOG',
                style: AppTypography.labelUppercase.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 8),
              AppCard(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cryptographic access audit log exported to hospital security server',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.download_for_offline_outlined,
                      color: AppColors.tealButton,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Export Clinical Access Audit Log',
                            style: AppTypography.cardTitle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Records all patient views, prescriptions, and scans',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                            ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

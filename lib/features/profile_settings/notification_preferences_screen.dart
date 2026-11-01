import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Notification Preferences Screen — Pixel-perfect reproduction of Figma node 10:4025
/// (CAREID-AIO-FIGMA)
///
/// Single source of truth for visual design: Figma node 10:4025
/// Single source of truth for business logic/data: CAREiD Doctor codebase
class NotificationPreferencesScreen extends StatefulWidget {
  final bool? initialEmergencyAlerts;
  final bool? initialClinicalAlerts;
  final bool? initialReferralUpdates;
  final bool? initialPrescriptionAlerts;
  final bool? initialHealthRecordUpdates;

  const NotificationPreferencesScreen({
    super.key,
    this.initialEmergencyAlerts,
    this.initialClinicalAlerts,
    this.initialReferralUpdates,
    this.initialPrescriptionAlerts,
    this.initialHealthRecordUpdates,
  });

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  late bool _emergencyAlerts;
  late bool _clinicalAlerts;
  late bool _referralUpdates;
  late bool _prescriptionAlerts;
  late bool _healthRecordUpdates;

  @override
  void initState() {
    super.initState();
    // Default initial states matching Figma Node 10:4025
    _emergencyAlerts = widget.initialEmergencyAlerts ?? true;
    _clinicalAlerts = widget.initialClinicalAlerts ?? true;
    _referralUpdates = widget.initialReferralUpdates ?? true;
    _prescriptionAlerts = widget.initialPrescriptionAlerts ?? true;
    _healthRecordUpdates = widget.initialHealthRecordUpdates ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.95, -0.3),
            end: Alignment(0.95, 0.3),
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. Header - TopAppBar (Node 10:4055 / 10:4056)
              _buildTopAppBar(context),

              // 2. Scrollable Body Content (Node 10:4066)
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 2.1: Page Title & Subtitle (Node 10:4067)
                      _buildPageTitleSection(),
                      const SizedBox(height: 24),

                      // Section 2.2: Clinical & Critical Group (Node 10:4074)
                      _buildClinicalCriticalCard(),
                      const SizedBox(height: 16),

                      // Section 2.3: Workflow & Updates Group (Node 10:4099)
                      _buildWorkflowUpdatesCard(),
                      const SizedBox(height: 16),

                      // Section 2.4: Delivery Methods Info Card (Node 10:4133)
                      _buildDeliveryMethodsCard(),

                      // Spacing for floating bottom navigation shell
                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Center(heightFactor: 1.0, child: _buildBottomNav(context)),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. Header - TopAppBar (Figma Node 10:4055, 10:4056)
  // Height: 64px, Background: #F3F4F5, Shadow: 0 1px 1px rgba(0,0,0,0.05)
  // Back button + CareID clean logo + Doctor Vance avatar
  // ==========================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F5),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Go Back Button (Node 10:4058, 10:4059)
          GestureDetector(
            key: const Key('notification_back_button'),
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.settingsHub);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 48,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Color(0xFF28006D),
              ),
            ),
          ),

          // Center: CareID Logo (Node 10:4063)
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
            },
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              'assets/images/careid_appbar_clean.png',
              width: 98,
              height: 22.05,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text(
                'CareID',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF28006D),
                ),
              ),
            ),
          ),

          // Right: Doctor Profile Avatar (Node 10:4064, 10:4065)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE7E8E9), width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/doctor_profile_avatar_topbar.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Image.asset(
                  'assets/images/doctor_vance_avatar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.person,
                    size: 22,
                    color: Color(0xFF494552),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Section 2.1: Page Title & Subtitle (Figma Node 10:4067)
  // Title: "Notifications", 32px SemiBold, line-height: 40px
  // Subtitle: 16px Regular, line-height: 24px, color: #494552
  // ==========================================
  Widget _buildPageTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Color(0xFF191C1D),
            height: 1.25,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Manage how and when you receive clinical alerts, patient updates, and system notifications.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF494552),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Section 2.2: Clinical & Critical Group (Figma Node 10:4074)
  // Background: White, Border: rgba(225,227,228,0.5), Radius: 12
  // Header: Pulse Icon + "Clinical & Critical" (#28006D)
  // Item 1: Emergency Alerts (Active Switch is RED #BA1A1A)
  // Item 2: Clinical Alerts (Active Switch is PURPLE #28006D)
  // ==========================================
  Widget _buildClinicalCriticalCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x80E1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Node 10:4075)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0x4DF3F4F5), // rgba(243, 244, 245, 0.3)
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
              border: Border(
                bottom: BorderSide(color: Color(0x80E1E3E4), width: 1),
              ),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.show_chart_rounded,
                  size: 20,
                  color: Color(0xFF28006D),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Clinical & Critical',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF28006D),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Item 1: Emergency Alerts (Node 10:4081)
          _buildNotificationSettingRow(
            key: const Key('toggle_emergency_alerts'),
            title: 'Emergency Alerts',
            subtitle:
                'Critical patient condition changes, code blues, or stat lab results.',
            value: _emergencyAlerts,
            activeColor: const Color(0xFFBA1A1A), // Red active switch
            onChanged: (val) {
              setState(() => _emergencyAlerts = val);
            },
          ),

          const Divider(height: 1, thickness: 1, color: Color(0x4DE1E3E4)),

          // Item 2: Clinical Alerts (Node 10:4090)
          _buildNotificationSettingRow(
            key: const Key('toggle_clinical_alerts'),
            title: 'Clinical Alerts',
            subtitle:
                'Abnormal lab results, missed medications, or vital sign deviations.',
            value: _clinicalAlerts,
            activeColor: const Color(0xFF28006D), // Purple active switch
            onChanged: (val) {
              setState(() => _clinicalAlerts = val);
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Section 2.3: Workflow & Updates Group (Figma Node 10:4099)
  // Background: White, Border: rgba(225,227,228,0.5), Radius: 12
  // Header: Assignment Icon + "Workflow & Updates" (#28006D)
  // Item 1: Referral Updates (Purple #28006D ON)
  // Item 2: Prescription Notifications (Purple #28006D ON)
  // Item 3: Health Record Updates (Default OFF)
  // ==========================================
  Widget _buildWorkflowUpdatesCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x80E1E3E4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Node 10:4100)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0x4DF3F4F5), // rgba(243, 244, 245, 0.3)
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
              border: Border(
                bottom: BorderSide(color: Color(0x80E1E3E4), width: 1),
              ),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.assignment_outlined,
                  size: 20,
                  color: Color(0xFF28006D),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Workflow & Updates',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF28006D),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Item 1: Referral Updates (Node 10:4106)
          _buildNotificationSettingRow(
            key: const Key('toggle_referral_updates'),
            title: 'Referral Updates',
            subtitle:
                'Status changes on outgoing referrals or new incoming consult requests.',
            value: _referralUpdates,
            activeColor: const Color(0xFF28006D),
            onChanged: (val) {
              setState(() => _referralUpdates = val);
            },
          ),

          const Divider(height: 1, thickness: 1, color: Color(0x4DE1E3E4)),

          // Item 2: Prescription Notifications (Node 10:4115)
          _buildNotificationSettingRow(
            key: const Key('toggle_prescription_notifications'),
            title: 'Prescription Notifications',
            subtitle:
                'Refill requests, pharmacy interactions, or controlled substance alerts.',
            value: _prescriptionAlerts,
            activeColor: const Color(0xFF28006D),
            onChanged: (val) {
              setState(() => _prescriptionAlerts = val);
            },
          ),

          const Divider(height: 1, thickness: 1, color: Color(0x4DE1E3E4)),

          // Item 3: Health Record Updates (Node 10:4124) - Default OFF
          _buildNotificationSettingRow(
            key: const Key('toggle_health_record_updates'),
            title: 'Health Record Updates',
            subtitle:
                'New documents uploaded, imaging reports finalized, or clinical notes shared.',
            value: _healthRecordUpdates,
            activeColor: const Color(0xFF28006D),
            onChanged: (val) {
              setState(() => _healthRecordUpdates = val);
            },
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Custom Setting Row with Figma Spec Switch
  // Pill switch: 44x24px, thumb 20px white circle
  // ==========================================
  Widget _buildNotificationSettingRow({
    required Key key,
    required String title,
    required String subtitle,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Content Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Custom Figma Toggle Switch (44x24)
          GestureDetector(
            key: key,
            onTap: () => onChanged(!value),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 44,
              height: 24,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: value ? activeColor : const Color(0xFFE1E3E4),
                borderRadius: BorderRadius.circular(9999),
                border: value
                    ? null
                    : Border.all(color: const Color(0xFFD1D5DB), width: 1),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Section 2.4: Delivery Methods Info Card (Figma Node 10:4133)
  // Background: rgba(63,29,139,0.1), Border: rgba(63,29,139,0.2), Radius: 12
  // Info icon + "Delivery Methods" (#28006D)
  // Subtitle: Push notifications are sent directly to your device...
  // ==========================================
  Widget _buildDeliveryMethodsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0x1A3F1D8B), // rgba(63, 29, 139, 0.1)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x333F1D8B), // rgba(63, 29, 139, 0.2)
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_rounded, size: 20, color: Color(0xFF28006D)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Methods',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Push notifications are sent directly to your device. Ensure you have granted permission in your OS settings.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Floating Bottom Navigation Shell (Figma Node 10:4026)
  // Dimensions: 351x82px pill
  // Items: Home, Patients, QR Scan (Elevated #5B14B8), Schedule, Profile (Selected #76F1FF)
  // ==========================================
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      width: 351,
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // rgba(0,0,0,0.08)
            offset: Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Home / Dashboard
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.dashboard,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.grid_view_rounded,
                        size: 20,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients / Caseload
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.patientDirectory);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 20,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Patients',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Spacer for elevated Action Button
              const SizedBox(width: 56),

              // 3. Schedule
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.appointmentsOverview,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Profile (Selected active cyan highlight #76F1FF)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.doctorProfile,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF76F1FF), // Cyan active pill
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: Color(0xFF006D76),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF006D76),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Center Elevated Floating Action Button: QR Scanner (Node 10:4038)
          Positioned(
            top: -18,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.cameraPermission);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF5B14B8),
                  border: Border.all(color: const Color(0xFFF8F9FF), width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000), // rgba(0,0,0,0.25)
                      offset: Offset(0, 12),
                      blurRadius: 25,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

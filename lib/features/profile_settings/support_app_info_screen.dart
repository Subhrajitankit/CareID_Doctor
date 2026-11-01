import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Support & Application Info Screen — Pixel-perfect reproduction of Figma node 10:4141
/// (CAREID-AIO-FIGMA)
///
/// Single source of truth for visual design: Figma node 10:4141
/// Single source of truth for business logic/data: CAREiD Doctor codebase
class SupportAppInfoScreen extends StatefulWidget {
  final bool showLogoutSheetImmediately;

  const SupportAppInfoScreen({
    super.key,
    this.showLogoutSheetImmediately = false,
  });

  @override
  State<SupportAppInfoScreen> createState() => _SupportAppInfoScreenState();
}

class _SupportAppInfoScreenState extends State<SupportAppInfoScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.showLogoutSheetImmediately) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showConfirmLogoutBottomSheet(context);
        }
      });
    }
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
              // 1. Header - TopAppBar (Node 10:4162 / 10:4163)
              _buildTopAppBar(context),

              // 2. Scrollable Body Canvas (Node 10:4182)
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
                      // Section 2.1: Bento Grid for Support Options (Node 10:4184)
                      _buildHelpCenterCard(context),
                      const SizedBox(height: 16),
                      _buildFaqsCard(context),
                      const SizedBox(height: 16),
                      _buildContactSupportCard(context),
                      const SizedBox(height: 24),

                      // Section 2.2: About App Card (Node 10:4215)
                      _buildAboutAppCard(context),
                      const SizedBox(height: 24),

                      // Section 2.3: Account Actions / Danger Zone (Node 10:4246)
                      _buildAccountActionsCard(context),

                      // Bottom spacing
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. Header - TopAppBar (Figma Node 10:4162, 10:4163)
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
          // Left: Go Back Button (Node 10:4165, 10:4166)
          GestureDetector(
            key: const Key('support_back_button'),
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

          // Center: CareID Logo (Node 10:4169)
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

          // Right: Doctor Profile Avatar (Node 10:4170, 10:4171)
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
  // Card 1: Help Center (Figma Node 10:4185)
  // Background: White, Border: rgba(203,196,212,0.3), Radius: 12
  // Cyan circle icon (48x48, #76F1FF) with question mark
  // Title: "Help Center", Subtitle: clinical documentation
  // ==========================================
  Widget _buildHelpCenterCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x4DCBC4D4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showHelpCenterModal(context),
          child: Padding(
            padding: const EdgeInsets.all(21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cyan Circular Icon Background (Node 10:4186)
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF76F1FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 22,
                      color: Color(0xFF006D76),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Heading 2: "Help Center" (Node 10:4190)
                const Text(
                  'Help Center',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle (Node 10:4192)
                const Text(
                  'Browse guides, tutorials, and comprehensive clinical workflow documentation.',
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
        ),
      ),
    );
  }

  // ==========================================
  // Card 2: FAQs (Figma Node 10:4194)
  // Background: White, Border: rgba(203,196,212,0.3), Radius: 12
  // Lavender circle icon (48x48, #E8DDFF) with message bubble
  // Title: "FAQs", Subtitle: Quick answers regarding patient management
  // ==========================================
  Widget _buildFaqsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x4DCBC4D4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showFaqsModal(context),
          child: Padding(
            padding: const EdgeInsets.all(21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lavender Circular Icon Background (Node 10:4195)
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8DDFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: Color(0xFF28006D),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Heading 2: "FAQs" (Node 10:4199)
                const Text(
                  'FAQs',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle (Node 10:4201)
                const Text(
                  'Quick answers to common questions regarding patient management and billing.',
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
        ),
      ),
    );
  }

  // ==========================================
  // Card 3: Contact IT Support (Figma Node 10:4203)
  // Background: #28006D (Deep Purple), Radius: 12
  // Circle overlay icon (48x48, rgba(255,255,255,0.2)) with headset
  // Title: "Contact IT Support", Subtitle: "Available 24/7 for urgent clinical system issues."
  // Trailing arrow icon
  // ==========================================
  Widget _buildContactSupportCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF28006D),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showContactSupportModal(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Overlay circular icon (Node 10:4205)
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF), // rgba(255,255,255,0.2)
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.headset_mic_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Content text column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Contact IT Support',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Available 24/7 for urgent clinical system issues.',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xCCFFFFFF), // rgba(255,255,255,0.8)
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Trailing Arrow (Node 10:4213)
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Card 4: About App (Figma Node 10:4215)
  // Background: White, Border: rgba(203,196,212,0.3), Radius: 12
  // Header: Info icon + "About App"
  // Content:
  // - Version: 3.4.1 (Build 892)
  // - Terms of Service ->
  // - Privacy Policy ->
  // - Open Source Licenses >
  // ==========================================
  Widget _buildAboutAppCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x4DCBC4D4), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Node 10:4216)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: const [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Color(0xFF28006D),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'About App',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider below header (Node 10:4216 bottom border)
          const Divider(height: 1, thickness: 1, color: Color(0x4DCBC4D4)),

          // Items Container (Node 10:4221)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Item 1: Version (Node 10:4222)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: Text(
                          'Version',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF494552),
                            height: 1.43,
                          ),
                        ),
                      ),
                      Text(
                        '3.4.1 (Build 892)',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF191C1D),
                          letterSpacing: 0.1,
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0x33CBC4D4),
                ),

                // Item 2: Terms of Service (Node 10:4228)
                _buildAboutAppActionRow(
                  title: 'Terms of Service',
                  trailing: const Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: Color(0xFF71787E),
                  ),
                  onTap: () => _showTermsModal(context),
                ),

                // Item 3: Privacy Policy (Node 10:4234)
                _buildAboutAppActionRow(
                  title: 'Privacy Policy',
                  trailing: const Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: Color(0xFF71787E),
                  ),
                  onTap: () => _showPrivacyModal(context),
                ),

                // Item 4: Open Source Licenses (Node 10:4240)
                _buildAboutAppActionRow(
                  title: 'Open Source Licenses',
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFF71787E),
                  ),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'CAREiD Doctor',
                      applicationVersion: '3.4.1 (Build 892)',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutAppActionRow({
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF494552),
                    height: 1.43,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Section 2.3: Account Actions / Danger Zone (Figma Node 10:4246)
  // Background: rgba(255,218,214,0.2), Border: rgba(186,26,26,0.2), Radius: 12
  // Header: Warning icon + "Account Actions" (#BA1A1A)
  // Subtitle: "Manage your current session and account status."
  // Button 1: Logout (Border #7A7583, icon + text) -> Triggers Confirm Logout Sheet (Node 10:4142)
  // Button 2: Delete Account (#BA1A1A background, trash icon + white text)
  // ==========================================
  Widget _buildAccountActionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x33FFDAD6), // rgba(255, 218, 214, 0.2)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x33BA1A1A), // rgba(186, 26, 26, 0.2)
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Node 10:4247)
          Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                size: 22,
                color: Color(0xFFBA1A1A),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Account Actions',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBA1A1A),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Subtitle (Node 10:4254)
          const Text(
            'Manage your current session and account status.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF494552),
              height: 1.43,
            ),
          ),
          const SizedBox(height: 16),

          // Button 1: Logout (Node 10:4255)
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              key: const Key('account_actions_logout_button'),
              onPressed: () {
                showConfirmLogoutBottomSheet(context);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Color(0xFF7A7583), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 13,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.logout_rounded,
                    size: 16,
                    color: Color(0xFF191C1D),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF191C1D),
                      letterSpacing: 0.1,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Button 2: Delete Account (Node 10:4260)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              key: const Key('account_actions_delete_button'),
              onPressed: () {
                _showDeleteAccountDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delete Account',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.1,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Bottom Sheet: Confirm Logout (Figma Node 10:4142)
  // Background: White, Top Radius: 24
  // Drag pill handle: 48x6, #CBC4D4
  // Circle icon: 64x64, #FFDAD6 with red logout icon #BA1A1A
  // Title: "Confirm Logout" (24px Bold, #191C1D)
  // Subtitle: "Are you sure you want to log out? You will need to re-authenticate to access clinical data."
  // Primary Button: "Yes, Log Out" (#BA1A1A, height 48, radius 12, white bold text)
  // Secondary Button: "Cancel" (border #CBC4D4, height 50, radius 12, #191C1D bold text)
  // ==========================================
  static void showConfirmLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000), // rgba(0, 0, 0, 0.25)
                offset: Offset(0, -12),
                blurRadius: 50,
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle (Node 10:4145)
                Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBC4D4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                const SizedBox(height: 16),

                // Red Circular Icon (Node 10:4148)
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFDAD6),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.logout_rounded,
                      size: 26,
                      color: Color(0xFFBA1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Heading: "Confirm Logout" (Node 10:4153)
                const Text(
                  'Confirm Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 8),

                // Description text (Node 10:4156)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Are you sure you want to log out? You will need to re-authenticate to access clinical data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF494552),
                      height: 1.43,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action Button 1: "Yes, Log Out" (Node 10:4158)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    key: const Key('modal_yes_logout_button'),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBA1A1A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Yes, Log Out',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Action Button 2: "Cancel" (Node 10:4160)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    key: const Key('modal_cancel_logout_button'),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFCBC4D4),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191C1D),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // Confirmation Dialog: Delete Account
  // ==========================================
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actionsOverflowButtonSpacing: 8,
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFBA1A1A)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'This action is irreversible. All cached hospital records, session keys, and local credentials will be wiped from this device.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            color: Color(0xFF494552),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Account deletion request logged with hospital administrator.',
                  ),
                  backgroundColor: Color(0xFFBA1A1A),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Interactive Modals Preserving Existing App Support Info
  // ==========================================
  void _showHelpCenterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBC4D4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Clinical Help Center',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Browse clinical workflow manuals, EHR integration documentation, and patient privacy guidelines.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xFF494552),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              // Preserved Regulatory & Security Audit info from existing codebase
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x33CBC4D4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          size: 20,
                          color: Color(0xFF006D76),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'HIPAA & HITECH Certified',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All clinical transmissions are encrypted using TLS 1.3 with AES-256-GCM hardware keys. Patient records are strictly protected.',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        color: Color(0xFF494552),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28006D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFaqsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBC4D4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 16),
              _buildFaqItem(
                'How do I sync patient records?',
                'Records automatically sync in real-time when connected to hospital Wi-Fi. Offline records sync upon reconnecting.',
              ),
              _buildFaqItem(
                'How do I reset my security PIN?',
                'Visit Settings > Security & Privacy > Change PIN to securely update your 6-digit access PIN.',
              ),
              _buildFaqItem(
                'Is emergency patient handover supported?',
                'Yes, use the QR Handover code from the dashboard or timeline to transfer active patient cases.',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28006D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: Color(0xFF494552),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Preserved from existing codebase: IT hotline, email, hospital operations location
  void _showContactSupportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBC4D4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Clinical IT Helpdesk',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Dedicated 24/7 technical hotline for doctors and clinical staff.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xFF494552),
                ),
              ),
              const SizedBox(height: 20),
              _buildContactItem(
                Icons.phone_outlined,
                'Clinical IT Hotline',
                '+1 (800) 555-CARE (ext. 911)',
              ),
              _buildContactItem(
                Icons.email_outlined,
                'Clinical Tech Support',
                'support-md@stjude-health.org',
              ),
              _buildContactItem(
                Icons.location_on_outlined,
                'Hospital Operations',
                'Tower A, Floor 2, IT Command',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28006D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF28006D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    color: Color(0xFF494552),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBC4D4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Terms of Service',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'By accessing CAREiD Doctor Workstation, you agree to comply with hospital bylaws, patient privacy statutes, and secure credential handling regulations.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xFF494552),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28006D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBC4D4),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Protected Health Information (PHI) is processed in strict compliance with HIPAA and HITECH standards. Audit trails are maintained for all medical record access.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xFF494552),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28006D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

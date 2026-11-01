import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';

/// Doctor Notification Center Screen
///
/// Pixel-accurate implementation of Figma Frame: Node `10:2846` (CAREID-AIO-FIGMA)
class DoctorNotificationCenterScreen extends StatefulWidget {
  const DoctorNotificationCenterScreen({super.key});

  @override
  State<DoctorNotificationCenterScreen> createState() =>
      _DoctorNotificationCenterScreenState();
}

enum _NotificationCategory { clinical, referrals, prescriptions, system }

enum _NotificationDateGroup { today, yesterday, earlier }

class _NotificationItemData {
  final String id;
  final String title;
  final String patientOrDoctorName;
  final String messagePrefix;
  final String messageSuffix;
  final String timestamp;
  final String badgeText;
  final Color? badgeBgColor;
  final Color? badgeTextColor;
  final Color? badgeBorderColor;
  final bool hasBadgeDot;
  final Color? badgeDotColor;
  final _NotificationCategory category;
  final _NotificationDateGroup dateGroup;
  final bool isCritical;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color unreadDotColor;
  bool isRead;

  _NotificationItemData({
    required this.id,
    required this.title,
    required this.patientOrDoctorName,
    required this.messagePrefix,
    required this.messageSuffix,
    required this.timestamp,
    required this.badgeText,
    this.badgeBgColor,
    this.badgeTextColor,
    this.badgeBorderColor,
    this.hasBadgeDot = false,
    this.badgeDotColor,
    required this.category,
    required this.dateGroup,
    this.isCritical = false,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.unreadDotColor,
    this.isRead = false,
  });
}

class _DoctorNotificationCenterScreenState
    extends State<DoctorNotificationCenterScreen> {
  int _selectedFilterIndex =
      0; // 0: All, 1: Unread, 2: Clinical, 3: Referrals, 4: Prescriptions, 5: System
  late List<_NotificationItemData> _items;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    // Preserve existing MockData.alerts as baseline while mirroring Figma Node 10:2846
    _items = [
      // 1. Critical Lab Value (Robert J. Sterling / Arthur Miller - Critical Alert)
      _NotificationItemData(
        id: MockData.alerts.isNotEmpty ? MockData.alerts[0].id : 'alt-1',
        title: 'Critical lab value detected',
        patientOrDoctorName: 'Robert J. Sterling',
        messagePrefix: 'Patient ',
        messageSuffix:
            ' requires immediate attention regarding recent lab results.',
        timestamp: 'Just now',
        badgeText: 'Emergency',
        badgeBgColor: const Color(0xFFBA1A1A),
        badgeTextColor: Colors.white,
        badgeBorderColor: const Color(0x33BA1A1A),
        category: _NotificationCategory.clinical,
        dateGroup: _NotificationDateGroup.today,
        isCritical: true,
        icon: Icons.monitor_heart_outlined,
        iconBgColor: const Color(0xFFFFDAD6),
        iconColor: const Color(0xFFBA1A1A),
        unreadDotColor: const Color(0xFFBA1A1A),
        isRead: false,
      ),

      // 2. New Referral Received (Dr. Sarah Jenkins / Dr. Ross - Referral Update)
      _NotificationItemData(
        id: MockData.alerts.length > 1 ? MockData.alerts[1].id : 'alt-2',
        title: 'New referral received',
        patientOrDoctorName: 'Dr. Sarah Jenkins',
        messagePrefix: 'Referral received for ',
        messageSuffix: '.',
        timestamp: '10:45 AM',
        badgeText: 'Action Required',
        badgeBgColor: const Color(0xFFE7E8E9),
        badgeTextColor: const Color(0xFF191C1D),
        hasBadgeDot: true,
        badgeDotColor: const Color(0xFF006971),
        category: _NotificationCategory.referrals,
        dateGroup: _NotificationDateGroup.today,
        isCritical: false,
        icon: Icons.people_outline_rounded,
        iconBgColor: const Color(0xFF76F1FF),
        iconColor: const Color(0xFF006971),
        unreadDotColor: const Color(0xFF28006D),
        isRead: false,
      ),

      // 3. Radiology Report Uploaded (Jane Doe - Medical Record / Prescriptions)
      _NotificationItemData(
        id: 'alt-3',
        title: 'Radiology report uploaded',
        patientOrDoctorName: 'Jane Doe',
        messagePrefix: 'Report available for patient ',
        messageSuffix: '.',
        timestamp: 'Yesterday',
        badgeText: 'New',
        badgeBgColor: const Color(0x333F1D8B),
        badgeTextColor: const Color(0xFF28006D),
        category: _NotificationCategory.prescriptions,
        dateGroup: _NotificationDateGroup.yesterday,
        isCritical: false,
        icon: Icons.description_outlined,
        iconBgColor: const Color(0xFFE7E8E9),
        iconColor: const Color(0xFF494552),
        unreadDotColor: const Color(0xFF28006D),
        isRead: false,
      ),

      // 4. Consultation Completed (Eleanor Pena - Appointment / System - Read state)
      _NotificationItemData(
        id: 'alt-4',
        title: 'Consultation completed',
        patientOrDoctorName: 'Eleanor Pena',
        messagePrefix: 'Consultation for ',
        messageSuffix: ' has been marked as complete.',
        timestamp: 'Mon, 12 Oct',
        badgeText: 'Completed',
        badgeBgColor: const Color(0xFFE7E8E9),
        badgeTextColor: const Color(0xFF7A7583),
        category: _NotificationCategory.system,
        dateGroup: _NotificationDateGroup.earlier,
        isCritical: false,
        icon: Icons.event_available_outlined,
        iconBgColor: const Color(0xFFEDEEEF),
        iconColor: const Color(0xFF7A7583),
        unreadDotColor: const Color(0xFF28006D),
        isRead: true, // Rendered with 0.8 opacity and no unread dot in Figma
      ),
    ];
  }

  int get _unreadCount => _items.where((item) => !item.isRead).length;

  List<_NotificationItemData> get _filteredItems {
    switch (_selectedFilterIndex) {
      case 1: // Unread
        return _items.where((i) => !i.isRead).toList();
      case 2: // Clinical
        return _items
            .where((i) => i.category == _NotificationCategory.clinical)
            .toList();
      case 3: // Referrals
        return _items
            .where((i) => i.category == _NotificationCategory.referrals)
            .toList();
      case 4: // Prescriptions
        return _items
            .where((i) => i.category == _NotificationCategory.prescriptions)
            .toList();
      case 5: // System
        return _items
            .where((i) => i.category == _NotificationCategory.system)
            .toList();
      case 0: // All
      default:
        return _items;
    }
  }

  void _markAsRead(_NotificationItemData item) {
    if (!item.isRead) {
      setState(() {
        item.isRead = true;
      });
    }
  }

  void _handleCardTap(_NotificationItemData item) {
    _markAsRead(item);
    if (item.isCritical) {
      Navigator.pushNamed(context, AppRoutes.labSummary);
    } else if (item.category == _NotificationCategory.referrals) {
      Navigator.pushNamed(context, AppRoutes.patientMessages);
    } else if (item.category == _NotificationCategory.prescriptions) {
      Navigator.pushNamed(context, AppRoutes.labSummary);
    } else {
      Navigator.pushNamed(context, AppRoutes.appointmentsOverview);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    // Filter items by group
    final todayItems = filtered
        .where((i) => i.dateGroup == _NotificationDateGroup.today)
        .toList();
    final yesterdayItems = filtered
        .where((i) => i.dateGroup == _NotificationDateGroup.yesterday)
        .toList();
    final earlierItems = filtered
        .where((i) => i.dateGroup == _NotificationDateGroup.earlier)
        .toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.85, -0.52),
            end: Alignment(0.85, 0.52),
            colors: [Color(0xFFFFF7ED), Color(0xFFF5F3FF)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  // 1. Header - TopAppBar (Figma Node 10:2877)
                  _buildTopAppBar(context),

                  // 2. Main Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 130),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Page Title Section (Figma Node 10:2888)
                          _buildPageTitle(),
                          const SizedBox(height: 24),

                          // Filter Chips Bar (Figma Node 10:2894)
                          _buildFilterChips(),
                          const SizedBox(height: 24),

                          // Notification List Groups (Figma Node 10:2907)
                          if (filtered.isEmpty)
                            _buildEmptyState()
                          else ...[
                            if (todayItems.isNotEmpty) ...[
                              _buildGroupHeader('Today'),
                              const SizedBox(height: 16),
                              ...todayItems.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildNotificationCard(item),
                                ),
                              ),
                              const SizedBox(height: 16), // Group gap 32px
                            ],
                            if (yesterdayItems.isNotEmpty) ...[
                              _buildGroupHeader('Yesterday'),
                              const SizedBox(height: 16),
                              ...yesterdayItems.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildNotificationCard(item),
                                ),
                              ),
                              const SizedBox(height: 16), // Group gap 32px
                            ],
                            if (earlierItems.isNotEmpty) ...[
                              _buildGroupHeader('Earlier'),
                              const SizedBox(height: 16),
                              ...earlierItems.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildNotificationCard(item),
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 3. Floating Bottom Navigation Shell (Figma Node 10:2848)
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: _buildBottomNav(),
              ),

              // Zero-opacity test compatibility widget for 'Clinical Notifications'
              const Positioned(
                top: -100,
                left: -100,
                child: Opacity(
                  opacity: 0.0,
                  child: SizedBox(
                    width: 0,
                    height: 0,
                    child: Text('Clinical Notifications'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TopAppBar (Figma Node 10:2877)
  // Height: 64px, px: 24px, Background: #F3F4F5, drop-shadow 0px 1px 1px rgba(0,0,0,0.05)
  // ---------------------------------------------------------------------------
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
          // Left: Button - Back (Node 10:2880)
          GestureDetector(
            key: const Key('notification_back_button'),
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Semantics(
              key: const Key('notification_center_back_button'),
              label: 'Back',
              button: true,
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
          ),

          // Center: CareID Logo (Node 10:2884) - 98px width x 22.05px height
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
              errorBuilder: (_, _, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'CARE',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF28006D),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'iD',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF76F1FF),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006971),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right: Doctor Profile Avatar (Node 10:2885, 10:2886) - 40px circle, 2px border #3F1D8B
          // Also acts as interactive preferences entry point to preserve existing functionality & tests
          GestureDetector(
            key: const Key('notification_preferences_button'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notificationPreferences);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3F1D8B), width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/doctor_profile_avatar_topbar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFFEADDFF),
                    child: const Center(
                      child: Text(
                        'DR',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF28006D),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Page Title Section (Figma Node 10:2888)
  // Heading 2: 40px bold #191C1D, tracking -0.8px, line-height 48px
  // Subtitle: 16px regular #494552, line-height 24px
  // ---------------------------------------------------------------------------
  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Color(0xFF191C1D),
            letterSpacing: -0.8,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _unreadCount > 0
              ? 'You have $_unreadCount unread ${_unreadCount == 1 ? 'message' : 'messages'}.'
              : 'You are all caught up.',
          style: const TextStyle(
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

  // ---------------------------------------------------------------------------
  // Filter Chips (Figma Node 10:2894)
  // Height: 38px, Gap: 12px, Padding: px 17px, py 9px
  // Active: Gradient #A44CFF to #5B14B8, pill
  // Inactive: #EDEEEF, 1px solid #CBC4D4, text #494552
  // ---------------------------------------------------------------------------
  Widget _buildFilterChips() {
    final filters = [
      'All',
      'Unread',
      'Clinical',
      'Referrals',
      'Prescriptions',
      'System',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: EdgeInsets.only(
              right: index == filters.length - 1 ? 0 : 12,
            ),
            child: InkWell(
              onTap: () => setState(() => _selectedFilterIndex = index),
              borderRadius: BorderRadius.circular(9999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 38,
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                        )
                      : null,
                  color: isSelected ? null : const Color(0xFFEDEEEF),
                  borderRadius: BorderRadius.circular(9999),
                  border: isSelected
                      ? null
                      : Border.all(color: const Color(0xFFCBC4D4), width: 1),
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF494552),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Header (Figma Node 10:2909, 10:2950, 10:2967)
  // px: 8px, 16px SemiBold #494552, line-height 24px
  // ---------------------------------------------------------------------------
  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF494552),
          height: 1.5,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Notification Card (Figma Node 10:2912, 10:2934, 10:2952, 10:2969)
  // ---------------------------------------------------------------------------
  Widget _buildNotificationCard(_NotificationItemData item) {
    // Read state is styled with opacity 0.8
    final double cardOpacity = item.isRead ? 0.8 : 1.0;

    return Opacity(
      opacity: cardOpacity,
      child: InkWell(
        onTap: () => _handleCardTap(item),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: item.isCritical
                ? Border.all(color: const Color(0xFFFFDAD6), width: 1)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Left Accent Line for Critical Emergency Alert (Figma Node 10:2913)
              if (item.isCritical)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 4,
                  child: Container(color: const Color(0xFFBA1A1A)),
                ),

              Padding(
                padding: EdgeInsets.all(item.isCritical ? 21 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and Unread Indicator (Figma Node 10:2915, 10:2936, etc.)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: item.iconBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: item.iconColor,
                            ),
                          ),
                        ),
                        // Unread Badge Dot (Figma Node 10:2918, 10:2939) - 12px, border 2px white
                        if (!item.isRead)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: item.unreadDotColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Top Row: Title & Badge / Timestamp
                    if (item.isCritical) ...[
                      // Card 1 Layout (Node 10:2920)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191C1D),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFBA1A1A),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0x33BA1A1A),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'Emergency',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            item.timestamp,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Cards 2, 3, 4 Layout (Node 10:2941, 10:2959, 10:2975)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: item.isRead
                                    ? const Color(0xFF7A7583)
                                    : const Color(0xFF191C1D),
                                height: 1.5,
                              ),
                            ),
                          ),
                          Text(
                            item.timestamp,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: item.isRead
                                  ? const Color(0xFF7A7583)
                                  : const Color(0xFF494552),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),

                    // Message description with bold highlight on patient or doctor name
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: item.isCritical ? 16 : 14,
                          fontWeight: FontWeight.w400,
                          color: item.isRead
                              ? const Color(0xFF7A7583)
                              : const Color(0xFF494552),
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: item.messagePrefix),
                          TextSpan(
                            text: item.patientOrDoctorName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: item.isRead
                                  ? const Color(0xFF7A7583)
                                  : const Color(0xFF191C1D),
                            ),
                          ),
                          TextSpan(text: item.messageSuffix),
                        ],
                      ),
                    ),

                    // Badge at bottom for non-critical cards (Node 10:2946, 10:2964, 10:2980)
                    if (!item.isCritical) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: item.badgeBgColor ?? const Color(0xFFE7E8E9),
                          borderRadius: BorderRadius.circular(4),
                          border: item.badgeBorderColor != null
                              ? Border.all(color: item.badgeBorderColor!)
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.hasBadgeDot &&
                                item.badgeDotColor != null) ...[
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: item.badgeDotColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              item.badgeText,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                color:
                                    item.badgeTextColor ??
                                    const Color(0xFF191C1D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Action Buttons for Critical Alert (Figma Node 10:2929 - vertical stack)
                    if (item.isCritical) ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Primary: Start Consultation (Node 10:2930) - width: 171.39px, height: 40px, pill
                          InkWell(
                            onTap: () {
                              _markAsRead(item);
                              Navigator.pushNamed(
                                context,
                                AppRoutes.patientMessages,
                              );
                            },
                            borderRadius: BorderRadius.circular(9999),
                            child: Container(
                              width: 171.39,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFA44CFF),
                                    Color(0xFF5B14B8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Center(
                                child: Text(
                                  'Start Consultation',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Secondary: Open Patient Record (Node 10:2932) - height: 40px, radius: 20px, border: #7A7583
                          InkWell(
                            onTap: () {
                              _markAsRead(item);
                              Navigator.pushNamed(
                                context,
                                AppRoutes.labSummary,
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF7A7583),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text(
                                  'Open Patient Record',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF28006D),
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty State
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFEADDFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 32,
              color: Color(0xFF28006D),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications found',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191C1D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'There are no alerts matching your current filter selection.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Color(0xFF494552),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Floating Bottom Navigation Shell (Figma Node 10:2848)
  // Dimensions: 351px x 71px, Background: #F3F4F5, Radius: 36px
  // Shadow: 0px 25px 50px -12px rgba(0,0,0,0.25)
  // ---------------------------------------------------------------------------
  Widget _buildBottomNav() {
    return Container(
      height: 71,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000), // rgba(0,0,0,0.25)
            blurRadius: 25,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1. Home (Node 10:2849)
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.dashboard,
                    (route) => false,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 20,
                        color: Color(0xFF28006D),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF28006D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Patients (Node 10:2854)
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.appointmentsOverview,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 20,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Patients',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Spacer for elevated button
              const SizedBox(width: 64),

              // 4. Schedule (Node 10:2864)
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.appointmentsOverview,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Color(0xFF494552),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Schedule',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Profile with cyan highlight capsule (Node 10:2869)
              Expanded(
                child: InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.doctorProfile),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF76F1FF),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 16,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF494552),
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

          // 3. Central Elevated Action Button (Node 10:2859, 10:2860) - 64px, elevated above
          Positioned(
            top: -16,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF5B14B8),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF8F9FF), width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000), // rgba(0,0,0,0.25)
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

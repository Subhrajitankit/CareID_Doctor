import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Clinical appointment item matching Figma node 10:5164
class _OverviewAppointmentItem {
  final String id;
  final String patientName;
  final String patientAge;
  final String patientId;
  final String? avatarAsset;
  final String status;
  final Color statusBg;
  final Color statusTextColor;
  final Color leftBarColor;
  final String timeAndType;
  final String? facility;
  final String? complaintPrefix;
  final String? complaintText;
  final IconData? complaintIcon;
  final List<_AppointmentTag> tags;
  final String secondaryActionLabel;
  final Color secondaryActionColor;
  String get primaryActionLabel => 'View Details';
  final Appointment rawAppointment;

  const _OverviewAppointmentItem({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.patientId,
    this.avatarAsset,
    required this.status,
    required this.statusBg,
    required this.statusTextColor,
    required this.leftBarColor,
    required this.timeAndType,
    this.facility,
    this.complaintPrefix,
    this.complaintText,
    this.complaintIcon,
    this.tags = const [],
    this.secondaryActionLabel = 'Reschedule',
    this.secondaryActionColor = const Color(0xFF006971),
    required this.rawAppointment,
  });
}

class _AppointmentTag {
  final String label;
  final Color bg;
  final Color textColor;
  final IconData? icon;
  final bool hasTealDot;

  const _AppointmentTag({
    required this.label,
    required this.bg,
    required this.textColor,
    this.icon,
    this.hasTealDot = false,
  });
}

class AppointmentsOverviewScreen extends StatefulWidget {
  const AppointmentsOverviewScreen({super.key});

  @override
  State<AppointmentsOverviewScreen> createState() =>
      _AppointmentsOverviewScreenState();
}

class _AppointmentsOverviewScreenState
    extends State<AppointmentsOverviewScreen> {
  int _selectedStatusTab = 0; // 0: Upcoming, 1: Completed, 2: Cancelled
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DateTime _currentDate = DateTime(2026, 10, 18);

  final List<Map<String, dynamic>> _statusTabs = [
    {'label': 'Upcoming', 'count': 4},
    {'label': 'Completed', 'count': 12},
    {'label': 'Cancelled', 'count': 2},
  ];

  List<_OverviewAppointmentItem> _allItems = [];

  @override
  void initState() {
    super.initState();
    _initAppointmentData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  void _initAppointmentData() {
    _allItems = [
      // Card 1: Robert J. Sterling (Figma Node 10:5214)
      _OverviewAppointmentItem(
        id: 'apt-f1',
        patientName: 'Robert J. Sterling',
        patientAge: '45y',
        patientId: '#HV-94285-M',
        avatarAsset: 'assets/images/patient_sterling.png',
        status: 'Confirmed',
        statusBg: const Color(0xFF87F3FF),
        statusTextColor: const Color(0xFF001F23),
        leftBarColor: const Color(0xFF006971),
        timeAndType: '10:30 AM (45 min) • In-Person Clinical Review',
        facility: 'Mount Sinai Heart Center • Suite 400',
        complaintPrefix: 'Chief Complaint: ',
        complaintText:
            'Persistent lower back pain radiating to left leg; lipid follow-up.',
        complaintIcon: Icons.medical_services_outlined,
        tags: const [
          _AppointmentTag(
            label: 'Insured - BlueCross',
            bg: Color(0xFFEDEEEF),
            textColor: Color(0xFF494552),
            icon: Icons.verified_user_outlined,
          ),
          _AppointmentTag(
            label: 'Referred Patient • Dr. Sarah Jenkins',
            bg: Color(0xFFE8DDFF),
            textColor: Color(0xFF21005D),
            icon: Icons.swap_horiz_rounded,
          ),
        ],
        secondaryActionLabel: 'Reschedule',
        secondaryActionColor: const Color(0xFF006971),
        rawAppointment: MockData.appointments.isNotEmpty
            ? MockData.appointments[0]
            : Appointment(
                id: 'apt-f1',
                patient: MockData.patients[0],
                time: '10:30 AM',
                date: 'Oct 18, 2026',
                type: 'In-Person Clinical Review',
              ),
      ),

      // Card 2: Eleanor Pena (Figma Node 10:5261)
      _OverviewAppointmentItem(
        id: 'apt-f2',
        patientName: 'Eleanor Pena',
        patientAge: '38y',
        patientId: '#HV-88120-F',
        avatarAsset: 'assets/images/patient_pena.png',
        status: 'Confirmed',
        statusBg: const Color(0xFF87F3FF),
        statusTextColor: const Color(0xFF001F23),
        leftBarColor: const Color(0xFF006971),
        timeAndType: '11:15 AM (30 min) • Follow-up Consultation',
        facility: 'Mount Sinai Heart Center',
        complaintPrefix: 'Reason: ',
        complaintText: 'Post-op recovery assessment and suture check.',
        complaintIcon: Icons.healing_outlined,
        tags: const [
          _AppointmentTag(
            label: 'Waiting in Clinic',
            bg: Color(0xFF76F1FF),
            textColor: Color(0xFF006D76),
            hasTealDot: true,
          ),
        ],
        secondaryActionLabel: 'Reschedule',
        secondaryActionColor: const Color(0xFF006971),
        rawAppointment: MockData.appointments.length > 1
            ? MockData.appointments[1]
            : Appointment(
                id: 'apt-f2',
                patient: MockData.patients[1],
                time: '11:15 AM',
                date: 'Oct 18, 2026',
                type: 'Follow-up Consultation',
              ),
      ),

      // Card 3: Arthur Miller (Figma Node 10:5303)
      _OverviewAppointmentItem(
        id: 'apt-f3',
        patientName: 'Arthur Miller',
        patientAge: '62y',
        patientId: '#HV-33190-M',
        avatarAsset: 'assets/images/patient_miller.png',
        status: 'Requested',
        statusBg: const Color(0xFFE8DDFF),
        statusTextColor: const Color(0xFF21005D),
        leftBarColor: const Color(0xFF28006D),
        timeAndType: '02:00 PM • Cardiac Stress Test',
        facility: null,
        complaintPrefix: null,
        complaintText: null,
        tags: const [
          _AppointmentTag(
            label: 'Referral Handover',
            bg: Color(0xFFEDEEEF),
            textColor: Color(0xFF494552),
            icon: Icons.compare_arrows_rounded,
          ),
        ],
        secondaryActionLabel: 'Review Request',
        secondaryActionColor: const Color(0xFF28006D),
        rawAppointment: MockData.appointments.length > 2
            ? MockData.appointments[2]
            : Appointment(
                id: 'apt-f3',
                patient: MockData.patients[0],
                time: '02:00 PM',
                date: 'Oct 18, 2026',
                type: 'Cardiac Stress Test',
              ),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_OverviewAppointmentItem> get _filteredItems {
    if (_allItems.isEmpty) {
      _initAppointmentData();
    }
    if (_searchQuery.isEmpty) return _allItems;
    return _allItems.where((item) {
      final nameMatches = item.patientName.toLowerCase().contains(_searchQuery);
      final idMatches = item.patientId.toLowerCase().contains(_searchQuery);
      final procMatches = item.timeAndType.toLowerCase().contains(_searchQuery);
      return nameMatches || idMatches || procMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildTopAppBar(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 110),
          child: Container(
            color: const Color(0xFFF8F9FA),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Bar (Figma Node 10:5167)
                _buildHeaderBar(context),
                const SizedBox(height: 16),

                // Status Filter Chips (Figma Node 10:5178)
                _buildStatusFilterChips(),
                const SizedBox(height: 16),

                // Top Context Card (Date Selector & Compact Search) (Figma Node 10:5194)
                _buildTopContextCard(),
                const SizedBox(height: 16),

                // Appointment Cards List (Figma Node 10:5213)
                _buildAppointmentCardsList(),
                const SizedBox(height: 16),

                // Bottom Summary & Sync Banner (Figma Node 10:5337)
                _buildBottomSummaryCard(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.patientDirectory);
              break;
            case 2:
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.doctorProfile);
              break;
          }
        },
      ),
    );
  }

  // --- Top App Bar (Figma Node 10:5354) ---
  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F5),
          border: Border(
            bottom: BorderSide(color: Color(0xFFCBC4D4), width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D000000), // rgba(0,0,0,0.05)
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left: Back button
                Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                  ),
                ),

                // Center: Exact CareID Logo
                Center(
                  child: Image.asset(
                    'assets/images/careid_appbar_clean.png',
                    width: 98,
                    height: 22.05,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text(
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

                // Right: Bell + Doctor Avatar
                Positioned(
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bell Icon Button
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.notificationCenter,
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 22,
                            color: Color(0xFF28006D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Doctor Profile Avatar
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.doctorProfile,
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE1E3E4),
                              width: 2.0,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/doctor_vance_avatar.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFFE8DDFF),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'SV',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF28006D),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Header Bar (Figma Node 10:5167) ---
  Widget _buildHeaderBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Back circle button + Title & Subtitle
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDEEEF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Clinical Appointments',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    letterSpacing: -0.5,
                    color: Color(0xFF191C1D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Triage & Schedule Flow',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.5,
                    color: Color(0xFF006971),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Right: Filter Preferences Button
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Filter preferences'),
                duration: Duration(milliseconds: 1000),
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFEDEEEF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.tune_rounded,
              size: 18,
              color: Color(0xFF191C1D),
            ),
          ),
        ),
      ],
    );
  }

  // --- Status Filter Chips (Figma Node 10:5178) ---
  Widget _buildStatusFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _statusTabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = _statusTabs[index];
          final bool isSelected = _selectedStatusTab == index;

          if (isSelected) {
            return GestureDetector(
              onTap: () => setState(() => _selectedStatusTab = index),
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tab['label'] as String,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                        letterSpacing: 0.1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0x33FFFFFF), // rgba(255,255,255,0.2)
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${tab['count']}',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return GestureDetector(
            onTap: () => setState(() => _selectedStatusTab = index),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEEEF),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tab['label'] as String,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                      letterSpacing: 0.1,
                      color: Color(0xFF494552),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9DADB),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${tab['count']}',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.33,
                        letterSpacing: 0.5,
                        color: Color(0xFF494552),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Top Context Card (Date Selector & Compact Search) (Figma Node 10:5194) ---
  Widget _buildTopContextCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Navigator Row (Figma Node 10:5195)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Day Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentDate = _currentDate.subtract(
                      const Duration(days: 1),
                    );
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F5),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    size: 18,
                    color: Color(0xFF494552),
                  ),
                ),
              ),

              // Calendar Icon & Current Date
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: Color(0xFF006971),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Today • Oct 18, 2026',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ],
              ),

              // Next Day Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentDate = _currentDate.add(const Duration(days: 1));
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F5),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFF494552),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Compact Search Input (Figma Node 10:5208)
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 14),
                const Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: Color(0xFF7A7583),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      color: Color(0xFF191C1D),
                    ),
                    decoration: const InputDecoration(
                      hintText:
                          'Search appointments by patient, ID, or procedure...',
                      hintStyle: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7A7583),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () => _searchController.clear(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.clear_rounded,
                        size: 16,
                        color: Color(0xFF7A7583),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Appointment Cards List (Figma Node 10:5213) ---
  Widget _buildAppointmentCardsList() {
    final items = _filteredItems;

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 36),
        alignment: Alignment.center,
        child: const Text(
          'No matching appointments found',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            color: Color(0xFF7A7583),
          ),
        ),
      );
    }

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(item),
        );
      }).toList(),
    );
  }

  // Individual Appointment Card
  Widget _buildAppointmentCard(_OverviewAppointmentItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Accent Bar (Figma Node 10:5215)
            Container(width: 6, color: item.leftBarColor),

            // Card Body Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Identity & Status Row (Figma Node 10:5216)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEDEEEF),
                          ),
                          child: ClipOval(
                            child: item.avatarAsset != null
                                ? Image.asset(
                                    item.avatarAsset!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildAvatarFallback(
                                              item.patientName,
                                            ),
                                  )
                                : _buildAvatarFallback(item.patientName),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Name, Age Badge & ID
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      item.patientName,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                        color: Color(0xFF191C1D),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEEEF),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Text(
                                      item.patientAge,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 1.33,
                                        letterSpacing: 0.5,
                                        color: Color(0xFF494552),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.patientId,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.33,
                                  letterSpacing: 0.5,
                                  color: Color(0xFF7A7583),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: item.statusBg,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            item.status,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                              letterSpacing: 0.5,
                              color: item.statusTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Time & Facility Info Box (Figma Node 10:5231)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time & Type
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.access_time_rounded,
                                  size: 15,
                                  color: Color(0xFF191C1D),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.timeAndType,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.43,
                                    letterSpacing: 0.1,
                                    color: Color(0xFF191C1D),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Facility (if present)
                          if (item.facility != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.apartment_rounded,
                                  size: 14,
                                  color: Color(0xFF494552),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.facility!,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                      color: Color(0xFF494552),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Chief Complaint / Reason (if present)
                    if (item.complaintText != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.complaintIcon != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                item.complaintIcon!,
                                size: 15,
                                color: const Color(0xFF494552),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  height: 1.25,
                                ),
                                children: [
                                  if (item.complaintPrefix != null)
                                    TextSpan(
                                      text: item.complaintPrefix,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF191C1D),
                                      ),
                                    ),
                                  TextSpan(
                                    text: item.complaintText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF494552),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Tags & Referral (Figma Node 10:5247)
                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: tag.bg,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (tag.hasTealDot) ...[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF006971),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ] else if (tag.icon != null) ...[
                                  Icon(
                                    tag.icon!,
                                    size: 13,
                                    color: tag.textColor,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  tag.label,
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.33,
                                    letterSpacing: 0.5,
                                    color: tag.textColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    // Action Buttons (Figma Node 10:5256)
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Secondary Button (Reschedule / Review Request)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.rescheduleAppointment,
                                arguments: item.rawAppointment,
                              );
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDEEEF),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                item.secondaryActionLabel,
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: item.secondaryActionColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Primary Button (View Details)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.appointmentDetails,
                                arguments: item.rawAppointment,
                              );
                            },
                            child: Container(
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
                              alignment: Alignment.center,
                              child: Text(
                                item.primaryActionLabel,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    final initials = name
        .split(' ')
        .where((e) => e.isNotEmpty)
        .take(2)
        .map((e) => e[0])
        .join();
    return Container(
      color: const Color(0xFFEDEEEF),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF28006D),
        ),
      ),
    );
  }

  // --- Bottom Summary & Sync Banner (Figma Node 10:5337) ---
  Widget _buildBottomSummaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon Container
              Container(
                width: 35,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 18,
                  color: Color(0xFF191C1D),
                ),
              ),
              const SizedBox(width: 10),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Today's Caseload",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '4 scheduled visits • 1 pending triage review',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.33,
                        letterSpacing: 0.5,
                        color: Color(0xFF494552),
                      ),
                    ),
                  ],
                ),
              ),

              // Cyan indicator dot (Figma Node 10:5348)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF76F1FF),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sync with Hospital EHR Button (Figma Node 10:5349)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hospital EHR synced successfully'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xFF28006D),
                ),
              );
            },
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                ),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.sync_rounded, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Sync with Hospital EHR',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                      letterSpacing: 0.1,
                      color: Colors.white,
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
}

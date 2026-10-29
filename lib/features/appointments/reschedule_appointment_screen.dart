import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:5393
/// "Care ID Doctor - Reschedule Appointment"
class RescheduleAppointmentScreen extends StatefulWidget {
  final Appointment? appointmentArg;

  const RescheduleAppointmentScreen({super.key, this.appointmentArg});

  @override
  State<RescheduleAppointmentScreen> createState() =>
      _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState
    extends State<RescheduleAppointmentScreen> {
  // Calendar selection state: default Oct 21, 2026
  int _selectedDay = 21;
  final int _conflictDay = 18;
  final Set<int> _openDays = {22, 23, 24, 28};

  // Selected time slot: default 10:30 AM
  String _selectedTimeSlot = '10:30 AM';
  final Set<String> _bookedSlots = {'11:15 AM', '03:45 PM'};

  // Selected clinical reason: default Physician Emergency Duty
  String _selectedReason = 'Physician Emergency Duty';
  final List<String> _clinicalReasons = [
    'Physician Emergency Duty',
    'Clinic Equipment Maintenance',
    'Patient Mutual Request',
    'Schedule Rebalance',
  ];

  late final TextEditingController _remarksController;

  @override
  void initState() {
    super.initState();
    _remarksController = TextEditingController(
      text: 'Doctor called into emergency cardiology procedure.',
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  String _formatSelectedDateTitle() {
    if (_selectedDay == 21) return 'Saturday, Oct 21';
    final date = DateTime(2026, 10, _selectedDay);
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final weekdayName = weekdays[date.weekday - 1];
    return '$weekdayName, Oct $_selectedDay';
  }

  String _formatTransitionProposedDate() {
    if (_selectedDay == 21) return 'Sat, Oct 21';
    final date = DateTime(2026, 10, _selectedDay);
    final shortWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final shortName = shortWeekdays[date.weekday - 1];
    return '$shortName, Oct $_selectedDay';
  }

  @override
  Widget build(BuildContext context) {
    final apt =
        widget.appointmentArg ??
        (ModalRoute.of(context)?.settings.arguments as Appointment?) ??
        MockData.appointments[0];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildTopAppBar(context),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2, // Schedule active
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.patientDirectory);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.appointmentsOverview);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.doctorProfile);
              break;
          }
        },
      ),
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
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: 110,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Sub-Header Navigation Row (Node 10:5397)
                _buildSubHeaderRow(context),
                const SizedBox(height: 16),

                // 2. Title & Subtitle Header (Node 10:5410)
                _buildTitleHeader(),
                const SizedBox(height: 16),

                // 3. Current Appointment Context Card with red left accent (Node 10:5416)
                _buildCurrentAppointmentCard(apt),
                const SizedBox(height: 20),

                // 4. Interactive Calendar Section (Node 10:5445)
                _buildInteractiveCalendar(),
                const SizedBox(height: 20),

                // 5. Time Slots Panel for Selected Date (Node 10:5571)
                _buildTimeSlotsPanel(),
                const SizedBox(height: 20),

                // 6. Clinical Reason for Reschedule Card (Node 10:5624)
                _buildClinicalReasonCard(),
                const SizedBox(height: 20),

                // 7. Schedule Transition & Confirmation Summary (Node 10:5648)
                _buildTransitionSummary(apt),
                const SizedBox(height: 24),

                // 8. Primary Action Deck (Node 10:5672)
                _buildActionDeck(context, apt),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top App Bar (Figma Node 10:5680) ---
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
              color: Color(0x0D000000),
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
                // Left: Back button (Node 10:5683)
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

                // Center: CareID Logo (Node 10:5687)
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

                // Right: Bell + Doctor Profile Avatar (Node 10:5688)
                Positioned(
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bell Icon Button (Node 10:5689)
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

                      // Doctor Profile Avatar (Node 10:5692)
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
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: const Color(0xFFE8DDFF),
                                    child: const Icon(
                                      Icons.person,
                                      size: 22,
                                      color: Color(0xFF28006D),
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

  // --- Sub-Header Navigation Row (Node 10:5397) ---
  Widget _buildSubHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back to Appointment Details Button (Node 10:5398)
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7E8E9),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 14,
                    color: Color(0xFF191C1D),
                  ),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'Appointment Details',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Conflict Detected Pill Badge (Node 10:5404)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDAD6),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 13,
                color: Color(0xFF93000A),
              ),
              SizedBox(width: 6),
              Text(
                'Conflict Detected',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Color(0xFF93000A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Title & Subtitle Header (Node 10:5410) ---
  Widget _buildTitleHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reschedule Slot',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
            color: Color(0xFF191C1D),
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Resolve physician calendar collision & dispatch re-booking notice',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF494552),
          ),
        ),
      ],
    );
  }

  // --- Current Appointment Context Card (Node 10:5416) ---
  Widget _buildCurrentAppointmentCard(Appointment apt) {
    final patientName = apt.patient.name.isNotEmpty
        ? apt.patient.name
        : 'Robert J. Sterling';
    final careId = apt.patient.careId.isNotEmpty
        ? apt.patient.careId
        : '#HV-94285-M';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
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
            // Left 6px Red Accent Bar (Node 10:5443)
            Container(width: 6, color: const Color(0xFFBA1A1A)),

            // Card Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Header Row (Node 10:5417)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // 48x48 Patient Avatar (Node 10:5419)
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEDEEEF),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/patient_sterling.png',
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.person,
                                        size: 28,
                                        color: Color(0xFF494552),
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Name, Age & ID Column (Node 10:5421)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      patientName,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF191C1D),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE7E8E9),
                                        borderRadius: BorderRadius.circular(
                                          9999,
                                        ),
                                      ),
                                      child: Text(
                                        '${apt.patient.age > 0 ? apt.patient.age : 45}y',
                                        style: const TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                          color: Color(0xFF494552),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  careId.startsWith('#')
                                      ? 'ID: $careId'
                                      : 'ID: #$careId',
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                    color: Color(0xFF006971),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Asterisk Icon (Node 10:5429)
                        const Icon(
                          Icons.emergency_outlined,
                          size: 18,
                          color: Color(0xFFCBC4D4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Colliding Slot Details Box (Node 10:5430)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1: Calendar icon + Current appointment date/time (Node 10:5431)
                          const Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: Color(0xFF191C1D),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Oct 18, 2026 • 10:30 AM',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                  color: Color(0xFF191C1D),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Row 2: Facility location + Collision State badge (Node 10:5436)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_hospital_outlined,
                                      size: 13,
                                      color: Color(0xFF494552),
                                    ),
                                    SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'Mount Sinai Heart Center',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.5,
                                          color: Color(0xFF494552),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Collision State',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  color: Color(0xFFBA1A1A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  // --- Interactive Calendar Section (Node 10:5445) ---
  Widget _buildInteractiveCalendar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: October 2026 + Month Switchers (Node 10:5446)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 18,
                    color: Color(0xFF28006D),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'October 2026',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
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
                      color: Color(0xFF191C1D),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
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
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Day Labels (S, M, T, W, T, F, S) (Node 10:5459)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('S', style: _calendarDayLabelStyle),
              Text('M', style: _calendarDayLabelStyle),
              Text('T', style: _calendarDayLabelStyle),
              Text('W', style: _calendarDayLabelStyle),
              Text('T', style: _calendarDayLabelStyle),
              Text('F', style: _calendarDayLabelStyle),
              Text('S', style: _calendarDayLabelStyle),
            ],
          ),
          const SizedBox(height: 8),

          // 7x5 Days Grid for October 2026 (Starts Thursday Oct 1)
          // Week 1: Sep 27, 28, 29, 30, Oct 1, 2, 3
          _buildCalendarWeekRow([
            _CalendarDay(day: 27, isPrevMonth: true),
            _CalendarDay(day: 28, isPrevMonth: true),
            _CalendarDay(day: 29, isPrevMonth: true),
            _CalendarDay(day: 30, isPrevMonth: true),
            _CalendarDay(day: 1),
            _CalendarDay(day: 2),
            _CalendarDay(day: 3),
          ]),
          const SizedBox(height: 8),

          // Week 2: Oct 4 - 10
          _buildCalendarWeekRow([
            _CalendarDay(day: 4),
            _CalendarDay(day: 5),
            _CalendarDay(day: 6),
            _CalendarDay(day: 7),
            _CalendarDay(day: 8),
            _CalendarDay(day: 9),
            _CalendarDay(day: 10),
          ]),
          const SizedBox(height: 8),

          // Week 3: Oct 11 - 17
          _buildCalendarWeekRow([
            _CalendarDay(day: 11),
            _CalendarDay(day: 12),
            _CalendarDay(day: 13),
            _CalendarDay(day: 14),
            _CalendarDay(day: 15),
            _CalendarDay(day: 16),
            _CalendarDay(day: 17),
          ]),
          const SizedBox(height: 8),

          // Week 4: Oct 18 (Conflict), 19, 20, 21 (Selected), 22, 23, 24
          _buildCalendarWeekRow([
            _CalendarDay(day: 18),
            _CalendarDay(day: 19),
            _CalendarDay(day: 20),
            _CalendarDay(day: 21),
            _CalendarDay(day: 22),
            _CalendarDay(day: 23),
            _CalendarDay(day: 24),
          ]),
          const SizedBox(height: 8),

          // Week 5: Oct 25 - 31
          _buildCalendarWeekRow([
            _CalendarDay(day: 25),
            _CalendarDay(day: 26),
            _CalendarDay(day: 27),
            _CalendarDay(day: 28),
            _CalendarDay(day: 29),
            _CalendarDay(day: 30),
            _CalendarDay(day: 31),
          ]),
          const SizedBox(height: 14),

          // Calendar Legend (Node 10:5557)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Conflict Slot
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFBA1A1A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Conflict Slot',
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

                // Selected
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF28006D),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Selected',
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

                // Open Slots
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF006971),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Open Slots',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const TextStyle _calendarDayLabelStyle = TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Color(0xFF7A7583),
  );

  Widget _buildCalendarWeekRow(List<_CalendarDay> days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) => _buildDayCell(day)).toList(),
    );
  }

  Widget _buildDayCell(_CalendarDay dayItem) {
    final day = dayItem.day;
    final isPrevMonth = dayItem.isPrevMonth;

    if (isPrevMonth) {
      return SizedBox(
        width: 36,
        height: 38,
        child: Center(
          child: Text(
            '$day',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFFCBC4D4),
            ),
          ),
        ),
      );
    }

    final isConflict = day == _conflictDay;
    final isSelected = day == _selectedDay;
    final hasOpenSlots = _openDays.contains(day);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
        });
      },
      child: SizedBox(
        width: 36,
        height: 38,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Selected Day Circle (Node 10:5526)
            if (isSelected)
              Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: const Color(0xFF28006D),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              )
            // Conflict Day Circle (Oct 18) (Node 10:5518)
            else if (isConflict)
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFDAD6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF93000A),
                  ),
                ),
              )
            // Available / Default Day
            else
              Text(
                '$day',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: hasOpenSlots ? FontWeight.w600 : FontWeight.w400,
                  color: hasOpenSlots
                      ? const Color(0xFF191C1D)
                      : const Color(0xFF7A7583).withValues(alpha: 0.6),
                ),
              ),

            // Indicator Dots
            if (isConflict)
              Positioned(
                bottom: 1,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBA1A1A),
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else if (hasOpenSlots && !isSelected)
              Positioned(
                bottom: 1,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF006971),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Time Slots Panel for Selected Date (Node 10:5571) ---
  Widget _buildTimeSlotsPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Date + Department Hours + Openings Badge (Node 10:5572)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatSelectedDateTitle(),
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Cardiology Department Open Hours',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xFF006971),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF76F1FF),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Text(
                  '4 Openings',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Color(0xFF006D76),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Morning Window Subheader (Node 10:5581)
          const Row(
            children: [
              Icon(
                Icons.wb_twilight_rounded,
                size: 14,
                color: Color(0xFF7A7583),
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'MORNING WINDOW (08:00 AM – 12:00 PM)',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: Color(0xFF7A7583),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Morning Slots Grid (08:30 AM, 09:15 AM, 10:30 AM, 11:15 AM)
          Row(
            children: [
              Expanded(child: _buildTimeSlotButton('08:30 AM')),
              const SizedBox(width: 10),
              Expanded(child: _buildTimeSlotButton('09:15 AM')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTimeSlotButton('10:30 AM')),
              const SizedBox(width: 10),
              Expanded(child: _buildTimeSlotButton('11:15 AM')),
            ],
          ),
          const SizedBox(height: 16),

          // Afternoon Window Subheader (Node 10:5605)
          const Row(
            children: [
              Icon(Icons.wb_sunny_outlined, size: 14, color: Color(0xFF7A7583)),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'AFTERNOON WINDOW (01:00 PM – 04:30 PM)',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: Color(0xFF7A7583),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Afternoon Slots Grid (01:30 PM, 02:45 PM, 03:45 PM)
          Row(
            children: [
              Expanded(child: _buildTimeSlotButton('01:30 PM')),
              const SizedBox(width: 10),
              Expanded(child: _buildTimeSlotButton('02:45 PM')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTimeSlotButton('03:45 PM')),
              const SizedBox(width: 10),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotButton(String slot) {
    final isBooked = _bookedSlots.contains(slot);
    final isSelected = !isBooked && _selectedTimeSlot == slot;

    if (isBooked) {
      // Booked / Conflict Slot (Node 10:5600)
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFE7E8E9).withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block_rounded, size: 13, color: Color(0xFF7A7583)),
            const SizedBox(width: 4),
            Text(
              slot,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                decoration: TextDecoration.lineThrough,
                color: Color(0xFF7A7583),
              ),
            ),
          ],
        ),
      );
    }

    if (isSelected) {
      // Selected Slot (Node 10:5595)
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF28006D),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3328006D),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              slot,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Available Slot (Node 10:5587)
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeSlot = slot;
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F5),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 13,
              color: Color(0xFF191C1D),
            ),
            const SizedBox(width: 6),
            Text(
              slot,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Color(0xFF191C1D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Clinical Reason for Reschedule Card (Node 10:5624) ---
  Widget _buildClinicalReasonCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title + Mandatory label (Node 10:5625)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Clinical Reason for Reschedule',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Mandatory',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: Color(0xFFBA1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Chips Selection Column (Node 10:5630)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _clinicalReasons.map((reason) {
              final isSelected = reason == _selectedReason;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedReason = reason;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF006971)
                          : const Color(0xFFEDEEEF),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: isSelected
                          ? const [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          const Icon(
                            Icons.check,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          reason,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            letterSpacing: 0.5,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF494552),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Physician Clinical Remarks Label (Node 10:5642)
          const Text(
            'Physician Clinical Remarks (Optional)',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Color(0xFF494552),
            ),
          ),
          const SizedBox(height: 6),

          // Remarks TextArea (Node 10:5644)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _remarksController,
              maxLines: 2,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF191C1D),
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Schedule Transition & Confirmation Summary (Node 10:5648) ---
  Widget _buildTransitionSummary(Appointment apt) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Node 10:5650)
          const Text(
            'SCHEDULE TRANSITION SUMMARY',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Color(0xFF006971),
            ),
          ),
          const SizedBox(height: 12),

          // Transition Row: Previous Slot -> Arrow -> New Proposed Slot (Node 10:5651)
          Row(
            children: [
              // Previous Slot Card (Node 10:5652)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Previous Slot',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFFBA1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Wed, Oct 18',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        apt.time.isNotEmpty ? apt.time : '10:30 AM',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Arrow Circle (Node 10:5658)
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE7E8E9),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 15,
                  color: Color(0xFF494552),
                ),
              ),
              const SizedBox(width: 8),

              // New Proposed Slot Card (Node 10:5661)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Proposed Slot',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Color(0xFF006971),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatTransitionProposedDate(),
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                          color: Color(0xFF28006D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedTimeSlot,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF006971),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Notification Dispatch Notice (Node 10:5667)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEEF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: Color(0xFF494552),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Patient will receive automated Care ID re-booking SMS & App Notification for approval.',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF494552),
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

  // --- Primary Action Deck (Node 10:5672) ---
  Widget _buildActionDeck(BuildContext context, Appointment apt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary Button: Confirm Reschedule (Node 10:5673)
        GestureDetector(
          onTap: () {
            final updatedApt = apt.copyWith(
              date: 'Oct $_selectedDay, 2026',
              time: _selectedTimeSlot,
              status: 'rescheduled',
              notes: _remarksController.text.trim(),
            );
            Navigator.pushNamed(
              context,
              AppRoutes.rescheduleSuccess,
              arguments: updatedApt,
            );
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
              ),
              borderRadius: BorderRadius.circular(9999),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Confirm Reschedule',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Secondary Button: Cancel & Keep Current Slot (Node 10:5678)
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEEF),
              borderRadius: BorderRadius.circular(9999),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Cancel & Keep Current Slot',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Color(0xFF494552),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarDay {
  final int day;
  final bool isPrevMonth;

  const _CalendarDay({required this.day, this.isPrevMonth = false});
}

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Exact implementation of Figma Node 10:1346
/// "Patient Summary - Quick Review"
class PatientSummaryScreen extends StatefulWidget {
  final Patient? patientArg;

  const PatientSummaryScreen({super.key, this.patientArg});

  @override
  State<PatientSummaryScreen> createState() => _PatientSummaryScreenState();
}

class _PatientSummaryScreenState extends State<PatientSummaryScreen> {
  static const Patient _defaultEleanorPatient = Patient(
    id: 'p-eleanor-thompson',
    name: 'Eleanor Thompson',
    age: 42,
    gender: 'Female',
    bloodGroup: 'B+',
    careId: '8829-4410-X',
    isCritical: false,
    queueStatus: 'in_progress',
    scheduledTime: '10:30 AM',
    primaryComplaint: 'Hypertension & Type 2 Diabetes Management',
    allergies: ['Penicillin', 'Latex', 'Peanuts'],
    chronicConditions: ['Hypertension', 'Type 2 Diabetes'],
    avatarUrl: 'assets/images/patient_eleanor_summary.png',
  );

  String _getAvatarImage(Patient patient) {
    if (patient.avatarUrl != null && patient.avatarUrl!.isNotEmpty) {
      return patient.avatarUrl!;
    }
    final lower = patient.name.toLowerCase();
    if (lower.contains('eleanor') || lower.contains('thompson')) {
      return 'assets/images/patient_eleanor_summary.png';
    } else if (lower.contains('elena') || lower.contains('rodriguez')) {
      return 'assets/images/patient_elena_rodriguez.png';
    } else if (lower.contains('sarah')) {
      return 'assets/images/patient_sarah_jenkins.png';
    } else if (lower.contains('arthur')) {
      return 'assets/images/patient_arthur.png';
    }
    return 'assets/images/patient_eleanor_summary.png';
  }

  Patient _resolvePatient(BuildContext context) {
    if (widget.patientArg != null) return widget.patientArg!;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Patient) {
      return args;
    } else if (args is String) {
      try {
        return MockData.patients.firstWhere(
          (p) =>
              p.id.toLowerCase() == args.toLowerCase() ||
              p.careId.toLowerCase() == args.toLowerCase() ||
              p.name.toLowerCase() == args.toLowerCase(),
          orElse: () => _defaultEleanorPatient,
        );
      } catch (_) {
        return _defaultEleanorPatient;
      }
    } else if (args is Map) {
      if (args['patient'] is Patient) {
        return args['patient'] as Patient;
      } else if (args['id'] is String) {
        final id = args['id'] as String;
        try {
          return MockData.patients.firstWhere(
            (p) =>
                p.id.toLowerCase() == id.toLowerCase() ||
                p.careId.toLowerCase() == id.toLowerCase(),
            orElse: () => _defaultEleanorPatient,
          );
        } catch (_) {
          return _defaultEleanorPatient;
        }
      }
    }
    return _defaultEleanorPatient;
  }

  @override
  Widget build(BuildContext context) {
    final patient = _resolvePatient(context);

    final allergies = patient.allergies.isNotEmpty
        ? patient.allergies
        : const ['Penicillin', 'Latex', 'Peanuts'];

    return Scaffold(
      // Gradient background matching Figma node 10:1346
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.6, -1.0),
            end: Alignment(0.6, 1.0),
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: Stack(
          children: [
            // Main Content Area
            Positioned.fill(
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Top App Bar (Node 10:1347)
                    _buildTopAppBar(context),

                    // Scrollable Cards List
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 130),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 358),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // 1. Patient Profile Card (Node 10:1359)
                                _buildProfileCard(patient),

                                const SizedBox(height: 16),

                                // 2. Known Allergies Alert Card (Node 10:1377)
                                _buildAllergiesCard(allergies),

                                const SizedBox(height: 16),

                                // 3. Insurance Status Card (Node 10:1390)
                                _buildInsuranceCard(),

                                const SizedBox(height: 16),

                                // 4. Clinical Assignment Card (Node 10:1400)
                                _buildClinicalAssignmentCard(),

                                const SizedBox(height: 16),

                                // 5. Current Medications Card (Node 10:1426)
                                _buildMedicationsCard(),

                                const SizedBox(height: 16),

                                // 6. Recent Vitals Trend Card (Node 10:1448)
                                _buildVitalsCard(),

                                const SizedBox(height: 16),

                                // 7. Action Pad (Nodes 10:1476 & 10:1481)
                                _buildActionPad(context, patient),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Shell (Node 10:1486)
            _buildBottomNavigationShell(context),
          ],
        ),
      ),
    );
  }

  /// Top App Bar matching Figma node 10:1347
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Back button & Title (node 10:1348)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                behavior: HitTestBehavior.opaque,
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 22,
                      color: Color(0xFF28006D),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Patient Summary',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF28006D),
                  height: 1.4,
                ),
              ),
            ],
          ),

          // Right: Notification Bell Button (node 10:1354)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notificationCenter);
            },
            behavior: HitTestBehavior.opaque,
            child: const SizedBox(
              width: 32,
              height: 36,
              child: Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 24,
                  color: Color(0xFF28006D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Patient Profile Image & Primary Meta Card matching Figma node 10:1359
  Widget _buildProfileCard(Patient patient) {
    final bloodText =
        patient.bloodGroup.contains('+') || patient.bloodGroup.contains('-')
        ? '${patient.bloodGroup} Positive'
        : '${patient.bloodGroup}+ Positive';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x05000000), // rgba(0,0,0,0.02)
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar 160x160 with Verified Badge (Nodes 10:1360 - 10:1364)
          Center(
            child: SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE8DDFF),
                        width: 4,
                      ),
                      color: const Color(0xFFEDEEEF),
                      image: DecorationImage(
                        image: AssetImage(_getAvatarImage(patient)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Verified Badge Dot at bottom-right (Node 10:1363)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF28006D),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Heading 2: Patient Name (Node 10:1366)
          Text(
            patient.name,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Patient Care ID (Node 10:1368)
          Text(
            'CR-ID: ${patient.careId}',
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFF494552),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Demographic Pills (Node 10:1370)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              // Age Pill (Node 10:1371)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEEEF),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  '${patient.age} Years',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Color(0xFF191C1D),
                    height: 1.33,
                  ),
                ),
              ),

              // Gender Pill (Node 10:1373)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEEEF),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  patient.gender,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Color(0xFF191C1D),
                    height: 1.33,
                  ),
                ),
              ),

              // Blood Group Pill (Node 10:1375)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF76F1FF),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  bloodText,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF006D76),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Known Allergies Alert Card matching Figma node 10:1377
  Widget _buildAllergiesCard(List<String> allergies) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x33FFDAD6), // rgba(255,218,214,0.2)
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFDAD6), width: 1),
      ),
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Icon + Title (node 10:1378)
          Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: Color(0xFFBA1A1A),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Known Allergies',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFBA1A1A),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Allergy Chips Row (node 10:1383)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allergies.map((allergy) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  allergy,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Colors.white,
                    height: 1.33,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Insurance Status Card matching Figma node 10:1390
  Widget _buildInsuranceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          left: BorderSide(color: Color(0xFF006971), width: 4),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 24, right: 20, top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'INSURANCE STATUS',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.6,
                    color: Color(0xFF494552),
                    height: 1.33,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Premium Global Care',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF191C1D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.shield_outlined, size: 26, color: Color(0xFF006971)),
        ],
      ),
    );
  }

  /// Clinical Assignment Card matching Figma node 10:1400
  Widget _buildClinicalAssignmentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (node 10:1401)
          Row(
            children: const [
              Icon(
                Icons.medical_services_outlined,
                size: 20,
                color: Color(0xFF28006D),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Clinical Assignment',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Primary Physician Item (node 10:1406)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8DDFF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.health_and_safety_rounded,
                    size: 20,
                    color: Color(0xFF28006D),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Primary Physician',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xFF494552),
                        height: 1.33,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Dr. Sarah Jenkins',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Emergency Contact Item (node 10:1415)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF87F3FF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.phone_rounded,
                    size: 18,
                    color: Color(0xFF006971),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xFF494552),
                        height: 1.33,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Mark Thompson (Husband)',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191C1D),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '+1 (555) 092-4412',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Color(0xFF006971),
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Current Medications Card matching Figma node 10:1426
  Widget _buildMedicationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (node 10:1427)
          Row(
            children: const [
              Icon(
                Icons.assignment_outlined,
                size: 20,
                color: Color(0xFF28006D),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Current Medications',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Medication 1: Lisinopril 10mg (node 10:1432)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Lisinopril 10mg',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF191C1D),
                          height: 1.5,
                        ),
                      ),
                      Text(
                        '1x Daily (Morning)',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 20,
                  color: Color(0xFF006971),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Medication 2: Metformin 500mg (node 10:1440)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Metformin 500mg',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF191C1D),
                          height: 1.5,
                        ),
                      ),
                      Text(
                        '2x Daily (Post-meal)',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 20,
                  color: Color(0xFF006971),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Recent Vitals Trend Card matching Figma node 10:1448
  Widget _buildVitalsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (node 10:1449)
          const Text(
            'Recent Vitals Trend',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFF191C1D),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // 2x2 Grid (node 10:1451)
          Row(
            children: [
              // Tile 1: BP (node 10:1452)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14.5),
                  decoration: BoxDecoration(
                    color: const Color(0x4DE8DDFF), // rgba(232, 221, 255, 0.3)
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'BP',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF4F319C),
                          height: 1.33,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '120/80',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C1D),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Stable',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF006971),
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Tile 2: Heart Rate (node 10:1458)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14.5),
                  decoration: BoxDecoration(
                    color: const Color(0x4D87F3FF), // rgba(135, 243, 255, 0.3)
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Heart Rate',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF004F55),
                          height: 1.33,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '72 bpm',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C1D),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Normal',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF006971),
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // Tile 3: SpO2 (node 10:1464)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEEEF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'SpO2',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                          height: 1.33,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '98%',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C1D),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Optimal',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF006971),
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Tile 4: Temp (node 10:1470)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEEEF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Temp',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF494552),
                          height: 1.33,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '98.6°F',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C1D),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Normal',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: Color(0xFF006971),
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Action Pad matching Figma nodes 10:1476 and 10:1481
  Widget _buildActionPad(BuildContext context, Patient patient) {
    return Column(
      children: [
        // Primary Button: "Open Full Profile" (node 10:1477)
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.patientProfile,
              arguments: patient,
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 40,
            width: double.infinity,
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
                Icon(
                  Icons.assignment_ind_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'Open Full Profile',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Secondary Action: "Scan Another QR" (node 10:1482)
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cameraPermission);
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 20,
                  color: Color(0xFF28006D),
                ),
                SizedBox(width: 8),
                Text(
                  'Scan Another QR',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF28006D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Bottom Navigation Shell matching Figma node 10:1486
  Widget _buildBottomNavigationShell(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: Center(
        child: Container(
          width: 351,
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000), // rgba(0,0,0,0.1)
                blurRadius: 25,
                offset: Offset(0, 20),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 8),
                spreadRadius: -6,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  // 1. Home
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
                            size: 18,
                            color: Color(0xFF006D76),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006D76),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Patients (Active cyan pill background)
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF76F1FF),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.people_alt_rounded,
                              size: 16,
                              color: Color(0xFF494552),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Patients',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF494552),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Center Spacer for elevated Scan QR button
                  const SizedBox(width: 56),

                  // 3. Schedule
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.appointmentsOverview,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Schedule',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF494552),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. Profile
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.doctorProfile);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: Color(0xFF494552),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF494552),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Elevated Center Scan QR Button (node 10:1498)
              Positioned(
                top: -16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.cameraPermission);
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5B14B8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF8F9FF),
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000), // rgba(0,0,0,0.25)
                          blurRadius: 25,
                          offset: Offset(0, 12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

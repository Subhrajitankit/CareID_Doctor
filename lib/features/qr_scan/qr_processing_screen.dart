import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/app_bottom_nav.dart';

/// Exact implementation of Figma Node 10:633
/// "Care ID Doctor - QR Processing"
class QrProcessingScreen extends StatefulWidget {
  final Duration processingDuration;
  final bool autoNavigate;
  final Future<dynamic> Function()? onProcess;
  final String? qrData;
  final bool? shouldFail;
  final String? failureTitle;
  final String? failureMessage;

  const QrProcessingScreen({
    super.key,
    this.processingDuration = const Duration(milliseconds: 1600),
    this.autoNavigate = true,
    this.onProcess,
    this.qrData,
    this.shouldFail,
    this.failureTitle,
    this.failureMessage,
  });

  @override
  State<QrProcessingScreen> createState() => _QrProcessingScreenState();
}

class _QrProcessingScreenState extends State<QrProcessingScreen> {
  bool _hasStarted = false;
  bool _hasNavigated = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _waitDuration(Duration duration) {
    final completer = Completer<void>();
    _timer = Timer(duration, () {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    return completer.future;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasStarted && widget.autoNavigate) {
      _hasStarted = true;
      _startProcessing();
    }
  }

  Future<void> _startProcessing() async {
    final args = ModalRoute.of(context)?.settings.arguments;

    // As required by the QR error workflow:
    // When the relevant processing step finishes with an error (or in the default QR Error flow),
    // navigate to the QR Error screen.
    bool shouldFail = widget.shouldFail ?? true;
    String? failureTitle = widget.failureTitle;
    String? failureMessage = widget.failureMessage;
    String? qrData = widget.qrData;
    Future<dynamic> Function()? processFn = widget.onProcess;

    if (args is Map) {
      if (args['isSuccess'] == true || args['shouldFail'] == false) {
        shouldFail = false;
      } else if (args['shouldFail'] == true || args['isError'] == true) {
        shouldFail = true;
      }
      if (args['title'] is String) {
        failureTitle = args['title'] as String;
      }
      if (args['message'] is String) {
        failureMessage = args['message'] as String;
      }
      if (args['qrData'] is String) {
        qrData = args['qrData'] as String;
      }
      if (args['onProcess'] is Future<dynamic> Function()) {
        processFn = args['onProcess'] as Future<dynamic> Function();
      }
    } else if (args is String) {
      qrData = args;
    } else if (args is bool) {
      shouldFail = args;
    }

    if (qrData != null) {
      final trimmed = qrData.trim().toLowerCase();
      if (trimmed.isEmpty ||
          trimmed.contains('invalid') ||
          trimmed.contains('expired') ||
          trimmed.contains('error') ||
          trimmed.contains('fail') ||
          trimmed.contains('reject')) {
        shouldFail = true;
        if (trimmed.contains('expired')) {
          failureTitle ??= 'QR Code Expired';
          failureMessage ??=
              'This code is no longer valid or not\nrecognized by the system.';
        } else if (trimmed.contains('invalid') || trimmed.isEmpty) {
          failureTitle ??= 'Invalid QR Code';
          failureMessage ??=
              'The scanned QR code is malformed or not recognized by CareID.';
        }
      }
    }

    dynamic processResult;
    bool executionFailed = false;
    dynamic executionError;

    if (processFn != null) {
      try {
        final processFuture = processFn();
        final delayFuture = _waitDuration(widget.processingDuration);
        processResult = await processFuture;
        await delayFuture;
        if (processResult == false) {
          executionFailed = true;
        } else {
          shouldFail = false;
        }
      } catch (e) {
        executionFailed = true;
        executionError = e;
      }
    } else {
      await _waitDuration(widget.processingDuration);
    }

    if (!mounted || _hasNavigated) return;

    if (shouldFail || executionFailed) {
      _hasNavigated = true;
      final String errTitle = failureTitle ?? 'QR Code Expired';
      final String errMessage =
          failureMessage ??
          (executionError != null
              ? executionError.toString().replaceFirst('Exception: ', '')
              : 'This code is no longer valid or not\nrecognized by the system.');

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.qrError,
        arguments: {'title': errTitle, 'message': errMessage},
      );
    } else {
      _hasNavigated = true;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.qrVerificationSuccess,
        arguments: processResult,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildTopAppBar(context),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0, // Home tab active as shown in Figma
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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
              Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // 1. Central Loading Animation / Gauge (Node 10:700)
                const SizedBox(height: 12),
                const _QrProgressRing(progress: 0.74),
                const SizedBox(height: 28),

                // 2. Title: Verifying Secure QR (Node 10:668)
                const Text(
                  'Verifying Secure QR',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 3. Checklist Steps Card (Node 10:671)
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 448),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x4DCBC4D4)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 22,
                  ),
                  child: Column(
                    children: [
                      // Item - Step 1: Reading QR (Node 10:673)
                      _buildStepItem(
                        icon: _buildCheckIcon(),
                        title: 'Reading QR',
                        isCompleted: true,
                      ),
                      const SizedBox(height: 16),

                      // Item - Step 2: Verifying Identity (Node 10:679)
                      _buildStepItem(
                        icon: _buildCheckIcon(),
                        title: 'Verifying Identity',
                        isCompleted: true,
                      ),
                      const SizedBox(height: 16),

                      // Item - Step 3: Checking Access Permission (Node 10:685)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                              Color(0xFF006D76),
                                            ),
                                        backgroundColor: const Color(
                                          0x1A006D76,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    'Checking Access\nPermission',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF191C1D),
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // IN PROGRESS Badge (Node 10:691)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF76F1FF),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: const Text(
                              'IN\nPROGRESS',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF006D76),
                                letterSpacing: 0.5,
                                height: 1.15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Item - Step 4: Loading Patient Summary (Node 10:693)
                      _buildStepItem(
                        icon: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFCBC4D4),
                              width: 2,
                            ),
                          ),
                        ),
                        title: 'Loading Patient Summary',
                        isPending: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 4. Context Hint / Encryption Note (Node 10:697)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'This verification uses end-to-end encryption to\nensure patient data remains confidential.',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF494552),
                      height: 1.43,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Color(0x1A006D76), // rgba(0, 109, 118, 0.1)
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.check_rounded,
        size: 15,
        color: Color(0xFF006D76),
      ),
    );
  }

  Widget _buildStepItem({
    required Widget icon,
    required String title,
    bool isCompleted = false,
    bool isPending = false,
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isPending
                  ? const Color(0xFF9E9AA6)
                  : const Color(0xFF191C1D),
            ),
          ),
        ),
      ],
    );
  }

  // --- Top App Bar (Node 10:658) ---
  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8F9FA),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button (Node 10:660)
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 22,
                      color: Color(0xFF191C1D),
                    ),
                  ),
                ),

                // CareID Logo (Node 10:663)
                Image.asset(
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

                // Notification Bell (Node 10:664)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Central Loading Gauge with QR Code Center (Node 10:700)
class _QrProgressRing extends StatelessWidget {
  final double progress;

  const _QrProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(172.8, 172.8),
            painter: _RingPainter(
              progress: progress,
              trackColor: const Color(0xFFE8DDFF),
              activeColor: const Color(0xFF28006D),
              strokeWidth: 10,
            ),
          ),
          const Icon(
            Icons.qr_code_2_rounded,
            size: 42,
            color: Color(0xFF28006D),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color activeColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.activeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Active arc: sweeps ~265° clockwise around the circle
    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = 1.8; // Radians (~103°)
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

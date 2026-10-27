import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routes/app_routes.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _countdownSeconds = 57;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _countdownSeconds = 57;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        if (mounted) {
          setState(() {
            _countdownSeconds--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 4 digits of the security code.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (otp == '0000') {
      Navigator.pushNamed(context, AppRoutes.authError);
    } else {
      Navigator.pushNamed(context, AppRoutes.authSuccess);
    }
  }

  void _resendOtp() {
    if (_countdownSeconds == 0) {
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A new 4-digit verification code has been sent.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTimer = '00:${_countdownSeconds.toString().padLeft(2, '0')}';

    return Scaffold(
      body: Stack(
        children: [
          // 1. Ambient Background with Peach-to-Lavender Gradient (Node 10:141)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.6, -1.0),
                end: Alignment(0.6, 1.0),
                colors: [
                  Color(0xFFFFF7ED), // Warm light peach
                  Color(0xFFF5F3FF), // Soft lavender
                ],
              ),
            ),
          ),

          // 2. Ambient Blurred Circles
          Positioned(
            left: -80,
            top: -80,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8DDFF).withValues(alpha: 0.40),
                ),
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF87F3FF).withValues(alpha: 0.30),
                ),
              ),
            ),
          ),

          // 3. Main Scrollable Content
          SafeArea(
            child: Column(
              children: [
                // Top Header (Node 10:142)
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    border: Border(
                      bottom: BorderSide(color: Color(0x0F000000), width: 1.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Color(0xFF28006D),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: Color(0xFF28006D),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Secure Access',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF28006D),
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Canvas Area (Node 10:147)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 448),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Main Verification Card (Node 10:148)
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000), // 8% opacity
                                    blurRadius: 16,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // CareID Cloud Brand Logo (Node 10:149, 10:150)
                                  SizedBox(
                                    width: 64,
                                    height: 48,
                                    child: Image.asset(
                                      'assets/images/login_careid_logo.png',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.cloud_rounded,
                                              size: 48,
                                              color: Color(0xFFA44CFF),
                                            );
                                          },
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Heading (Node 10:151, 10:153)
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xFFA44CFF),
                                            Color(0xFF5B14B8),
                                          ],
                                        ).createShader(bounds),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Authentication',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            height: 32 / 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Required',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            height: 32 / 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Instruction Subtitle (Node 10:154, 10:156)
                                  Text(
                                    'Enter the 4-digit code sent to your\nregistered device to access clinical\nrecords.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF494552),
                                      height: 20 / 14,
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // 4-Digit OTP Input Boxes (Node 10:157, 10:158)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(4, (index) {
                                      final isFocused =
                                          _focusNodes[index].hasFocus;
                                      return Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          border: Border.all(
                                            color: isFocused
                                                ? const Color(0xFF2563EB)
                                                : const Color(0xFF6B7280),
                                            width: isFocused ? 1.5 : 1.0,
                                          ),
                                          boxShadow: isFocused
                                              ? const [
                                                  BoxShadow(
                                                    color: Color(0x332563EB),
                                                    blurRadius: 4,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Center(
                                          child: TextField(
                                            controller: _controllers[index],
                                            focusNode: _focusNodes[index],
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            autofillHints: null,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            cursorColor:
                                                const Color(0xFF2563EB),
                                            cursorWidth: 1.5,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                1,
                                              ),
                                            ],
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF191C1D),
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedErrorBorder:
                                                  InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              filled: false,
                                              contentPadding: EdgeInsets.zero,
                                              isDense: true,
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty &&
                                                  index < 3) {
                                                _focusNodes[index + 1]
                                                    .requestFocus();
                                              } else if (value.isEmpty &&
                                                  index > 0) {
                                                _focusNodes[index - 1]
                                                    .requestFocus();
                                              }
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                                  ),

                                  const SizedBox(height: 20),

                                  // Timer & Resend Row (Node 10:171, 10:172)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Timer Indicator (Node 10:173)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.schedule_rounded,
                                            size: 14,
                                            color: Color(0xFF494552),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            formattedTimer,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF494552),
                                              letterSpacing: 0.1,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Resend OTP Button (Node 10:178)
                                      GestureDetector(
                                        onTap: _countdownSeconds == 0
                                            ? _resendOtp
                                            : null,
                                        child: Opacity(
                                          opacity: _countdownSeconds == 0
                                              ? 1.0
                                              : 0.5,
                                          child: Text(
                                            'Resend OTP',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF28006D),
                                              letterSpacing: 0.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  // Primary "Verify & Access" Button (Node 10:180, 10:181)
                                  Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFA44CFF),
                                          Color(0xFF5B14B8),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFA44CFF,
                                          ).withValues(alpha: 0.35),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          9999,
                                        ),
                                        onTap: _verifyOtp,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.verified_outlined,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Verify & Access',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                      letterSpacing: 0.1,
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
                            ),

                            const SizedBox(height: 24),

                            // Secure Vault Info Cards (Node 10:185, 10:186)
                            // Bento Card 1: HIPAA Compliant (Node 10:187)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D000000), // 5% opacity
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF87F3FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.health_and_safety_rounded,
                                        color: Color(0xFF001F23),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'HIPAA Compliant',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF191C1D),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'All patient data is encrypted end-to-end and stored securely in compliance with strict healthcare regulations.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF494552),
                                            height: 20 / 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Bento Card 2: Device Registration (Node 10:195)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D000000), // 5% opacity
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF87F3FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.hub_rounded,
                                        color: Color(0xFF001F23),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Device Registration',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF191C1D),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'This session is bound to your currently registered device. Unrecognized attempts will be logged.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF494552),
                                            height: 20 / 14,
                                          ),
                                        ),
                                      ],
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

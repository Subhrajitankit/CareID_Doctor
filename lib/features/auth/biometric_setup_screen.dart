import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routes/app_routes.dart';

class BiometricSetupScreen extends StatelessWidget {
  const BiometricSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Ambient Background with Peach-to-Lavender Gradient (Node 10:203)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.6, -1.0),
                end: Alignment(0.6, 1.0),
                colors: [
                  Color(0xFFFFF7ED), // Warm peach
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

          // 3. Main Screen Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CareID Cloud Brand Emblem (Node 10:232: 168x78 in Figma)
                      SizedBox(
                        width: 160,
                        height: 72,
                        child: Image.asset(
                          'assets/images/login_careid_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.cloud_rounded,
                              size: 56,
                              color: Color(0xFFA44CFF),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Premium Circular Biometric Icon Container (Node 10:213, 10:214: 128x128)
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE8DDFF),
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF28006D,
                              ).withValues(alpha: 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFE8DDFF,
                              ).withValues(alpha: 0.50),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: const [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Icon(
                                        Icons.fingerprint_rounded,
                                        size: 52,
                                        color: Color(0xFF260058),
                                      ),
                                    ),
                                    Positioned(
                                      right: -2,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.shield_rounded,
                                        size: 24,
                                        color: Color(0xFF260058),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Screen Title: "Secure Your Clinical Vault" (Node 10:207, 10:209)
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                        ).createShader(bounds),
                        child: Text(
                          'Secure Your Clinical\nVault',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            height: 40 / 32,
                            letterSpacing: -0.8,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle (Node 10:210, 10:212)
                      Text(
                        'Enable biometrics for instant, secure\naccess to patient records.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF494552),
                          height: 24 / 16,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Action Buttons (Node 10:220)
                      // Primary Button: "Enable Biometrics" (Node 10:221)
                      Container(
                        height: 52,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9999),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFA44CFF,
                              ).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(9999),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.authSuccess,
                              );
                            },
                            child: Center(
                              child: Text(
                                'Enable Biometrics',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Secondary Button: "Maybe Later" (Node 10:224)
                      Container(
                        height: 52,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: const Color(0xFF006971),
                            width: 1.0,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(9999),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.authSuccess,
                              );
                            },
                            child: Center(
                              child: Text(
                                'Maybe Later',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF006971),
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Trust Indicator Footer (Node 10:226, 10:227)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 14,
                            color: Color(0xFF494552),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Enterprise Grade Encryption',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF494552),
                                  letterSpacing: 0.5,
                                  height: 16 / 12,
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
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routes/app_routes.dart';

class VerificationSuccessScreen extends StatelessWidget {
  final String? customTitle;
  final String? customSubtitle;
  final String? nextRoute;

  const VerificationSuccessScreen({
    super.key,
    this.customTitle,
    this.customSubtitle,
    this.nextRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Ambient Background with Peach-to-Lavender Gradient (Node 10:233)
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

          // 2. Ambient Blurred Circles (Node 10:236, 10:237)
          Positioned(
            left: -40,
            top: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF28006D).withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
          Positioned(
            right: -40,
            bottom: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF006971).withValues(alpha: 0.05),
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
                      // CareID Cloud Brand Emblem (Node 10:244)
                      SizedBox(
                        width: 168,
                        height: 78,
                        child: Image.asset(
                          'assets/images/login_careid_logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.cloud_rounded,
                              size: 64,
                              color: Color(0xFFA44CFF),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Heading 1: "Access Verified" (Node 10:240, 10:241)
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                        ).createShader(bounds),
                        child: Text(
                          customTitle ?? 'Access Verified',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            height: 48 / 40,
                            letterSpacing: -1.0,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle (Node 10:242)
                      Text(
                        customSubtitle ??
                            'Welcome, Dr. Vance. Your secure\nclinical workspace is ready.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF494552),
                          height: 24 / 16,
                        ),
                      ),

                      const SizedBox(height: 44),

                      // Action Button: "Continue to Dashboard" (Node 10:245)
                      Container(
                        height: 56,
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
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(9999),
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                nextRoute ?? AppRoutes.dashboard,
                                (route) => false,
                              );
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Continue to Dashboard',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 24 / 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Security Badge (Node 10:251, 10:252, 10:255)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shield_rounded,
                            size: 14,
                            color: Color(0xFF494552),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'END-TO-END ENCRYPTED SESSION',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF494552),
                                  letterSpacing: 0.6,
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

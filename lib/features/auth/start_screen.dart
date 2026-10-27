import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/routes/app_routes.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.85, -0.9),
            end: Alignment(0.85, 0.9),
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
            stops: [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 448),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 15,
                      spreadRadius: -3,
                      offset: Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 6,
                      spreadRadius: -4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Premium Medical Illustration Area (Node 10:75, 10:76)
                    Container(
                      height: 256,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE1E3E4),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final w = constraints.maxWidth;
                            final h = constraints.maxHeight;
                            return Stack(
                              children: [
                                Positioned(
                                  left: -w * 0.2769,
                                  top: 0,
                                  width: w * 1.5537,
                                  height: h,
                                  child: Opacity(
                                    opacity: 0.95,
                                    child: Image.asset(
                                      'assets/images/start_medical_vault.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 2. Typography Section (Node 10:78, 10:79)
                    // Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomPaint(
                          size: const Size(18.67, 24.5),
                          painter: const LockIconPainter(
                            color: Color(0xFF28006D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Verified Doctor Access',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF28006D),
                                letterSpacing: -0.6,
                                height: 32 / 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Subtitle (Node 10:85, 10:86)
                    Text(
                      'Enter your digital vault to manage patients\nand clinical data securely.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF494552),
                        height: 22.75 / 14,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 3. Action Buttons (Node 10:87)
                    // Button 1: Doctor Login (Node 10:88)
                    Container(
                      height: 44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA44CFF), Color(0xFF5B14B8)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 6,
                            spreadRadius: -1,
                            offset: Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 4,
                            spreadRadius: -2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Doctor Login',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Button 2: Register New Account (Node 10:94)
                    Container(
                      height: 44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFF006971),
                          width: 1.0,
                        ),
                        color: Colors.transparent,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          child: Center(
                            child: Text(
                              'Register New Account',
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

                    const SizedBox(height: 24),

                    // 4. Footer Note (Node 10:96, 10:97)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomPaint(
                          size: const Size(9.33, 11.67),
                          painter: const ShieldCheckPainter(
                            color: Color(0xFF7A7583),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Enterprise Grade Encryption',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7A7583),
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
      ),
    );
  }
}

/// Custom vector painter reproducing the exact Figma Lock SVG (Node 10:82)
class LockIconPainter extends CustomPainter {
  final Color color;
  const LockIconPainter({this.color = const Color(0xFF28006D)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final scaleX = size.width / 18.6667;
    final scaleY = size.height / 24.5;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    final path = Path()
      ..moveTo(2.33333, 24.5)
      ..cubicTo(1.69167, 24.5, 1.14236, 24.2715, 0.685417, 23.8146)
      ..cubicTo(0.228472, 23.3576, 0, 22.8083, 0, 22.1667)
      ..lineTo(0, 10.5)
      ..cubicTo(0, 9.85833, 0.228472, 9.30903, 0.685417, 8.85208)
      ..cubicTo(1.14236, 8.39514, 1.69167, 8.16667, 2.33333, 8.16667)
      ..lineTo(3.5, 8.16667)
      ..lineTo(3.5, 5.83333)
      ..cubicTo(3.5, 4.21944, 4.06875, 2.84375, 5.20625, 1.70625)
      ..cubicTo(6.34375, 0.56875, 7.71944, 0, 9.33333, 0)
      ..cubicTo(10.9472, 0, 12.3229, 0.56875, 13.4604, 1.70625)
      ..cubicTo(14.5979, 2.84375, 15.1667, 4.21944, 15.1667, 5.83333)
      ..lineTo(15.1667, 8.16667)
      ..lineTo(16.3333, 8.16667)
      ..cubicTo(16.975, 8.16667, 17.5243, 8.39514, 17.9813, 8.85208)
      ..cubicTo(18.4382, 9.30903, 18.6667, 9.85833, 18.6667, 10.5)
      ..lineTo(18.6667, 22.1667)
      ..cubicTo(18.6667, 22.8083, 18.4382, 23.3576, 17.9813, 23.8146)
      ..cubicTo(17.5243, 24.2715, 16.975, 24.5, 16.3333, 24.5)
      ..close();

    final shackleHole = Path()
      ..moveTo(5.83333, 8.16667)
      ..lineTo(12.8333, 8.16667)
      ..lineTo(12.8333, 5.83333)
      ..cubicTo(12.8333, 4.86111, 12.4931, 4.03472, 11.8125, 3.35417)
      ..cubicTo(11.1319, 2.67361, 10.3056, 2.33333, 9.33333, 2.33333)
      ..cubicTo(8.36111, 2.33333, 7.53472, 2.67361, 6.85417, 3.35417)
      ..cubicTo(6.17361, 4.03472, 5.83333, 4.86111, 5.83333, 5.83333)
      ..close();

    final keyhole = Path()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(9.33333, 16.3333),
          radius: 2.33333,
        ),
      );

    final combined = Path.combine(PathOperation.difference, path, shackleHole);
    final finalPath = Path.combine(PathOperation.difference, combined, keyhole);
    canvas.drawPath(finalPath, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom vector painter reproducing the exact Figma Shield Check SVG (Node 10:99)
class ShieldCheckPainter extends CustomPainter {
  final Color color;
  const ShieldCheckPainter({this.color = const Color(0xFF7A7583)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final scaleX = size.width / 9.33333;
    final scaleY = size.height / 11.6667;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    final outer = Path()
      ..moveTo(4.66667, 11.6667)
      ..cubicTo(3.31528, 11.3264, 2.19965, 10.551, 1.31979, 9.34062)
      ..cubicTo(0.439931, 8.13021, 0, 6.78611, 0, 5.30833)
      ..lineTo(0, 1.75)
      ..lineTo(4.66667, 0)
      ..lineTo(9.33333, 1.75)
      ..lineTo(9.33333, 5.30833)
      ..cubicTo(9.33333, 6.78611, 8.8934, 8.13021, 8.01354, 9.34062)
      ..cubicTo(7.13368, 10.551, 6.01806, 11.3264, 4.66667, 11.6667)
      ..close();

    final inner = Path()
      ..moveTo(4.66667, 10.4417)
      ..cubicTo(5.67778, 10.1208, 6.51389, 9.47917, 7.175, 8.51667)
      ..cubicTo(7.83611, 7.55417, 8.16667, 6.48472, 8.16667, 5.30833)
      ..lineTo(8.16667, 2.55208)
      ..lineTo(4.66667, 1.23958)
      ..lineTo(1.16667, 2.55208)
      ..lineTo(1.16667, 5.30833)
      ..cubicTo(1.16667, 6.48472, 1.49722, 7.55417, 2.15833, 8.51667)
      ..cubicTo(2.81944, 9.47917, 3.65556, 10.1208, 4.66667, 10.4417)
      ..close();

    final checkmark = Path()
      ..moveTo(4.05417, 7.90417)
      ..lineTo(7.35, 4.60833)
      ..lineTo(6.51875, 3.77708)
      ..lineTo(4.05417, 6.24167)
      ..lineTo(2.82917, 5.01667)
      ..lineTo(1.99792, 5.84792)
      ..close();

    final shieldOutline = Path.combine(PathOperation.difference, outer, inner);
    final finalPath = Path.combine(
      PathOperation.union,
      shieldOutline,
      checkmark,
    );
    canvas.drawPath(finalPath, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

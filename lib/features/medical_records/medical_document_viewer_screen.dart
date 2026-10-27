import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class MedicalDocumentViewerScreen extends StatefulWidget {
  final MedicalRecordItem? recordArg;

  const MedicalDocumentViewerScreen({super.key, this.recordArg});

  @override
  State<MedicalDocumentViewerScreen> createState() =>
      _MedicalDocumentViewerScreenState();
}

class _MedicalDocumentViewerScreenState
    extends State<MedicalDocumentViewerScreen> {
  double _zoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    final record =
        widget.recordArg ??
        (ModalRoute.of(context)?.settings.arguments as MedicalRecordItem?) ??
        MockData.records[0];

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          record.title,
          style: AppTypography.cardTitle.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: () => setState(
              () => _zoomLevel = (_zoomLevel + 0.25).clamp(1.0, 3.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: () => setState(
              () => _zoomLevel = (_zoomLevel - 0.25).clamp(1.0, 3.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Document downloaded to secure hospital vault'),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Transform.scale(
              scale: _zoomLevel,
              child: Container(
                margin: const EdgeInsets.all(24),
                width: 360,
                height: 520,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ST. JUDE HEALTH SYSTEM',
                          style: AppTypography.badgeSmall.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                        Text(
                          'CONFIDENTIAL EHR',
                          style: AppTypography.badgeSmall.copyWith(
                            color: AppColors.criticalRed,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16, thickness: 1.5),
                    Text(
                      record.title,
                      style: AppTypography.cardTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patient: Arthur Miller (CID-8821-NY)',
                      style: AppTypography.bodySmall,
                    ),
                    Text(
                      'Date: ${record.date} • Facility: ${record.facility}',
                      style: AppTypography.bodySmall,
                    ),
                    const Divider(height: 24),
                    // Simulated Medical Graph / Waveform / Lab Values
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF86EFAC)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(310, 100),
                            painter: _EcgWaveformPainter(),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 12,
                            child: Text(
                              'Calibration: 25mm/s, 10mm/mV • Lead II rhythm strip',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 9,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Diagnostic Summary & Measurements:',
                      style: AppTypography.cardTitle.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.summary,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Physician: ${record.doctor}',
                          style: AppTypography.bodySmall.copyWith(fontSize: 10),
                        ),
                        Text(
                          'Digital Signature: VERIFIED',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10,
                            color: AppColors.successGreen,
                            fontWeight: FontWeight.bold,
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

class _EcgWaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF15803D)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    double x = 0;
    while (x < size.width) {
      path.lineTo(x + 20, size.height * 0.5);
      path.lineTo(x + 25, size.height * 0.45); // P
      path.lineTo(x + 30, size.height * 0.5);
      path.lineTo(x + 35, size.height * 0.52); // Q
      path.lineTo(x + 40, size.height * 0.15); // R
      path.lineTo(x + 45, size.height * 0.75); // S
      path.lineTo(x + 50, size.height * 0.5);
      path.lineTo(x + 60, size.height * 0.35); // T
      path.lineTo(x + 75, size.height * 0.5);
      x += 75;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

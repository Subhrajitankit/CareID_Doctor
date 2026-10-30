import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

/// Medical Document Viewer Screen
/// Matches Figma Node 10:2244 ("Medical Document Viewer")
class MedicalDocumentViewerScreen extends StatefulWidget {
  final MedicalRecordItem? recordArg;

  const MedicalDocumentViewerScreen({super.key, this.recordArg});

  @override
  State<MedicalDocumentViewerScreen> createState() =>
      _MedicalDocumentViewerScreenState();
}

class _MedicalDocumentViewerScreenState
    extends State<MedicalDocumentViewerScreen> {
  late final TransformationController _transformationController;
  double _zoomLevel = 1.0;
  int _currentPage = 1;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.25).clamp(0.5, 3.0);
      _transformationController.value =
          Matrix4.diagonal3Values(_zoomLevel, _zoomLevel, 1.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.25).clamp(0.5, 3.0);
      _transformationController.value =
          Matrix4.diagonal3Values(_zoomLevel, _zoomLevel, 1.0);
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = 1.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
    }
  }

  MedicalRecordItem _resolveRecord(BuildContext context) {
    if (widget.recordArg != null) return widget.recordArg!;
    final routeArg = ModalRoute.of(context)?.settings.arguments;
    if (routeArg is MedicalRecordItem) return routeArg;
    return MockData.records[0];
  }

  @override
  Widget build(BuildContext context) {
    final record = _resolveRecord(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Figma Node 10:2244 background gradient:
        // linear-gradient(114.39deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.8, -0.6),
            end: Alignment(0.8, 0.6),
            colors: [
              Color(0xFFFFF7ED), // rgb(255, 247, 237)
              Color(0xFFF5F3FF), // rgb(245, 243, 255)
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 1. Header - TopAppBar (Figma Node 10:2245)
              _buildTopAppBar(context),

              // 2. Document Sub-Header / Action Bar (Figma Node 10:2252)
              _buildSubHeader(context, record),

              // 3. Main Viewer Canvas & Floating Controls (Figma Node 10:2272)
              Expanded(child: _buildMainCanvas(context, record)),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. Header - TopAppBar (Figma Node 10:2245)
  // Height: 56px, background: #F8F9FA, px: 24px, py: 8px
  // ==========================================
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
          // Left: Back Button (Figma Node 10:2246)
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Color(0xFF28006D),
              ),
            ),
          ),

          // Center: CareID Logo (Figma Node 10:2249)
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

          // Right: Doctor Profile Avatar (Figma Node 10:2250)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.doctorProfile);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFCBC4D4), width: 1),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/doctor_profile_avatar_appbar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE1E3E4),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF494552),
                      size: 22,
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

  // ==========================================
  // 2. Document Sub-Header / Action Bar (Figma Node 10:2252)
  // Height: ~121px, background: white, px: 24, pt: 12, pb: 13
  // ==========================================
  Widget _buildSubHeader(BuildContext context, MedicalRecordItem record) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 13),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0x33CBC4D4), // rgba(203,196,212,0.2)
            width: 1,
          ),
        ),
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
          // Left: Document Icon Badge + Titles (Figma Node 10:2253)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Deep Purple Document Badge (Figma Node 10:2254)
                Container(
                  width: 32,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F1D8B),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.article_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),

                // Title + Subtitle (Figma Node 10:2257)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Heading 2 (Figma Node 10:2258)
                      Text(
                        record.title,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1D),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Subtitle (Figma Node 10:2260)
                      Text(
                        'Patient: Doe, John\n• Added Today',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF494552),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Right: 3 Action Buttons (Figma Node 10:2262)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Search Button (Figma Node 10:2263)
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Searching in document...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Color(0xFF494552),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // 2. Download Button (Figma Node 10:2266)
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Document downloaded to secure hospital vault',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0x4D006971), // rgba(0,105,113,0.3)
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.file_download_outlined,
                    size: 16,
                    color: Color(0xFF006971),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // 3. Share Button (Figma Node 10:2269)
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Sharing document...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFCBC4D4),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.share_outlined,
                    size: 16,
                    color: Color(0xFF494552),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. Main Viewer Canvas & Floating Controls (Figma Node 10:2272)
  // Background: #D9DADB
  // ==========================================
  Widget _buildMainCanvas(BuildContext context, MedicalRecordItem record) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFD9DADB),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Interactive Pan & Zoom Document Canvas
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 3.5,
              onInteractionUpdate: (_) {
                final currentScale = _transformationController.value
                    .getMaxScaleOnAxis();
                if ((currentScale - _zoomLevel).abs() > 0.05) {
                  setState(() {
                    _zoomLevel = currentScale;
                  });
                }
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: _buildDocumentSheet(record),
                ),
              ),
            ),
          ),

          // Floating Controls Pill Bar (Figma Node 10:2275)
          Positioned(
            bottom: 24 + MediaQuery.of(context).padding.bottom,
            child: _buildFloatingControls(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Document Sheet (Figma Node 10:2273)
  // Background: White, rounded: 8px, shadow: 0px 4px 24px rgba(0,0,0,0.08)
  // ==========================================
  Widget _buildDocumentSheet(MedicalRecordItem record) {
    return Container(
      width: 358,
      height: 195.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // rgba(0,0,0,0.08)
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/medical_doc_lab_report.png',
          width: 358,
          height: 195.08,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildFallbackDocumentCard(record),
        ),
      ),
    );
  }

  // Structured Fallback Lab Report Card
  Widget _buildFallbackDocumentCard(MedicalRecordItem record) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'MEDCOR CLINICAL LABS',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF006971),
                ),
              ),
              Text(
                'LABORATORY REPORT',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191C1D),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Text(
            'Patient: Eliza R. Vance (ID: MCR-891724)',
            style: const TextStyle(fontSize: 11, color: Color(0xFF494552)),
          ),
          Text(
            'Date: 24 OCT 2023 • ${record.title}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF494552)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCBC4D4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'WBC: 6.8  (10^9/L)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                Text(
                  'NORMAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006971),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Floating Controls Pill Bar (Figma Node 10:2275)
  // Background: rgba(248,249,250,0.95), blur: 6px, rounded: 9999px
  // ==========================================
  Widget _buildFloatingControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xF2F8F9FA), // rgba(248,249,250,0.95)
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: const Color(0x33CBC4D4), // rgba(203,196,212,0.2)
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000), // rgba(0,0,0,0.12)
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Group 1: Pagination (Figma Node 10:2276) ---
          // Previous Page Button (Figma Node 10:2277)
          GestureDetector(
            onTap: _currentPage > 1 ? _previousPage : null,
            behavior: HitTestBehavior.opaque,
            child: Opacity(
              opacity: _currentPage > 1 ? 1.0 : 0.3,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 18,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
          ),

          // Vertical Stacked Pagination Indicator (Figma Node 10:2280, 10:2281)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_currentPage',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.1,
                  ),
                ),
                const Text(
                  '/',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7A7583),
                    height: 1.1,
                  ),
                ),
                Text(
                  '$_totalPages',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7A7583),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          // Next Page Button (Figma Node 10:2282)
          GestureDetector(
            onTap: _currentPage < _totalPages ? _nextPage : null,
            behavior: HitTestBehavior.opaque,
            child: Opacity(
              opacity: _currentPage < _totalPages ? 1.0 : 0.3,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF191C1D),
                ),
              ),
            ),
          ),

          // Vertical Divider (Figma Node 10:2285)
          Container(
            height: 24,
            width: 0.89,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: const Color(0x80CBC4D4), // rgba(203,196,212,0.5)
          ),

          // --- Group 2: View Controls (Figma Node 10:2286) ---
          // Zoom Out Button (Figma Node 10:2287)
          GestureDetector(
            onTap: _zoomOut,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: const Icon(
                Icons.remove_rounded,
                size: 18,
                color: Color(0xFF191C1D),
              ),
            ),
          ),

          // Zoom Percentage Text (Figma Node 10:2290, 10:2291)
          SizedBox(
            width: 52,
            child: Text(
              '${(_zoomLevel * 100).toInt()}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF494552),
                letterSpacing: 0.1,
              ),
            ),
          ),

          // Zoom In Button (Figma Node 10:2292)
          GestureDetector(
            onTap: _zoomIn,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: const Icon(
                Icons.add_rounded,
                size: 18,
                color: Color(0xFF191C1D),
              ),
            ),
          ),

          // Vertical Divider (Figma Node 10:2295)
          Container(
            height: 24,
            width: 0.89,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: const Color(0x80CBC4D4), // rgba(203,196,212,0.5)
          ),

          // --- Group 3: Fit / Reset Button (Figma Node 10:2296) ---
          GestureDetector(
            onTap: _resetZoom,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: const Icon(
                Icons.restart_alt_rounded,
                size: 20,
                color: Color(0xFF191C1D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

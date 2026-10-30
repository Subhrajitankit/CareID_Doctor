import 'package:flutter/material.dart';
import '../../data/models/clinical_models.dart';

/// Share Record Modal
/// Matches Figma Node 10:7512 ("Share Record Modal")
class ShareRecordModal extends StatefulWidget {
  final MedicalRecordItem record;

  const ShareRecordModal({super.key, required this.record});

  @override
  State<ShareRecordModal> createState() => _ShareRecordModalState();
}

enum _ShareMethod { secureLink, emailPdf, fax }

class _ShareRecordModalState extends State<ShareRecordModal> {
  _ShareMethod _selectedMethod = _ShareMethod.secureLink;
  late final TextEditingController _recipientController;

  @override
  void initState() {
    super.initState();
    _recipientController = TextEditingController();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    super.dispose();
  }

  String _getMethodLabel(_ShareMethod method) {
    switch (method) {
      case _ShareMethod.secureLink:
        return 'Secure Link';
      case _ShareMethod.emailPdf:
        return 'Email PDF';
      case _ShareMethod.fax:
        return 'Fax to Provider';
    }
  }

  void _onSend() {
    final methodStr = _getMethodLabel(_selectedMethod);
    final recipient = _recipientController.text.trim();
    final target = recipient.isNotEmpty ? recipient : 'authorized provider';

    Navigator.pop(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Document "${widget.record.title}" shared via $methodStr with $target',
          ),
          backgroundColor: const Color(0xFF5B14B8),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.8, -0.6),
          end: Alignment(0.8, 0.6),
          colors: [
            Color(0xFFFFF7ED), // rgb(255, 247, 237)
            Color(0xFFF5F3FF), // rgb(245, 243, 255)
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Drag Handle Bar (Figma Node 10:7513, 10:7514)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),

              // 2. Header (Figma Node 10:7515)
              _buildHeader(context),

              // 3. Body Content (Figma Node 10:7524)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Record Information Card (Figma Node 10:7525)
                    _buildRecordCard(),
                    const SizedBox(height: 24),

                    // "SELECT METHOD" Section (Figma Node 10:7537)
                    _buildSelectMethodSection(),
                    const SizedBox(height: 24),

                    // "RECIPIENT DETAILS" Section (Figma Node 10:7572)
                    _buildRecipientDetailsSection(),
                    const SizedBox(height: 24),

                    // HIPAA Security Notice Banner (Figma Node 10:7582)
                    _buildHipaaBanner(),
                    const SizedBox(height: 24),

                    // "Send Document" Action Button (Figma Node 10:7587)
                    _buildSendButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Header (Figma Node 10:7515)
  // Height: ~65px, Border-Bottom: #F3F4F6
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Back Button + "Share Record" Title (Figma Node 10:7516)
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
              const SizedBox(width: 16),
              const Text(
                'Share Record',
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

          // Right: Print Icon (Figma Node 10:7522)
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Sending document to printer...'),
                    duration: Duration(seconds: 2),
                  ),
                );
            },
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Icons.print_outlined,
              size: 20,
              color: Color(0xFF191C1D),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Record Information Card (Figma Node 10:7525)
  // Background: #F9FAFB, Border: rgba(203,196,212,0.3), Rounded: 12px
  // ==========================================
  Widget _buildRecordCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Document Badge Icon (Figma Node 10:7526)
          Container(
            width: 43,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE1E3E4),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.article_outlined,
              size: 22,
              color: Color(0xFF494552),
            ),
          ),
          const SizedBox(width: 16),

          // Title & Subtitle (Figma Node 10:7529)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.record.title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF191C1D),
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  '2 Pages • PDF • 1.2 MB',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF494552),
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // VERIFIED Badge (Figma Node 10:7535)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF76F1FF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'VERIFIED',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF006D76),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // "SELECT METHOD" Section (Figma Node 10:7537)
  // ==========================================
  Widget _buildSelectMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title (Figma Node 10:7539)
        const Text(
          'SELECT METHOD',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF494552),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),

        // Method 1: Secure Link (Figma Node 10:7541)
        _buildMethodCard(
          method: _ShareMethod.secureLink,
          title: 'Secure Link',
          subtitle: 'Expires in 24 hours',
          icon: Icons.smart_toy_outlined,
        ),
        const SizedBox(height: 8),

        // Method 2: Email PDF (Figma Node 10:7552)
        _buildMethodCard(
          method: _ShareMethod.emailPdf,
          title: 'Email PDF',
          subtitle: 'Direct encrypted attachment',
          icon: Icons.visibility_outlined,
        ),
        const SizedBox(height: 8),

        // Method 3: Fax to Provider (Figma Node 10:7562)
        _buildMethodCard(
          method: _ShareMethod.fax,
          title: 'Fax to Provider',
          subtitle: 'HIPAA compliant fax transmission',
          icon: Icons.description_outlined,
        ),
      ],
    );
  }

  Widget _buildMethodCard({
    required _ShareMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == method;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8F9FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5B14B8)
                : const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Icon + Title + Subtitle
            Expanded(
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? const Color(0xFF5B14B8)
                        : const Color(0xFF494552),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF28006D)
                                : const Color(0xFF191C1D),
                            height: 1.5,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF5B14B8).withValues(alpha: 0.7)
                                : const Color(
                                    0xFF494552,
                                  ).withValues(alpha: 0.7),
                            height: 1.33,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Right: Radio Indicator (Figma Node 10:7550 / 10:7561)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5B14B8)
                      : const Color(0xFFD1D5DB),
                  width: isSelected ? 4 : 2,
                ),
                color: isSelected
                    ? const Color(0xFF5B14B8)
                    : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF5B14B8),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // "RECIPIENT DETAILS" Section (Figma Node 10:7572)
  // ==========================================
  Widget _buildRecipientDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (Figma Node 10:7574)
        const Text(
          'RECIPIENT DETAILS',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF494552),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),

        // Input Container (Figma Node 10:7576)
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0x4DCBC4D4), // rgba(203,196,212,0.3)
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _recipientController,
                  decoration: const InputDecoration(
                    hintText: 'Email or Phone Number',
                    hintStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF191C1D),
                  ),
                ),
              ),
              const Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: Color(0xFF494552),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // HIPAA Security Notice Banner (Figma Node 10:7582)
  // Background: #F9FAFB, Rounded: 8px
  // ==========================================
  Widget _buildHipaaBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 16,
              color: Color(0xFF006971),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'All transfers are end-to-end encrypted and logged in\nyour HIPAA audit trail.',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF006971),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // "Send Document" Action Button (Figma Node 10:7587)
  // Height: 60px, Background: #5B14B8, Rounded: 9999px
  // ==========================================
  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _onSend,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF5B14B8),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x335B14B8), // rgba(91,20,184,0.2)
              blurRadius: 15,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Color(0x335B14B8),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Send Document',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.23,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.qr_code_scanner_rounded, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Filter Records Bottom Sheet
/// Exact Figma Source of Truth: Node 10:7354 ("Filter Records Bottom Sheet")
/// CAREID-AIO-FIGMA: https://www.figma.com/design/9nUU700n9WAPQAXoGT17N6/CAREID-AIO-FIGMA?node-id=10-7354&m=dev
class FilterRecordsBottomSheet extends StatefulWidget {
  final Set<String>? initialTypes;
  final String? initialRange;
  final String? initialFacility;
  final ValueChanged<Map<String, dynamic>>? onApply;

  const FilterRecordsBottomSheet({
    super.key,
    this.initialTypes,
    this.initialRange,
    this.initialFacility,
    this.onApply,
  });

  @override
  State<FilterRecordsBottomSheet> createState() =>
      _FilterRecordsBottomSheetState();
}

class _FilterRecordsBottomSheetState extends State<FilterRecordsBottomSheet> {
  late Set<String> _selectedTypes;
  late String _selectedRange;
  String? _selectedFacility;
  DateTime? _fromDate;
  DateTime? _toDate;
  final TextEditingController _facilitySearchController =
      TextEditingController();

  /// Record type options matching Figma Node 10:7369
  final List<String> _recordTypes = [
    'Lab Report',
    'Imaging',
    'Prescription',
    'Clinical Note',
    'Dental',
    'Vision',
  ];

  /// Date range preset options
  final List<String> _dateRangePresets = [
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'This Year',
    'All Time',
  ];

  /// Available facilities matching Figma Node 10:7422 + app data
  final List<String> _allFacilities = [
    'Metro General Hospital',
    'City Clinic Branch 4',
    'Quest Diagnostics',
    'St. Jude Heart Center',
    'Apex Dental Clinic',
    'VisionCare Specialists',
  ];

  @override
  void initState() {
    super.initState();
    // Default matching Figma node 10:7370 ('Lab Report' selected)
    _selectedTypes = widget.initialTypes != null
        ? Set<String>.from(widget.initialTypes!)
        : {'Lab Report'};
    _selectedRange = widget.initialRange ?? 'Last 3 months';
    _selectedFacility = widget.initialFacility;
    _fromDate = DateTime(2023, 10, 1);
    _toDate = DateTime(2023, 12, 31);
  }

  @override
  void dispose() {
    _facilitySearchController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _selectedTypes.clear();
      _selectedRange = 'All Time';
      _selectedFacility = null;
      _fromDate = null;
      _toDate = null;
      _facilitySearchController.clear();
    });
  }

  void _applyFilters() {
    final filterData = {
      'types': _selectedTypes,
      'range': _selectedRange,
      'facility': _selectedFacility,
      'fromDate': _fromDate,
      'toDate': _toDate,
    };
    widget.onApply?.call(filterData);
    Navigator.pop(context, filterData);
  }

  String _formatDate(DateTime? dt, String fallback) {
    if (dt == null) return fallback;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  List<String> get _filteredFacilities {
    final query = _facilitySearchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _allFacilities;
    }
    return _allFacilities
        .where((f) => f.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      // Figma Node 10:7354 background gradient:
      // linear-gradient(115.41deg, rgb(255, 247, 237) 0%, rgb(245, 243, 255) 50%)
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle (Figma Node 10:7355, 10:7356)
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEEEF),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),

          // Header Row (Figma Node 10:7357)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF8F9FA), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Heading 2: "Filter Records" (Node 10:7358, 10:7359)
                const Text(
                  'Filter Records',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191C1D),
                    height: 1.5,
                  ),
                ),

                // Close Button (Node 10:7360, 10:7361)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Color(0xFF494552),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Filter Sections (Figma Node 10:7365)
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: Record Type (Figma Node 10:7366)
                  _buildSectionHeading('RECORD TYPE'),
                  const SizedBox(height: 16),
                  _buildRecordTypeChips(),

                  const SizedBox(height: 32),

                  // SECTION 2: Date Range (Figma Node 10:7386)
                  _buildSectionHeading('DATE RANGE'),
                  const SizedBox(height: 16),
                  _buildDateRangeSection(),

                  const SizedBox(height: 32),

                  // SECTION 3: Facility (Figma Node 10:7412)
                  _buildSectionHeading('FACILITY'),
                  const SizedBox(height: 16),
                  _buildFacilitySection(),
                ],
              ),
            ),
          ),

          // Fixed Bottom Action Bar (Figma Node 10:7433)
          Container(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 20 + bottomPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFF8F9FA), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Clear All Button (Node 10:7434, 10:7435)
                GestureDetector(
                  onTap: _clearAll,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF494552),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Apply Filters Button (Node 10:7436, 10:7437)
                Expanded(
                  child: GestureDetector(
                    onTap: _applyFilters,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B14B8), // Deep purple
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x4D5B14B8), // rgba(91,20,184,0.3)
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.5,
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

  // ==========================================
  // Section Heading Helper
  // 14px, SemiBold, Uppercase, #006971 (Teal)
  // ==========================================
  Widget _buildSectionHeading(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: Color(0xFF006971),
        height: 1.5,
      ),
    );
  }

  // ==========================================
  // Section 1: Record Type Chips (Figma Node 10:7369)
  // Selected: #006971 with checkmark icon
  // Unselected: White with border rgba(203,196,212,0.4)
  // ==========================================
  Widget _buildRecordTypeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: _recordTypes.map((type) {
        final isSelected = _selectedTypes.contains(type);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedTypes.remove(type);
              } else {
                _selectedTypes.add(type);
              }
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isSelected ? 8 : 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF006971) : Colors.white,
              borderRadius: BorderRadius.circular(9999),
              border: isSelected
                  ? null
                  : Border.all(
                      color: const Color(0x66CBC4D4), // rgba(203,196,212,0.4)
                      width: 1,
                    ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000), // rgba(0,0,0,0.05)
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF494552),
                    height: 1.5,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // Section 2: Date Range (Figma Node 10:7386)
  // Preset selector card + From/To date fields
  // ==========================================
  Widget _buildDateRangeSection() {
    return Column(
      children: [
        // Preset Card (Node 10:7390)
        PopupMenuButton<String>(
          onSelected: (range) {
            setState(() {
              _selectedRange = range;
              final now = DateTime.now();
              if (range == 'Last 30 days') {
                _fromDate = now.subtract(const Duration(days: 30));
                _toDate = now;
              } else if (range == 'Last 3 months') {
                _fromDate = DateTime(now.year, now.month - 3, now.day);
                _toDate = now;
              } else if (range == 'Last 6 months') {
                _fromDate = DateTime(now.year, now.month - 6, now.day);
                _toDate = now;
              } else if (range == 'This Year') {
                _fromDate = DateTime(now.year, 1, 1);
                _toDate = now;
              } else {
                _fromDate = null;
                _toDate = null;
              }
            });
          },
          offset: const Offset(0, 60),
          itemBuilder: (context) {
            return _dateRangePresets.map((preset) {
              return PopupMenuItem<String>(
                value: preset,
                child: Text(
                  preset,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                  ),
                ),
              );
            }).toList();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0x80CBC4D4), // rgba(203,196,212,0.5)
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000), // rgba(0,0,0,0.05)
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF006971),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _selectedRange,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF191C1D),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Color(0xFF494552),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // From / To Date Inputs (Node 10:7399)
        Row(
          children: [
            // From Field (Node 10:7400)
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fromDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _fromDate = picked;
                    });
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 4),
                      child: Text(
                        'From',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(
                            0x4DCBC4D4,
                          ), // rgba(203,196,212,0.3)
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _formatDate(_fromDate, 'Oct 1, 2023'),
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // To Field (Node 10:7406)
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _toDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _toDate = picked;
                    });
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 4),
                      child: Text(
                        'To',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(
                            0x4DCBC4D4,
                          ), // rgba(203,196,212,0.3)
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _formatDate(_toDate, 'Dec 31, 2023'),
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          color: Color(0xFF494552),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // Section 3: Facility (Figma Node 10:7412)
  // Facility Search input + clickable badges
  // ==========================================
  Widget _buildFacilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Facility Search Input (Node 10:7415, 10:7416)
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0x80CBC4D4), // rgba(203,196,212,0.5)
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(
                Icons.search_rounded,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _facilitySearchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    color: Color(0xFF191C1D),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search facilities...',
                    hintStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_facilitySearchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _facilitySearchController.clear();
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.cancel,
                      size: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Facility Badges (Node 10:7422)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _filteredFacilities.map((facility) {
            final isSelected = _selectedFacility == facility;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFacility = null;
                  } else {
                    _selectedFacility = facility;
                  }
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE0F7F9)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF006971)
                        : const Color(0x33CBC4D4), // rgba(203,196,212,0.2)
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.apartment_rounded,
                      size: 14,
                      color: isSelected
                          ? const Color(0xFF006971)
                          : const Color(0xFF494552),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      facility,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF006971)
                            : const Color(0xFF494552),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

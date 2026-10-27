import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../data/mock_data.dart';
import '../../data/models/clinical_models.dart';

class PatientSearchScreen extends StatefulWidget {
  const PatientSearchScreen({super.key});

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Patient> get _searchResults {
    if (_searchQuery.trim().isEmpty) return MockData.patients;
    final q = _searchQuery.toLowerCase();
    return MockData.patients.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.careId.toLowerCase().contains(q) ||
          p.primaryComplaint.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText:
                        'Enter name, CareID (e.g. CID-8821), condition...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primaryPurple,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                  },
                ),
              ),
              Expanded(
                child: _searchResults.isEmpty
                    ? EmptyStateView(
                        icon: Icons.person_search_rounded,
                        title: 'No Patients Found',
                        message:
                            'No patient records matched "$_searchQuery". Verify spelling or scan patient CareID directly.',
                        buttonText: 'Scan QR Code Instead',
                        onButtonPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.cameraPermission,
                          );
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        itemCount: _searchResults.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final patient = _searchResults[index];
                          return AppCard(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.patientProfile,
                                arguments: patient,
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: AppColors.purpleSurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      patient.name
                                          .split(' ')
                                          .map((e) => e[0])
                                          .take(2)
                                          .join(),
                                      style: AppTypography.cardTitle.copyWith(
                                        color: AppColors.primaryPurple,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient.name,
                                        style: AppTypography.cardTitle.copyWith(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        '${patient.careId} • ${patient.primaryComplaint}',
                                        style: AppTypography.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

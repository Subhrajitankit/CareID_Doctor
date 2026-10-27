import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

// Auth & Onboarding
import 'features/auth/splash_screen.dart';
import 'features/auth/start_screen.dart';
import 'features/auth/doctor_login_screen.dart';
import 'features/auth/otp_verification_screen.dart';
import 'features/auth/biometric_setup_screen.dart';
import 'features/auth/verification_success_screen.dart';
import 'features/auth/doctor_auth_error_screen.dart';

// Dashboard
import 'features/dashboard/doctor_dashboard_screen.dart';

// QR Scanning & Verification
import 'features/qr_scan/camera_permission_screen.dart';
import 'features/qr_scan/qr_processing_screen.dart';
import 'features/qr_scan/qr_verification_success_screen.dart';
import 'features/qr_scan/qr_error_screen.dart';
import 'features/qr_scan/scan_history_screen.dart';
import 'features/qr_scan/access_denied_screen.dart';

// Patients
import 'features/patients/patient_directory_screen.dart';
import 'features/patients/patient_summary_screen.dart';
import 'features/patients/patient_search_screen.dart';
import 'features/patients/patient_profile_screen.dart';

// Medical Records & Vault
import 'features/medical_records/medical_records_timeline_screen.dart';
import 'features/medical_records/medical_record_details_screen.dart';
import 'features/medical_records/medical_document_viewer_screen.dart';
import 'features/medical_records/laboratory_results_screen.dart';
import 'features/medical_records/dental_records_screen.dart';
import 'features/medical_records/vision_records_screen.dart';
import 'features/medical_records/pet_records_screen.dart';
import 'features/medical_records/add_addendum_screen.dart';

// OCR & Upload Center
import 'features/ocr_upload/upload_center_screen.dart';
import 'features/ocr_upload/ocr_processing_screen.dart';
import 'features/ocr_upload/ocr_review_screen.dart';
import 'features/ocr_upload/report_upload_success_screen.dart';

// Referrals
import 'features/referrals/referral_dashboard_screen.dart';
import 'features/referrals/create_referral_screen.dart';
import 'features/referrals/referral_details_screen.dart';
import 'features/referrals/referral_success_screen.dart';
import 'features/referrals/incoming_referral_screen.dart';

// Prescriptions
import 'features/prescriptions/prescription_builder_screen.dart';
import 'features/prescriptions/drug_interaction_review_screen.dart';
import 'features/prescriptions/prescription_preview_screen.dart';
import 'features/prescriptions/prescription_history_screen.dart';

// Appointments & Scheduling
import 'features/appointments/appointments_overview_screen.dart';
import 'features/appointments/appointment_details_screen.dart';
import 'features/appointments/reschedule_appointment_screen.dart';
import 'features/appointments/select_new_slot_screen.dart';
import 'features/appointments/review_reschedule_screen.dart';
import 'features/appointments/reschedule_success_screen.dart';
import 'features/appointments/cancel_appointment_screen.dart';
import 'features/appointments/cancellation_confirmation_screen.dart';
import 'features/appointments/appointment_cancelled_screen.dart';

// Notifications & Messages
import 'features/notifications_messages/doctor_notification_center_screen.dart';
import 'features/notifications_messages/patient_messages_screen.dart';

// Profile & Settings
import 'features/profile_settings/doctor_profile_screen.dart';
import 'features/profile_settings/doctor_settings_hub_screen.dart';
import 'features/profile_settings/notification_preferences_screen.dart';
import 'features/profile_settings/support_app_info_screen.dart';
import 'features/profile_settings/security_privacy_screen.dart';
import 'features/profile_settings/professional_credentials_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CareIdDoctorApp());
}

class CareIdDoctorApp extends StatelessWidget {
  const CareIdDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAREiD Doctor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        // Auth & Onboarding
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.start: (context) => const StartScreen(),
        AppRoutes.login: (context) => const DoctorLoginScreen(),
        AppRoutes.otp: (context) => const OtpVerificationScreen(),
        AppRoutes.biometricSetup: (context) => const BiometricSetupScreen(),
        AppRoutes.authSuccess: (context) => const VerificationSuccessScreen(),
        AppRoutes.authError: (context) => const DoctorAuthErrorScreen(),

        // Dashboard
        AppRoutes.dashboard: (context) => const DoctorDashboardScreen(),

        // QR Code Scanning & Access Verification
        AppRoutes.cameraPermission: (context) => const CameraPermissionScreen(),
        AppRoutes.qrProcessing: (context) => const QrProcessingScreen(),
        AppRoutes.qrVerificationSuccess: (context) =>
            const QrVerificationSuccessScreen(),
        AppRoutes.qrError: (context) => const QrErrorScreen(),
        AppRoutes.scanHistory: (context) => const ScanHistoryScreen(),
        AppRoutes.accessDenied: (context) => const AccessDeniedScreen(),

        // Patient Management
        AppRoutes.patientDirectory: (context) => const PatientDirectoryScreen(),
        AppRoutes.patientSummary: (context) => const PatientSummaryScreen(),
        AppRoutes.patientSearch: (context) => const PatientSearchScreen(),
        AppRoutes.patientProfile: (context) => const PatientProfileScreen(),

        // Medical Records & Vault
        AppRoutes.medicalRecords: (context) =>
            const MedicalRecordsTimelineScreen(),
        AppRoutes.medicalRecordDetails: (context) =>
            const MedicalRecordDetailsScreen(),
        AppRoutes.documentViewer: (context) =>
            const MedicalDocumentViewerScreen(),
        AppRoutes.labSummary: (context) => const LaboratoryResultsScreen(),
        AppRoutes.dentalRecords: (context) => const DentalRecordsScreen(),
        AppRoutes.visionRecords: (context) => const VisionRecordsScreen(),
        AppRoutes.petRecords: (context) => const PetRecordsScreen(),
        AppRoutes.addAddendum: (context) => const AddAddendumScreen(),

        // OCR & Lab Report Upload
        AppRoutes.uploadCenter: (context) => const UploadCenterScreen(),
        AppRoutes.ocrProcessing: (context) => const OcrProcessingScreen(),
        AppRoutes.ocrReview: (context) => const OcrReviewScreen(),
        AppRoutes.uploadSuccess: (context) => const ReportUploadSuccessScreen(),

        // Clinical Referrals
        AppRoutes.referralDashboard: (context) =>
            const ReferralDashboardScreen(),
        AppRoutes.createReferral: (context) => const CreateReferralScreen(),
        AppRoutes.referralDetails: (context) => const ReferralDetailsScreen(),
        AppRoutes.referralSuccess: (context) => const ReferralSuccessScreen(),
        AppRoutes.incomingReferral: (context) => const IncomingReferralScreen(),

        // Prescription Builder
        AppRoutes.prescriptionBuilder: (context) =>
            const PrescriptionBuilderScreen(),
        AppRoutes.drugInteractionReview: (context) =>
            const DrugInteractionReviewScreen(),
        AppRoutes.prescriptionPreview: (context) =>
            const PrescriptionPreviewScreen(),
        AppRoutes.prescriptionHistory: (context) =>
            const PrescriptionHistoryScreen(),

        // Appointments & Scheduling
        AppRoutes.appointmentsOverview: (context) =>
            const AppointmentsOverviewScreen(),
        AppRoutes.appointmentDetails: (context) =>
            const AppointmentDetailsScreen(),
        AppRoutes.rescheduleAppointment: (context) =>
            const RescheduleAppointmentScreen(),
        AppRoutes.selectNewSlot: (context) => const SelectNewSlotScreen(),
        AppRoutes.reviewReschedule: (context) => const ReviewRescheduleScreen(),
        AppRoutes.rescheduleSuccess: (context) =>
            const RescheduleSuccessScreen(),
        AppRoutes.cancelAppointment: (context) =>
            const CancelAppointmentScreen(),
        AppRoutes.cancellationConfirmation: (context) =>
            const CancellationConfirmationScreen(),
        AppRoutes.appointmentCancelled: (context) =>
            const AppointmentCancelledScreen(),

        // Notifications & Messages
        AppRoutes.notificationCenter: (context) =>
            const DoctorNotificationCenterScreen(),
        AppRoutes.patientMessages: (context) => const PatientMessagesScreen(),

        // Profile & Settings
        AppRoutes.doctorProfile: (context) => const DoctorProfileScreen(),
        AppRoutes.settingsHub: (context) => const DoctorSettingsHubScreen(),
        AppRoutes.notificationPreferences: (context) =>
            const NotificationPreferencesScreen(),
        AppRoutes.supportInfo: (context) => const SupportAppInfoScreen(),
        AppRoutes.securityPrivacy: (context) => const SecurityPrivacyScreen(),
        AppRoutes.professionalCredentials: (context) =>
            const ProfessionalCredentialsScreen(),
      },
    );
  }
}

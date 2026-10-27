class AppRoutes {
  // Auth & Onboarding
  static const String splash = '/';
  static const String start = '/start';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String biometricSetup = '/biometric-setup';
  static const String authSuccess = '/auth-success';
  static const String authError = '/auth-error';

  // Dashboard & Root
  static const String dashboard = '/dashboard';

  // QR Scanning & Verification
  static const String cameraPermission = '/camera-permission';
  static const String qrProcessing = '/qr-processing';
  static const String qrVerificationSuccess = '/qr-verification-success';
  static const String qrError = '/qr-error';
  static const String scanHistory = '/scan-history';
  static const String accessDenied = '/access-denied';

  // Patients
  static const String patientDirectory = '/patients';
  static const String patientSummary = '/patient-summary';
  static const String patientSearch = '/patient-search';
  static const String patientProfile = '/patient-profile';

  // Medical Records & Vault
  static const String medicalRecords = '/medical-records';
  static const String medicalRecordDetails = '/medical-record-details';
  static const String documentViewer = '/document-viewer';
  static const String labSummary = '/lab-summary';
  static const String dentalRecords = '/dental-records';
  static const String visionRecords = '/vision-records';
  static const String petRecords = '/pet-records';
  static const String addAddendum = '/add-addendum';

  // OCR & Upload
  static const String uploadCenter = '/upload-center';
  static const String ocrProcessing = '/ocr-processing';
  static const String ocrReview = '/ocr-review';
  static const String uploadSuccess = '/upload-success';

  // Referrals
  static const String referralDashboard = '/referrals';
  static const String createReferral = '/create-referral';
  static const String referralDetails = '/referral-details';
  static const String referralSuccess = '/referral-success';
  static const String incomingReferral = '/incoming-referral';

  // Prescriptions
  static const String prescriptionBuilder = '/prescription-builder';
  static const String drugInteractionReview = '/drug-interaction-review';
  static const String prescriptionPreview = '/prescription-preview';
  static const String prescriptionHistory = '/prescription-history';

  // Appointments
  static const String appointmentsOverview = '/appointments';
  static const String appointmentDetails = '/appointment-details';
  static const String rescheduleAppointment = '/reschedule-appointment';
  static const String selectNewSlot = '/select-new-slot';
  static const String reviewReschedule = '/review-reschedule';
  static const String rescheduleSuccess = '/reschedule-success';
  static const String cancelAppointment = '/cancel-appointment';
  static const String cancellationConfirmation = '/cancellation-confirmation';
  static const String appointmentCancelled = '/appointment-cancelled';

  // Notifications & Messages
  static const String notificationCenter = '/notifications';
  static const String patientMessages = '/patient-messages';

  // Doctor Profile & Settings
  static const String doctorProfile = '/doctor-profile';
  static const String settingsHub = '/settings-hub';
  static const String notificationPreferences = '/notification-preferences';
  static const String supportInfo = '/support-info';
  static const String securityPrivacy = '/security-privacy';
  static const String professionalCredentials = '/professional-credentials';
}

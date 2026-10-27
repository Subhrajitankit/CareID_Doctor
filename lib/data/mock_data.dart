import 'models/clinical_models.dart';

class MockData {
  static const String doctorName = 'Dr. Vance';
  static const String doctorTitle = 'Chief Cardiologist';
  static const String doctorHospital = 'St. Jude Hospital';
  static const String doctorLicense = 'MED-NY-849204';

  static final List<Patient> patients = [
    const Patient(
      id: 'p1',
      name: 'Arthur Miller',
      age: 64,
      gender: 'Male',
      bloodGroup: 'O+',
      careId: 'CID-8821-NY',
      allergies: ['Penicillin', 'Sulfa Drugs'],
      chronicConditions: ['Hypertension', 'Tachycardia'],
      queueStatus: 'waiting',
      scheduledTime: '09:00 AM',
      primaryComplaint: 'Tachycardia & Chest tightness',
      isCritical: true,
    ),
    const Patient(
      id: 'p2',
      name: 'Sarah Jenkins',
      age: 42,
      gender: 'Female',
      bloodGroup: 'A+',
      careId: 'CID-4920-BOS',
      allergies: ['NSAIDs'],
      chronicConditions: ['Type 2 Diabetes'],
      queueStatus: 'in_progress',
      scheduledTime: '09:45 AM',
      primaryComplaint: 'Routine Diabetic Follow-up',
      isCritical: false,
    ),
    const Patient(
      id: 'p3',
      name: 'Elena Rostova',
      age: 29,
      gender: 'Female',
      bloodGroup: 'B-',
      careId: 'CID-1102-CHI',
      allergies: ['Latex'],
      chronicConditions: ['Asthma'],
      queueStatus: 'waiting',
      scheduledTime: '10:30 AM',
      primaryComplaint: 'Bronchial Spasms & Wheezing',
      isCritical: false,
    ),
    const Patient(
      id: 'p4',
      name: 'Marcus Chen',
      age: 51,
      gender: 'Male',
      bloodGroup: 'AB+',
      careId: 'CID-7741-SF',
      allergies: [],
      chronicConditions: ['Hyperlipidemia'],
      queueStatus: 'done',
      scheduledTime: '08:15 AM',
      primaryComplaint: 'Post-Stent Follow-up',
      isCritical: false,
    ),
  ];

  static final List<Appointment> appointments = [
    Appointment(
      id: 'apt-1',
      patient: patients[0],
      time: '09:00 AM',
      date: 'Today, Oct 26',
      type: 'Urgent Consultation',
      notes: 'Arrhythmia onset past 48 hours.',
    ),
    Appointment(
      id: 'apt-2',
      patient: patients[1],
      time: '09:45 AM',
      date: 'Today, Oct 26',
      type: 'Routine Review',
      notes: 'HbA1c quarterly lab results review.',
    ),
    Appointment(
      id: 'apt-3',
      patient: patients[2],
      time: '10:30 AM',
      date: 'Today, Oct 26',
      type: 'Pulmonology Sync',
      notes: 'Inhaler dose titration needed.',
    ),
    Appointment(
      id: 'apt-4',
      patient: patients[3],
      time: '11:15 AM',
      date: 'Tomorrow, Oct 27',
      type: 'Cardiology Follow-up',
      notes: 'Lipid panel assessment.',
    ),
  ];

  static final List<MedicalRecordItem> records = [
    const MedicalRecordItem(
      id: 'rec-1',
      patientId: 'p1',
      title: '12-Lead Electrocardiogram (ECG)',
      category: 'Cardiology',
      date: 'Oct 24, 2026',
      doctor: 'Dr. Vance',
      facility: 'St. Jude Heart Center',
      summary: 'Sinus tachycardia with ST depression in V4-V6. Rate 118 bpm.',
      flags: ['Abnormal Rate', 'Elevated ST'],
      addendums: ['Echo scheduled for Oct 27.'],
    ),
    const MedicalRecordItem(
      id: 'rec-2',
      patientId: 'p1',
      title: 'Comprehensive Metabolic Panel (CMP)',
      category: 'Lab',
      date: 'Oct 20, 2026',
      doctor: 'Dr. Adams',
      facility: 'Quest Diagnostics',
      summary:
          'Potassium 3.4 mEq/L (Low), Sodium 138 mEq/L, Creatinine 0.9 mg/dL.',
      flags: ['Hypokalemia'],
    ),
    const MedicalRecordItem(
      id: 'rec-3',
      patientId: 'p1',
      title: 'Annual Dental Panoramic X-Ray',
      category: 'Dental',
      date: 'Sep 14, 2026',
      doctor: 'Dr. Clara Wei',
      facility: 'Apex Dental Clinic',
      summary: 'No periodontal pockets. Mild enamel erosion on lower molars.',
    ),
    const MedicalRecordItem(
      id: 'rec-4',
      patientId: 'p1',
      title: 'Ophthalmic Retinal Scan',
      category: 'Vision',
      date: 'Aug 02, 2026',
      doctor: 'Dr. H. Thorne',
      facility: 'VisionCare Specialists',
      summary:
          'Normal macula and optic disc. No hypertensive retinopathy signs.',
    ),
    const MedicalRecordItem(
      id: 'rec-5',
      patientId: 'p1',
      title: 'Pet Companion Health Record - Bella',
      category: 'Pet',
      date: 'Jul 15, 2026',
      doctor: 'Dr. P. Foster DVM',
      facility: 'City Paws Veterinary',
      summary: 'Golden Retriever, 4 yrs. Core rabies & bordetella updated.',
    ),
  ];

  static final List<ReferralItem> referrals = [
    ReferralItem(
      id: 'ref-1',
      patient: patients[0],
      targetDoctor: 'Dr. Stephanie Ross',
      specialty: 'Electrophysiology',
      urgency: 'Critical',
      reason: 'Recurrent SVT unresponsive to Beta Blockers',
      clinicalNotes: 'Requesting EPS and catheter ablation evaluation.',
      date: 'Oct 25, 2026',
      status: 'Pending',
    ),
    ReferralItem(
      id: 'ref-2',
      patient: patients[1],
      targetDoctor: 'Dr. Nathan Patel',
      specialty: 'Endocrinology',
      urgency: 'Routine',
      reason: 'Insulin regimen optimization',
      clinicalNotes: 'Fasting glucose > 180 consistently.',
      date: 'Oct 22, 2026',
      status: 'Accepted',
    ),
  ];

  static final List<PrescriptionItem> prescriptions = [
    PrescriptionItem(
      id: 'rx-101',
      patient: patients[0],
      diagnosis: 'Supraventricular Tachycardia',
      medications: const [
        PrescriptionMedication(
          name: 'Metoprolol Succinate',
          dosage: '50 mg',
          frequency: 'Once Daily (Morning)',
          duration: '30 Days',
          instructions: 'Take with food. Monitor resting heart rate daily.',
        ),
        PrescriptionMedication(
          name: 'Potassium Chloride ER',
          dosage: '20 mEq',
          frequency: 'Once Daily',
          duration: '14 Days',
          instructions: 'Swallow whole with a full glass of water.',
        ),
      ],
      interactionWarnings: const [
        'Potential additive bradycardia when combined with calcium channel blockers.',
      ],
      date: 'Oct 26, 2026',
    ),
  ];

  static final List<ClinicalAlert> alerts = [
    const ClinicalAlert(
      id: 'alt-1',
      title: 'Critical Lab Flag: Arthur Miller',
      message: 'Potassium 3.4 mEq/L reported by Central Lab. Requires review.',
      time: '12 min ago',
      severity: 'critical',
    ),
    const ClinicalAlert(
      id: 'alt-2',
      title: 'Referral Response: Dr. Ross',
      message: 'Accepted transfer request for Electrophysiology consult.',
      time: '1 hr ago',
      severity: 'info',
    ),
    const ClinicalAlert(
      id: 'alt-3',
      title: 'Appointment Rescheduled: Sarah Jenkins',
      message: 'Slot changed from 09:15 AM to 09:45 AM by clinic reception.',
      time: '2 hrs ago',
      severity: 'warning',
    ),
  ];
}

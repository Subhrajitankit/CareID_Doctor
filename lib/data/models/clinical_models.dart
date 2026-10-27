class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String bloodGroup;
  final String careId;
  final List<String> allergies;
  final List<String> chronicConditions;
  final String? avatarUrl;
  final String queueStatus; // waiting, in_progress, done
  final String scheduledTime;
  final String primaryComplaint;
  final bool isCritical;

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.careId,
    this.allergies = const [],
    this.chronicConditions = const [],
    this.avatarUrl,
    this.queueStatus = 'waiting',
    this.scheduledTime = '09:00 AM',
    this.primaryComplaint = '',
    this.isCritical = false,
  });
}

class Appointment {
  final String id;
  final Patient patient;
  final String time;
  final String date;
  final String type; // Consultation, Follow-up, Emergency, Lab Review
  final String status; // scheduled, completed, cancelled, rescheduled
  final String notes;

  const Appointment({
    required this.id,
    required this.patient,
    required this.time,
    required this.date,
    required this.type,
    this.status = 'scheduled',
    this.notes = '',
  });

  Appointment copyWith({
    String? id,
    Patient? patient,
    String? time,
    String? date,
    String? type,
    String? status,
    String? notes,
  }) {
    return Appointment(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      time: time ?? this.time,
      date: date ?? this.date,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

class MedicalRecordItem {
  final String id;
  final String patientId;
  final String title;
  final String category; // Lab, Dental, Vision, Pet, General, Cardiology
  final String date;
  final String doctor;
  final String facility;
  final String summary;
  final List<String> flags;
  final List<String> addendums;
  final bool hasDocument;

  const MedicalRecordItem({
    required this.id,
    required this.patientId,
    required this.title,
    required this.category,
    required this.date,
    required this.doctor,
    required this.facility,
    required this.summary,
    this.flags = const [],
    this.addendums = const [],
    this.hasDocument = true,
  });
}

class ReferralItem {
  final String id;
  final Patient patient;
  final String targetDoctor;
  final String specialty;
  final String urgency; // Critical, Urgent, Routine
  final String reason;
  final String clinicalNotes;
  final String date;
  final String status; // Pending, Accepted, Completed

  const ReferralItem({
    required this.id,
    required this.patient,
    required this.targetDoctor,
    required this.specialty,
    required this.urgency,
    required this.reason,
    required this.clinicalNotes,
    required this.date,
    this.status = 'Pending',
  });
}

class PrescriptionMedication {
  final String name;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;

  const PrescriptionMedication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });
}

class PrescriptionItem {
  final String id;
  final Patient patient;
  final String diagnosis;
  final List<PrescriptionMedication> medications;
  final List<String> interactionWarnings;
  final String date;
  final bool isSigned;

  const PrescriptionItem({
    required this.id,
    required this.patient,
    required this.diagnosis,
    required this.medications,
    this.interactionWarnings = const [],
    required this.date,
    this.isSigned = true,
  });
}

class ClinicalAlert {
  final String id;
  final String title;
  final String message;
  final String time;
  final String severity; // critical, warning, info
  final bool isRead;

  const ClinicalAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.severity,
    this.isRead = false,
  });
}

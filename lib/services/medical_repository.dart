import '../models/medical_profile_model.dart';
import '../models/prescription_model.dart';
import '../models/voice_note_model.dart';

class MedicalRepository {
  MedicalProfileModel? _stored;

  Future<MedicalProfileModel?> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _stored;
  }

  Future<MedicalProfileModel> saveProfile(MedicalProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (profile.age == null || profile.age! <= 0 || profile.age! > 120) {
      throw Exception('Please enter a valid age.');
    }
    if (profile.gender == null) {
      throw Exception('Please select a gender.');
    }
    _stored = profile;
    return profile;
  }

  Future<PrescriptionModel> savePrescription(PrescriptionModel prescription) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final current = _stored ?? const MedicalProfileModel();
    final updatedList = List<PrescriptionModel>.from(current.prescriptions)
      ..removeWhere((p) => p.id == prescription.id)
      ..insert(0, prescription);
    _stored = current.copyWith(prescriptions: updatedList);
    return prescription;
  }

  Future<void> deletePrescription(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_stored != null) {
      final updatedList = List<PrescriptionModel>.from(_stored!.prescriptions)
        ..removeWhere((p) => p.id == id);
      _stored = _stored!.copyWith(prescriptions: updatedList);
    }
  }

  Future<VoiceNoteModel> saveVoiceNote(VoiceNoteModel note) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final current = _stored ?? const MedicalProfileModel();
    final updatedList = List<VoiceNoteModel>.from(current.voiceNotes)
      ..insert(0, note);
    _stored = current.copyWith(voiceNotes: updatedList);
    return note;
  }
}


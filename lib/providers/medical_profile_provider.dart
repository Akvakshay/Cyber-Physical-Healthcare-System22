import 'package:flutter/foundation.dart';

import '../models/medical_profile_model.dart';
import '../models/prescription_model.dart';
import '../models/voice_note_model.dart';
import '../services/medical_repository.dart';
import 'view_state.dart';

class MedicalProfileProvider extends ChangeNotifier {
  MedicalProfileProvider({MedicalRepository? repository})
      : _repository = repository ?? MedicalRepository();

  final MedicalRepository _repository;

  ViewState<MedicalProfileModel> _state = const ViewState.initial();
  ViewState<MedicalProfileModel> get state => _state;

  MedicalProfileModel get draft => _state.data ?? const MedicalProfileModel();

  List<PrescriptionModel> get prescriptions => draft.prescriptions;
  List<VoiceNoteModel> get voiceNotes => draft.voiceNotes;

  Future<void> loadProfile() async {
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final profile = await _repository.fetchProfile();
      _state = profile == null
          ? const ViewState.empty()
          : ViewState.success(profile);
    } catch (e) {
      _state = ViewState.error(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  void updateDraft(MedicalProfileModel Function(MedicalProfileModel) update) {
    final updated = update(draft);
    _state = ViewState.success(updated);
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    final current = draft;
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final saved = await _repository.saveProfile(current);
      _state = ViewState.success(saved);
      notifyListeners();
      return true;
    } catch (e) {
      _state = ViewState.error(e.toString().replaceFirst('Exception: ', ''));
      notifyListeners();
      return false;
    }
  }

  Future<bool> addPrescription(PrescriptionModel prescription) async {
    try {
      await _repository.savePrescription(prescription);
      final updatedList = List<PrescriptionModel>.from(draft.prescriptions)
        ..removeWhere((p) => p.id == prescription.id)
        ..insert(0, prescription);
      _state = ViewState.success(draft.copyWith(prescriptions: updatedList));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removePrescription(String id) async {
    try {
      await _repository.deletePrescription(id);
      final updatedList = List<PrescriptionModel>.from(draft.prescriptions)
        ..removeWhere((p) => p.id == id);
      _state = ViewState.success(draft.copyWith(prescriptions: updatedList));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addVoiceNote(VoiceNoteModel voiceNote) async {
    try {
      await _repository.saveVoiceNote(voiceNote);
      final updatedList = List<VoiceNoteModel>.from(draft.voiceNotes)
        ..insert(0, voiceNote);
      _state = ViewState.success(draft.copyWith(voiceNotes: updatedList));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}

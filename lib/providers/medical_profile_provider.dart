import 'package:flutter/foundation.dart';

import '../models/medical_profile_model.dart';
import '../services/medical_repository.dart';
import 'view_state.dart';

class MedicalProfileProvider extends ChangeNotifier {
  MedicalProfileProvider({MedicalRepository? repository})
      : _repository = repository ?? MedicalRepository();

  final MedicalRepository _repository;

  ViewState<MedicalProfileModel> _state = const ViewState.initial();
  ViewState<MedicalProfileModel> get state => _state;

  MedicalProfileModel get draft => _state.data ?? const MedicalProfileModel();

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
}

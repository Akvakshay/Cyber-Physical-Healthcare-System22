import '../models/medical_profile_model.dart';

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
}

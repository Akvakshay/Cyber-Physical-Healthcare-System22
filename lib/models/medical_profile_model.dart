enum Gender { male, female, other }

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

class MedicalProfileModel {
  final int? age;
  final double? weightKg;
  final Gender? gender;
  final String knownDiseases;
  final String allergies;
  final String? selectedEmergencyTypeId;

  const MedicalProfileModel({
    this.age,
    this.weightKg,
    this.gender,
    this.knownDiseases = '',
    this.allergies = '',
    this.selectedEmergencyTypeId,
  });

  /// BMI requires height; since the design only captures weight, we derive
  /// a placeholder BMI from weight alone using an assumed average height of
  /// 1.7m so the "BMI (Calculated)" field always has a sensible value.
  double? get bmi {
    if (weightKg == null || weightKg! <= 0) return null;
    const assumedHeightM = 1.7;
    final value = weightKg! / (assumedHeightM * assumedHeightM);
    return double.parse(value.toStringAsFixed(1));
  }

  MedicalProfileModel copyWith({
    int? age,
    double? weightKg,
    Gender? gender,
    String? knownDiseases,
    String? allergies,
    String? selectedEmergencyTypeId,
  }) {
    return MedicalProfileModel(
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      knownDiseases: knownDiseases ?? this.knownDiseases,
      allergies: allergies ?? this.allergies,
      selectedEmergencyTypeId:
          selectedEmergencyTypeId ?? this.selectedEmergencyTypeId,
    );
  }

  factory MedicalProfileModel.fromJson(Map<String, dynamic> json) {
    return MedicalProfileModel(
      age: json['age'] as int?,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      gender: json['gender'] != null
          ? Gender.values.firstWhere((g) => g.name == json['gender'])
          : null,
      knownDiseases: json['knownDiseases'] as String? ?? '',
      allergies: json['allergies'] as String? ?? '',
      selectedEmergencyTypeId: json['selectedEmergencyTypeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'age': age,
        'weightKg': weightKg,
        'gender': gender?.name,
        'knownDiseases': knownDiseases,
        'allergies': allergies,
        'selectedEmergencyTypeId': selectedEmergencyTypeId,
      };
}

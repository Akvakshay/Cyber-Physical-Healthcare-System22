class AmbulanceModel {
  final String driverName;
  final String vehicleNumber;
  final int etaMinutes;
  final List<String> equipment;
  final String driverPhone;
  final String medicalTeamPhone;

  const AmbulanceModel({
    required this.driverName,
    required this.vehicleNumber,
    required this.etaMinutes,
    required this.equipment,
    required this.driverPhone,
    required this.medicalTeamPhone,
  });

  factory AmbulanceModel.fromJson(Map<String, dynamic> json) {
    return AmbulanceModel(
      driverName: json['driverName'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      etaMinutes: json['etaMinutes'] as int,
      equipment: List<String>.from(json['equipment'] as List),
      driverPhone: json['driverPhone'] as String,
      medicalTeamPhone: json['medicalTeamPhone'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'driverName': driverName,
        'vehicleNumber': vehicleNumber,
        'etaMinutes': etaMinutes,
        'equipment': equipment,
        'driverPhone': driverPhone,
        'medicalTeamPhone': medicalTeamPhone,
      };
}

class HospitalModel {
  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final String phone;
  final bool hasEmergencyBeds;

  const HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.phone,
    required this.hasEmergencyBeds,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      phone: json['phone'] as String,
      hasEmergencyBeds: json['hasEmergencyBeds'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'distanceKm': distanceKm,
        'phone': phone,
        'hasEmergencyBeds': hasEmergencyBeds,
      };
}

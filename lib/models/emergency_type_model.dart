import 'package:flutter/material.dart';

class EmergencyTypeModel {
  final String id;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const EmergencyTypeModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

/// Static catalogue mirroring "B. Emergency Type" grid in the design.
class EmergencyTypes {
  EmergencyTypes._();

  static const List<EmergencyTypeModel> all = [
    EmergencyTypeModel(
      id: 'cardiac_arrest',
      label: 'Cardiac Arrest',
      icon: Icons.favorite,
      backgroundColor: Color(0xFFFBDCDC),
      iconColor: Color(0xFFD3273E),
    ),
    EmergencyTypeModel(
      id: 'trauma',
      label: 'Trauma',
      icon: Icons.personal_injury,
      backgroundColor: Color(0xFFD9F0EA),
      iconColor: Color(0xFF1E7C6B),
    ),
    EmergencyTypeModel(
      id: 'stroke',
      label: 'Stroke',
      icon: Icons.psychology_alt,
      backgroundColor: Color(0xFFF4D9EE),
      iconColor: Color(0xFF9C2C8C),
    ),
    EmergencyTypeModel(
      id: 'poisoning',
      label: 'Poisoning',
      icon: Icons.dangerous,
      backgroundColor: Color(0xFFDAF0DC),
      iconColor: Color(0xFF1F7A34),
    ),
    EmergencyTypeModel(
      id: 'accident',
      label: 'Accident',
      icon: Icons.car_crash,
      backgroundColor: Color(0xFFDCE9F7),
      iconColor: Color(0xFF1D5A9C),
    ),
    EmergencyTypeModel(
      id: 'burn',
      label: 'Burn',
      icon: Icons.local_fire_department,
      backgroundColor: Color(0xFFFBE3D3),
      iconColor: Color(0xFFC65A15),
    ),
    EmergencyTypeModel(
      id: 'snake_bite',
      label: 'Snake Bite',
      icon: Icons.pest_control,
      backgroundColor: Color(0xFFF3F0D2),
      iconColor: Color(0xFF8A7A15),
    ),
    EmergencyTypeModel(
      id: 'respiratory',
      label: 'Respiratory',
      icon: Icons.air,
      backgroundColor: Color(0xFFE9E1F7),
      iconColor: Color(0xFF5B3E9C),
    ),
  ];
}

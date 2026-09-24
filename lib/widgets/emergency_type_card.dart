import 'package:flutter/material.dart';

import '../models/emergency_type_model.dart';
import '../theme/app_theme.dart';

class EmergencyTypeCard extends StatelessWidget {
  const EmergencyTypeCard({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final EmergencyTypeModel type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.md),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: type.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(
            color: selected ? type.iconColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(type.icon, color: type.iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                type.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: type.iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

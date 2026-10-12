import 'package:flutter/material.dart';

class MedicalProfileFloatingActions extends StatelessWidget {
  final VoidCallback onAddPrescription;
  final VoidCallback onVoiceRecord;

  const MedicalProfileFloatingActions({
    super.key,
    required this.onAddPrescription,
    required this.onVoiceRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Voice Record Button (Purple Circle)
        Material(
          color: Colors.transparent,
          elevation: 6,
          shadowColor: const Color(0x407C3AED),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onVoiceRecord,
            customBorder: const CircleBorder(),
            child: Ink(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFF7C3AED),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Add Prescription Button (White Circle with Purple +)
        Material(
          color: Colors.transparent,
          elevation: 8,
          shadowColor: const Color(0x28000000),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onAddPrescription,
            customBorder: const CircleBorder(),
            child: Ink(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFF7C3AED),
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

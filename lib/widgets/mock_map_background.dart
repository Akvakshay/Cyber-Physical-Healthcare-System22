import 'package:flutter/material.dart';

/// A lightweight stand-in for a real map SDK (e.g. google_maps_flutter).
/// Draws a simple street grid so location/tracking screens have visual
/// context without requiring API keys or network access.
class MockMapBackground extends StatelessWidget {
  const MockMapBackground({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE3EFE5),
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),
          if (child != null) Positioned.fill(child: child!),
          const Positioned(
            left: 8,
            bottom: 6,
            child: Text(
              'Google',
              style: TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    const step = 46.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

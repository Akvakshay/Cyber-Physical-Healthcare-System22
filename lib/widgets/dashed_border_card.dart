import 'package:flutter/material.dart';

class DashedBorderCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gap;
  final double borderRadius;
  final VoidCallback? onTap;

  const DashedBorderCard({
    super.key,
    required this.child,
    this.color = const Color(0xFF8B5CF6),
    this.strokeWidth = 1.5,
    this.dashLength = 6.0,
    this.gap = 4.0,
    this.borderRadius = 18.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: color,
          strokeWidth: strokeWidth,
          dashLength: dashLength,
          gap: gap,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gap;
  final double borderRadius;

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gap,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = _createDashedPath(path, dashLength, gap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, double dashLength, double gap) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final length = draw ? dashLength : gap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, (distance + length).clamp(0.0, metric.length)),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedRectPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      dashLength != oldDelegate.dashLength ||
      gap != oldDelegate.gap ||
      borderRadius != oldDelegate.borderRadius;
}

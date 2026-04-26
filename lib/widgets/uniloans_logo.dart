import 'package:flutter/material.dart';

/// UniLoans brand logo — U shape + upward arrow + house
class UniLoansLogo extends StatelessWidget {
  final double size;
  final Color? primaryColor;
  final Color? accentColor;

  const UniLoansLogo({
    super.key,
    this.size = 32,
    this.primaryColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? const Color(0xFF0D1E5C);
    final accent  = accentColor  ?? const Color(0xFF1560D4);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter(primary, accent)),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color primary;
  final Color accent;
  const _LogoPainter(this.primary, this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // U stroke
    final pU = Paint()
      ..color = primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.12
      ..strokeCap = StrokeCap.round;

    final uPath = Path()
      ..moveTo(w * 0.15, h * 0.15)
      ..lineTo(w * 0.15, h * 0.62)
      ..quadraticBezierTo(w * 0.15, h * 0.88, w * 0.50, h * 0.88)
      ..quadraticBezierTo(w * 0.85, h * 0.88, w * 0.85, h * 0.62)
      ..lineTo(w * 0.85, h * 0.15);
    canvas.drawPath(uPath, pU);

    // Arrow head (blue)
    final pArrow = Paint()..color = accent..style = PaintingStyle.fill;
    final arrowPath = Path()
      ..moveTo(w * 0.68, h * 0.08)
      ..lineTo(w * 0.85, h * 0.15)
      ..lineTo(w * 0.68, h * 0.28);
    canvas.drawPath(arrowPath, pArrow);

    // House roof
    final pRoof = Paint()
      ..color = primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final roofPath = Path()
      ..moveTo(w * 0.30, h * 0.60)
      ..lineTo(w * 0.50, h * 0.40)
      ..lineTo(w * 0.70, h * 0.60);
    canvas.drawPath(roofPath, pRoof);

    // House door
    canvas.drawRect(
      Rect.fromLTWH(w * 0.42, h * 0.60, w * 0.16, h * 0.16),
      Paint()..color = primary..style = PaintingStyle.fill,
    );

    // Window (white cutout)
    canvas.drawRect(
      Rect.fromLTWH(w * 0.46, h * 0.63, w * 0.06, h * 0.06),
      Paint()..color = Colors.white..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_LogoPainter old) => false;
}

/// White squircle background with logo — used in headers & sidebar
class UniLoansAppIcon extends StatelessWidget {
  final double size;
  const UniLoansAppIcon({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.225),
      ),
      child: Center(
        child: UniLoansLogo(
          size: size * 0.65,
          primaryColor: const Color(0xFF0D1E5C),
          accentColor: const Color(0xFF1560D4),
        ),
      ),
    );
  }
}

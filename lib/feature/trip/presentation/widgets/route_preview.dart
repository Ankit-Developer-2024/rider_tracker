import 'package:flutter/material.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/data/trip/models/location_point_model.dart';


class RoutePreview extends StatelessWidget {
  final List<LocationPointModel> points;
  final double height;

  const RoutePreview({super.key, this.height = 180, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey600,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _RoutePainter(points),
          ),

          if (points.isEmpty)
            const Center(
              child: Text(
                'Route will appear once tracking starts',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final List<LocationPointModel> points;
  _RoutePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final lats = points.map((p) => p.latitude).toList();
    final lngs = points.map((p) => p.longitude).toList();
    final minLat = lats.reduce((a, b) => a < b ? a : b);
    final maxLat = lats.reduce((a, b) => a > b ? a : b);
    final minLng = lngs.reduce((a, b) => a < b ? a : b);
    final maxLng = lngs.reduce((a, b) => a > b ? a : b);

    final latRange = (maxLat - minLat).abs() < 0.0001 ? 0.0001 : (maxLat - minLat);
    final lngRange = (maxLng - minLng).abs() < 0.0001 ? 0.0001 : (maxLng - minLng);

    const padding = 20.0;
    Offset toOffset(LocationPointModel p) {
      final x = padding + ((p.longitude - minLng) / lngRange) * (size.width - padding * 2);
      final y = size.height - padding - ((p.latitude - minLat) / latRange) * (size.height - padding * 2);
      return Offset(x, y);
    }

    final path = Path();
    final first = toOffset(points.first);
    path.moveTo(first.dx, first.dy);
    for (final p in points.skip(1)) {
      final o = toOffset(p);
      path.lineTo(o.dx, o.dy);
    }

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    final startPaint = Paint()..color = AppColors.accentBlue;
    final endPaint = Paint()..color = AppColors.primary;
    canvas.drawCircle(first, 5, startPaint);
    canvas.drawCircle(toOffset(points.last), 6, endPaint);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) =>
      oldDelegate.points.length != points.length;
}

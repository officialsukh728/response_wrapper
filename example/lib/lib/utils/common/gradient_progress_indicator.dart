import 'package:sample/utils/common/app_text.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  /// progress value between or equal to 0 and 1 (0 <= progress <= 1)
  final double progress;
  final Gradient gradient;

  /// default background Colors.transparent
  final Color? backgroundColor;

  /// default stroke is (size of child divided by 10)
  final double? stroke;

  /// default size is size of child
  final double? size;
  final Widget? child;

  const GradientCircularProgressIndicator({
    super.key,
    required this.progress,
    required this.gradient,
    this.backgroundColor,
    this.stroke,
    this.size,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size != null ? Size(size!, size!) : MediaQuery.sizeOf(context),
      painter: _GradientCircularProgressPainter(
          progress: progress,
          gradient: gradient,
          backgroundColor: backgroundColor ?? Colors.transparent,
          stroke: stroke),
      child: SizedBox(
        height: size,
        width: size,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Center(
            child: AppText(
              "${(progress*100).toInt().toString()}%",
              color: Colors.black,
              textAlign: TextAlign.center,
              fontSize: 10.sp,
              fontFamily: 'Jost',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;
  final Color backgroundColor;
  final double? stroke;

  _GradientCircularProgressPainter({
    required this.progress,
    required this.gradient,
    required this.backgroundColor,
    this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const startAngle = -pi / 2;
    const fullSweepAngle = 2 * pi;
    final progressSweepAngle = 2 * pi * progress;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke ?? size.width / 10;

    final gradientPaint = Paint()
      ..shader =
      gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke ?? size.width / 10;

    // Draw the background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + progressSweepAngle,
      fullSweepAngle - progressSweepAngle,
      false,
      backgroundPaint,
    );

    // Draw the gradient arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressSweepAngle,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// GradientCircularProgressIndicator(
//         progress: 0.75, // Specify the progress value between 0 and 1
//         gradient: LinearGradient(
//           colors: [Colors.blue, Colors.green],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         backgroundcolor:AppColors.textLightGreyColor, // Specify the background color
//         child: Center(child:AppText('75%')), // Optional child widget
//       )
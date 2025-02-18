import 'package:flutter/material.dart';
import 'dart:math';

class CircularProgressBar extends StatelessWidget {
  final double percentage;
  final String title;
  final bool inMiddle;

  const CircularProgressBar(
      {super.key,
      required this.percentage,
      required this.title,
      required this.inMiddle});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: percentage),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Column(children: [
          if (!inMiddle) // Show title ABOVE the progress bar if inMiddle is false
            Text(
              title,
            ),
          SizedBox(height: 8),
          CustomPaint(
            painter: ProgressPainter(value / 100),
            child: SizedBox(
              width: 150,
              height: 150,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (inMiddle)
                      Text(
                        title,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    Text(
                      "${value.toInt()}%",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]);
      },
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth = 10;

  ProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    // Background Circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Gradient Progress Arc
    final gradient = SweepGradient(
      startAngle: 3 * pi / 2, // Starts from top
      endAngle: 7 * pi / 2,
      center: Alignment.center, // Completes a full circle
      colors: [
        Colors.red, // End - Red
        Colors.brown, // Mid - Brown
        Colors.green, // Start - Green
      ],
      tileMode: TileMode.repeated,
    );

    final gradientPaint = Paint()
      ..shader =
          gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'dart:ui';

enum CanvasState { pan, draw }

class InfiniteCanvasPage extends StatefulWidget {
  final int i;
  InfiniteCanvasPage(this.i);
  @override
  _InfiniteCanvasPageState createState() => _InfiniteCanvasPageState();
}

class _InfiniteCanvasPageState extends State<InfiniteCanvasPage> {
  List<Offset> points = [];
  CanvasState canvasState = CanvasState.draw;
  Offset offset = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onPanDown: (details) {
          this.setState(() {
            points.add(details.localPosition - offset);
          });
        },
        onPanUpdate: (details) {
          this.setState(() {
            points.add(details.localPosition - offset);
          });
        },
        onPanEnd: (details) {},
        child: SizedBox.expand(
          child: ClipRRect(
            child: CustomPaint(
              painter: CanvasCustomPainter(
                  points: points, offset: offset, i: widget.i),
            ),
          ),
        ),
      ),
    );
  }
}

class CanvasCustomPainter extends CustomPainter {
  List<Offset> points;
  Offset offset;
  int i;

  CanvasCustomPainter(
      {required this.points, required this.offset, required this.i});

  @override
  void paint(Canvas canvas, Size size) {
    //define canvas background color
    Paint background = Paint()..color = Colors.transparent;

    //define canvas size
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    //define the paint properties to be used for drawing
    Paint drawingPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = Colors.orange
      ..strokeWidth = 3;

    //a single line is defined as a series of points followed by a null at the end
    for (int x = 0; x < points.length - 1; x++) {
      //drawing line between the points to form a continuous line
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(
            points[x] + offset, points[x + 1] + offset, drawingPaint);
      }
      //if next point is null, means the line ends here
      else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[x] + offset], drawingPaint);
      }
    }

    if (1 == i) {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CanvasCustomPainter oldDelegate) {
    return true;
  }
}

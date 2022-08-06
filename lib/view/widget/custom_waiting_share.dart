import 'dart:ui';

import 'package:flutter/material.dart';

class CustomWaitingShare extends StatefulWidget {
  CustomWaitingShare({Key? key}) : super(key: key);

  double totalWidth = 50;
  double totalHeight = 50;

  final double borderRaidus = 20;

  @override
  _CustomWaitingShareState createState() => _CustomWaitingShareState();
}

class _CustomWaitingShareState extends State<CustomWaitingShare>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  final _colorList = Colors.primaries;

  int _curIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    _controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _curIndex = (++_curIndex) % _colorList.length;
        });
        _controller?.reset();
        _controller?.forward();
      }
    });
    //    _controller?.repeat(reverse: true);
    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Transform.translate(
          offset: Offset(-widget.totalWidth / 2, -widget.totalHeight / 2),
          child: CustomPaint(
              painter: BorderPainter(
                  width: widget.totalWidth,
                  height: widget.totalHeight,
                  borderRadius: widget.borderRaidus,
                  controller: _controller!,
                  firstBorderColor: _colorList[_curIndex].withOpacity(0.2),
                  secondBorderColor: _colorList[_curIndex])),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          '正在等待分享者的加入，请稍等片刻~~~',
          style: TextStyle(fontSize: 30),
        )
      ]),
    );
  }
}

//自定义的圆角边框画线
class BorderPainter extends CustomPainter {
  final double width;
  final double height;
  final double borderRadius;
  final AnimationController controller;
  Path? borderPath;
  Color firstBorderColor;
  Color secondBorderColor;

//  PathMetrics? pathMetrics;

  PathMetric? pathMetric;

  BorderPainter(
      {required this.width,
      required this.height,
      required this.borderRadius,
      required this.controller,
      required this.firstBorderColor,
      required this.secondBorderColor})
//      这里要注意，CustomPaint的repaint机制可以直接用controller来叫醒绘制
      : super(repaint: controller) {
    final remainWidth = width - 2 * borderRadius;
    final remainHeight = height - 2 * borderRadius;

    borderPath = Path()
//    这里从上方的1/4处开始
      ..relativeMoveTo(width / 2, 0)
      ..relativeLineTo(remainWidth / 2, 0)
      ..arcToPoint(Offset(width, borderRadius),
          radius: Radius.circular(borderRadius))
      ..relativeLineTo(0, remainHeight)
      ..arcToPoint(Offset(width - borderRadius, height),
          radius: Radius.circular(borderRadius))
      ..relativeLineTo(-remainWidth, 0)
      ..arcToPoint(Offset(0, height - borderRadius),
          radius: Radius.circular(borderRadius))
      ..relativeLineTo(0, -remainHeight)
      ..arcToPoint(Offset(borderRadius, 0),
          radius: Radius.circular(borderRadius))
      ..relativeLineTo(remainWidth / 2, 0);

//    取第一段，也就是这里我们的路径
    pathMetric = borderPath?.computeMetrics().first;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path newPath =
        pathMetric!.extractPath(0, pathMetric!.length * controller.value);

////    这里通过打印metrics的小节会发现，flutter把前面的圆角边框都作为了一个小节metric来处理，因此这里不需要for循环了
//    pathMetrics = borderPath.computeMetrics();
//
////    print(pathMetrics?.length);
//
//    for (var item in pathMetrics!) {
//      newPath.addPath(
//          item.extractPath(0, item.length * controller.value), Offset.zero);
//    }
//
////    print(pathMetrics?.length);

//    绘制
//    整个路线的
    canvas.drawPath(
        borderPath!,
        Paint()
          ..color = firstBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0);

//    部分已经完成线段的
    canvas.drawPath(
        newPath,
        Paint()
          ..color = secondBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

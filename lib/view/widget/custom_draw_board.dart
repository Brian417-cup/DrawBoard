import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/model/PathInfo.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:provider/provider.dart';

class CustomDrawBoardKeyWidget extends StatefulWidget {
  final bool isSender;
  final Function(Picture src, int w, int h)? getCurPicDatata;

  CustomDrawBoardKeyWidget(
      {Key? key, required this.isSender, required this.getCurPicDatata})
      : super(key: key);

  @override
  _CustomDrawBoardKeyWidgetState createState() =>
      _CustomDrawBoardKeyWidgetState();
}

class _CustomDrawBoardKeyWidgetState extends State<CustomDrawBoardKeyWidget> {
//  对路径和画笔属性进行暂存，再转交到Provider的数据集合中进行间接管理，图层交由Provider直接管理
  Path? _currentPath;
  Paint? _currentPen;

  CustomPainter? lastPainter;
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _drawBoardFunc(),
    );
  }

  Widget _drawBoardFunc() {
    return Consumer<DrawBoardProvider>(builder: (context, cur, child) {
      return GestureDetector(
          onPanDown: (details) {
//      这里因为用了Provider所以不用setstate了
//      setState(() {
            isFinished = false;

            _currentPath = Path();
            _currentPen = Paint()
              ..style = PaintingStyle.stroke
              ..color = cur.isEraser ? cur.eraserColor : cur.nextPenColor
              ..strokeWidth = cur.nextPenStrokeWidth;

            cur.addToCurrentLayer(_currentPath!, _currentPen!);

            final dx = details.localPosition.dx;
            final dy = details.localPosition.dy;
            _currentPath
              ?..moveTo(dx, dy)
              ..lineTo(dx + 1, dy + 1);
//      });
          },
          onPanUpdate: (details) {
            final dx = details.localPosition.dx;
            final dy = details.localPosition.dy;

            setState(() {
              _currentPath?.lineTo(dx, dy);
            });
          },
          onPanEnd: (details) {
            isFinished = true;
            _currentPath = null;
          },
          child: CustomPaint(
            painter: MyCustomPainter(cur.pathInfoList[cur.curLayerIndex],
                lastFrame: (oldFrame) {},
                targetLayer: cur.curLayerIndex,
                isSender: widget.isSender,
                getCurrentData: widget.isSender
                    ? (pic, w, h) {
                        if (isFinished) {
                          widget.getCurPicDatata!(pic, w, h);
                          isFinished = false;
                        }
                      }
                    : null),
          ));
    });
  }
}

//自定义画板的具体画法
class MyCustomPainter extends CustomPainter {
  final List<PathInfo> _pathList;
  final Function(CustomPainter oldPainter) lastFrame;
  final int targetLayer;
  final bool isSender;

//  如果是观察者，这里还需要有记录器和画布
  PictureRecorder? recorder = null;
  Canvas? outCanvas = null;
  Function(Picture src, int w, int h)? getCurrentData;

  MyCustomPainter(this._pathList,
      {required this.lastFrame,
      required this.targetLayer,
      required this.isSender,
      this.getCurrentData});

  @override
  void paint(Canvas canvas, Size size) {
    if (isSender) {
      recorder = PictureRecorder();
      outCanvas = Canvas(recorder!);

      _pathList.forEach((e) {
        canvas.drawPath(e.data, e.pen);
        outCanvas?.drawPath(e.data, e.pen);
      });

      final recorderData = recorder?.endRecording();
      getCurrentData!(recorderData!, size.width.toInt(), size.height.toInt());
    } else {
      _pathList.forEach((e) {
        canvas.drawPath(e.data, e.pen);
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    lastFrame(oldDelegate);
    return true;
  }
}

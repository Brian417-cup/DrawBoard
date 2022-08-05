import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/model/OperationIdentity.dart';
import 'package:flutterdrawboard/model/PathInfo.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:provider/provider.dart';

class CustomDrawBoardKeyWidget extends StatefulWidget {
//  新版用枚举量代替逻辑变量
//  final bool isSenderOrSaver;
  final OperationIdentity identity;
  final Function(Picture src, int w, int h)? getCurPicDatata;

//  CustomDrawBoardKeyWidget(
//      {Key? key, required this.isSenderOrSaver, required this.getCurPicDatata})
//      : super(key: key);

  CustomDrawBoardKeyWidget(
      {Key? key, required this.identity, required this.getCurPicDatata})
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
  bool isFinished = true;

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
//                isSender: widget.isSenderOrSaver,
                identity: widget.identity,
                backGroundColor: cur.backgroundColor,
                getCurrentData:
//                widget.isSenderOrSaver
                !(widget.identity==OperationIdentity.Watcher)
                    ? (pic, w, h) {
                        if (isFinished) {
                          widget.getCurPicDatata!(pic, w, h);
//                          如果下面这个注释掉，保存能立刻保存
                          if (widget.identity!=OperationIdentity.Saver) {
                            isFinished = false;
                          }
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

//  新版本用枚举量代替逻辑变量
//  final bool isSender;
  final OperationIdentity identity;
  final Color backGroundColor;

//  如果是观察者，这里还需要有记录器和画布
  PictureRecorder? recorder = null;
  Canvas? outCanvas = null;
  Function(Picture src, int w, int h)? getCurrentData;

//  MyCustomPainter(this._pathList,
//      {required this.lastFrame,
//      required this.targetLayer,
//      required this.isSender,
//      this.getCurrentData,
//      required this.backGroundColor});

  MyCustomPainter(this._pathList,
      {required this.lastFrame,
      required this.targetLayer,
      required this.identity,
      this.getCurrentData,
      required this.backGroundColor});

  @override
  void paint(Canvas canvas, Size size) {
//    if (isSender) {
////      开始录制
//      recorder = PictureRecorder();
//      outCanvas = Canvas(recorder!);
////      先设置背景色
//      outCanvas?.drawColor(Colors.white, BlendMode.color);
////      再画路径
//      _pathList.forEach((e) {
//        canvas.drawPath(e.data, e.pen);
//        outCanvas?.drawPath(e.data, e.pen);
//      });
//
//      final recorderData = recorder?.endRecording();
//      getCurrentData!(recorderData!, size.width.toInt(), size.height.toInt());
//    } else {
//      _pathList.forEach((e) {
//        canvas.drawPath(e.data, e.pen);
//      });
//    }

    switch (identity) {
      case OperationIdentity.Sharer:
      case OperationIdentity.Saver:
      case OperationIdentity.None:
      //      开始录制
        recorder = PictureRecorder();
        outCanvas = Canvas(recorder!);
//      先设置背景色
        outCanvas?.drawColor(Colors.white, BlendMode.color);
//      再画路径
        _pathList.forEach((e) {
          canvas.drawPath(e.data, e.pen);
          outCanvas?.drawPath(e.data, e.pen);
        });

        final recorderData = recorder?.endRecording();
        getCurrentData!(recorderData!, size.width.toInt(), size.height.toInt());
        break;
      case OperationIdentity.Watcher:
        _pathList.forEach((e) {
          canvas.drawPath(e.data, e.pen);
        });
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    lastFrame(oldDelegate);
    return true;
  }
}

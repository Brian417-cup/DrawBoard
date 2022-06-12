import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/model/PathInfo.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:provider/provider.dart';

class KeyCustomDrawBoardWidget extends StatefulWidget {
  KeyCustomDrawBoardWidget({Key? key}) : super(key: key);

  @override
  _KeyCustomDrawBoardWidgetState createState() =>
      _KeyCustomDrawBoardWidgetState();
}

class _KeyCustomDrawBoardWidgetState extends State<KeyCustomDrawBoardWidget> {
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
//      _currentPathInfo = PathInfo(_currentPath!, _currentPen!);
//
////        最后汇总的线路数据集全部上交到Provider中
//      drawBoardProvider.pathInfoList.add(_currentPathInfo!);

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
//      _currentPathInfo = null;
//        print('当前这条线绘制完成!!');
          },
          child: CustomPaint(
            painter: MyCustomPainter(cur.pathInfoList,
                lastFrame: (oldFrame) {}, targetLayer: cur.curLayerIndex),
          ));
    });
  }
}

//自定义画板的具体画法
class MyCustomPainter extends CustomPainter {
  final List<PathInfo> _pathList;
  final Function(CustomPainter oldPainter) lastFrame;
  final int targetLayer;

  MyCustomPainter(this._pathList,
      {required this.lastFrame, required this.targetLayer});

  @override
  void paint(Canvas canvas, Size size) {
//    print('当前一共${_pathList.length}条线');
    for (int i = 0; i < _pathList.length; i++) {
      final PathInfo e = _pathList[i];
      if (e.layer == targetLayer) {
        canvas.drawPath(e.data, e.pen);
      }
    }

//    print('绘制完成');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    lastFrame(oldDelegate);
    return true;
  }
}

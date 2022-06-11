import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/model/PathInfo.dart';

class DrawBoardProvider extends ChangeNotifier {
//  画笔核心功能
//画笔颜色
  Color _nextPenColor = Colors.blue;

//  画笔宽度
  double _nextPenStrideWidth = 1.0;

//  所有的数据
  List<PathInfo> _pathInfoList = [];

  Color get nextPenColor => _nextPenColor;

  set nextPenColor(Color dstColor) {
    if (dstColor.value != _nextPenColor.value) {
      print('进行赋值');
      _nextPenColor = dstColor;
    }
  }

  double get nextPenStrideWidth => _nextPenStrideWidth;

  set nextPenStrideWidth(double value) {
    if (value != _nextPenStrideWidth) {
      _nextPenStrideWidth = value;
    }
  }

  //  橡皮擦功能，刚开始默认此功能是关闭的
  Color _eraserColor = Colors.white;
  bool _isEraser = false;

  Color get eraserColor => _eraserColor;

  set eraserColor(Color dstColor) {
    _eraserColor = dstColor;
  }

  bool get isEraser => _isEraser;

  set isEraser(bool value) {
    _isEraser = value;
  }

  eraserConverse() {
    _isEraser = !_isEraser;
    print('打开橡皮擦功能');
    notifyListeners();
  }

//  前进和撤退功能,用下标记录当前的总共要绘画的步数来确定
  List<PathInfo> get pathInfoList => _pathInfoList;

  set pathInfoList(List<PathInfo> value) {
    _pathInfoList = value;
  }

  popLastPathData() {
    if (_pathInfoList.length != 0) {
      _pathInfoList.removeLast();
      notifyListeners();
    }
  }

//    多图层功能
  int curLayer = 0;

//    把新的路线加入到当前图层中
  addToCurrentLayer(Path curPath, Paint curPaint) {
    _pathInfoList.add(PathInfo(curLayer, curPath, curPaint));
  }
}

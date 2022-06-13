import 'package:flutter/material.dart';
import 'package:flutterdrawboard/model/PathInfo.dart';

class DrawBoardProvider extends ChangeNotifier {
//  画笔核心功能
//画笔颜色
  Color _nextPenColor = Colors.blue;

//  画笔宽度
  double _nextPenStrokeWidth = 1.0;

//  所有的数据
//  List<PathInfo> _pathInfoList = [];
  List<List<PathInfo>> _pathInfoList = List.generate(
      1,
      (index) => List.generate(
          1,
          (index) => PathInfo(
              Path(),
              Paint()
                ..strokeWidth = 1.0
                ..color = Colors.blue
                ..style = PaintingStyle.stroke)));

  Color get nextPenColor => _nextPenColor;

  set nextPenColor(Color dstColor) {
    if (dstColor.value != _nextPenColor.value) {
      _nextPenColor = dstColor;
    }
  }

  double get nextPenStrokeWidth => _nextPenStrokeWidth;

  set nextPenStrokeWidth(double value) {
    if (value != _nextPenStrokeWidth) {
      _nextPenStrokeWidth = value;
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

  List<List<PathInfo>> get pathInfoList => _pathInfoList;

  set pathInfoList(List<List<PathInfo>> value) {
    _pathInfoList = value;
  }

//      找到当前图层的最后一条线并执行“后退一步”功能
  popLastPathData() {
    if (_pathInfoList[_curLayerIndex].length != 0) {
      _pathInfoList[_curLayerIndex].removeLast();
      notifyListeners();
    }
  }

//    多图层功能
  int _curLayerIndex = 0;

//  总图层数
  int _layerCnt = 1;

  int get curLayerIndex => _curLayerIndex;

  set curLayerIndex(int value) {
    _curLayerIndex = value;
  }

  int get layerCnt => _layerCnt;

  set layerCnt(int value) {
    _layerCnt = value;
  }

  //    把新的路线加入到当前图层中
  addToCurrentLayer(Path curPath, Paint curPaint) {
    _pathInfoList[_curLayerIndex].add(PathInfo(curPath, curPaint));
    notifyListeners();
  }

  //  判断输入图层下标的准确性
  bool _isLayerInSuitRange(String targetStr) {
    try {
      int targetIndex = int.parse(targetStr);
      if (targetIndex >= 0 && targetIndex < _layerCnt) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  //  新加一个图层并创建新的画笔到末尾
  addOneNewLayer() {
    _pathInfoList.add(List<PathInfo>.generate(
        1,
        (index) => PathInfo(
            Path(),
            Paint()
              ..style = PaintingStyle.stroke
              ..color = Colors.blue
              ..strokeWidth = 1.0)));

    _layerCnt++;

    notifyListeners();
  }

//  删除图层
  bool delTargetLayer(indexStr) {
//    只有一个图层的时候不能删
    if (_layerCnt <= 1) {
      return false;
    }

//    在合理的范围才进行图层的删除
    if (_isLayerInSuitRange(indexStr)) {
      int targetIndex = int.parse(indexStr);
//      如果当前删除的图层恰好是用户控制的图层，需要先调整再执行删除操作
      if (_curLayerIndex == targetIndex) {
        _curLayerIndex = 0;
      }

      _pathInfoList.removeAt(targetIndex);

//      最后总图层数量要保证-1
      _layerCnt--;
      notifyListeners();

      return true;
    }
    return false;
  }

//  交换两个图层
  bool swapTwoLayer(first, second) {
    if (_isLayerInSuitRange(first) && _isLayerInSuitRange(second)) {
      int firstIndex = int.parse(first);
      int secondIndex = int.parse(second);

//      如果两个输入的交换目标相同，则默认不需要交换，直接返回
      if (firstIndex == secondIndex) {
        return true;
      }

      var temp = _pathInfoList[firstIndex];
      _pathInfoList[firstIndex] = _pathInfoList[secondIndex];
      _pathInfoList[secondIndex] = temp;

      notifyListeners();
      return true;
    }
    return false;
  }
}

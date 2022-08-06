import 'dart:io';

import 'package:flutter/material.dart';

class CustomMagnifier extends StatefulWidget {
  CustomMagnifier(
      {Key? key, required this.bottomWidget, required this.magnifySize})
      : super(key: key);

  Widget bottomWidget;
  double magnifySize = 2.0;

  @override
  _CustomMagnifierState createState() => _CustomMagnifierState();
}

class _CustomMagnifierState extends State<CustomMagnifier> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _keyPart(),
    );
  }

  Widget _keyPart() {
    return Stack(
      children: [
        widget.bottomWidget,
        Positioned.fill(
            child: LayoutBuilder(
                builder: (context, constraints) => MagnifierTop(
                      bottomWidget: widget.bottomWidget,
                      bottomWidth: constraints.maxWidth,
                      bottomHeight: constraints.maxHeight,
                      magnifySize: widget.magnifySize,
                    )))
      ],
    );
  }
}

class MagnifierTop extends StatefulWidget {
  final bottomWidget;
  final bottomWidth;
  final bottomHeight;
  final magnifySize;

  MagnifierTop(
      {required this.bottomWidget,
      required this.bottomWidth,
      required this.bottomHeight,
      required this.magnifySize});

  @override
  _MagnifierTopState createState() => _MagnifierTopState();
}

class _MagnifierTopState extends State<MagnifierTop> {
  Offset curPos = Offset.zero;
  final delta = 20.0;

//  final frameWidth = 120.0;
  double frameWidth = 0.0;

//  final frameHeight = 120.0;
  double frameHeight = 0.0;

  @override
  void initState() {
    super.initState();
    frameWidth = widget.bottomWidth * 0.4;
    frameHeight = widget.bottomHeight * 0.4;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      光标的位置
      child: (Platform.isAndroid || Platform.isIOS)
          ? Stack(children: [
              _magnifierRegion(),
              GestureDetector(
                onPanUpdate: (details) {
                  print(details.localPosition);
                  setState(() {
                    curPos = details.localPosition;
                    _correctRange();
                  });
                },
              ),
            ])
          : MouseRegion(
              onHover: (details) {
                setState(() {
                  curPos = details.localPosition;
                  _correctRange();
                });
              },
//        光标位置下的放大区域
              child: _magnifierRegion(),
            ),
    );
  }

//  碰撞检测
  _correctRange() {
//    水平方向
    if (curPos.dx + frameWidth / 2 > widget.bottomWidth) {
      curPos = Offset(widget.bottomWidth - frameWidth / 2, curPos.dy);
    } else if (curPos.dx - frameWidth / 2 < 0) {
      curPos = Offset(frameWidth / 2, curPos.dy);
    }

//    垂直方向
    if (curPos.dy + frameHeight / 2 > widget.bottomHeight) {
      curPos = Offset(curPos.dx, widget.bottomHeight - frameHeight / 2);
    } else if (curPos.dy - frameHeight / 2 < 0) {
      curPos = Offset(curPos.dx, frameHeight / 2);
    }
  }

  Widget _magnifierRegion() {
    final centerPosX = curPos.dx - frameWidth / 2;
    final centerPosY = curPos.dy - frameHeight / 2;

    return Stack(
      alignment: Alignment.topLeft,
      children: [
//        底板遮罩
        _mask(centerPosX, centerPosY),
//        放大后的控件
        _keyPart(centerPosX, centerPosY, frameWidth, frameHeight,
            widget.magnifySize, delta),
      ],
    );
  }

  Widget _mask(double centerPosX, double centerPosY) {
    return Positioned(
//            left: curPos.dx + delta,
//            top: curPos.dy + delta,
        left: centerPosX,
        top: centerPosY,
        child: Container(
          width: frameWidth,
          height: frameHeight,
          color: Colors.white.withOpacity(0.8),
        ));
  }

  Widget _keyPart(double centerPosX, double centerPosY, double frameWidth,
      double frameHeight, double magnifySize, double delta) {
    return Positioned(
      left: centerPosX,
      top: centerPosY,
//      left: curPos.dx + delta,
//      top: curPos.dy + delta,
      child: Container(
        width: frameWidth,
        height: frameHeight,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: ClipRect(
          child: Transform.scale(
              scale: magnifySize,
              child: Transform.translate(
                offset: Offset(widget.bottomWidth / 2 - curPos.dx,
                    widget.bottomHeight / 2 - curPos.dy),
//                打破上级约束
                child: OverflowBox(
                  minWidth: widget.bottomWidth,
                  maxWidth: widget.bottomWidth,
                  minHeight: widget.bottomHeight,
                  maxHeight: widget.bottomHeight,
                  child: widget.bottomWidget,
                ),
              )),
        ),
      ),
    );
  }

  Widget _transformWidget() {
    return Container(
      alignment: Alignment.topLeft,
//      transform: Matrix4.translationValues(curPos.dx, curPos.dy, 0.0),
      child: widget.bottomWidget,
    );
  }
}

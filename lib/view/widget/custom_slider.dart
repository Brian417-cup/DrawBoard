import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final Function(double value) getSliderValue;
  final String title;
  final Color curColor;
  final double initData;

  double uiCnt = 1.0;

  CustomSlider(
      {Key? key,
      required this.title,
      required this.getSliderValue,
      required this.curColor,
      required this.initData})
      : super(key: key) {
    uiCnt = initData;
  }

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 5, right: 5),
            leading: sliderTitle(),
            title: sliderKeyPart(),
            trailing: sliderConfirmBtn(),
          ),
        ));
  }

  Widget sliderTitle() {
    return Container(
      width: 200,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.only(right: 5),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: widget.curColor),
          width: 15 + widget.uiCnt,
          height: 15 + widget.uiCnt,
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 17),
        ),
//        trailing: Text(
//          '${_cnt}',
//          style: TextStyle(fontSize: 17),
//        ),
      ),
    );
  }

  Widget sliderKeyPart() {
    return CustomSliderKeyPart(
//        initData: widget.initData,
      initData: widget.uiCnt,
      onChangeEnd: (value) {
        setState(() {
//            _cnt = value;

          widget.uiCnt = value;
        });
      },
      activatedColor: widget.curColor,
      inActivatedColor: Colors.grey[200]!,
    );
  }

  Widget sliderConfirmBtn() {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
//          color: Colors.blue,
          gradient: LinearGradient(colors: [widget.curColor, Colors.blue]),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: InkWell(
        onTap: () {
          widget.getSliderValue(widget.uiCnt);
          Navigator.of(context).pop();
        },
        child: Text(
          '确定',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class CustomSliderKeyPart extends StatefulWidget {
  final double initData;
  final Function(double sliderValue) onChangeEnd;
  bool _isFirstShown = true;
  final Color activatedColor;
  final Color inActivatedColor;

  CustomSliderKeyPart(
      {required this.initData,
      required this.onChangeEnd,
      required this.activatedColor,
      required this.inActivatedColor});

  @override
  _CustomSliderKeyPartState createState() => _CustomSliderKeyPartState();
}

class _CustomSliderKeyPartState extends State<CustomSliderKeyPart> {
  double _cnt = 1.0;

  @override
  Widget build(BuildContext context) {
    if (widget._isFirstShown) {
      _cnt = widget.initData;
    }
    return Slider(
      min: 1,
      max: 10,
      divisions: 200,
      activeColor: widget.activatedColor,
      inactiveColor: widget.inActivatedColor,
      onChangeEnd: (value) {
        print(value);
        setState(() {
          _cnt = value;
//                  print(_cnt);
//          widget.getSliderValue(value);
        });
      },
      onChanged: (double value) {
        widget._isFirstShown = false;
        setState(() {
          _cnt = value;
        });
        widget.onChangeEnd(value);
      },
      value: _cnt,
    );
  }
}

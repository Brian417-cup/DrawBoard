import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final Function(double value) getSliderValue;
  final String title;
  final Color curColor;
  final double initData;

  const CustomSlider(
      {Key? key,
      required this.title,
      required this.getSliderValue,
      required this.curColor,
      required this.initData})
      : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _cnt = 1.0;

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
          width: 15,
          height: 15,
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
        initData: widget.initData,
        onChangeEnd: (value) {
          _cnt = value;
        });
  }

  Widget sliderConfirmBtn() {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: InkWell(
        onTap: () {
          widget.getSliderValue(_cnt);
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

  CustomSliderKeyPart({required this.initData, required this.onChangeEnd});

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
    return CupertinoSlider(
      min: 0,
      max: 10,
      divisions: 20,
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

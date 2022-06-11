import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final Function(double value) getSliderValue;
  final String title;
  final Color curColor;

  const CustomSlider(
      {Key? key, required this.title, required this.getSliderValue,required this.curColor})
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
      width: 180,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(shape: BoxShape.circle, color: widget.curColor),
          width: 15,
          height: 15,
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  Widget sliderKeyPart() {
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
        setState(() {
          _cnt = value;
        });
      },
      value: _cnt,
    );
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

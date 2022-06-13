import 'package:flutter/material.dart';

class CustomNetWorkRatio extends StatefulWidget {
  final Function(bool isServer) onRatioChanged;
  final Function(String ipStr) onIPChanged;
  final Function(String portStr) onPortChanged;

  CustomNetWorkRatio(
      {Key? key,
      required this.onRatioChanged,
      required this.onIPChanged,
      required this.onPortChanged})
      : super(key: key);

  @override
  _CustomNetWorkRatioState createState() => _CustomNetWorkRatioState();
}

class _CustomNetWorkRatioState extends State<CustomNetWorkRatio> {
  int groupValue = 1;
  bool isSender = true;
  String ipAddressStr = '';
  String portStr = '';

  final inputTextFieldWidth = 130.0;
  final activateColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
//        单选按钮组的核心
          _ratioGroupKeyPart(),
//          如果是分享者的话这里要填入对应的目的IP和端口号
          isSender
//          是发起者的处理方法
              ? Container(
                  height: 100,
                  width: 250,
                  padding: EdgeInsets.only(top: 3),
                  child: Column(
                    children: [
//                      IP地址组
                      _ipGroupForm(),
//                      端口输入组
                      _portGroupForm()
                    ],
                  ))
//          观看者的处理方法
              : Container(
                  height: 100,
                  width: 250,
                  padding: EdgeInsets.only(top: 3),
                  child: //                      端口输入组
                      _portGroupForm(),
                )
        ],
      ),
    );
  }

//  单选按钮组件核心
  Widget _ratioGroupKeyPart() {
    return Row(
      children: [
        Row(
          children: [
            Radio(
                value: 1,
                groupValue: groupValue,
                activeColor: activateColor,
                onChanged: (value) {
                  setState(() {
                    isSender = true;
                    groupValue = value as int;
                  });
                  widget.onRatioChanged(isSender);
                }),
            Text(
              '分享者',
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
        Row(
          children: [
            Radio(
                value: 2,
                groupValue: groupValue,
                activeColor: activateColor,
                onChanged: (value) {
                  setState(() {
                    isSender = false;
                    groupValue = value as int;
                  });
                  widget.onRatioChanged(isSender);
                }),
            Text(
              '观看者',
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ],
    );
  }

//  输入框信息组
//    IP组
  Widget _ipGroupForm() {
    return Row(
      children: [
//            IP地址说明
        Text(
          '观看者IP:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 20),
//            IP地址输入
        Container(
          width: inputTextFieldWidth,
          child: TextField(
            onChanged: (value) {
              ipAddressStr = value;
              widget.onIPChanged(ipAddressStr);
            },
          ),
        ),
      ],
    );
  }

//    端口号组
  Widget _portGroupForm() {
    return Row(
      children: [
//                          端口号说明
        Text(
          '端口号',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 20),
//            端口号输入
        Container(
          width: inputTextFieldWidth,
          child: TextField(
            onChanged: (value) {
              portStr = value;
              widget.onPortChanged(portStr);
            },
          ),
        ),
      ],
    );
  }
}

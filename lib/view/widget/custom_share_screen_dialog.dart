import 'package:flutter/material.dart';

//和主文件的_shareIdentityDialogShow一起使用
class CustomShareScreenDialog extends StatefulWidget {
  //  在一开始就要进行身份确认
  final Function() onInitIdentity;
  final Function(bool isServer) onRatioChanged;
  final Function(String ipStr) onIPChanged;
  final Function(String portStr) onPortChanged;

  CustomShareScreenDialog(
      {Key? key,
      required this.onInitIdentity,
      required this.onRatioChanged,
      required this.onIPChanged,
      required this.onPortChanged})
      : super(key: key);

  @override
  _CustomShareScreenDialogState createState() =>
      _CustomShareScreenDialogState();
}

class _CustomShareScreenDialogState extends State<CustomShareScreenDialog> {
  int groupValue = 1;
  bool isSender = true;
  String ipAddressStr = '';
  String portStr = '';

  final inputTextFieldWidth = 130.0;
  final activateColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    widget.onInitIdentity();
  }

  @override
  Widget build(BuildContext context) {
    widget.onInitIdentity();
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
//                  height: 100,
//                  width: 250,
                  padding: EdgeInsets.only(top: 3),
                  child: Column(
                    children: [
//                      IP地址组
//                      _ipGroupForm('本机'),
//                      端口输入组
                      _portGroupForm('本机')
                    ],
                  ))
//          观看者的处理方法
              : Container(
//                  height: 100,
//                  width: 250,
                  padding: EdgeInsets.only(top: 3),
                  child: Column(
                    children: [
                      _ipGroupForm('分享者'),
                      _portGroupForm('分享者'),
                    ],
                  ))
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
  Widget _ipGroupForm(String name) {
    return Row(
      children: [
//            IP地址说明
        Text(
          '${name}IP:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 10),
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
  Widget _portGroupForm(String name) {
    return Row(
      children: [
//                          端口号说明
        Text(
          '${name}端口:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 10),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLayerSwapDialog extends StatefulWidget {
  final maxIndex;
  final Function(String firstStr, String secondStr) onSwapConfirm;

  CustomLayerSwapDialog(
      {Key? key, required this.maxIndex, required this.onSwapConfirm})
      : super(key: key);

  @override
  _CustomLayerSwapDialogState createState() => _CustomLayerSwapDialogState();
}

class _CustomLayerSwapDialogState extends State<CustomLayerSwapDialog> {
  String txt1 = '';
  String txt2 = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10,bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          inputGroup(1, '编号1,(0-${widget.maxIndex})'),
          inputGroup(2, '编号2,(0-${widget.maxIndex})'),
          confirmBtn()
        ],
      ),
    );
  }

  Widget inputGroup(@required int no, @required String title) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10),
      shape: no == 1
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)))
          : BeveledRectangleBorder(),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 5, right: 5),
        leading: Text(
          title,
          style: TextStyle(fontSize: 25),
        ),
        title: CupertinoTextField(
          showCursor: true,
          onChanged: (value) {
            if (no == 1) {
              txt1 = value;
            } else {
              txt2 = value;
            }
          },
        ),
      ),
    );
  }

  Widget confirmBtn() {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: ListTile(
        title: MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          minWidth: 50,
          height: 50,
          color: Colors.blue,
          onPressed: () {
            print('${txt1}--${txt2}');
            widget.onSwapConfirm(txt1, txt2);
            Navigator.of(context).pop();
          },
          child: Text(
            '确定',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

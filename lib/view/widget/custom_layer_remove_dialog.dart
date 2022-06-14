import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLayerRemoveDialog extends StatelessWidget {
  String txtValue = '';
  int maxIndex;
  final Function(String txtValue) onRemoveConfirm;

  CustomLayerRemoveDialog(
      {required this.maxIndex, required this.onRemoveConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          inputGroup('刪除图层编号:0-${maxIndex}'),
          confirmBtn(context)
        ],
      ),
    );
  }

  Widget inputGroup(@required String title) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 5, right: 5),
        leading: Text(
          title,
          style: TextStyle(fontSize: 25),
        ),
        title: CupertinoTextField(
          showCursor: true,
          onChanged: (inputValue) {
            txtValue = inputValue;
          },
        ),
      ),
    );
  }

  Widget confirmBtn(context) {
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
            onRemoveConfirm(txtValue);
            Navigator.of(context).pop();
          },
          child: Text(
            '确定',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}

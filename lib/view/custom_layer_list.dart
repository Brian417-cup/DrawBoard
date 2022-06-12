import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomLayerList extends StatefulWidget {
  final Function(int curIndex) onIndexChosen;
  int curChosenIndex;
  final int srcLength;

  CustomLayerList({required this.srcLength,required this.curChosenIndex, required this.onIndexChosen});

  @override
  State<CustomLayerList> createState() => _CustomLayerListState();
}

class _CustomLayerListState extends State<CustomLayerList> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 20),
              itemBuilder: (context, index) {
                return _customItemBuilder(index);
              },
              itemCount: widget.srcLength,
              physics: const AlwaysScrollableScrollPhysics()),
        ),
      ],
    );
  }

  Widget _customItemBuilder(int no) {
    final contentColor = Colors.primaries[no % Colors.primaries.length][500];
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          border: Border.all(
              color: widget.curChosenIndex == no ? Colors.white : contentColor!,
              width: 5.0),
          color: contentColor,
        ),
        margin: EdgeInsets.only(top: 20,right: 20),
        child: GestureDetector(
          onPanDown: (_) {
            setState(() {
              widget.curChosenIndex = no;
            });
//            回调反馈
            widget.onIndexChosen(no);
//            反馈后关闭当前对话框
            Navigator.of(context).pop();
          },
          child: Center(
              child: Text(
            '图层${no}',
            style: TextStyle(fontSize: 15, color: Colors.white),
          )),
        ),
      ),
    );
  }


}

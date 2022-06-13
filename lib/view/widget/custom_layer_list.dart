import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class CustomLayerList extends StatefulWidget {
  final Function(int curIndex) onIndexChosen;
  int curChosenIndex;
  final int srcLength;

  CustomLayerList(
      {required this.srcLength,
      required this.curChosenIndex,
      required this.onIndexChosen});

  @override
  State<CustomLayerList> createState() => _CustomLayerListState();
}

class _CustomLayerListState extends State<CustomLayerList> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
//        置顶按钮
        _toTopBtn(),
//        中间列表整体展示
        Expanded(
          child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return _customItemBuilder(index);
              },
              itemCount: widget.srcLength,
              physics: const AlwaysScrollableScrollPhysics()),
        ),
//        置底按钮
        _toBottomBtn(),
      ],
    );
  }

//  置顶按钮
  Widget _toTopBtn() {
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(top: 10, right: 30,bottom: 10),
        child: MaterialButton(
          onPressed: () {
//                返回顶部
            _scrollController.animateTo(0.0,
                duration: Duration(milliseconds: 800), curve: Curves.ease);
          },
          height: 50,
          minWidth: 50,
          color: Colors.deepOrange,
          child: Icon(
            Icons.vertical_align_top,
            size: 20,
            color: Colors.white,
          ),
        ));
  }

//  列表单个元素构建
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
        margin: EdgeInsets.only(top: 20, right: 20),
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

//  回到底部按钮
  Widget _toBottomBtn() {
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(top: 10, right: 30),
        child: MaterialButton(
          onPressed: () {
//                一键到底
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 800),
                curve: Curves.ease);
          },
          height: 50,
          minWidth: 50,
          color: Colors.deepPurple,
          child: Icon(
            Icons.vertical_align_bottom,
            size: 20,
            color: Colors.white,
          ),
        ));
  }
}

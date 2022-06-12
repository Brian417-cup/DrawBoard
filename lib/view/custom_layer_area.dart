import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:flutterdrawboard/view/custom_layer_list.dart';
import 'package:flutterdrawboard/view/custom_layer_swap_dialog.dart';
import 'package:provider/provider.dart';

class CustomLayerArea extends StatefulWidget {
  CustomLayerArea({Key? key}) : super(key: key);

  @override
  _CustomLayerAreaState createState() => _CustomLayerAreaState();
}

class _CustomLayerAreaState extends State<CustomLayerArea> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawBoardProvider>(
      builder: (context, cur, child) {
        return Column(
          children: [
            Expanded(
              child: CustomLayerList(
                  srcLength: cur.layerCnt,
                  curChosenIndex: cur.curLayerIndex,
                  onIndexChosen: (chosenIndex) {
                    cur.curLayerIndex = chosenIndex;
                    cur.notifyListeners();
                  }),
            ),
            Expanded(child: floatingActionBtnGroup())
          ],
        );
      },
    );
  }

  //按钮组
  Widget floatingActionBtnGroup() {
    return Container(
      height: 30,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(left: 10, bottom: 10),
      child: Row(
        children: [
          plusOneBtn(),
          const SizedBox(width: 20),
          decreaseOneBtn(),
          const SizedBox(width: 20),
          swapLayerBtn(),
          const SizedBox(width: 20),
          closeDialogBtn()
        ],
      ),
    );
  }

//  加一个图层悬浮按钮
  Widget plusOneBtn() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Consumer<DrawBoardProvider>(
        builder: (context, cur, child) {
          return FloatingActionButton(
            tooltip: '加一个图层',
            onPressed: () {
              cur.addOneNewLayer();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              child: Icon(
                Icons.plus_one,
                size: 35,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  //  减一个图层悬浮按钮
  Widget decreaseOneBtn() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: FloatingActionButton(
        tooltip: '减少一个图层',
        onPressed: () {
          print('减一个图层');
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: Icon(
            Icons.delete_forever,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

//  交换图层按钮
  Widget swapLayerBtn() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: FloatingActionButton(
        tooltip: '交换图层',
        onPressed: () {
          print('交换图层');

          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CustomLayerSwapDialog();
              });
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: Icon(
            Icons.swap_vert,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

//  关闭当前视窗按钮
  Widget closeDialogBtn() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: FloatingActionButton(
        tooltip: '关闭当前绘画',
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: Icon(
            Icons.close,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

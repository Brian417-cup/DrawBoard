import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:flutterdrawboard/view/custom_layer_area.dart';
import 'package:flutterdrawboard/view/custom_slider.dart';
import 'package:flutterdrawboard/view/pen_color_picker.dart';
import 'package:provider/provider.dart';

import 'custom_draw_board.dart';

class CustomDrawBoardArea extends StatefulWidget {
  CustomDrawBoardArea({Key? key}) : super(key: key);

  @override
  _CustomDrawBoardAreaState createState() => _CustomDrawBoardAreaState();
}

class _CustomDrawBoardAreaState extends State<CustomDrawBoardArea> {
  double _cnt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '自定义画板',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
//            画笔颜色调整
          IconButton(
              tooltip: '画笔颜色',
              onPressed: () {
                penColorPickerDialogShow(context);
              },
              icon: Icon(
                Icons.color_lens,
                size: 35,
              )),
//            画笔粗细调整
          IconButton(
              tooltip: '画笔粗细',
              onPressed: () {
                penStrokeWidthDialogShow(context);
              },
              icon: Icon(
                Icons.brush,
                size: 35,
              )),
//            橡皮擦功能
          Consumer<DrawBoardProvider>(
            builder: (context, cur, child) {
              return IconButton(
                  tooltip: '橡皮擦',
                  onPressed: () {
                    cur.eraserConverse();
                  },
                  icon: Icon(
                    Icons.style,
                    color:
                        cur.isEraser ? Colors.deepOrangeAccent : Colors.white,
                    size: 35,
                  ));
            },
          ),
//          返回上一步功能
          Consumer<DrawBoardProvider>(
            builder: (context, cur, child) {
              return IconButton(
                  tooltip: '返回上一步',
                  onPressed: () {
                    cur.popLastPathData();
                  },
                  icon: Icon(
                    Icons.rotate_left,
                    size: 35,
                  ));
            },
          ),
//            多页图层编辑功能
          IconButton(
              onPressed: () {
                layerEditorDialogShow(context);
              },
              icon: Icon(
                Icons.find_in_page,
                size: 35,
              )),
          SizedBox(
            width: 30,
          )
        ],
      ),
      body: Container(color: Colors.white, child: KeyCustomDrawBoardWidget()),
    );
  }

  penColorPickerDialogShow(context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Consumer<DrawBoardProvider>(builder: (context, cur, child) {
            return ColorPickerDialog(
              onColorChange: ((dstColor) {
                print(dstColor);
//              回调结果及时更新到Provider中
                cur.nextPenColor = dstColor;
              }),
              initColor: cur.nextPenColor,
            );
          });
        });
  }

  penStrokeWidthDialogShow(context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<DrawBoardProvider>(builder: (context, cur, child) {
                return CustomSlider(
                  title: '线条粗细',
                  getSliderValue: (sliderValue) {
                    print(sliderValue);
                    cur.nextPenStrokeWidth = sliderValue;
                  },
                  curColor: cur.nextPenColor,
                  initData: cur.nextPenStrokeWidth,
                );
              }),
            ],
          );
        });
  }

  layerEditorDialogShow(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Consumer<DrawBoardProvider>(
            builder: (context, cur, child) {
              return CustomLayerArea();
            },
          );
        });
  }
}

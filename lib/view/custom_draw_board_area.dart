import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:flutterdrawboard/view/custom_draw_board.dart';
import 'package:flutterdrawboard/view/custom_slider.dart';
import 'package:flutterdrawboard/view/pen_color_picker.dart';
import 'package:provider/provider.dart';

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
        ),
        body: Container(
            color: Colors.white,
            child: Column(children: [
              Expanded(child: KeyCustomDrawBoardWidget()),
//                画笔颜色调整
              MaterialButton(
                  minWidth: 20,
                  height: 120,
                  color: Colors.blue,
                  onPressed: () {
                    penColorPickerDialogShow(context);
                  }),

//            画笔线条粗细调整
              Container(
                width: 50,
                height: 100,
                color: Colors.red,
                child: InkWell(onTap: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Consumer<DrawBoardProvider>(
                                builder: (context, cur, child) {
                              return CustomSlider(
                                title: '线条粗细',
                                getSliderValue: (sliderValue) {
                                  print(sliderValue);
                                  cur.nextPenStrideWidth = sliderValue;
                                },
                                curColor: cur.nextPenColor,
                              );
                            }),
                          ],
                        );
                      });
                }),
              ),
//              橡皮擦功能调整
              Consumer<DrawBoardProvider>(builder: (context, cur, child) {
                return MaterialButton(
                  onPressed: () {
                    cur.eraserConverse();
                  },
                  minWidth: 100,
                  height: 100,
                  color: Colors.green,
                );
              }),

//              撤退功能
              Consumer<DrawBoardProvider>(builder: (context, cur, child) {
                return MaterialButton(
                  onPressed: () {
                    cur.popLastPathData();
                  },
                  minWidth: 100,
                  height: 100,
                  color: Colors.orangeAccent,
                );
              }),
            ])));
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
}

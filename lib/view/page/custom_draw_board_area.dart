import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:flutterdrawboard/provider/draw_board_saver_provider.dart';
import 'package:flutterdrawboard/provider/draw_board_share_screen_provider.dart';
import 'package:flutterdrawboard/utils/custom_toast.dart';
import 'package:flutterdrawboard/view/widget/custom_net_work_ratio.dart';
import 'custom_layer_area.dart';
import '../widget/custom_slider.dart';
import '../widget/pen_color_picker.dart';
import 'package:provider/provider.dart';

import '../widget/custom_draw_board.dart';

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
//        title: Text(
//          '自定义画板',
//          style: TextStyle(fontSize: 20),
//        ),
        actions: [
//            画笔颜色调整
          IconButton(
              tooltip: '画笔颜色',
              onPressed: () {
                _penColorPickerDialogShow(context);
              },
              icon: Icon(
                Icons.color_lens,
                size: 35,
              )),
//            画笔粗细调整
          IconButton(
              tooltip: '画笔粗细',
              onPressed: () {
                _penStrokeWidthDialogShow(context);
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
//          选择模式
//        udp网络待实现...
//          Consumer<DrawBoardShareScreenProvider>(
//            builder: (context, cur, child) {
//              return IconButton(
//                  onPressed: () async {
//                    if (!cur.isSharing) {
//                      await _shareIdentityDialogShow(context, cur)
////                          .then((value) {
////                        cur.sharingStateConverse();
////                      })
//                          ;
//                    } else {
//                      if (await cur.closeConnect()) {
//                        DrawBoardToast.showSuccessToast(context, '连接资源释放成功!!');
//                        cur.sharingStateConverse();
//                      } else {
//                        DrawBoardToast.showErrorToast(context, '连接资源释放失败!!');
//                      }
//                    }
//                  },
//                  icon: Icon(
//                    Icons.network_wifi,
//                    size: 35,
//                    color: cur.isSharing ? Colors.purple : Colors.white,
//                  ));
//            },
//          ),
          //保存成图片
          Consumer<DrawBoardSaverProvider>(builder: (context, cur, child) {
            return IconButton(
                tooltip: '保存图片，暂时对Web和Windows端不支持',
                onPressed: () {
                  cur.needSaver = true;
                  cur.notifyListeners();
                },
                icon: Icon(
                  Icons.save,
                  size: 35,
                ));
          }),
          SizedBox(
            width: 30,
          )
        ],
      ),
      body: Container(
          color: Colors.white,
          child:
              Consumer<DrawBoardSaverProvider>(builder: (context, cur, child) {
            return CustomDrawBoardKeyWidget(
                isSender: true,
                getCurPicDatata: (data, w, h) {
                  if (cur.needSaver) {
                    cur.saverToImg(data, w, h);
                  }
                });
          })),
    );
  }

  _penColorPickerDialogShow(context) {
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

  _penStrokeWidthDialogShow(context) {
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

//  udp共享屏幕网络部分待实现...

//  分享身份选择
  _shareIdentityDialogShow(
      BuildContext context, DrawBoardShareScreenProvider cur) async {
    //展示模式选择对话框
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            content: CustomNetWorkRatio(
              onRatioChanged: ((isSender) {
                cur.isSender = isSender;
                cur.notifyListeners();
              }),
              onIPChanged: (ipStr) {
                cur.ipStr = ipStr;
              },
              onPortChanged: (portStr) {
                cur.portStr = portStr;
              },
            ),
            scrollable: true,
            actions: [
//              关闭共享按钮
              MaterialButton(
                onPressed: () {
                  cur.clearSocketInfo();
                  cur.isSharing = false;
                  cur.notifyListeners();
                  Navigator.of(context).pop();
                },
                color: Colors.blue,
                minWidth: 30,
                height: 35,
                child: Text(
                  '关闭共享',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
//              待会再设按钮
              MaterialButton(
                onPressed: () {
                  cur.clearSocketInfo();
                  Navigator.of(context).pop();
                },
                color: Colors.blue,
                minWidth: 30,
                height: 35,
                child: Text(
                  '待会再设',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
//              确认开始按钮
              MaterialButton(
                onPressed: () async {
//                  发起者的处理逻辑
                  if (cur.isSender) {
                    _connectBuildFeedBack(await cur.sharerInit(), cur);
                  }
//                  观看者处理
                  else {
                    _connectBuildFeedBack(
//                        await cur.watcherInit(),
                        NetWorkBaseState.Sucess,
                        cur);
                  }
                },
                color: Colors.blue,
                minWidth: 30,
                height: 35,
                child: Text(
                  '确定',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          );
        });
  }

//  连接建立提示
  _connectBuildFeedBack(connectResult, DrawBoardShareScreenProvider provider) {
    switch (connectResult) {
      case NetWorkBaseState.Sucess:
        DrawBoardToast.showSuccessToast(context, '连接建立成功!');
        provider.sharingStateConverse();
        Navigator.of(context).pop();
        break;
      case NetWorkBaseState.Exception:
        DrawBoardToast.showErrorToast(context, '参数初始化失败，请检查输入是否合法!');
        break;
      case NetWorkBaseState.Error:
        DrawBoardToast.showErrorToast(context, '连接建立失败，可能由于IP或者端口已被占用');
        break;
    }
  }
}

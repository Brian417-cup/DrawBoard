import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/provider/draw_board_provider.dart';
import 'package:flutterdrawboard/provider/draw_board_saver_provider.dart';
import 'package:flutterdrawboard/provider/draw_board_share_screen_provider.dart';
import 'package:flutterdrawboard/utils/custom_toast.dart';
import 'package:flutterdrawboard/view/widget/custom_share_screen_dialog.dart';
import 'package:flutterdrawboard/view/widget/custom_watcher_screen.dart';
import '../../model/OperationIdentity.dart';
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
          buildPenColorBtn(context),
//            画笔粗细调整
          buildPenWidthBtn(context),
//            橡皮擦功能
          buildEraserBtn(),
//          返回上一步功能
          buildRollBackBtn(),
//            多页图层编辑功能
          buildLayerEditorBtn(context),
//          画板共享选择模式
          buildShareScreenBtn(),
//          保存成图片
          buildImgSaverBtn(),
          SizedBox(
            width: 30,
          )
        ],
      ),
//      核心部分：画板
      body: Container(
          color: Colors.white,
          child: Consumer<DrawBoardShareScreenProvider>(
              builder: (context, cur, child) {
            final shareDelegat = cur;

            return Consumer<DrawBoardSaverProvider>(
                builder: (context, cur, child) {
//                  新版方法，用身份枚举来进行判断
              switch (shareDelegat.identity) {
                case OperationIdentity.Watcher:
                  return Builder(
                      builder: (context) =>
                          CustomWatcherScreen(shareDelegat.currPic));
                case OperationIdentity.Saver:
                case OperationIdentity.None:
                  return CustomDrawBoardKeyWidget(
                      identity: shareDelegat.identity,
                      getCurPicDatata: (data, w, h) async {
                        _saveImgWithResult(shareDelegat, cur, data, w, h);
                      });
//        return CustomDrawBoardKeyWidget(isSenderOrSaver: isSenderOrSaver, getCurPicDatata: getCurPicDatata)
                case OperationIdentity.Sharer:
                  return CustomDrawBoardKeyWidget(
                      identity: shareDelegat.identity,
                      getCurPicDatata: (data, w, h) async {
                        shareDelegat.sendPicData(data, w, h);
                      });
              }
            });
          })),
    );
  }

//  屏幕共享
  Widget buildShareScreenBtn() {
    return Consumer<DrawBoardShareScreenProvider>(
      builder: (context, cur, child) {
        return IconButton(
            onPressed: () async {
              if (!cur.isSharing) {
                await _shareIdentityDialogShow(context, cur);
              } else {
                if (await cur.closeConnect()) {
                  DrawBoardToast.showSuccessToast(context, '连接资源释放成功!!');
                  cur.sharingStateConverse();
                } else {
                  DrawBoardToast.showErrorToast(context, '连接资源释放失败!!');
                }
              }
            },
            icon: Icon(
              Icons.wb_cloudy,
              size: 35,
              color: cur.isSharing ? Colors.purple : Colors.white,
            ));
      },
    );
  }

//  画笔颜色按钮
  Widget buildPenColorBtn(BuildContext context) {
    return IconButton(
        tooltip: '画笔颜色',
        onPressed: () {
          _penColorPickerDialogShow(context);
        },
        icon: Icon(
          Icons.color_lens,
          size: 35,
        ));
  }

//  画笔颜色选择对话框
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

  //  画笔粗细按钮
  Widget buildPenWidthBtn(BuildContext context) {
    return IconButton(
        tooltip: '画笔粗细',
        onPressed: () {
          _penStrokeWidthDialogShow(context);
        },
        icon: Icon(
          Icons.brush,
          size: 35,
        ));
  }

//  画笔粗细选择对话框
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
//                    print(sliderValue);
                    cur.nextPenStrokeWidth = sliderValue;
                    print(cur.nextPenStrokeWidth);
                    cur.notifyListeners();
                  },
                  curColor: cur.nextPenColor,
                  initData: cur.nextPenStrokeWidth,
                );
              }),
            ],
          );
        });
  }

  //  橡皮擦按钮
  Widget buildEraserBtn() {
    return Consumer<DrawBoardProvider>(
      builder: (context, cur, child) {
        return IconButton(
            tooltip: '橡皮擦',
            onPressed: () {
              cur.eraserConverse();
            },
            icon: Icon(
              Icons.style,
              color: cur.isEraser ? Colors.deepOrangeAccent : Colors.white,
              size: 35,
            ));
      },
    );
  }

  //  回退上一步按钮
  Widget buildRollBackBtn() {
    return Consumer<DrawBoardProvider>(
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
    );
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

  //  图层编辑器
  Widget buildLayerEditorBtn(BuildContext context) {
    return IconButton(
        onPressed: () {
          layerEditorDialogShow(context);
        },
        icon: Icon(
          Icons.find_in_page,
          size: 35,
        ));
  }

//  udp共享屏幕网络部分待实现...

//  分享身份选择
  _shareIdentityDialogShow(
      BuildContext context, DrawBoardShareScreenProvider cur) async {
    cur.identityInitOnDialogOpen();

    //展示模式选择对话框
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10),
            content: CustomShareScreenDialog(
              onInitIdentity: () {
//                  cur.isSender=true;
//                  cur.identity=OperationIdentity.Sharer;
              },
              onRatioChanged: ((isSender) {
                cur.isSender = isSender;
//                新变量，用枚举替换逻辑bool来判断身份信息
                if (isSender) {
                  cur.identity = OperationIdentity.Sharer;
                } else {
                  cur.identity = OperationIdentity.Watcher;
                }
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
                  cur.clearShareInfo();
//                  cur.isSharing = false;
//                  cur.notifyListeners();
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
                  cur.clearShareInfo();
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
                        await cur.watcherInit(),
//                        NetWorkBaseState.Sucess,
                        cur);
                  }
                  cur.isSharing = true;
                  cur.notifyListeners();
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

  //  保存图片具体操作函数
  Widget buildImgSaverBtn() {
    return Consumer<DrawBoardSaverProvider>(builder: (context, cur, child) {
      return Consumer<DrawBoardShareScreenProvider>(
          builder: (context, shareDelegate, child) {
        return IconButton(
            tooltip: '保存图片，暂时只支持移动端',
            onPressed: () {
              cur.needSaver = true;
//              新加入的身份枚举管理
              shareDelegate.identity = OperationIdentity.Saver;
              cur.notifyListeners();
//              新加入的身份枚举管理
              shareDelegate.notifyListeners();
            },
            icon: Icon(
              Icons.save,
              size: 35,
            ));
      });
    });
  }

//  保存图片处理
  _saveImgWithResult(DrawBoardShareScreenProvider shareDelegate,
      DrawBoardSaverProvider cur, data, w, h) async {
    if (cur.needSaver) {
      switch (await cur.saverToImg(data, w, h)) {
        case SaverResult.Success:
          DrawBoardToast.showSuccessToast(context, '保存成功');
          break;
        case SaverResult.Error:
          DrawBoardToast.showErrorToast(context, '保存失败');
          break;
        case SaverResult.ErrorPlatform:
          DrawBoardToast.showErrorToast(context, '当前平台暂不支持该操作');
          break;
        case SaverResult.Exception:
          DrawBoardToast.showErrorToast(context, '参数异常');
          break;
      }
    }

//    新加入的身份管理
    shareDelegate.identity = OperationIdentity.None;
//    shareDelegate.notifyListeners();
  }
}

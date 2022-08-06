import 'dart:typed_data';
import 'package:flutterdrawboard/view/widget/custom_magnifier.dart';
import 'package:flutterdrawboard/view/widget/custom_waiting_share.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutterdrawboard/provider/draw_board_share_screen_provider.dart';

class CustomWatcherScreen extends StatefulWidget {
  Uint8List? picData;

  CustomWatcherScreen(this.picData);

  @override
  _CustomWatcherScreenState createState() => _CustomWatcherScreenState();
}

class _CustomWatcherScreenState extends State<CustomWatcherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _keyPart(),
      floatingActionButton: _buildActionGroup(),
    );
  }

  Widget _keyPart() {
    return widget.picData == null
        ?
//    空白加载界面
        Container(
//            color: Colors.blue,
        alignment: Alignment.center,
          child: CustomWaitingShare(),
        )
        :
//    开始共享
        Consumer<DrawBoardShareScreenProvider>(
            builder: (context, cur, child) {
              return cur.isMagnifierOpen
                  ?
//              放大镜打开
                  CustomMagnifier(
                      bottomWidget: Image.memory(widget.picData!),
                      magnifySize: cur.magnifySize)
                  :
//              放大镜关闭
                  Image.memory(widget.picData!);
            },
          );
  }

  Widget _buildActionGroup() {
    return Consumer<DrawBoardShareScreenProvider>(
        builder: (context, cur, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
//          向上增大放大倍数
          _buildAddScaleBtn(cur),
          SizedBox(height: 20),
//          待开发放大镜功能
          _buildMagnifierBtn(cur),
          SizedBox(height: 20),
//          向下减少放大倍数按钮
          _buildSubScaleBtn(cur)
        ],
      );
    });
  }

  FloatingActionButton _buildMagnifierBtn(DrawBoardShareScreenProvider cur) {
    return FloatingActionButton(
      backgroundColor:
          cur.isMagnifierOpen ? Colors.primaries[4] : Colors.primaries[4][100],
      onPressed: () {
        cur.magnifierStateConverse();
      },
      child: Icon(
        Icons.zoom_in,
        size: 35,
      ),
    );
  }

  Widget _buildSubScaleBtn(DrawBoardShareScreenProvider cur) {
    return Visibility(
      visible: cur.isMagnifierOpen,
      child: FloatingActionButton(
        onPressed: () {
          cur.subScale();
        },
        child: Icon(
          Icons.arrow_downward,
          size: 35,
        ),
      ),
    );
  }

  Widget _buildAddScaleBtn(DrawBoardShareScreenProvider cur) {
    return Visibility(
      visible: cur.isMagnifierOpen,
      child: FloatingActionButton(
        onPressed: () {
          cur.addScale();
        },
        child: Icon(
          Icons.arrow_upward,
          size: 35,
        ),
      ),
    );
  }
}

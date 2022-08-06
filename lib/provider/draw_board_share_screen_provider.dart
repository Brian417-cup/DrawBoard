import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdrawboard/utils/custom_compress_data.dart';
import 'package:flutterdrawboard/utils/custom_socket_client.dart';
import 'package:flutterdrawboard/utils/custom_socket_server.dart';

import '../model/OperationIdentity.dart';

//连接状态
enum NetWorkBaseState {
  Error,
  Exception,
  Sucess,
}

//放大镜功能下的状态选择
enum MagnifierShape { Retangle, Circle }

class DrawBoardShareScreenProvider with ChangeNotifier {
//  平台检查，当前网页端不支持该功能
  bool isPlatformFittted() {
    return !kIsWeb;
  }

//  是否处于分享状态
  bool _isSharing = false;

  bool get isSharing => _isSharing;

  set isSharing(bool value) {
    _isSharing = value;
  }

  sharingStateConverse() {
    _isSharing = !_isSharing;
//    print('当前状态:${isSharing}');
    clearShareInfo();
    notifyListeners();
  }

//  是否是共享画板的发起者
  bool _isSender = true;

  bool get isSender => _isSender;

  set isSender(bool value) {
    _isSender = value;
  }

//  IP地址
  String _ipStr = '';

  String get ipStr => _ipStr;

  set ipStr(String value) {
    _ipStr = value;
  }

//  port端口号
  String _portStr = '';

  String get portStr => _portStr;

  set portStr(String value) {
    _portStr = value;
  }

//  对话框打开第一次需要初始化身份
  identityInitOnDialogOpen() {
    _isSender = true;
    _identity = OperationIdentity.Sharer;
  }

//  IP和端口号清空
  clearShareInfo() {
    _ipStr = '';
    _portStr = '';
    _currPic = null;
    _isSharing = false;
//    _identity = OperationIdentity.None;
    notifyListeners();
  }

//  新API
//身份
  OperationIdentity _identity = OperationIdentity.None;

  OperationIdentity get identity => _identity;

  set identity(OperationIdentity value) {
    _identity = value;
  }

//  分享者作为服务器
  CustomSocketServer? server = null;

//  观看者作为客户端
  CustomSocketClient? client = null;

//  释放连接
  Future<bool> closeConnect() async {
//    try {
//      _socket?.close();
//    } catch (e) {
//      print(e);
//      return false;
//    }
//
//    return true;

    try {
      switch (_identity) {
        case OperationIdentity.Sharer:
          await server?.close();
          break;
        case OperationIdentity.Watcher:
          await client?.closeConnection().then((value) {
            //关闭连接后待添加功能
          });
          break;
        default:
          break;
      }
    } catch (e) {
      return false;
    } finally {
      _identity = OperationIdentity.None;
    }
    return true;
  }

//  共享者初始化
  Future<NetWorkBaseState> sharerInit() async {
    NetWorkBaseState state = NetWorkBaseState.Sucess;
    try {
      server = CustomSocketServer();
//      server?.serverBind(_ipStr, int.parse(_portStr));
      server?.serverBind(null, int.parse(_portStr));

      _isSharing = true;
      _identity = OperationIdentity.Sharer;

      print('分享者初始化成功');
    } catch (e) {
      print(e);
      return NetWorkBaseState.Exception;
    }

    return state;
  }

//  发送数据
  Future<bool> sendPicData(Picture rawData, int w, int h) async {
    try {
      await rawData.toImage(w, h).then((img) async {
        await img
            .toByteData(format: ImageByteFormat.png)
            .then((curSendData) async {
          print(curSendData!.buffer.lengthInBytes);
//          新版的发送数据
          if (curSendData != null) {
//            先压缩后发送(仅适用于移动设备)
            if (Platform.isIOS || Platform.isAndroid) {
              server?.sendIntBytes(await CustomCompressData.fromUintList(
                  Uint8List.view(curSendData!.buffer), null, null, 70));
            } else {
              print('桌面端发送');
              server?.sendIntBytes(Uint8List.view(curSendData!.buffer));
            }

            print('发送数据成功');
          }
        });
      });

      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

//  观看者初始化
  Future<NetWorkBaseState> watcherInit() async {
    NetWorkBaseState state = NetWorkBaseState.Error;
    try {
//      新版写法
      client = CustomSocketClient(
          targetIp: _ipStr,
          targetPort: _portStr,
          onDataReceive: (data) {
            decodePicData(data);
          });

      _isSharing = true;
      _identity = OperationIdentity.Watcher;

      print('观看者初始化成功');
      state = NetWorkBaseState.Sucess;
    } catch (e) {
      print(e);
      return NetWorkBaseState.Exception;
    }

    return state;
  }

//  解析图片数据并显示在图片上
  Uint8List? _currPic = null;

  Uint8List? get currPic => _currPic;

  set currPic(Uint8List? value) {
    _currPic = value;
  }

//  接收方解析数据
  decodePicData(Uint8List? src) {
    if (src != null) {
      _currPic = src;
    } else {
      return;
    }
    notifyListeners();
  }

//  放大镜部分
  bool _isMagnifierOpen = false;
  double _magnifySize = 2.0;
  final _magnifyStep = 0.2;
  MagnifierShape _shape = MagnifierShape.Retangle;

  double get magnifySize => _magnifySize;

  set magnifySize(double value) {
    _magnifySize = value;
  }

  bool get isMagnifierOpen => _isMagnifierOpen;

  set isMagnifierOpen(bool value) {
    _isMagnifierOpen = value;
  }

//  放大镜状态转换
  magnifierStateConverse() {
    _isMagnifierOpen = !_isMagnifierOpen;
    notifyListeners();
  }

//  一次加0.2
  addScale() {
    if (_magnifySize + _magnifyStep <= 5.0) {
      _magnifySize += _magnifyStep;
    }

    notifyListeners();
  }

  //    一次减0.2
  subScale() {
    if (_magnifySize - _magnifyStep >= 1.0) {
      _magnifySize -= _magnifyStep;
    }

    notifyListeners();
  }
}

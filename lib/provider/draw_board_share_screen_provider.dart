import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//连接状态
enum NetWorkBaseState {
  Error,
  Exception,
  Sucess,
}

class DrawBoardShareScreenProvider with ChangeNotifier {
//  是否处于分享状态
  bool _isSharing = false;

  bool get isSharing => _isSharing;

  set isSharing(bool value) {
    _isSharing = value;
  }

  sharingStateConverse() {
    _isSharing = !_isSharing;
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

//  IP和端口号清空
  clearSocketInfo() {
    _ipStr = '';
    _portStr = '';
  }

  RawDatagramSocket? _socket = null;

//  释放连接
  Future<bool> closeConnect()async {
    try{
      _socket?.close();
    }
    catch(e){
      print(e);
      return false;
    }

    return true;
  }

//  共享者初始化
  Future<NetWorkBaseState> sharerInit() async {
    NetWorkBaseState state = NetWorkBaseState.Error;
    try {
      int port = int.parse(_portStr);
      _socket = await RawDatagramSocket.bind(InternetAddress(_ipStr), port)
          .then((value) {
        _socket?.broadcastEnabled = true;
        state = NetWorkBaseState.Sucess;
      });
    } catch (e) {
      print(e);
      return NetWorkBaseState.Exception;
    }

    return state;
  }

//  发送数据
  Future<bool> sendPicData(Picture rawData, int w, int h) async {
    try {
      _currPic = await rawData.toImage(w, h).then((value) async {
        await value.toByteData(format: ImageByteFormat.png).then((value) {
          _socket?.send(Uint8List.view(value!.buffer),
              InternetAddress(_portStr), int.parse(_portStr));
        });
      });
    } catch (e) {
      return false;
    }
    return true;
  }

//  观看者初始化
  Future<NetWorkBaseState> watcherInit() async {
    NetWorkBaseState state = NetWorkBaseState.Error;
    try {
      int port = int.parse(_portStr);
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port)
          .then((value) {
        _socket?.broadcastEnabled = true;
        state = NetWorkBaseState.Sucess;
      });
    } catch (e) {
      print(e);
      return NetWorkBaseState.Exception;
    }
    return state;
  }

//  解析图片数据并显示在图片上
  Uint8List? _currPic = null;

//  接收方解析数据
  decodeReceiveData() {
    final dg = _socket?.receive();
    if (dg != null) {
      _currPic = dg.data;
    }
  }
}

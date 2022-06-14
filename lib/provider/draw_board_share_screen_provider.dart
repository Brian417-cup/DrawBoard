import 'dart:convert';
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
  Future<bool> closeConnect() async {
    try {
      _socket?.close();
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

//  共享者初始化
  Future<NetWorkBaseState> sharerInit() async {
    NetWorkBaseState state = NetWorkBaseState.Sucess;
    try {
      int port = int.parse(_portStr);
      await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, port)
          .then((udpSocket) {
        _socket = udpSocket;
        _socket?.broadcastEnabled = true;
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
      await rawData.toImage(w, h).then((img) async {
        await img.toByteData(format: ImageByteFormat.png).then((curSendData) {
          var temp=_socket?.send(Uint8List.view(curSendData!.buffer),
              InternetAddress('192.168.137.1'), int.parse(_portStr));
          print('数据已发送到${_ipStr}-${_portStr},发送了${temp}');
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
      int port = int.parse(_portStr);
//      _socket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, port)
      _socket =
          await RawDatagramSocket.bind(InternetAddress('10.151.73.216'), port)
              .then((value) {
        state = NetWorkBaseState.Sucess;
      });

      print('观看者初始化成功');
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
//  decodeReceiveData() {
//    print('处理接受数据');
//    _socket?.listen((event) {
//      Future.delayed(Duration(seconds: 2)).then((value) {
//        final dg = _socket?.receive();
//        if (dg != null) {
//          _currPic = dg.data;
//        }
//        print('接收到数据了');
//
//        notifyListeners();
//      });
//    });
//  }
}

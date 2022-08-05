import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

HttpServer? server;
WebSocket? serverSocket;

void main() async {
//  RawDatagramSocket socket =
//      await RawDatagramSocket.bind(InternetAddress('127.0.0.1'), 9999);
//
//  int i = 0;
//
//  Timer.periodic(Duration(milliseconds: 1500), (timer) {
//    socket.send(
//        utf8.encode('我们的歌${i++}'), InternetAddress('192.168.0.105'), 9998);
//    print('我们的歌${i++}');
//  });

  serverBind('192.168.0.105', 9999);

  int i=0;

  Timer.periodic(Duration(milliseconds: 1500), (timer) {
    serverSendMsg('我们的歌${i++}');
  });

}

void serverBind(String ip, int port) async {
  server = await HttpServer.bind(InternetAddress(ip), port);

  server?.listen((event) async {
    print('服务器监听成功');

    if (WebSocketTransformer.isUpgradeRequest(event)) {
      var socket = await WebSocketTransformer.upgrade(event).then((webSocket) {
        webSocket.listen(handleMsg);
        serverSocket = webSocket;
      });
    }
  });
}

void handleMsg(dynamic msg) {
  print('收到客户端消息：$msg');
}

void handleDone() {
  print('Done');
}

void serverSendMsg(String msg) {
  if ((msg == null || serverSocket == null)) {
    return;
  }

  serverSocket?.add(msg);
}

void serverSendDatas(List<int> datas) {
  if (datas == null || serverSocket == null) {
    return;
  }
  serverSocket?.add(datas);
}

void serverSendVideoFrameSteam(var dataBytes) {
  if (dataBytes == null || serverSocket == null) {
    return null;
  }
  var msg = Stream.value(dataBytes);

  bool isContinueSendSteam = true;
  if (!isContinueSendSteam) {
    return;
  }
  isContinueSendSteam = false;
  serverSocket?.addStream(msg).then((_) {
    isContinueSendSteam = true;
  });
}

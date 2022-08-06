import 'dart:async';
import 'dart:convert';
import 'dart:io';

//客户端原型

WebSocket? clientSocket;

void main() async{
//  RawDatagramSocket socket =
//      await RawDatagramSocket.bind(InternetAddress('192.168.0.105'), 9998);
//
////  Timer.periodic(Duration(milliseconds: 1500), (timer) {
//    socket.listen((event) {
//      if (event==RawSocketEvent.read) {
//        Datagram? dg= socket.receive();
//        print('有读入数据');
//        if (dg!=null) {
//          print('收到的数据:'+utf8.decode(dg.data));
//        }
//      }
//
//    });
////  });

    clientConnect('ws://192.168.0.105:9999');



}

void clientConnect(String url) async{
//  客户端连接到服务器
  clientSocket = await WebSocket.connect(url);
  clientSocket?.listen((msg) {

    clientReceiveMsg(msg);
  });
}

void clientSendMsg(String msg){

  if (clientSocket==null) {
    return;
  }

  clientSocket?.add(msg);
}

void clientReceiveMsg(String msg){
  print('收到的数据为${msg}');

}
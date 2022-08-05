import 'dart:async';
import 'dart:io';

class CustomSocketClient {
  WebSocket? _clientSocket;
  String targetIp = '';
  String targetPort = '';


  Function(dynamic data) onDataReceive;

  CustomSocketClient(
      {required String this.targetIp,
      required String this.targetPort,
      required this.onDataReceive}) {
    _connect(targetIp, targetPort);
  }

  //  客户端连接服务器
  void _connect(String ip, String port) async {
    String url = 'ws://${targetIp}:${targetPort}';

    _clientSocket = await WebSocket.connect(url);
    _clientSocket?.listen((data) {
      //处理接收到的数据
      onDataReceive(data);
    });
  }

  void sendStr(String msg) {
    if (_clientSocket == null) {
      return;
    }
    _clientSocket?.add(msg);
  }

  void sendBytes(dataBytes) {
    if (dataBytes == null || _clientSocket == null) {
      return null;
    }

    var datas = Stream.value(dataBytes);
    bool isContinueSendSteam = true;
    if (!isContinueSendSteam) {
      return;
    }
    isContinueSendSteam = false;
    _clientSocket?.addStream(datas).then((_) {
      isContinueSendSteam = true;
    });
  }

  Future closeConnection() async {
    await _clientSocket?.close();
  }
}

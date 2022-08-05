import 'dart:io';

class CustomSocketServer {
  HttpServer? _server;
  WebSocket? _serverSocket;
  Function(dynamic data)? onFeedBackOfClient;

  CustomSocketServer({this.onFeedBackOfClient});

  void serverBind(String? ip, int port) async {
    _server = await HttpServer.bind(
        ip == null ? InternetAddress.anyIPv4 : InternetAddress(ip), port);

    _server?.listen((request) async {
      print('服务器正在监听中...');

      if (WebSocketTransformer.isUpgradeRequest(request)) {
        var tmpSocket =
            await WebSocketTransformer.upgrade(request).then((webSocket) {
          _serverSocket = webSocket;
          if (onFeedBackOfClient == null) {
            _serverSocket?.listen(handleDataFeedBack);
          } else {
            _serverSocket?.listen(onFeedBackOfClient);
          }
        });
      }
    });
  }

  void handleDataFeedBack(dynamic data) {
    print('收到客户端的消息为:${data}');
    if (onFeedBackOfClient != null) {
      onFeedBackOfClient!(data);
    }
  }

  void handleDone() {
    print('处理完成');
  }

  void sendStr(String data) {
    if (data == null || _serverSocket == null) {
      return;
    }

    _serverSocket?.add(data);
  }

  void sendIntBytes(List<int> datas) {
    if (datas == null || _serverSocket == null) {
      return;
    }
    _serverSocket?.add(datas);
  }

  void sendStream(var dataBytes) {
    if (dataBytes == null || _serverSocket == null) {
      return null;
    }
    var msg = Stream.value(dataBytes);

    bool isContinueSendSteam = true;
    if (!isContinueSendSteam) {
      return;
    }
    isContinueSendSteam = false;
    _serverSocket?.addStream(msg).then((_) {
      isContinueSendSteam = true;
    });
  }

  Future close() async {
    await _serverSocket?.close().then((value) async {
      await _server?.close();
    });
  }
}

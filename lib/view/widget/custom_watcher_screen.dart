import 'dart:typed_data';

import 'package:flutter/material.dart';

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
      body:
          widget.picData == null ? Container(color: Colors.blue,) : Image.memory(widget.picData!),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
//          待开发放大镜功能
          FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.zoom_in,
              size: 35,
            ),
          )
        ],
      ),
    );
  }
}

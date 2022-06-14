import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gallery_saver/files.dart';

class DrawBoardSaverProvider with ChangeNotifier {
  bool _needSaver = false;

  bool get needSaver => _needSaver;

  set needSaver(bool value) {
    _needSaver = value;
  }

  saverToImg(Picture rawData, int w, int h) async {
    await rawData.toImage(w, h).then((img) async {
      await img.toByteData(format: ImageByteFormat.png).then((curData) async {
        final pngBytes = curData?.buffer.asUint8List();
        final imgFile = File('${DateTime.now().millisecond}');
        imgFile.writeAsBytes(List.from(pngBytes!));
        bool isSuccess = false;
        try {
          isSuccess = await GallerySaver.saveImage(imgFile.path)
              .then((_success) => _success ?? false);

          if (isSuccess) {
            print('保存成功!!');
          }
        } catch (e) {
          print(e);
        }
      });
    });

    needSaver = false;
    notifyListeners();
  }
}

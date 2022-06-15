import 'dart:io';
import 'dart:ui';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

enum SaverResult { Success, Error, Exception }

class DrawBoardSaverProvider with ChangeNotifier {
  bool _needSaver = false;

  bool get needSaver => _needSaver;

  set needSaver(bool value) {
    _needSaver = value;
  }

  Future<SaverResult> saverToImg(Picture rawData, int w, int h) async {
    needSaver = false;
    notifyListeners();

    if (!Platform.isAndroid && !Platform.isIOS) {
      return SaverResult.Error;
    }



    return await rawData.toImage(w, h).then((img) async {
      return await img
          .toByteData(format: ImageByteFormat.png)
          .then((curData) async {
        final pngBytes = curData?.buffer.asUint8List();
        dynamic isSuccess;
        try {
          if (await Permission.storage.request().isGranted) {
            final savePath = '${DateTime.now()}_drawboard_saver';
            isSuccess = await ImageGallerySaver.saveImage(pngBytes!,
                quality: 100, name: savePath);
          }

          if (Platform.isIOS) {
            if (isSuccess) {
              print('保存成功');

              return SaverResult.Success;
            } else {
              return SaverResult.Error;
            }
          } else {
            if (isSuccess != null) {
              print('保存成功');
              return SaverResult.Success;
            } else {
              return SaverResult.Error;
            }
          }
        } catch (e) {
          print(e);
          return SaverResult.Exception;
        }
      });
    });
  }
}

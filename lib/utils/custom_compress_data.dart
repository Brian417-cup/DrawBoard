import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

//仅适用于苹果和安卓移动端平台
class CustomCompressData {
  static Future<Uint8List?> fromFile(
      File file, int minWith, int minHeight, int compressQuality) async {
    Uint8List? result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: minWith,
      minHeight: minHeight,
      quality: compressQuality,
    ).then((result) {
      print(file.lengthSync());
      print(result?.length);
      return result;
    });

    return result;
  }

  static Future<Uint8List?> fromAsset(
      String assetName, int minWith, int minHeight, int compressQuality) async {
    Uint8List? list = await FlutterImageCompress.compressAssetImage(
      assetName,
      minHeight: minHeight,
      minWidth: minWith,
      quality: compressQuality,
    );

    return list;
  }

  static Future<Uint8List> fromUintList(Uint8List compressedData,
      int? minWith, int? minHeight, int compressQuality) async {
    Uint8List result = await FlutterImageCompress.compressWithList(
      compressedData,
      minHeight: minHeight == null ? 1920 : minHeight!,
      minWidth: minWith == null ? 1080 : minWith,
      quality: compressQuality,
    );
    print(compressedData.length);
    print(result.length);
    return result;
  }
}

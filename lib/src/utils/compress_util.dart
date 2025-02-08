import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class CompressUtil {
  static int minHeight = 480; // 指定最小分辨率的高度
  static int minWidth = 320; // 指定最小分辨率的宽度

  /// 压缩方式一 Uint8List -> Uint8List
  static Future<Uint8List> u8ToU8(Uint8List list) async {
    int quality = imageQuality(list.length);
    Uint8List result = await FlutterImageCompress.compressWithList(
      list,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );
    debugPrint("压缩后图片的大小：${size(result.length)}");
    return result;
  }

  /// 压缩方式二 File -> File
  static Future<File?> fileToFile(File file) async {
    // 图片质量
    int quality = imageQuality(file.readAsBytesSync().length);
    // 缓存路径
    Directory cache = await getTemporaryDirectory();
    int time = DateTime.now().millisecondsSinceEpoch;
    String savePath = "${cache.path}/AllenSu_$time.jpg";
    XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      savePath,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );
    if (result != null) {
      var res = File(result.path);
      debugPrint("压缩后图片的大小：${size(res.readAsBytesSync().length)}");
      return res;
    }
    return null;
  }

  /// 压缩方式三 File -> Uint8List
  static Future<Uint8List?> fileToU8(File file) async {
    // 图片质量
    int quality = imageQuality(file.readAsBytesSync().length);
    Uint8List? result = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );
    if (result != null) {
      debugPrint("压缩后图片的大小：${size(result.length)}");
    }
    return result;
  }

  /// 压缩方式四 Asset -> Uint8List
  static Future<Uint8List?> assetToU8(String assetName) async {
    File file = File(assetName);
    // 图片质量
    int quality = imageQuality(file.readAsBytesSync().length);
    Uint8List? result = await FlutterImageCompress.compressAssetImage(
      assetName,
      minWidth: minWidth,
      minHeight: minHeight,
      quality: quality,
    );
    if (result != null) {
      debugPrint("压缩后图片的大小：${size(result.length)}");
    }
    return result!;
  }

  /// 根据传入的图片字节长度，返回指定的图片质量
  static int imageQuality(int length) {
    debugPrint("压缩前图片的大小：${size(length)}");
    int quality = 100; // 图片质量指数
    int m = 1024 * 1024; // 1 兆
    if (length < 0.5 * m) {
      quality = 90;
      debugPrint("图片小于 0.5 兆，质量设置为 90");
    } else if (length >= 0.5 * m && length < 1 * m) {
      quality = 80;
      debugPrint("图片大于 0.5 兆小于 1 兆，质量设置为 80");
    } else if (length >= 1 * m && length < 2 * m) {
      quality = 65;
      debugPrint("图片大于 1 兆小于 2 兆，质量设置为 65");
    } else if (length >= 2 * m && length < 3 * m) {
      quality = 50;
      debugPrint("图片大于 2 兆小于 3 兆，质量设置为 50");
    } else if (length >= 3 * m && length < 4 * m) {
      quality = 30;
      debugPrint("图片大于 3 兆小于 4 兆，质量设置为 30");
    } else {
      quality = 20;
      debugPrint("图片大于 4 兆，质量设置为 20");
    }
    return quality;
  }

  /// 根据传入的字节长度，转换成相应的 M 和 KB
  static String size(int length) {
    String res = "";
    const int unit = 1024;
    const int m = unit * unit; // 1M
    // 如果小于 1 兆，显示 KB
    if (length < 1 * m) {
      res = "${(length / unit).toStringAsFixed(0)} KB";
    }
    // 如果大于 1 兆，显示 MB，并保留一位小数
    if (length >= 1 * m) {
      res = "${(length / m).toStringAsFixed(1)} MB";
    }
    return res;
  }
}

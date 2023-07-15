import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class GetImageBytes {
  static Future<Uint8List?> getBytesImage(String url) async {
    final response = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes), // Set the response type to `bytes`.
    );

    if (response.data != null) {
      return Uint8List.fromList(response.data!);
    }
    return null;
  }
}

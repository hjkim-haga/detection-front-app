/*
요청은 body에 다음과 같은 3가지 항목을 지녀야 한다.
  "button": 2,  // 0: ocr, 1: cfr, 2: obj
  "rsc": "sample-images/naver_cfr_test1.jpg",  // 실제는 영상 이미지.
  "protocol": "rpc"  // "rpc", "api" 두 가지가 가능.


요청이 거부되는데 web server에는 문제가 없을 때
(pub upgrade 등을 하면 원래대로 돌아갈 때가 있음):
  1. Go to flutter\bin\cache and remove a file named 'flutter_tools.stamp.
  2. Go to flutter\packages\flutter_tools\lib\src\web and open the file 'chrome.dart'.
  3. Find '--disable-extensions'
  4. Add '--disable-web-security'
 */

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

const int ocr = 0;
const int cfr = 1;
const int obj = 1;

/// button:[0, 1, 2], protocol: ['rpc', 'api']
Future<http.Response> fetchInference(
    int button, XFile resource, String protocol) async {
  const String address = 'http://211.184.186.118:8000/';

  // Encode the image.
  print('type: ${resource.readAsBytes().runtimeType}');

  // New method: trying.
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Access-Control-Allow-Origin': '*',
  };

  http.Response response = await http.post(
    Uri.parse(address),
    headers: headers,
    body: jsonEncode({
      'button': button,
      'rsc': base64Encode(await File(resource.path).readAsBytesSync()),
      'protocol': protocol,
    }),
  );
  if (response.statusCode == 200) {
    // response.body.runtimeType == String,
    // response.bodyBytes.runtimeType == Uint8List
    return response;
  } else {
    throw Exception('Failed to create byte stream.');
  }
}

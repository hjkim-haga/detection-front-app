import 'package:flutter/material.dart';
import 'package:my_first_flutter/comm.dart';
import 'package:my_first_flutter/result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var whichInfer = [true, false, false];
  Image dummyImage = Image.asset('assets/s3.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inference Request Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: dummyImage,
            ),
            ElevatedButton(
              child: const Text('Upload Image'),
              onPressed: () {},
            ),
            const SizedBox(
              height: 25,
            ),
            ToggleButtons(
              children: const <Widget>[
                Icon(Icons.book),
                Icon(Icons.cake),
                Icon(Icons.face),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < whichInfer.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      whichInfer[buttonIndex] = true;
                    } else {
                      whichInfer[buttonIndex] = false;
                    }
                  }
                });
              },
              isSelected: whichInfer,
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                onPressed: () async {
                  // Send API.
                  // Image image = openImage('');
                  // 버튼이 눌리면 그에 맞는 음성 '문자 인식', '표정 인식', '사물 인식' 재생.
                  int inferType = whichInfer.indexOf(true);
                  var response = await fetchInference(
                      inferType, 'naver_ocr_test1.png', 'rpc');
                  // String result = jsonDecode(utf8.decode(response.bodyBytes));
                  // response.body.runtimeType == String
                  // response.bodyBytes.runtimeType == Uint8List
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ResultPage(result: response.bodyBytes)),
                  );
                },
                child: const Text('Inference')),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_first_flutter/comm.dart';
import 'package:my_first_flutter/result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var whichInfer = [true, false, false];
  XFile? _image = XFile('assets/error.png');
  Image placeholderImage = Image.file(
    File('assets/error.png'),
    fit: BoxFit.scaleDown,
  );
  final ImagePicker _picker = ImagePicker();
  late AudioPlayer _player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inference Request Page'),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: placeholderImage,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50)),
                    child: const Text(
                      'Camera',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onPressed: () {
                      getImageFromSource(ImageSource.camera);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50)),
                      onPressed: () {
                        getImageFromSource(ImageSource.gallery);
                      },
                      child: const Text('Gallery',
                          style: TextStyle(fontSize: 16.0))),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: ToggleButtons(
                constraints: BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 50) / 3,
                    minHeight: MediaQuery.of(context).size.width / 8),
                children: [
                  GestureDetector(
                    child: Icon(Icons.document_scanner_outlined),
                    onLongPress: () {
                      print('Optical Character Recognition.');
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.face_outlined),
                    onLongPress: () {
                      print('CLOVA Face Recognition.');
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.wallpaper_outlined),
                    onLongPress: () {
                      print('Object Detection.');
                    },
                  ),
                ],
                onPressed: (int index) async {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < whichInfer.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        whichInfer[buttonIndex] = true;
                        print('## index: $buttonIndex');
                      } else {
                        whichInfer[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: whichInfer,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    maximumSize: const Size(200, 80)),
                onPressed: () async {
                  int inferType = whichInfer.indexOf(true);
                  var response =
                      await fetchInference(inferType, _image!, 'rpc');
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
                child: const Text(
                  'Inference',
                  style: TextStyle(fontSize: 20.0),
                )),
          ],
        ),
      ),
    );
  }

  /// source: {ImageSource.camera, ImageSource.gallery}
  Future getImageFromSource(ImageSource source) async {
    // TODO (me): orientation 적용해서 원래 시점대로 영상 맞출 것.
    var orientation = MediaQuery.of(context).orientation;
    XFile? image = await _picker.pickImage(source: source);
    setState(() {
      _image = image;
      placeholderImage = Image.file(
        File(_image!.path),
        fit: BoxFit.scaleDown,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  Future<void> dispose() async {
    super.dispose(); //change here
    await _player.stop();
  }
}

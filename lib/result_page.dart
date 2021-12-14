import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_first_flutter/audio_source.dart';

class ResultPage extends StatefulWidget {
  final Uint8List result;

  ResultPage({Key? key, required this.result}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  IconData playingIcon = Icons.play_circle_outline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inference Result Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                child: Icon(playingIcon),
                onPressed: () {
                  // TODO (me): 배속도 가능해야 함. 자동 재생도.
                  BufferAudioSource source = BufferAudioSource(widget.result);
                  player.setAudioSource(source);
                  if (isPlaying) {
                    player.stop();
                    setState(() {
                      playingIcon = Icons.play_circle_filled_rounded;
                    });
                  } else {
                    player.play();
                    setState(() {
                      playingIcon = Icons.pause_circle_filled_rounded;
                    });
                  }
                  isPlaying = !isPlaying;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  child: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose(); //change here
    await player.stop();
  }
}

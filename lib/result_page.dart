import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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
                  // TODO (me):화면이 넘어가면 재생 종료 dispose.
                  // 배속도 가능해야 함. 자동 재생도.
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

class BufferAudioSource extends StreamAudioSource {
  final Uint8List _buffer;

  BufferAudioSource(this._buffer) : super();

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) {
    start = start ?? 0;
    end = end ?? _buffer.length;

    return Future.value(
      StreamAudioResponse(
        sourceLength: _buffer.length,
        contentLength: end - start,
        offset: start,
        contentType: 'audio/mpeg',
        stream:
            Stream.value(List<int>.from(_buffer.skip(start).take(end - start))),
      ),
    );
  }
}

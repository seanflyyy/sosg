import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

import 'widgets/bottom_buttons_row.dart';
import 'widgets/card_overlay.dart';
import 'widgets/example_card.dart';

const _colors = [
  Colors.orange,
  Colors.blue,
  Colors.red,
  Colors.purple,
  Colors.amber,
  Colors.deepOrange,
  Colors.lightBlue,
  Colors.pink,
  Colors.deepPurple,
  Colors.cyan,
  Colors.yellow,
  Colors.indigo,
  Colors.green,
  Colors.lime
];

const _audio = [
  'audio1.mp3',
  'audio2.mp3',
  'audio3.mp3',
  'audio4.wav',
  'audio5.wav',
  'audio6.wav',
  'audio7.wav',
  'audio8.wav',
  'audio9.wav',
  'audio10.mp3',
  'audio11.mp3',
  'audio12.mp3',
  'audio13.mp3',
  'audio14.mp3',
];

class BasicExample extends StatefulWidget {
  const BasicExample({Key? key}) : super(key: key);

  @override
  _BasicExampleState createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  late final SwipableStackController _controller;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    audioCache = AudioCache(fixedPlayer: audioPlayer);
    _controller = SwipableStackController()..addListener(_listenController);
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearAll();
    _controller.removeListener(_listenController);
    _controller.dispose();
  }

  void playMusic(int index) async {
    // final rng = Random();
    // final audioFolderSize = _audio.length;
    // final randomNumber = rng.nextInt(audioFolderSize);
    await audioCache.play(_audio[index % _colors.length]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwipableStack(
                  controller: _controller,
                  stackClipBehaviour: Clip.none,
                  onSwipeCompleted: (index, direction) {
                    print('$index, $direction');
                    // print("playing audio");
                    playMusic(index);
                  },
                  horizontalSwipeThreshold: 0.8,
                  verticalSwipeThreshold: 0.8,
                  overlayBuilder: (
                    context,
                    constraints,
                    index,
                    direction,
                    swipeProgress,
                  ) =>
                      CardOverlay(
                    swipeProgress: swipeProgress,
                    direction: direction,
                  ),
                  builder: (context, index, constraints) {
                    final itemIndex = index % _colors.length;
                    return ExampleCard(
                      playSong: () => playMusic(index - 1),
                      name: 'Card ${itemIndex + 1}',
                      containerColor: _colors[itemIndex],
                    );
                  },
                ),
              ),
            ),
            BottomButtonsRow(
              onSwipe: (direction) {
                _controller.next(swipeDirection: direction);
              },
              onRewindTap: _controller.rewind,
              canRewind: _controller.canRewind,
            ),
          ],
        ),
      ),
    );
  }
}

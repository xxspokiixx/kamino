import 'package:chewie_nbtx/chewie_nbtx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PlayerView extends StatefulWidget {

  final String url;

  PlayerView({
    Key key,
    @required this.url
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerViewState();

}

class _PlayerViewState extends State<PlayerView> {

  Chewie _player;

  @override
  void initState() {
    super.initState();

    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    // Hide SystemUI overlays
    SystemChrome.setEnabledSystemUIOverlays([]);

    // Change progress color to white to make it more visible.
    ChewieProgressColors _progressColors = ChewieProgressColors(
      playedColor: const Color(0xFFFFFFFF),
      handleColor: const Color(0xFFFFFFFF)
    );

    // Instantiate the player.
    _player = new Chewie(
      new VideoPlayerController.network(
          widget.url
      ),
      autoPlay: true,
      looping: false,
      materialProgressColors: _progressColors,
      cupertinoProgressColors: _progressColors,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _player
    );
  }

  @override
  void dispose() {
    super.dispose();

    // Re-enable System UI overlays.
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    // Allow all rotations.
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    // Dispose of player.
    _player.controller.dispose();
  }

}
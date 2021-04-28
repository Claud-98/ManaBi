import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final double size;

  VideoPlayerWidget({Key key, @required this.videoUrl, this.size})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _controller;
  String _videoUrl;
  double _size;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _videoUrl = widget.videoUrl;
    _size = widget.size;
    _controller = VideoPlayerController.network(_videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    _controller.setLooping(false);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translatedStrings = AppLocalizations.of(context);

    return Container(
      height: _size,
      width: _size,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_controller.value.duration != Duration.zero)
              return GestureDetector(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                onDoubleTap: () async {
                  await _controller.seekTo(Duration.zero);
                  setState(() {
                    _controller.play();
                  });
                },
              );
            else
              return Center(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3.25,
                      child: Container(
                          height: _size,
                          width: _size,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/error_img.png"),
                                  fit: BoxFit.fill))),
                    ),
                    AutoSizeText(
                      translatedStrings.genericErrorMessage,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

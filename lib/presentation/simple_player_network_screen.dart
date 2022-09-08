import 'package:simple_player/model/simple_player_settings.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class SimplePlayerNetworkScrren extends StatefulWidget {
  final SimplePlayerSettings simplePlayerSettings;
  const SimplePlayerNetworkScrren(
      {Key? key, required this.simplePlayerSettings})
      : super(key: key);

  @override
  State<SimplePlayerNetworkScrren> createState() =>
      _SimplePlayerNetworkScrrenState();
}

class _SimplePlayerNetworkScrrenState extends State<SimplePlayerNetworkScrren>
    with SingleTickerProviderStateMixin {
  //Classes and Packages
  late SimplePlayerSettings simplePlayerSettings;

  //Attributes
  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;
  double _currentSeconds = 0.0;
  double _totalSeconds = 0.0;
  bool _isFullscreen = false;
  bool _isMuted = true;

  Future<bool> _fullScreenManager() {
    if (_isFullscreen) {
      _exitFullscreen();
      return Future.value(false);
    }
    return Future.value(true);
  }

  _jumpTo(double value) {
    _videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
  }

  _muteToggle() {
    if (_isMuted) {
      _videoPlayerController.setVolume(1.0);
    } else {
      _videoPlayerController.setVolume(0.0);
    }
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  _playToggle() {
    if (_videoPlayerController.value.isPlaying) {
      _animationController.reverse();
      _videoPlayerController.pause();
    } else {
      _animationController.forward();
      _videoPlayerController.play();
    }
  }

  _enterFullscreen() {}
  _exitFullscreen() {}

  _secondsListener() {
    _videoPlayerController.addListener(() {
      setState(() {
        _currentSeconds =
            _videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });
  }

  _initializeInterface() {
    //Controllers
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400));
    _videoPlayerController = VideoPlayerController.network(
        simplePlayerSettings.url!)
      ..initialize().then((_) => setState(() {
            _totalSeconds =
                _videoPlayerController.value.duration.inMilliseconds.toDouble();
            _videoPlayerController.setLooping(true);
            _videoPlayerController.setVolume(0.5);
          }));

    //Methods
    _secondsListener();
  }

  @override
  void initState() {
    simplePlayerSettings = widget.simplePlayerSettings;
    _initializeInterface();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _fullScreenManager(),
      child: Center(
        child: AspectRatio(
          aspectRatio: simplePlayerSettings.aspectRatio!,
          child: Stack(
            children: [
              VideoPlayer(_videoPlayerController),
              Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        children: [
                          IconButton(
                            icon: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                color: Colors.white,
                                progress: _animationController),
                            onPressed: () => _playToggle(),
                          ),
                          Expanded(
                            child: Slider(
                              value: _currentSeconds,
                              min: 0,
                              max: _totalSeconds,
                              // label: label,
                              activeColor: Colors.orangeAccent,
                              // divisions: 20, // divisor de numero exato
                              onChanged: (double value) {
                                _jumpTo(value);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                                _isMuted ? Icons.volume_mute : Icons.volume_up,
                                color: Colors.white),
                            onPressed: () {
                              _muteToggle();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

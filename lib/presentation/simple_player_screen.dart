import 'package:simple_player/aplication/simple_aplication.dart';
import 'package:simple_player/model/simple_player_settings.dart';
import 'package:simple_player/model/simple_player_state.dart';
import 'package:simple_player/presentation/simple_player_fullscreen.dart';
import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class SimplePlayerScrren extends StatefulWidget {
  final SimplePlayerSettings simplePlayerSettings;
  const SimplePlayerScrren({Key? key, required this.simplePlayerSettings})
      : super(key: key);

  @override
  State<SimplePlayerScrren> createState() => _SimplePlayerScrrenState();
}

class _SimplePlayerScrrenState extends State<SimplePlayerScrren>
    with SingleTickerProviderStateMixin {
  //Classes and Packages
  late SimplePlayerSettings simplePlayerSettings;
  SimpleAplication simpleAplication = SimpleAplication();

  //Attributes
  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;
  double? _currentSeconds = 0.0;
  double? _totalSeconds = 0.0;
  String? _tittle = '';
  bool? _loopMode = true;
  bool? _isMuted = true;

  _fullScreenManager() {
    final sps = SimplePlayerState(currentSenconds: _currentSeconds);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimplePlayerFullScreen(
              simplePlayerSettings: simplePlayerSettings,
              simplePlayerState: sps),
        )).then((value) {
      print('back');
    });
  }

  _jumpTo(double value) {
    _videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
  }

  _muteToggle() {
    if (_isMuted!) {
      _videoPlayerController.setVolume(1.0);
    } else {
      _videoPlayerController.setVolume(0.0);
    }
    setState(() {
      _isMuted = !_isMuted!;
    });
  }

  _playAndPauseSwitch() {
    bool playing = _videoPlayerController.value.isPlaying;
    if (playing) {
      //pause
      _animationController.reverse();
      _videoPlayerController.pause();
    } else {
      //play
      _animationController.forward();
      _videoPlayerController.play();
    }
  }

  _setupControllers(SimplePlayerSettings simplePlayerSettings) {
    //Video controller
    _videoPlayerController = simpleAplication.getControler(simplePlayerSettings)
      ..initialize().then(
        (_) => setState(
          () {
            _totalSeconds =
                _videoPlayerController.value.duration.inMilliseconds.toDouble();
            _videoPlayerController.setLooping(_loopMode!);
            _videoPlayerController.setVolume(0.0);
          },
        ),
      );

    //Icons controller
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400));
  }

  _secondsListener() {
    _videoPlayerController.addListener(() {
      setState(() {
        _currentSeconds =
            _videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });
  }

  _initializeInterface() {
    simplePlayerSettings = widget.simplePlayerSettings;
    setState(() {
      _loopMode = simplePlayerSettings.autoPlay!;
      _tittle = simplePlayerSettings.label;
    });

    //Methods
    _setupControllers(simplePlayerSettings);
    _secondsListener();
  }

  @override
  void initState() {
    _initializeInterface();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: simplePlayerSettings.aspectRatio!,
        child: Stack(
          children: [
            VideoPlayer(_videoPlayerController),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      _tittle!,
                      style: TextStyle(color: Colors.white),
                    ),
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
                          onPressed: () => _playAndPauseSwitch(),
                        ),
                        Expanded(
                          child: Slider(
                            value: _currentSeconds!,
                            max: _totalSeconds!,
                            min: 0,
                            label: _currentSeconds.toString(),
                            activeColor: Colors.orangeAccent,
                            onChanged: (double value) {
                              _jumpTo(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                              _isMuted! ? Icons.volume_mute : Icons.volume_up,
                              color: Colors.white),
                          onPressed: () {
                            _muteToggle();
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.fullscreen, color: Colors.white),
                          onPressed: () => _fullScreenManager(),
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
    );
  }

  //Finalize resources
  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    super.dispose();
  }
}

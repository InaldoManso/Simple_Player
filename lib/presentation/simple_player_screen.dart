import 'package:simple_player/presentation/widgets/settings_screen.dart';
import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';
import '../aplication/simple_aplication.dart';
import '../model/simple_player_settings.dart';
import '../model/simple_player_state.dart';
import 'simple_player_fullscreen.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../core/date_formatter.dart';
import 'dart:async';

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
  SimpleAplication simpleAplication = SimpleAplication();
  late SimplePlayerSettings simplePlayerSettings;
  Constants constants = Constants();

  //Attributes
  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;
  double? _currentSeconds = 0.0;
  double? _totalSeconds = 0.0;
  double? _speed = 1.0;
  String? _showTime = '-:-';
  String? _tittle = '';
  bool? _visibleControls = true;
  bool? _visibleSettings = false;
  bool? _autoPlay = false;
  bool? _loopMode = false;
  bool? _wasPlaying = false;
  bool? _confortMode = false;
  Color? _colorAccent = Colors.red;

  _showScreenSettings() {
    bool playing = _videoPlayerController.value.isPlaying;
    if (_visibleSettings! && !playing) {
      //play
      if (_wasPlaying!) {
        _playAndPauseSwitch();
        setState(() => _visibleSettings = false);
      } else {
        setState(() => _visibleSettings = false);
        _showAndHideControls(true);
      }
    } else if (!_visibleSettings! && playing) {
      //pause
      _playAndPauseSwitch();
      setState(() => _visibleSettings = true);
    } else if (!_visibleSettings!) {
      setState(() => _visibleSettings = true);
      _showAndHideControls(false);
    }
  }

  double _aspectRatioManager(VideoPlayerController controller) {
    if (simplePlayerSettings.forceAspectRatio!) {
      return simplePlayerSettings.aspectRatio!;
    } else {
      return controller.value.aspectRatio;
    }
  }

  _showAndHideControls(bool show) {
    setState(() {
      _visibleControls = show;
    });
  }

  _speedSetter(double? speed) async {
    setState(() => _speed = speed);
    _videoPlayerController.setPlaybackSpeed(speed!);
  }

  _autoPlayChecker(bool? autoPlay) {
    if (autoPlay!) {
      _animationController.forward();
      _videoPlayerController.play();
      _wasPlaying = true;
    }
  }

  _fullScreenManager() {
    SimplePlayerState simplePlayerState = SimplePlayerState(
        currentSeconds: _currentSeconds,
        totalSeconds: _totalSeconds,
        speed: _speed,
        showTime: _showTime,
        label: _tittle,
        autoPlay: _autoPlay,
        loopMode: _loopMode,
        wasPlaying: _videoPlayerController.value.isPlaying,
        confortMode: _confortMode);

    if (_videoPlayerController.value.isPlaying) _playAndPauseSwitch();

    //LockRotation
    simpleAplication.lockAndUnlockScreen(true);
    //FullScreenActivate
    simpleAplication.hideNavigation(true).then((value) {
      Timer(const Duration(milliseconds: 50), () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimplePlayerFullScreen(
                  simplePlayerSettings: simplePlayerSettings,
                  simplePlayerState: simplePlayerState),
            )).then((value) {
          _lastState(value);
        });
      });
    });
  }

  _lastState(SimplePlayerState simplePlayerState) {
    //Retrieves and inserts the last state of the previous screen
    bool playing = false;
    setState(() {
      _speed = simplePlayerState.speed;
      _tittle = simplePlayerState.label;
      _wasPlaying = simplePlayerState.wasPlaying;
      _confortMode = simplePlayerState.confortMode;
      playing = simplePlayerState.wasPlaying!;
    });

    _jumpTo(simplePlayerState.currentSeconds!);
    _speedSetter(simplePlayerState.speed);

    if (playing) {
      _playAndPauseSwitch();
    }
  }

  _jumpTo(double value) {
    _videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
  }

  _playAndPauseSwitch({bool pauseButton = false}) {
    bool playing = _videoPlayerController.value.isPlaying;
    if (playing) {
      //pause
      if (pauseButton) {
        _wasPlaying = !playing;
      } else {
        _wasPlaying = playing;
      }
      _animationController.reverse();
      _videoPlayerController.pause();
    } else {
      //play
      _wasPlaying = playing;
      _animationController.forward();
      _videoPlayerController.play();
      Timer(const Duration(seconds: 1), () => _showAndHideControls(false));
    }
  }

  _screenTap() {
    if (_visibleControls!) {
      _showAndHideControls(false);
    } else {
      _showAndHideControls(true);
    }
  }

  _setupControllers(SimplePlayerSettings simplePlayerSettings) {
    //Video controller
    _videoPlayerController = simpleAplication.getControler(simplePlayerSettings)
      ..initialize().then(
        (_) {
          setState(() {
            _totalSeconds =
                _videoPlayerController.value.duration.inMilliseconds.toDouble();
            _videoPlayerController.setLooping(_loopMode!);
          });

          //Methods after settings
          _autoPlayChecker(_autoPlay);
        },
      );

    //Icons controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );
  }

  _secondsListener() {
    _videoPlayerController.addListener(
      () {
        bool playing = _videoPlayerController.value.isPlaying;
        if (_currentSeconds == _totalSeconds && !playing) {
          _showAndHideControls(true);
          _animationController.reverse();
          _jumpTo(0.0);
        }
        setState(() {
          _currentSeconds =
              _videoPlayerController.value.position.inMilliseconds.toDouble();
          _showTime = DateFormatter()
              .currentTime(_videoPlayerController.value.position);
        });
      },
    );
  }

  _initializeInterface() {
    setState(() {
      simplePlayerSettings = widget.simplePlayerSettings;
      _tittle = widget.simplePlayerSettings.label;
      _autoPlay = widget.simplePlayerSettings.autoPlay!;
      _loopMode = widget.simplePlayerSettings.loopMode!;
      _colorAccent = widget.simplePlayerSettings.colorAccent;
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AspectRatio(
      aspectRatio: simplePlayerSettings.aspectRatio!,
      child: Container(
        width: width,
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _aspectRatioManager(_videoPlayerController),
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _visibleControls!
                    ? GestureDetector(
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          key: const ValueKey('a'),
                          color: _confortMode!
                              ? Colors.deepOrange.withOpacity(0.1)
                              : Colors.black.withOpacity(0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      _tittle!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                            offset: Offset(3.0, 2.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(
                                      Icons.settings_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _showScreenSettings();
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Center(
                                  child: IconButton(
                                      icon: AnimatedIcon(
                                          size: 40,
                                          color: Colors.white,
                                          icon: AnimatedIcons.play_pause,
                                          progress: _animationController),
                                      onPressed: () => _playAndPauseSwitch(
                                          pauseButton: true)),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(_showTime!,
                                          style: const TextStyle(
                                              color: Colors.white))),
                                  Expanded(
                                      child: SliderTheme(
                                    data: constants.getSliderThemeData(
                                        colorAccent: _colorAccent),
                                    child: Slider.adaptive(
                                      value: _currentSeconds!,
                                      max: _totalSeconds!,
                                      min: 0,
                                      label: _currentSeconds.toString(),
                                      onChanged: (double value) {
                                        _jumpTo(value);
                                      },
                                    ),
                                  )),
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _fullScreenManager(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () => _screenTap(),
                      )
                    : GestureDetector(
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          key: const ValueKey('b'),
                          color: _confortMode!
                              ? Colors.deepOrange.withOpacity(0.1)
                              : Colors.transparent,
                          height: height,
                        ),
                        onTap: () => _screenTap(),
                      ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _visibleSettings!
                  ? SettingsScreen(
                      colorAccent: _colorAccent!,
                      speed: _speed!,
                      confortModeOn: _confortMode!,
                      onExit: () => _showScreenSettings(),
                      confortClicked: (value) =>
                          setState(() => _confortMode = value),
                      speedSelected: (value) => _speedSetter(value),
                    )
                  : const SizedBox(width: 1, height: 1),
            ),
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

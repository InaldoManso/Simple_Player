import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';
import '../aplication/simple_aplication.dart';
import '../model/simple_player_state.dart';
import 'package:flutter/material.dart';
import 'widgets/settings_screen.dart';
import '../core/date_formatter.dart';
import '../constants/constants.dart';
import 'dart:async';

class SimplePlayerFullScreen extends StatefulWidget {
  final SimpleController simpleController;
  final SimplePlayerSettings simplePlayerSettings;
  final SimplePlayerState simplePlayerState;
  const SimplePlayerFullScreen(
      {Key? key,
      required this.simpleController,
      required this.simplePlayerSettings,
      required this.simplePlayerState})
      : super(key: key);

  @override
  State<SimplePlayerFullScreen> createState() => _SimplePlayerFullScreenState();
}

class _SimplePlayerFullScreenState extends State<SimplePlayerFullScreen>
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
  bool? _visibleSettings = false;
  bool? _visibleControls = true;
  bool? _wasPlaying = false;
  bool? _confortMode = false;
  Color? _colorAccent = Colors.red;

  //Control settings block display.
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

  //Controls whether or not to force image distortion.
  double _aspectRatioManager(VideoPlayerController controller) {
    if (simplePlayerSettings.forceAspectRatio!) {
      return simplePlayerSettings.aspectRatio!;
    } else {
      return controller.value.aspectRatio;
    }
  }

  //Controls the display of simple controls.
  _showAndHideControls(bool show) {
    setState(() {
      _visibleControls = show;
    });
  }

  //Controls the video playback speed.
  _speedSetter(double? speed) async {
    setState(() => _speed = speed);
    _videoPlayerController.setPlaybackSpeed(speed!);
  }

  //Responsible for sending all data to the environment in full screen.
  _fullScreenManager() {
    //UnlockRotation
    simpleAplication.lockAndUnlockScreen(false);
    //FullScreenDisable
    simpleAplication.hideNavigation(false);

    SimplePlayerState simplePlayerState = SimplePlayerState(
        currentSeconds: _currentSeconds,
        totalSeconds: _totalSeconds,
        speed: _speed,
        showTime: _showTime,
        label: _tittle,
        autoPlay: simplePlayerSettings.autoPlay,
        loopMode: simplePlayerSettings.loopMode,
        wasPlaying: _videoPlayerController.value.isPlaying,
        confortMode: _confortMode);

    Navigator.pop(context, simplePlayerState);
  }

  //Retrieves and inserts the last state of the previous screen
  _lastState() {
    SimplePlayerState simplePlayerState = widget.simplePlayerState;

    setState(() {
      _speed = simplePlayerState.speed;
      _tittle = simplePlayerState.label;
      _wasPlaying = simplePlayerState.wasPlaying;
      _confortMode = simplePlayerState.confortMode;
    });

    _videoPlayerController.setLooping(simplePlayerState.loopMode!);
    _jumpTo(simplePlayerState.currentSeconds!);
    _speedSetter(simplePlayerState.speed);
  }

  // Sends playback to the specified point.
  _jumpTo(double value) {
    _videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));

    if (_wasPlaying!) {
      _playAndPauseSwitch();
    }
  }

  // Extremely precise control of all animations
  // in conjunction with play and pause of playback.
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

  //Treat screen tapping to show or hide simple controllers.
  _screenTap() {
    if (_visibleControls!) {
      _showAndHideControls(false);
    } else {
      _showAndHideControls(true);
    }
  }

  //Responsible for correct initialization of all controllers.
  _setupControllers(SimplePlayerSettings simplePlayerSettings) {
    //Video controller
    _videoPlayerController = simpleAplication.getControler(simplePlayerSettings)
      ..initialize().then(
        (_) {
          setState(() {
            _totalSeconds =
                _videoPlayerController.value.duration.inMilliseconds.toDouble();
          });

          //Methods after settings
          _lastState();
        },
      );

    //Icons controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );
  }

  //Update the real-time seconds counter on replay.
  _secondsListener() {
    _videoPlayerController.addListener(
      () {
        widget.simpleController.updateController(_videoPlayerController);
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

  //Shows or hides the HUB from controller commands.
  _listenerPlayFromController() {
    String changeTime = '';
    widget.simpleController.listenPlayAndPause().listen((event) {
      if (changeTime != event) {
        bool playing = _videoPlayerController.value.isPlaying;
        if (playing) {
          _showAndHideControls(false);
        } else {
          _showAndHideControls(true);
        }
        changeTime = event;
      }
    });
  }

  //Responsible for starting the interface
  _initializeInterface() {
    simplePlayerSettings = widget.simplePlayerSettings;

    setState(() {
      _colorAccent = simplePlayerSettings.colorAccent;
    });

    //Methods
    _setupControllers(simplePlayerSettings);
    _secondsListener();
    _listenerPlayFromController();
  }

  @override
  void initState() {
    _initializeInterface();
    super.initState();
  }

  @override
  void dispose() {
    _dismissConstrollers();
    super.dispose();
  }

  //Finalize resources
  _dismissConstrollers() async {
    _animationController.stop();
    _animationController.dispose();
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.black,
      child: RotatedBox(
        quarterTurns: 1,
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
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
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
                                        padding:
                                            const EdgeInsets.only(left: 16),
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
                                        Icons.fullscreen_exit,
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
      ),
    );
  }
}

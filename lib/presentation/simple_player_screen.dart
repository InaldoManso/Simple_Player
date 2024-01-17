import 'package:simple_player/model/simple_player_state.dart';
import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';
import '../aplication/simple_aplication.dart';
import 'simple_player_fullscreen.dart';
import 'package:flutter/material.dart';
import 'widgets/settings_screen.dart';
import '../constants/constants.dart';
import '../core/date_formatter.dart';
import 'dart:async';

class SimplePlayerScrren extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final SimplePlayerSettings simplePlayerSettings;
  final SimpleController simpleController;
  const SimplePlayerScrren(
      {Key? key,
      required this.simpleController,
      required this.simplePlayerSettings,
      required this.videoPlayerController})
      : super(key: key);

  @override
  State<SimplePlayerScrren> createState() => _SimplePlayerScrrenState();
}

class _SimplePlayerScrrenState extends State<SimplePlayerScrren>
    with SingleTickerProviderStateMixin {
  /// Classes and Packages
  SimpleAplication simpleAplication = SimpleAplication();

  /// Attributes
  late StreamSubscription streamSubscription;
  late AnimationController animationController;
  Color colorAccent = Colors.red;
  bool visibleSettings = false;
  bool visibleControls = true;
  bool confortMode = false;
  bool wasPlaying = false;
  bool autoPlay = false;
  String showTime = '00:00';
  String tittle = '';
  double currentSeconds = 0.0;
  double totalSeconds = 0.0;
  double speed = 1.0;

  ///  Sends playback to the specified point.
  jumpTo(double value) {
    widget.videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
  }

  /// Shows or hides the HUB from controller commands.
  listenerPlayFromController() {
    String changeTime = '';
    streamSubscription =
        widget.simpleController.listenPlayAndPause().listen((event) {
      if (changeTime != event) {
        bool playing = widget.videoPlayerController.value.isPlaying;
        if (playing) {
          showControls(false);
        } else {
          showControls(true);
        }
        changeTime = event;
      }
    });
  }

  ///  Extremely precise control of all animations
  ///  in conjunction with play and pause of playback.
  playAndPauseSwitch({bool pauseButton = false}) {
    bool playing = widget.videoPlayerController.value.isPlaying;

    if (widget.videoPlayerController.value.isPlaying) {
      /// pause
      widget.videoPlayerController.pause();
      animationController.reverse();
    } else {
      /// play
      widget.videoPlayerController.play();
      animationController.forward();

      /// Configure a Delay to hide the interface controls
      Timer(const Duration(seconds: 1), () => showControls(false));
    }
  }

  /// Controls the display of simple controls.
  showControls(bool show) {
    setState(() => visibleControls = show);
  }

  /// Responsible for sending all data to the environment in full screen.
  fullScreenManager() {
    /// LockRotation
    double ratio = widget.videoPlayerController.value.aspectRatio;
    simpleAplication.lockAndUnlockScreen(lock: true, aspectRatio: ratio);

    /// FullScreenActivate
    simpleAplication.hideNavigation(true).then((value) {
      Timer(const Duration(milliseconds: 50), () {
        /// Send to FullScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SimplePlayerFullScreen(
              videoPlayerController: widget.videoPlayerController,
              simplePlayerSettings: widget.simplePlayerSettings,
              simpleController: widget.simpleController,
              simplePlayerState: SimplePlayerState(confortMode: confortMode),
            ),
          ),
        ).then((value) {
          SimplePlayerState simplePlayerState = value;
          setState(() {
            confortMode = simplePlayerState.confortMode;
          });
        });
      });
    });
  }

  /// Treat screen tapping to show or hide simple controllers.
  screenTap() {
    setState(() => visibleControls = !visibleControls);
  }

  /// Control settings block display.
  showScreenSettings() {
    /// Saves if the video was playing
    /// to play again after leaving the settings menu
    bool playing = widget.videoPlayerController.value.isPlaying;

    if (visibleSettings) {
      /// Hide Settings
      /// Show Controls
      /// Play Video if was playing

      setState(() => visibleSettings = false);
      showControls(true);

      if (wasPlaying) {
        playAndPauseSwitch();
        wasPlaying = false;
      }
    } else if (!visibleSettings) {
      /// Show Settings
      /// Hide Controls
      /// Pause video if was playing

      setState(() => visibleSettings = true);
      showControls(false);

      if (playing) {
        playAndPauseSwitch();
        wasPlaying = playing;
      }
    }
  }

  /// Controls whether or not to force image distortion.
  double aspectRatioManager(VideoPlayerController controller) {
    /// Check if there is a predefined AspectRatio
    if (widget.simplePlayerSettings.forceAspectRatio) {
      return widget.simplePlayerSettings.aspectRatio;
    } else {
      return controller.value.aspectRatio;
    }
  }

  /// Controls the video playback speed.
  speedSetter(double speedChange) async {
    setState(() => speed = speedChange);
    widget.videoPlayerController.setPlaybackSpeed(speed);
  }

  /// Checks if the video should be displayed in looping.
  autoPlayChecker(bool? autoPlay) {
    if (autoPlay!) {
      animationController.forward();
      widget.videoPlayerController.play();
      showControls(false);
    }
  }

  /// Responsible for correct initialization of all controllers.
  setupControllers() {
    /// Icons controller
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );

    /// Update Seconds
    setState(() {
      totalSeconds =
          widget.videoPlayerController.value.duration.inMilliseconds.toDouble();
    });

    print("loop mode: ${widget.simplePlayerSettings.loopMode}");

    /// Methods after settings
    widget.videoPlayerController
        .setLooping(widget.simplePlayerSettings.loopMode);
    autoPlayChecker(autoPlay);
  }

  /// Update the real-time seconds counter on replay.
  secondsListener() {
    bool loopActive = widget.simplePlayerSettings.loopMode;

    widget.videoPlayerController.addListener(
      () {
        widget.simpleController.updateController(widget.videoPlayerController);

        /// Check if the video is over
        if (currentSeconds == totalSeconds && !loopActive) {
          showControls(true);
          animationController.reverse();
          jumpTo(0.0);
        }

        setState(() {
          currentSeconds = widget
              .videoPlayerController.value.position.inMilliseconds
              .toDouble();
          showTime = DateFormatter()
              .currentTime(widget.videoPlayerController.value.position);
        });
      },
    );
  }

  /// Responsible for starting the interface
  initializeInterface() async {
    setState(() {
      tittle = widget.simplePlayerSettings.label;
      autoPlay = widget.simplePlayerSettings.autoPlay;
      colorAccent = widget.simplePlayerSettings.colorAccent;
    });

    //// Methods
    /// The above code is written in the Dart programming language. It appears to be a comment that is
    /// indicating the presence of a function called "secondsListener". However, since the code is
    /// commented out, the function is not being executed or used in the current code.
    secondsListener();
    setupControllers();
    listenerPlayFromController();
  }

  @override
  void initState() {
    /// Method responsible for initializing
    /// all methods in the correct order
    initializeInterface();
    super.initState();
  }

  @override
  void dispose() {
    _dismissConstrollers();
    super.dispose();
  }

  /// Finalize resources
  _dismissConstrollers() async {
    animationController.stop();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AspectRatio(
      aspectRatio: widget.simplePlayerSettings.aspectRatio,
      child: Container(
        width: width,
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: aspectRatioManager(widget.videoPlayerController),
                child: VideoPlayer(
                  widget.videoPlayerController,
                ),
              ),
            ),
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: visibleControls
                    ? GestureDetector(
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          key: const ValueKey('a'),
                          color: confortMode
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
                                      tittle,
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
                                      showScreenSettings();
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
                                      progress: animationController,
                                    ),
                                    onPressed: () =>
                                        playAndPauseSwitch(pauseButton: true),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      showTime,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                      child: SliderTheme(
                                    data: Constants.getSliderThemeData(
                                        colorAccent: colorAccent),
                                    child: Slider.adaptive(
                                      value: currentSeconds!,
                                      max: totalSeconds!,
                                      min: 0,
                                      label: currentSeconds.toString(),
                                      onChanged: (double value) {
                                        jumpTo(value);
                                      },
                                    ),
                                  )),
                                  IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => fullScreenManager(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () => screenTap(),
                      )
                    : GestureDetector(
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          key: const ValueKey('b'),
                          color: confortMode
                              ? Colors.deepOrange.withOpacity(0.1)
                              : Colors.transparent,
                          height: height,
                        ),
                        onTap: () => screenTap(),
                      ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: visibleSettings
                  ? SettingsScreen(
                      tittle: tittle,
                      colorAccent: colorAccent,
                      speed: speed,
                      confortModeOn: confortMode,
                      onExit: () => showScreenSettings(),
                      speedSelected: (value) => speedSetter(value),
                      confortMode: (value) =>
                          setState(() => confortMode = value),
                    )
                  : const SizedBox(width: 1, height: 1),
            ),
          ],
        ),
      ),
    );
  }
}

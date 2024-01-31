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
  /// The jumpTo function seeks the video player controller to a specific time in milliseconds.
  ///
  /// Args:
  ///   value (double): The value parameter is a double representing the time in milliseconds to jump to
  /// in the video.
  jumpTo(double value) {
    widget.videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
  }

  /// Shows or hides the HUB from controller commands.
  /// The function `listenerPlayFromController()` listens for play and pause events from a
  /// `simpleController` and updates the visibility of controls based on the current playback state.
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
  /// The function `playAndPauseSwitch` toggles between playing and pausing a video and also controls the
  /// visibility of interface controls.
  ///
  /// Args:
  ///   pauseButton (bool): The `pauseButton` parameter is a boolean value that indicates whether the
  /// pause button is currently pressed or not. It is set to `false` by default. Defaults to false
  playAndPauseSwitch({bool pauseButton = false}) {
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
  /// The `fullScreenManager()` function manages the full-screen functionality of a video player in a Dart
  /// application.
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
              simplePlayerState: SimplePlayerState(
                confortMode: confortMode,
                showTime: showTime,
              ),
            ),
          ),
        ).then((value) {
          SimplePlayerState simplePlayerState = value;
          setState(() {
            confortMode = simplePlayerState.confortMode;
            showTime = simplePlayerState.showTime;
          });
        });
      });
    });
  }

  /// Treat screen tapping to show or hide simple controllers.
  /// The screenTap function toggles the visibility of controls in the UI.
  screenTap() {
    setState(() => visibleControls = !visibleControls);
  }

  /// Control settings block display.
  /// The function `showScreenSettings()` toggles the visibility of the settings menu, hides or shows the
  /// controls accordingly, and pauses or resumes the video playback based on its previous state.
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
  /// The function `aspectRatioManager` returns the aspect ratio of a video player controller, either
  /// using a predefined aspect ratio or the aspect ratio of the controller itself.
  ///
  /// Args:
  ///   controller (VideoPlayerController): The `controller` parameter is an instance of the
  /// `VideoPlayerController` class. It is used to control the playback of a video and retrieve
  /// information about the video, such as its aspect ratio.
  ///
  /// Returns:
  ///   The method `aspectRatioManager` returns a double value.
  double aspectRatioManager(VideoPlayerController controller) {
    /// Check if there is a predefined AspectRatio
    if (widget.simplePlayerSettings.forceAspectRatio) {
      return widget.simplePlayerSettings.aspectRatio;
    } else {
      return controller.value.aspectRatio;
    }
  }

  /// Controls the video playback speed.
  /// The function `speedSetter` updates the playback speed of a video player and updates the state of the
  /// widget.
  ///
  /// Args:
  ///   speedChange (double): The speedChange parameter is a double value that represents the new playback
  /// speed that you want to set for the video player.
  speedSetter(double speedChange) async {
    setState(() => speed = speedChange);
    widget.videoPlayerController.setPlaybackSpeed(speed);
  }

  /// Checks if the video should be displayed in looping.
  /// The function `autoPlayChecker` checks if `autoPlay` is true, and if so, it forwards the animation
  /// controller, plays the video player controller, and hides the controls.
  ///
  /// Args:
  ///   autoPlay (bool): The autoPlay parameter is a boolean value that indicates whether the video should
  /// automatically start playing or not.
  autoPlayChecker(bool? autoPlay) {
    if (autoPlay!) {
      animationController.forward();
      widget.videoPlayerController.play();
      showControls(false);
    }
  }

  /// Responsible for correct initialization of all controllers.
  /// The function `setupControllers()` sets up the animation controller, updates the total seconds of the
  /// video, sets the loop mode of the video player controller, and checks if auto play is enabled.
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

    /// Methods after settings
    widget.videoPlayerController
        .setLooping(widget.simplePlayerSettings.loopMode);
    autoPlayChecker(autoPlay);
  }

  /// Update the real-time seconds counter on replay.
  /// The `secondsListener` function updates the current playback time and checks if the video is over,
  /// based on the `videoPlayerController` and `loopActive` settings.
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

  /// The function `_dismissControllers()` stops and disposes an animation controller.
  _dismissConstrollers() async {
    animationController.stop();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// The above code is retrieving the height and width of the device's screen using the `MediaQuery`
    /// class in Dart. It is storing the height in the `height` variable and the width in the `width`
    /// variable.
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
                                      value: currentSeconds,
                                      max: totalSeconds,
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

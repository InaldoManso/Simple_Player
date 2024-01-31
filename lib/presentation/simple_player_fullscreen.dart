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
  final VideoPlayerController videoPlayerController;
  final SimplePlayerSettings simplePlayerSettings;
  final SimpleController simpleController;
  final SimplePlayerState simplePlayerState;

  const SimplePlayerFullScreen({
    Key? key,
    required this.videoPlayerController,
    required this.simplePlayerSettings,
    required this.simpleController,
    required this.simplePlayerState,
  }) : super(key: key);

  @override
  State<SimplePlayerFullScreen> createState() => _SimplePlayerFullScreenState();
}

class _SimplePlayerFullScreenState extends State<SimplePlayerFullScreen>
    with SingleTickerProviderStateMixin {
  /// Classes and Packages
  SimpleAplication simpleAplication = SimpleAplication();

  /// Attributes
  late AnimationController animationController;
  late VideoPlayerController localController;
  Color colorAccent = Colors.red;
  bool visibleSettings = false;
  bool visibleControls = true;
  bool confortMode = false;
  bool wasPlaying = false;
  bool autoPlay = false;
  bool loopMode = false;
  bool disposed = false;
  String showTime = '00:00';
  String tittle = '';
  double currentSeconds = 0.0;
  double totalSeconds = 0.0;
  double speed = 1.0;

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

  ///  Extremely precise control of all animations
  ///  in conjunction with play and pause of playback.
  /// The function `playAndPauseSwitch` toggles between playing and pausing a video, and also hides the
  /// interface controls after a delay.
  ///
  /// Args:
  ///   pauseButton (bool): A boolean value indicating whether the pause button is pressed or not.
  /// Defaults to false
  playAndPauseSwitch({bool pauseButton = false}) {
    bool playing = widget.videoPlayerController.value.isPlaying;

    if (widget.videoPlayerController.value.isPlaying) {
      /// pause
      if (pauseButton) {
        wasPlaying = !playing;
      } else {
        wasPlaying = playing;
      }
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

  /// Shows or hides the HUB from controller commands.
  /// The function listens for play and pause events from a controller and updates the visibility of
  /// controls accordingly.
  listenerPlayFromController() {
    String changeTime = '';
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

  /// Controls whether or not to force image distortion.
  /// The function `aspectRatioManager` returns the aspect ratio of a video player controller, either
  /// using a predefined aspect ratio or the aspect ratio of the controller's value.
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

  /// Responsible for correct initialization of all controllers.
  /// The function sets up controllers for icons and updates the total seconds of the video player.
  setupControllers() {
    /// Icons controller
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );

    if (widget.videoPlayerController.value.isPlaying) {
      animationController.forward();
    } else {
      animationController.reverse();
    }

    /// Update Seconds
    setState(() {
      totalSeconds =
          widget.videoPlayerController.value.duration.inMilliseconds.toDouble();
    });
  }

  /// Responsible for sending all data to the environment in full screen.
  /// The `fullScreenManager` function disables full screen mode, shows the navigation bar, and unlocks
  /// screen rotation.
  fullScreenManager() async {
    /// FullScreenDisable
    await simpleAplication.hideNavigation(false);

    /// UnlockRotation
    simpleAplication.lockAndUnlockScreen(lock: false).then((value) {
      Navigator.pop(
        context,
        SimplePlayerState(
          confortMode: confortMode,
          showTime: showTime,
        ),
      );
    });
  }

  /// Controls the display of simple controls.
  /// The function `showControls` updates the visibility of controls in the UI.
  ///
  /// Args:
  ///   show (bool): A boolean value indicating whether the controls should be shown or hidden.
  showControls(bool show) {
    setState(() => visibleControls = show);
  }

  ///  Sends playback to the specified point.
  /// The jumpTo function seeks the video player controller to a specific time in milliseconds.
  ///
  /// Args:
  ///   value (double): The value parameter is a double value representing the time in milliseconds to
  /// jump to in the video.
  jumpTo(double value) {
    widget.videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
  }

  /// Treat screen tapping to show or hide simple controllers.
  /// The screenTap function toggles the visibility of controls in the UI.
  screenTap() {
    setState(() => visibleControls = !visibleControls);
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

  /// The function `configureRotation()` checks the aspect ratio of a video being played back and locks or
  /// unlocks the screen orientation accordingly.
  configureRotation() {
    /// Check the Aspect Ratio of the video
    /// being played back to define whether
    /// to keep the display in landscape or portrait mode

    double ratio = widget.videoPlayerController.value.aspectRatio;
    simpleAplication.lockAndUnlockScreen(lock: true, aspectRatio: ratio);
  }

  /// Update the real-time seconds counter on replay.
  /// The `secondsListener` function updates the current time and show time of a video player controller,
  /// and checks if the video is over to show controls and reset the animation.
  secondsListener() {
    widget.videoPlayerController.addListener(
      () {
        if (!disposed) {
          widget.simpleController
              .updateController(widget.videoPlayerController);

          /// Check if the video is over
          bool playing = widget.videoPlayerController.value.isPlaying;
          if (currentSeconds == totalSeconds && !playing) {
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
        }
      },
    );
  }

  /// Responsible for starting the interface
  initializeInterface() {
    setState(() {
      tittle = widget.simplePlayerSettings.label;
      autoPlay = widget.simplePlayerSettings.autoPlay;
      loopMode = widget.simplePlayerSettings.loopMode;
      colorAccent = widget.simplePlayerSettings.colorAccent;
      confortMode = widget.simplePlayerState.confortMode;
      showTime = widget.simplePlayerState.showTime;
    });

    /// Methods
    setupControllers();
    secondsListener();
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
  /// The function `_dismissControllers()` stops and disposes an animation controller.
  _dismissConstrollers() async {
    disposed = true;
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

    return WillPopScope(
      onWillPop: () async {
        fullScreenManager();
        return false;
      },
      child: Material(
        color: Colors.black,
        child: Container(
          width: width,
          color: Colors.black,
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatioManager(widget.videoPlayerController),
                  child: VideoPlayer(widget.videoPlayerController),
                ),
              ),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
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
                                            progress: animationController),
                                        onPressed: () => playAndPauseSwitch(
                                            pauseButton: true)),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Text(showTime,
                                            style: const TextStyle(
                                                color: Colors.white))),
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
                                      ),
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(
                                        Icons.fullscreen_exit,
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
                        confortMode: (value) =>
                            setState(() => confortMode = value),
                        speedSelected: (value) => speedSetter(value),
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

import 'package:simple_player/presentation/simple_player_fullscreen.dart';
import 'package:simple_player/aplication/simple_aplication.dart';
import 'package:simple_player/model/simple_player_settings.dart';
import 'package:simple_player/model/simple_player_state.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
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
  late SimplePlayerSettings simplePlayerSettings;
  SimpleAplication simpleAplication = SimpleAplication();

  //Attributes
  SnappingSheetController _snappingSheetController = SnappingSheetController();
  late VideoPlayerController _videoPlayerController;
  // late VideoPlayerController _videoPlayerController2;
  late AnimationController _animationController;
  double? _currentSeconds = 0.0;
  double? _totalSeconds = 0.0;
  double? _lastVolume = 0.0;
  double? _volume = 0.0;
  double? _speed = 1.0;
  String? _tittle = '';
  bool? _completedAnimation = false;
  bool? _visibleControls = false;
  bool? _autoPlay = true;
  bool? _loopMode = true;
  bool? _isMuted = false;

  //Default
  final SnappingPosition _initPosition = const SnappingPosition.factor(
      positionFactor: 0.6, grabbingContentOffset: GrabbingContentOffset.bottom);

  _volumeSetter(double? volume) async {
    _volume = volume;
    _videoPlayerController.setVolume(volume!);
  }

  _speedSetter(double? speed) async {
    _speed = speed;
    _videoPlayerController.setPlaybackSpeed(speed!);
  }

  _muteToggle() {
    if (_isMuted!) {
      _volumeSetter(_lastVolume);
    } else {
      _lastVolume = _volume;

      _volumeSetter(0.0);
    }
    setState(() {
      _lastVolume = _lastVolume;
      _isMuted = !_isMuted!;
    });
  }

  _visibleControlManager(double position) {
    if (position < 0.3 && !_visibleControls!) {
      setState(() {
        _visibleControls = true;
      });
    } else if (position > 0.3 && _visibleControls!) {
      setState(() {
        _visibleControls = false;
      });
    }
  }

  _sheetMove(double position) {
    bool playing = _videoPlayerController.value.isPlaying;
    if (position > 0.5 && !playing && _completedAnimation!) {
      _playAndPauseSwitch();
    } else if (position < 0.5 && playing && _completedAnimation!) {
      _playAndPauseSwitch();
    }
  }

  _autoPlayChecker(bool? autoPlay) {
    if (autoPlay!) {
      _animationController.forward();
      _videoPlayerController.play();
    }
  }

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

  _animateSheet() {
    Timer(const Duration(milliseconds: 700), () {
      _snappingSheetController
          .snapToPosition(
        const SnappingPosition.factor(
            positionFactor: 1.0,
            snappingCurve: Curves.bounceOut,
            snappingDuration: Duration(milliseconds: 700),
            grabbingContentOffset: GrabbingContentOffset.bottom),
      )
          .then((value) {
        Timer(const Duration(milliseconds: 200), () {
          _completedAnimation = true;
        });
      });
    });
  }

  _setupControllers(SimplePlayerSettings simplePlayerSettings) {
    //Video controller
    _videoPlayerController = simpleAplication.getControler(simplePlayerSettings)
      ..initialize().then((_) {
        setState(() {
          _totalSeconds =
              _videoPlayerController.value.duration.inMilliseconds.toDouble();
          _videoPlayerController.setLooping(_loopMode!);
          _videoPlayerController.setVolume(0.0);
        });
        _autoPlayChecker(_autoPlay);
        _volumeSetter(0.3);
      });

    //Icons controller
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400));
  }

  _secondsListener() {
    _videoPlayerController.addListener(
      () {
        setState(() {
          _currentSeconds =
              _videoPlayerController.value.position.inMilliseconds.toDouble();
        });
        bool playing = _videoPlayerController.value.isPlaying;

        if (_currentSeconds == _totalSeconds && !playing) {
          _animationController.reverse();
          _jumpTo(0.0);
        }
      },
    );
  }

  _initializeInterface() {
    simplePlayerSettings = widget.simplePlayerSettings;
    setState(() {
      _tittle = simplePlayerSettings.label;
      _autoPlay = simplePlayerSettings.autoPlay!;
      _loopMode = simplePlayerSettings.loopMode!;
    });

    //Methods
    _setupControllers(simplePlayerSettings);
    _secondsListener();
    _animateSheet();
  }

  @override
  void initState() {
    _initializeInterface();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: AspectRatio(
        aspectRatio: simplePlayerSettings.aspectRatio!,
        child: SnappingSheet.horizontal(
          controller: _snappingSheetController,
          initialSnappingPosition: _initPosition,
          snappingPositions: const [
            SnappingPosition.factor(
                //right position:
                positionFactor: 0.0,
                snappingCurve: Curves.easeOutExpo,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.top),
            SnappingPosition.factor(
                //left position:
                positionFactor: 1.0,
                snappingCurve: Curves.easeOutExpo,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.bottom),
          ],
          onSheetMoved: (sheetPositionData) {
            _visibleControlManager(
                sheetPositionData.relativeToSnappingPositions);
          },
          onSnapCompleted: (sheetPosition, snappingPosition) {
            _sheetMove(sheetPosition.relativeToSnappingPositions);
          },
          grabbingWidth: width * 0.15,
          grabbing: Container(
            color: Colors.transparent,
            // color: Colors.black.withOpacity(0.5),
            // child: Row(
            //   children: [
            //     IconButton(
            //       icon: AnimatedIcon(
            //           icon: AnimatedIcons.play_pause,
            //           color: Colors.white,
            //           progress: _animationController),
            //       onPressed: () => _playAndPauseSwitch(),
            //     ),
            //     Expanded(
            //       child: Slider(
            //         value: _currentSeconds!,
            //         max: _totalSeconds!,
            //         min: 0,
            //         label: _currentSeconds.toString(),
            //         activeColor: Colors.orangeAccent,
            //         onChanged: (double value) {
            //           _jumpTo(value);
            //         },
            //       ),
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.fullscreen, color: Colors.white),
            //       onPressed: () => _fullScreenManager(),
            //     ),
            //   ],
            // ),
          ),
          sheetRight: SnappingSheetContent(
            sizeBehavior: const SheetSizeFill(),
            draggable: false,
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
              child: Visibility(
                visible: _visibleControls!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('Volume:',
                          style: TextStyle(color: Colors.white)),
                    ),
                    Slider(
                      value: _volume!,
                      max: 1.0,
                      min: 0.0,
                      divisions: 20,
                      label: simpleAplication.volumeConvert(_volume!),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.white,
                      onChanged: (double value) {
                        _volumeSetter(value);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('Velocidade de reprodução:',
                          style: TextStyle(color: Colors.white)),
                    ),
                    Slider(
                      value: _speed!,
                      max: 2.0,
                      min: 0.1,
                      divisions: 19,
                      label: simpleAplication.speedConvert(_speed!),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.white,
                      onChanged: (double value) {
                        _speedSetter(value);
                      },
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                                _isMuted! ? Icons.volume_mute : Icons.volume_up,
                                color: Colors.white),
                            onPressed: () {
                              _muteToggle();
                            },
                          ),
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 20,
                              icon: const Icon(
                                Icons.replay_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _speedSetter(1.0);
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          child: VideoPlayer(_videoPlayerController),
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

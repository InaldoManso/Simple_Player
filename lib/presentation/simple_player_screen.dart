import 'package:simple_player/core/date_formatter.dart';
import 'package:simple_player/presentation/simple_player_fullscreen.dart';
import 'package:simple_player/aplication/simple_aplication.dart';
import 'package:simple_player/model/simple_player_settings.dart';
import 'package:simple_player/model/simple_player_state.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:simple_player/simple_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
  final SnappingSheetController _snappingSheetController =
      SnappingSheetController();
  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;
  double? _currentSeconds = 0.0;
  double? _totalSeconds = 0.0;
  double? _lastVolume = 0.0;
  double? _volume = 0.0;
  double? _speed = 1.0;
  String? _showTime = '-:-';
  String? _tittle = '';
  bool? _visibleSheetControls = false;
  bool? _visibleControls = true;
  bool? _autoPlay = true;
  bool? _loopMode = true;
  bool? _isMuted = false;
  bool? _wasPlaying = false;
  bool? _confortMode = false;

  //Default
  final SnappingPosition _initPosition = const SnappingPosition.factor(
      positionFactor: 1.0, grabbingContentOffset: GrabbingContentOffset.bottom);

  _showAndHideControls(bool show) {
    setState(() {
      _visibleControls = show;
    });
  }

  _volumeSetter(double? volume) async {
    _volume = volume;
    _videoPlayerController.setVolume(volume!);

    if (volume > 0.0 && _isMuted!) {
      setState(() => _isMuted = false);
    } else if (volume == 0.0) {
      setState(() => _isMuted = true);
    }
  }

  _speedSetter(double? speed) async {
    setState(() => _speed = speed);
    _videoPlayerController.setPlaybackSpeed(speed!);
  }

  _confortToggle() {
    if (_confortMode!) {
      setState(() => _confortMode = false);
    } else {
      setState(() => _confortMode = true);
    }
  }

  _muteToggle() {
    if (_isMuted!) {
      _volumeSetter(_lastVolume);
      setState(() => _isMuted = false);
    } else {
      _lastVolume = _volume;
      _volumeSetter(0.0);
      setState(() => _isMuted = true);
    }
  }

  _visibleControlManager(double position) {
    if (position < 0.3 && !_visibleSheetControls!) {
      setState(() {
        _visibleSheetControls = true;
      });
    } else if (position > 0.3 && _visibleSheetControls!) {
      setState(() {
        _visibleSheetControls = false;
      });
    }
  }

  _sheetMove(double position) {
    bool playing = _videoPlayerController.value.isPlaying;
    if (position > 0.5 && !playing) {
      //play
      if (_wasPlaying!) {
        _playAndPauseSwitch();
      } else {
        _showAndHideControls(true);
      }
    } else if (position < 0.5 && playing) {
      //pause
      _playAndPauseSwitch();
    }
  }

  _autoPlayChecker(bool? autoPlay) {
    if (autoPlay!) {
      _animationController.forward();
      _videoPlayerController.play();
      _wasPlaying = true;
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
        )).then((value) {});
  }

  _jumpTo(double value) {
    _videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
  }

  _playAndPauseSwitch() {
    bool playing = _videoPlayerController.value.isPlaying;
    if (playing) {
      //pause
      _wasPlaying = playing;
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

  _sheetTap() {
    print('tap');
    if (_visibleSheetControls!) {
      _snappingSheetController.snapToPosition(const SnappingPosition.factor(
          positionFactor: 1.0,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(milliseconds: 500),
          grabbingContentOffset: GrabbingContentOffset.bottom));
    }
    if (_visibleControls!) {
      _showAndHideControls(false);
    } else {
      _showAndHideControls(true);
    }
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

        //After settings
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
        bool playing = _videoPlayerController.value.isPlaying;
        if (_currentSeconds == _totalSeconds && !playing) {
          _showAndHideControls(true);
          _animationController.reverse();
          _jumpTo(0.0);
        }
        double minutes =
            _videoPlayerController.value.position.inMinutes.toDouble();
        int seconds = _videoPlayerController.value.position.inSeconds;
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
    simplePlayerSettings = widget.simplePlayerSettings;
    setState(() {
      _tittle = simplePlayerSettings.label;
      _autoPlay = simplePlayerSettings.autoPlay!;
      _loopMode = simplePlayerSettings.loopMode!;
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
    return Center(
      child: AspectRatio(
        aspectRatio: simplePlayerSettings.aspectRatio!,
        child: SnappingSheet.horizontal(
          controller: _snappingSheetController,
          initialSnappingPosition: _initPosition,
          snappingPositions: const [
            SnappingPosition.factor(
                //left position:
                positionFactor: 0.2,
                snappingCurve: Curves.easeOutCirc,
                snappingDuration: Duration(milliseconds: 700),
                grabbingContentOffset: GrabbingContentOffset.top),
            SnappingPosition.factor(
                //right position:
                positionFactor: 1.0,
                snappingCurve: Curves.easeOutExpo,
                snappingDuration: Duration(milliseconds: 300),
                grabbingContentOffset: GrabbingContentOffset.bottom),
          ],
          onSheetMoved: (sheetPositionData) {
            double position = sheetPositionData.relativeToSnappingPositions;
            _visibleControlManager(position);
            if (_visibleControls! && position < 0.8) {
              _showAndHideControls(false);
            }
          },
          onSnapCompleted: (sheetPosition, snappingPosition) {
            _sheetMove(sheetPosition.relativeToSnappingPositions);
          },
          sheetLeft: SnappingSheetContent(
            draggable: true,
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(top: 50),
                margin: const EdgeInsets.only(bottom: 50),
                child: Visibility(
                  visible: _visibleControls!,
                  child: Center(
                    child: IconButton(
                      icon: AnimatedIcon(
                          size: 40,
                          color: Colors.white,
                          icon: AnimatedIcons.play_pause,
                          progress: _animationController),
                      onPressed: () => _playAndPauseSwitch(),
                    ),
                  ),
                ),
              ),
              onTap: () => _sheetTap(),
            ),
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
                visible: _visibleSheetControls!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('Volume:',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SliderTheme(
                      data: _sliderTheme(),
                      child: Slider(
                        value: _volume!,
                        max: 1.0,
                        min: 0.0,
                        divisions: 20,
                        label: simpleAplication.volumeConvert(_volume!),
                        onChanged: (double value) {
                          _volumeSetter(value);
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text('Velocidade de reprodução:',
                          style: TextStyle(color: Colors.white)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: TextButton(
                                child: Text('0.5x',
                                    style: TextStyle(
                                        color: _speed == 0.5
                                            ? Colors.red
                                            : Colors.white)),
                                onPressed: () => _speedSetter(0.5))),
                        Expanded(
                            child: TextButton(
                                child: Text('1.0x',
                                    style: TextStyle(
                                        color: _speed == 1.0
                                            ? Colors.red
                                            : Colors.white)),
                                onPressed: () => _speedSetter(1.0))),
                        Expanded(
                            child: TextButton(
                                child: Text('1.5x',
                                    style: TextStyle(
                                        color: _speed == 1.5
                                            ? Colors.red
                                            : Colors.white)),
                                onPressed: () => _speedSetter(1.5))),
                        Expanded(
                            child: TextButton(
                                child: Text('2.0x',
                                    style: TextStyle(
                                        color: _speed == 2.0
                                            ? Colors.red
                                            : Colors.white)),
                                onPressed: () => _speedSetter(2.0))),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              tooltip: 'Modo confortável: suaviza as cores.',
                              padding: EdgeInsets.zero,
                              splashRadius: 20,
                              icon: Icon(Icons.nights_stay,
                                  color: _confortMode!
                                      ? Colors.orange
                                      : Colors.white),
                              onPressed: () {
                                _confortToggle();
                              },
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 20,
                              icon: Icon(
                                  _isMuted!
                                      ? Icons.volume_mute
                                      : Icons.volume_up,
                                  color: _isMuted! ? Colors.red : Colors.white),
                              onPressed: () {
                                _muteToggle();
                              },
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              tooltip: 'Reset',
                              padding: EdgeInsets.zero,
                              splashRadius: 20,
                              icon: const Icon(
                                Icons.replay_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _speedSetter(1.0);
                                _volumeSetter(0.3);
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
          child: Stack(
            children: [
              VideoPlayer(_videoPlayerController),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _visibleControls!
                    ? Container(
                        key: const ValueKey('a'),
                        height: width,
                        color: Colors.black.withOpacity(0.2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _tittle!,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.white,
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
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(right: 16),
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.swipe_left_outlined,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 13.0,
                                      color: Colors.black45,
                                      offset: Offset(3.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(_showTime!,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                                Expanded(
                                    child: SliderTheme(
                                  data: _sliderTheme(),
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
                                  padding: EdgeInsets.all(0),
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
                      )
                    : AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        key: const ValueKey('b'),
                        color: _confortMode!
                            ? Colors.deepOrange.withOpacity(0.1)
                            : Colors.transparent,
                        height: height,
                        width: width,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SliderThemeData _sliderTheme() {
    return SliderThemeData(
      activeTrackColor: Colors.red[600]!,
      thumbColor: Colors.white,
      inactiveTrackColor: Colors.grey,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      overlayColor: Colors.red.withOpacity(0.5),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
      activeTickMarkColor: Colors.white,
      inactiveTickMarkColor: Colors.white,
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

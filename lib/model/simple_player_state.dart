class SimplePlayerState {
  double? currentSeconds;
  double? totalSeconds;
  double? speed;
  String? showTime;
  String? label;
  bool? autoPlay;
  bool? loopMode;
  bool? wasPlaying;
  bool? confortMode;

  SimplePlayerState({
    required this.currentSeconds,
    required this.totalSeconds,
    required this.speed,
    required this.showTime,
    required this.label,
    required this.autoPlay,
    required this.loopMode,
    required this.wasPlaying,
    required this.confortMode,
  });

  get getCurrentSeconds => currentSeconds;
  set setCurrentSeconds(currentSeconds) => this.currentSeconds = currentSeconds;

  get getTotalSeconds => totalSeconds;
  set setTotalSeconds(totalSeconds) => this.totalSeconds = totalSeconds;

  get getSpeed => speed;
  set setSpeed(speed) => this.speed = speed;

  get getShowTime => showTime;
  set setShowTime(showTime) => this.showTime = showTime;

  get getLabel => label;
  set setLabel(label) => this.label = label;

  get getAutoPlay => autoPlay;
  set setAutoPlay(autoPlay) => this.autoPlay = autoPlay;

  get getLoopMode => loopMode;
  set setLoopMode(loopMode) => this.loopMode = loopMode;

  get getWasPlaying => wasPlaying;
  set setWasPlaying(wasPlaying) => this.wasPlaying = wasPlaying;

  get getConfortMode => confortMode;
  set setConfortMode(confortMode) => this.confortMode = confortMode;
}

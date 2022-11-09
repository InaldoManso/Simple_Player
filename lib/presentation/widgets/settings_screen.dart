// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'playback_speed_options.dart';
import 'brightness_slider.dart';

class SettingsScreen extends StatefulWidget {
  double speed;
  Color colorAccent;
  bool confortModeOn;
  void Function()? onExit;
  final ValueSetter<bool> confortClicked;
  final ValueSetter<double> speedSelected;
  SettingsScreen({
    Key? key,
    required this.speed,
    required this.colorAccent,
    required this.confortModeOn,
    required this.onExit,
    required this.confortClicked,
    required this.speedSelected,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //ReturnValue
  void _onExit() => widget.onExit!();
  void _confortCallBack(bool value) => widget.confortClicked(value);
  void _speedCallBack(double value) => widget.speedSelected(value);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[850]!,
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: BrightnessSlider(colorAccent: widget.colorAccent)),
                Expanded(
                  child: PlaybackSpeedOptions(
                    speed: widget.speed,
                    colorAccent: widget.colorAccent,
                    speedSelected: (value) => _speedCallBack(value),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  height: 4,
                  indent: 8,
                  endIndent: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          splashColor: Colors.orangeAccent,
                          icon: Icon(Icons.nights_stay,
                              color: widget.confortModeOn
                                  ? Colors.orange
                                  : Colors.white),
                          onPressed: () {
                            _confortCallBack(!widget.confortModeOn);
                          },
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashRadius: 20,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          splashColor: widget.colorAccent,
                          icon: Icon(Icons.exit_to_app_rounded,
                              color: widget.colorAccent),
                          onPressed: () => _onExit(),
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
    );
  }
}

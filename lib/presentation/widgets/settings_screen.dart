// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'playback_speed_options.dart';
import 'brightness_slider.dart';

class SettingsScreen extends StatefulWidget {
  String tittle;
  double speed;
  Color colorAccent;
  bool confortModeOn;
  void Function()? onExit;
  final ValueSetter<bool> confortMode;
  final ValueSetter<double> speedSelected;
  SettingsScreen({
    Key? key,
    required this.tittle,
    required this.speed,
    required this.colorAccent,
    required this.confortModeOn,
    required this.onExit,
    required this.confortMode,
    required this.speedSelected,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// ReturnValue
  void onExit() => widget.onExit!();
  void _confortCallBack(bool value) => widget.confortMode(value);
  void _speedCallBack(double value) => widget.speedSelected(value);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onExit,
      child: Container(
        ///  Standardized color so that it does not harm the user's eyes.
        color: Colors.black38,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              ///  Maximum display size.
              constraints: const BoxConstraints(maxHeight: 200),

              ///  Spacers that provide a more pleasant layout.
              // padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                ///  Standardized color so that it does not harm the user's eyes.
                color: Colors.grey[850]!,
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
                ),
              ),

              child: AspectRatio(
                ///  The controller has its standard appearance
                ///  so that it does not suffer from distortions
                ///  in the display on tablets and other
                ///  smartphones with peculiar sizes.
                aspectRatio: 16 / 9,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ),
                              child: Text(
                                widget.tittle,
                                style: const TextStyle(color: Colors.white),
                                softWrap: false,
                              ),
                            ),
                          ),

                          ///  The 'ExitButton' of the options widget
                          ///  is locked to this button so that an accidental
                          ///  bump on the screen causes a bad user experience.
                          Container(
                            width: 60,
                            decoration: BoxDecoration(
                              color: widget.colorAccent,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              splashColor: Colors.black,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () => onExit(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: BrightnessSlider(
                              colorAccent: widget.colorAccent,
                            ),
                          ),

                          ///  Here, a yellow filter is applied
                          ///  so that the user can avoid blue
                          ///  light at night or an eventual eye strain.
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: PlaybackSpeedOptions(
                        speed: widget.speed,
                        colorAccent: widget.colorAccent,
                        speedSelected: (value) => _speedCallBack(value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

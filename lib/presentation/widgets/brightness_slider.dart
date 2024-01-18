import 'package:screen_brightness/screen_brightness.dart';
import '../../aplication/simple_aplication.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class BrightnessSlider extends StatefulWidget {
  final Color colorAccent;
  const BrightnessSlider({Key? key, required this.colorAccent})
      : super(key: key);

  @override
  State<BrightnessSlider> createState() => BbrightnessStateSlider();
}

class BbrightnessStateSlider extends State<BrightnessSlider> {
  /// Classes and Packages
  SimpleAplication simpleAplication = SimpleAplication();

  /// Attributes
  double? _brightness = 0.0;

  /// The function sets the screen brightness to the specified value and updates the state.
  ///
  /// Args:
  ///   brightness (double): The brightness parameter is a double value that represents the desired
  /// brightness level. It should be a value between 0.0 and 1.0, where 0.0 represents the lowest
  /// brightness level and 1.0 represents the highest brightness level.
  brightnessSetter(double brightness) async {
    setState(() => _brightness = brightness);
    ScreenBrightness().setScreenBrightness(brightness);
  }

  initializeInterface() async {
    double brightness = await ScreenBrightness().current;

    /// Methods
    brightnessSetter(brightness);
  }

  @override
  void initState() {
    initializeInterface();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.settings_brightness_rounded, color: Colors.white),
        ),
        Expanded(
          child: SliderTheme(
            data: Constants.getSliderThemeData(colorAccent: widget.colorAccent),
            child: Slider(
              value: _brightness!,
              max: 1.0,
              min: 0.0,
              divisions: 20,
              label: simpleAplication.doubleConvert(_brightness!),
              onChanged: (double value) {
                brightnessSetter(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}

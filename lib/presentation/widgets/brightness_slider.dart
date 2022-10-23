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
  //Classes and Packages
  SimpleAplication simpleAplication = SimpleAplication();
  Constants constants = Constants();

  //Attributes
  double? _brightness = 0.0;

  _brightnessSetter(double brightness) async {
    setState(() => _brightness = brightness);
    ScreenBrightness().setScreenBrightness(brightness);
  }

  _initializeInterface() async {
    double brightness = await ScreenBrightness().current;

    //Methods
    _brightnessSetter(brightness);
  }

  @override
  void initState() {
    _initializeInterface();
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
            data: constants.getSliderThemeData(colorAccent: widget.colorAccent),
            child: Slider(
              value: _brightness!,
              max: 1.0,
              min: 0.0,
              divisions: 20,
              label: simpleAplication.doubleConvert(_brightness!),
              onChanged: (double value) {
                _brightnessSetter(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}

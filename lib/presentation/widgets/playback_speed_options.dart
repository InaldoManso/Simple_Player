import 'package:flutter/material.dart';

class PlaybackSpeedOptions extends StatefulWidget {
  double speed;
  Color colorAccent;
  final ValueSetter<double> speedSelected;
  PlaybackSpeedOptions(
      {Key? key,
      required this.speed,
      required this.colorAccent,
      required this.speedSelected})
      : super(key: key);

  @override
  State<PlaybackSpeedOptions> createState() => PplaybackSpeedOptionsState();
}

class PplaybackSpeedOptionsState extends State<PlaybackSpeedOptions> {
  //ReturnValue
  void _setCallBack(double value) {
    widget.speedSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.slow_motion_video_rounded, color: Colors.white),
        ),
        Expanded(
            child: TextButton(
                child: Text('0.5x',
                    style: TextStyle(
                        color: widget.speed == 0.5
                            ? widget.colorAccent
                            : Colors.white)),
                onPressed: () => _setCallBack(0.5))),
        Expanded(
            child: TextButton(
                child: Text('1.0x',
                    style: TextStyle(
                        color: widget.speed == 1.0
                            ? widget.colorAccent
                            : Colors.white)),
                onPressed: () => _setCallBack(1.0))),
        Expanded(
            child: TextButton(
                child: Text('1.5x',
                    style: TextStyle(
                        color: widget.speed == 1.5
                            ? widget.colorAccent
                            : Colors.white)),
                onPressed: () => _setCallBack(1.5))),
        Expanded(
            child: TextButton(
                child: Text('2.0x',
                    style: TextStyle(
                        color: widget.speed == 2.0
                            ? widget.colorAccent
                            : Colors.white)),
                onPressed: () => _setCallBack(2.0))),
      ],
    );
  }
}

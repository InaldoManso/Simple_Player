import 'package:flutter/material.dart';

class ConfortModeButton extends StatefulWidget {
  bool confortModeOn;
  final ValueSetter<bool> confortClicked;
  ConfortModeButton(
      {Key? key, required this.confortModeOn, required this.confortClicked})
      : super(key: key);

  @override
  State<ConfortModeButton> createState() => CconforMmodBbuttonState();
}

class CconforMmodBbuttonState extends State<ConfortModeButton> {
  //ReturnValue
  void _setCallBack(bool value) {
    widget.confortClicked(value);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        tooltip: 'Modo confortável: suaviza as cores.',
        splashRadius: 20,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        splashColor: Colors.orangeAccent,
        icon: Icon(Icons.nights_stay,
            color: widget.confortModeOn ? Colors.orange : Colors.white),
        onPressed: () {
          _setCallBack(!widget.confortModeOn);
        },
      ),
    );
  }
}

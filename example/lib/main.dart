import 'package:flutter/material.dart';
import 'package:simple_player/simple_player.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Simple Example'),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: SimplePlayer.network(
          simplePlayerSettings: SimplePlayerSettings(
              simplePathType: SimplePathType.network(url: url),
              aspectRatio: 16 / 9,
              autoPlay: false,
              label: 'Bee'),
        ),
      ),
    );
  }
}

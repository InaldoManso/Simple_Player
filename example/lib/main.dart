import 'package:simple_player/simple_player.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
          title: const Text('SimplePlayer Example'),
          backgroundColor: Colors.grey),
      body: Center(
        child: SimplePlayer.build(
          simplePlayerSettings: SimplePlayerSettings.network(
            path: url,
            label: 'Bee',
            aspectRatio: 16 / 9,
            autoPlay: false,
            loopMode: true,
            forceAspectRatio: false,
            colorAccent: Colors.red,
          ),
        ),
      ),
    );
  }
}

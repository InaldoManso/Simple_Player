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
  SimpleController simpleController = SimpleController();
  String url =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  //Attributes
  String currentPosition = '...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('SimplePlayer Example'),
          backgroundColor: Colors.grey),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimplePlayer(
              simpleController: simpleController,
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
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            color: Colors.blue.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Using the controller',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                const Divider(thickness: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      label: const Text("Play Video"),
                      icon: const Icon(Icons.play_arrow_rounded),
                      onPressed: () {
                        simpleController.play();
                      },
                    ),
                    TextButton.icon(
                      label: const Text("Pause Video"),
                      icon: const Icon(Icons.pause_rounded),
                      onPressed: () {
                        simpleController.pause();
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      label: const Text("Get Current Position"),
                      icon: const Icon(Icons.timelapse_rounded),
                      onPressed: () {
                        setState(() {
                          currentPosition =
                              simpleController.position.toString();
                        });
                      },
                    ),
                    Text(currentPosition)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      label: const Text("Stream Position"),
                      icon: const Icon(Icons.timelapse_rounded),
                      onPressed: () {
                        setState(() {
                          currentPosition =
                              simpleController.position.toString();
                        });
                      },
                    ),
                    Text(simpleController.position.toString())
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

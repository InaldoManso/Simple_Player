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
  // Example link provided in the video_player package on which SimplePlayer is based.
  String url =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  // Attributes
  String currentPosition = '...';
  String stremPosition = '...';

  // This is where the lsitener for the decorator of the video playback seconds starts.
  _initListener() {
    simpleController.listenPosition().listen((event) {
      // Updated seconds in the interface.
      // Requires setState to update seconds counter.
      setState(() {
        stremPosition = event.toString();
      });
    });
  }

  @override
  void initState() {
    // initialize listener.
    _initListener();
    super.initState();
  }

  @override
  void dispose() {
    // dispose the control to avoid complications and conflicts
    // with other playable controllers that can be used.
    simpleController.dispose();
    super.dispose();
  }

  // Here a basic interface will be built,
  // with the player and its simple controls,
  // and also the use of the player through
  // SimpleController in a very simplified way!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('SimplePlayer Example'),
          backgroundColor: Colors.grey),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Player wrapped in a padding.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimplePlayer(
                simpleController: simpleController,
                simplePlayerSettings: SimplePlayerSettings.network(
                  // Only the path is required, all other parameters are optional
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

            // Start using the controller.
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
                          // Does not require setState to play.
                          simpleController.play();
                        },
                      ),
                      TextButton.icon(
                        label: const Text("Pause Video"),
                        icon: const Icon(Icons.pause_rounded),
                        onPressed: () {
                          // Does not require setState to pause.
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
                        icon: const Icon(Icons.timer_outlined),
                        onPressed: () {
                          //Requires setState to update seconds counter.
                          setState(() {
                            currentPosition =
                                simpleController.position.toString();
                          });
                        },
                      ),
                      Text(currentPosition)
                    ],
                  ),
                  // Here the result of the listener is displayed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        label: const Text(" Stream Position"),
                        icon: const Icon(Icons.ondemand_video_rounded,
                            color: Colors.red),
                        onPressed: null,
                      ),
                      Text(stremPosition)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

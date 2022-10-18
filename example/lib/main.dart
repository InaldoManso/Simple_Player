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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Simple Example'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              height: 200,
            ),
            SizedBox(
              width: width * 1,
              child: SimplePlayer.build(
                simplePlayerSettings: SimplePlayerSettings(
                    simplePathType: SimplePathType.network(url: url),
                    label: 'Bee',
                    aspectRatio: 16 / 9,
                    autoPlay: false,
                    loopMode: false,
                    colorAccent: Colors.red),
              ),
            ),
            SizedBox(
              width: width * 1,
              child: SimplePlayer.build(
                simplePlayerSettings: SimplePlayerSettings(
                  simplePathType: SimplePathType.network(url: url),
                  autoPlay: false,
                  loopMode: false,
                  label: 'Bee',
                ),
              ),
            ),
            Container(
              color: Colors.amber,
              height: 200,
            ),
            Container(
              color: Colors.red,
              height: 200,
            ),
            Container(
              color: Colors.purple,
              height: 200,
            ),
            Container(
              color: Colors.orange,
              height: 200,
            ),
            Container(
              color: Colors.green,
              height: 200,
            ),
            Container(
              color: Colors.blue,
              height: 200,
            ),
            Container(
              color: Colors.amber,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

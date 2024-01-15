# Simple Player 🎬
## Welcome to the simplest user-friendly player ever made!

### Applicable preferences:
- Label (String)
- AspectRatio (double)
- AutoPlay (bool)
- LoopMode (bool)
- ForceAspectRatio (bool)
- ColorAccent (Color)

</br><div>

```dart
/// Example:

SimpleController simpleController = SimpleController();
String url =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';


SimplePlayer(
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

SimplePlayer(
    simpleController: simpleController,
    simplePlayerSettings: SimplePlayerSettings.assets(
        path: url,
        label: 'Bee',
        aspectRatio: 16 / 9,
        autoPlay: false,
        loopMode: true,
        forceAspectRatio: false,
        colorAccent: Colors.red,
    ),
),

/// Examples of controller usage:

// Play
simpleController.play();

// Pause
simpleController.pause()

// Get current position (return Duration)
 simpleController.position;

// Hear player position (return Duration)
simpleController.listenPosition().listen((event) {
    Duration stremPosition = event.toString();
});
```
</div>
<div>

### Result:
<img align="left" alt="Simple Player" src="https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/bee.png">
&nbsp;
<img align="rigth" alt="Simple Player" src="https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/menu.png">

</br>

### FullScreen:
<img align="center" alt="Simple Player" src="https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/player.png">


</br>
</br>


## Good coding! 😎💙
#### Follow me on: https://github.com/InaldoManso
###### Developed by: Inaldo Manso

</br></div>

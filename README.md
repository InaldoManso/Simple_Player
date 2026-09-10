# Simple Player 🎬
## Welcome to the simplest user-friendly player ever made!

### Applicable preferences:
- Label (String)
- AspectRatio (double) — the proportion of the **player box**
- Expand (bool) — let the player fill the parent box instead of forcing `aspectRatio`
- Fit (BoxFit) — how the **video frame** is scaled inline (default `BoxFit.contain`)
- FullScreenFit (BoxFit) — how the **video frame** is scaled in full screen (default `BoxFit.contain`)
- AutoPlay (bool)
- LoopMode (bool)
- ColorAccent (Color)

### The interface 🎛️

One tap toggles it, and it fades out on its own 3 seconds after playback
starts. Nothing else — no settings popup, no hidden menus:

- title over a soft top gradient;
- a single play/pause button in the middle (a spinner while buffering);
- elapsed / total time, the full screen toggle and an edge to edge seek bar
  showing the buffered range.

### Fitting the video 🖼️

`aspectRatio` (or `expand`) defines the box the player occupies on your layout.
`fit` and `fullScreenFit` decide how the video is painted **inside** that box:

| Value | Behaviour |
| --- | --- |
| `BoxFit.contain` (default) | The whole frame is visible, black bars may appear. |
| `BoxFit.cover` | The box is fully painted, the frame is cropped. |
| `BoxFit.fill` | The frame is stretched to the box (distorts the image). |
| `BoxFit.fitWidth` / `BoxFit.fitHeight` | One axis is matched, the other overflows and is cropped. |

The scaling is applied to the video layer only. The controls (play/pause,
timeline, settings and the full screen button) live on a separate layer of the
same `Stack`, so **they are never cropped, clipped or distorted**, whatever
`fit` you choose. Do not wrap `SimplePlayer` in an external `FittedBox` — use
`fit` instead, otherwise the controls get scaled away with the video.

```dart
// Fill a square card without distorting the video, but show the
// whole frame once the user opens full screen.
SimplePlayerSettings.network(
    path: url,
    aspectRatio: 1 / 1,
    fit: BoxFit.cover,
    fullScreenFit: BoxFit.contain,
),
```

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
        fit: BoxFit.cover,
        fullScreenFit: BoxFit.contain,
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
        fit: BoxFit.cover,
        fullScreenFit: BoxFit.contain,
        colorAccent: Colors.red,
    ),
),

/// Examples of controller usage:

// Play
simpleController.play();

// Pause
simpleController.pause()

// Playback speed
simpleController.setSpeed(1.5);

// Jump to a point of the video
simpleController.seekTo(const Duration(seconds: 30));

// Get current position (return Duration)
 simpleController.position;

// By disposing of the controller
// This method does not need to be called in normal cases, SimplePlayer already has an AutoDispose to facilitate its correct use.
 simpleController.delete()

// Hear player position (return Duration)
simpleController.listenPosition().listen((event) {
    Duration stremPosition = event.toString();
});
```
</div>
<div>

### Result:

<img alt="SimplePlayer" width="360" src="https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/player_inline.jpg">

### FullScreen:

<img alt="SimplePlayer in full screen" src="https://raw.githubusercontent.com/InaldoManso/Simple_Player/main/lib/assets/player_fullscreen.jpg">

</br>
</br>


## Good coding! 😎💙
#### Follow me on: https://github.com/InaldoManso
###### Developed by: Inaldo Manso

</br></div>

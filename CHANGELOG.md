## 3.0.0 - New look, BoxFit support & project modernization 🎬🖼️🚀

### Interface
* Redesigned around what current players look like: soft top/bottom gradients
  instead of a flat veil, one central play/pause button, elapsed/total time and
  a slim edge to edge seek bar that also shows the buffered range.
* The interface now auto hides 3 seconds after playback starts and comes back
  on a tap.
* A spinner replaces the play button while the video is buffering.
* **Removed:** the settings popup, along with the brightness slider, the
  "comfort mode" tint and the speed buttons it carried. Playback speed is now
  part of the controller API (`simpleController.setSpeed`), and the
  `screen_brightness` dependency is gone.
* **Removed:** `forceAspectRatio`. Use `fit` / `fullScreenFit` instead —
  the old `forceAspectRatio: true` is `fit: BoxFit.fill`.
* **New:** `simpleController.seekTo(Duration)`.

### Player
* **New:** `fit` and `fullScreenFit` (`BoxFit`, default `BoxFit.contain`) on `SimplePlayerSettings`.
  The scaling is applied to the video frame only — the controls live on a separate
  layer of the `Stack` and are never cropped, clipped or distorted.
* **New:** `expand` (`bool`, default `false`) lets the player fill the parent box
  instead of forcing its own `aspectRatio`.
* Migrated to Flutter 3.29+/Dart 3.8+, `video_player` ^2.10 and `flutter_lints` ^6.
  `video_player` is now the package's only runtime dependency.
* Example app migrated to the current Android (Gradle Kotlin DSL, AGP 9, Gradle 9.1,
  Kotlin 2.3, Java 17, `namespace`) and iOS (deployment target 13.0) templates.
* Replaced deprecated APIs: `WillPopScope` → `PopScope` and
  `withOpacity` → `withValues`.
* `SimpleController` position/play-pause streams are now event driven instead of
  polling every 50ms, and are closed on `dispose()`.
* Fixed leaked listeners and stream subscriptions when the player is disposed.
* A failing video source no longer throws an unhandled exception nor spins forever.
* Added a test suite covering the fit resolution and the "controls are never
  clipped" rule.

## 2.1.0 - Correção de alertas de problemas e nova função: delete() ✨📺✅

* Adjustment of the play and pause interface that was not hidden after playing the video
* Playback discard adjustment that was not working correctly
* Added .delete() method. (dipose)

## 2.0.2 - Issues alerts fix 📺❗

* Adjust the play button and pause in fullscreen.

## 2.0.1 - Issues alerts fix 🐞❗

* Issues alerts fix.

## 2.0.0 - Player fluidity 🍃🚀

* FullScreen mode is now much more fluid.
* Optimized video loading.
* New Settings PopUp.

## 1.1.4 - FullScreen adjustments 📺✨

* FullScreen mode now respects the Aspect Ratio of the played video: portrait and landscape.

## 1.1.1 - adjustments 🛟

* documentation adjustments.

## 1.1.0 - Options widget ⌨️✨

* Improvements made to the scale and behavior of the playback adjustment widget.

## 1.0.8 - Added controller and Adjust ✨

* Video loading screen

## 1.0.7 - Added controller and Adjust ✨

* Now you can control your playback without using the interface directly!
* Adjusted autoplay

## 1.0.6 - Added controller ✨

* Now you can control your playback without using the interface directly!

## 1.0.5 - New settings screen

* A simpler and more functional look than before, focused on usability and practicality!

## 1.0.4 - SimplePlayer Add AspectRatio

* Improvements to full screen and aspect ratio settings.
* AspectRatio gained more features
* Code optimization

## 1.0.3 - Organizing SimplePlayer

* Functional package accepts videos via network and via assets path.
* Edit Readme*

## 1.0.2 - SimplePlayer BetaOn

* Functional package accepts videos via network .
* Edit Readme

## 1.0.1 - SimplePlayer

* Functional package accepts videos via assets path.


## 1.0.0 - Play videos

* Basic interface ready.

## 0.0.1

* Initialize backstages.

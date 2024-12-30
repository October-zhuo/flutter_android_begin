import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:video_player/video_player.dart';

class SimpleScreen extends StatefulWidget {
  const SimpleScreen({Key? key}) : super(key: key);

  @override
  State<SimpleScreen> createState() => _SimpleScreenState();
}

class _SimpleScreenState extends State<SimpleScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  UnityWidgetController? _unityWidgetController;
  double _sliderValue = 0.0;

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

      _controller.addListener((){
        print('调用时机');
      });
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.play();
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Simple Screen'),
      ),
      body: Container(
          child: Stack(
        children: [
          Container(
            child: Center(
              child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
            ),width: 500, height: 500,
          ),
          // Container(
          //     child: UnityWidget(
          //       onUnityCreated: _onUnityCreated,
          //       onUnityMessage: onUnityMessage,
          //       onUnitySceneLoaded: onUnitySceneLoaded,
          //       useAndroidViewSurface: false,
          //       borderRadius: const BorderRadius.all(Radius.circular(70)),
          //     ),
          //     width: 200,
          //     height: 400),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PointerInterceptor(
              child: Card(
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Rotation speed:"),
                    ),
                    Slider(
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                        setRotationSpeed(value.toString());
                      },
                      value: _sliderValue,
                      min: 0.0,
                      max: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text("lalala")
        ],
      )),
    );
  }

  void setRotationSpeed(String speed) {
    _unityWidgetController?.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      print('Received scene loaded from unity: ${scene.name}');
      print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
    } else {
      print('Received scene loaded from unity: null');
    }
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
  }
}

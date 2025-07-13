import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gal/gal.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null || cameraController?.value.isInitialized == false) {return;}
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

Widget _buildUI() {
  if (cameraController == null || cameraController?.value.isInitialized == false) {
    return const Center(child: CircularProgressIndicator());
  }
  return Stack(
    children: [
      // Camera footage takes up the entire screen
      Positioned.fill(
        child: CameraPreview(cameraController!),
      ),       Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        height: 185,
        child: Container(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      // Button stacked on top, centered horizontally and near the bottom
      Positioned(
        left: 0,
        right: 0,
        bottom: 80,
        child: Center(
          child: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              onPressed: () async {
                XFile picture = await cameraController!.takePicture();
                Gal.putImage(picture.path);
              },
              backgroundColor: Colors.red,
              shape: const CircleBorder(),
              child: const Icon(Icons.camera, color: Colors.white, size: 50),
            ),
          ),
        ),
      ),
    ],
  );
}

  Future<void> _setupCameraController() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        cameras = cameras;
        cameraController = CameraController(cameras.first, ResolutionPreset.high);
      });
      cameraController?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      }
      ).catchError((Object e) {
        // Handle error
        print('Error initializing camera: $e');
      });
    }
  }
}

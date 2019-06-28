import 'package:camera/camera.dart';

void testPhotos() async {
  List<CameraDescription> cameras = await availableCameras();
  CameraController controller =
      CameraController(cameras[0], ResolutionPreset.medium);
  String filePath = "Photos/image_test.jpg";
  await controller.takePicture(filePath);
}

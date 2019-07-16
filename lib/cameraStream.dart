import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:yuka_like/Provider.dart';
import 'package:provider/provider.dart';
import 'package:yuka_like/productDetails.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class CameraStream extends StatefulWidget {
  final CameraDescription camera;

  const CameraStream({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraStreamState createState() => CameraStreamState();
}

class CameraStreamState extends State<CameraStream> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool _productScan = true;
  bool _isDetected = false;

  void startTimer() {
    Timer(Duration(seconds: 5), () {
      setState(() {});
      _productScan = false;

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => ProductDetails()));
      return;
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      try {
        await _initializeControllerFuture;

        final path = join(
          (await getTemporaryDirectory()).path,
          '${DateTime.now()}.png',
        );
        await _controller.takePicture(path);
        FirebaseVisionImage ourImage =
            FirebaseVisionImage.fromFilePath(path.toString());

        BarcodeDetector barcodeDetector =
            FirebaseVision.instance.barcodeDetector();
        List barCodes = await barcodeDetector.detectInImage(ourImage);

        for (Barcode readableCode in barCodes) {
          print(readableCode.displayValue);
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return ChangeNotifierProvider<BarCode>(
                builder: (context) => BarCode(''),
                child: Consumer<BarCode>(builder: (context, provider, child) {
                  return provider.getBarCode() == ''
                      ? ChangeNotifierProvider<BarCode>(
                          builder: (context) =>
                              BarCode(readableCode.displayValue.toString()),
                          child: Scaffold(
                            body: ProductDetails(),
                          ),
                        )
                      : Container();
                }));
          }));
          timer.cancel();
        }
      } catch (e) {
        print(e);
      }
      return;
    });
    double _widthScreen = MediaQuery.of(context).size.width;
    double _heightScreen = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider<BarCode>(
        builder: (context) => BarCode(''),
        child: Consumer<BarCode>(builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(title: Text('Please scan your product')),
            body: new Stack(children: <Widget>[
              provider.getBarCode() == ''
                  ? FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CameraPreview(_controller);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  : Container(),
              new Center(
                child: Stack(children: <Widget>[
                  Container(
                    height: 270.0,
                    width: 350.0,
                    child: _productScan
                        ? CustomPaint(
                            foregroundPainter: MyPainterRect(
                                lineColor: Colors.white, width: 4.0),
                          )
                        : Container(),
                  ),
                  Container(
                    height: 270.0,
                    width: 350.0,
                    child: CustomPaint(
                      foregroundPainter:
                          MyPainterLines(lineColor: Colors.white, width: 6.0),
                    ),
                  ),
                  Positioned(
                      top: 250,
                      left: 60,
                      child: _productScan
                          ? Center(
                              child:
                                  Text('Placez le produit au centre de lecran'))
                          : Center(
                              child: Text('Merci de scanner le code barre')))
                ]),
              ),
            ]),
          );
        }));
  }
}

class MyPainterRect extends CustomPainter {
  Color lineColor;
  double width;

  MyPainterRect({this.lineColor, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Rect myRect = new Offset(1, -30) & new Size(size.width, size.height);
    canvas.drawRRect(
        RRect.fromRectAndRadius(myRect, Radius.circular(60.0)), line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MyPainterLines extends CustomPainter {
  Color lineColor;
  double width;

  MyPainterLines({this.lineColor, this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width;
    final points1 = [
      Offset(55, 45),
      Offset(55, 20),
      Offset(85, 20),
    ];
    final points2 = [
      Offset(270, 20),
      Offset(300, 20),
      Offset(300, 45),
    ];
    final points3 = [
      Offset(55, 170),
      Offset(55, 195),
      Offset(85, 195),
    ];
    final points4 = [
      Offset(270, 195),
      Offset(300, 195),
      Offset(300, 170),
    ];

    canvas.drawPoints(PointMode.polygon, points1, paint);
    canvas.drawPoints(PointMode.polygon, points2, paint);
    canvas.drawPoints(PointMode.polygon, points3, paint);
    canvas.drawPoints(PointMode.polygon, points4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

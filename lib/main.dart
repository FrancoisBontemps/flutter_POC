import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './productDetails.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'package:camera/camera.dart';
import './cameraStream.dart';

Future<void> main() async {
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider<OnProductPage>(
          builder: (_) => OnProductPage(), child: CameraStream(camera: firstCamera,)),

      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/scan':(BuildContext context) => CameraStream(camera:firstCamera),
        '/productdetails' : (BuildContext context) => ProductDetails()
      },
    ),
  );
}
/*
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new Scaffold(
            body: ChangeNotifierProvider<BarCode>(
                builder: (_) => BarCode(''), child: MyScan())));
  }
}

class MyScan extends StatefulWidget with ChangeNotifier {
  @override
  _MyScanState createState() => new _MyScanState();
}

class _MyScanState extends State<MyScan> {
  String errorHandler = '';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final barCode = Provider.of<BarCode>(context);

    if (barCode.getBarCode().length > 1) {
      return MaterialApp(home: ProductDetails());
    }
    print('DANS LE BUILD' + barCode.getBarCode());
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Scan Barcode'),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new RaisedButton(
                      onPressed: barcodeScanning,
                      child: new Text("Capture image")),
                  padding: const EdgeInsets.all(8.0),
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                new Text("Barcode Number after Scan : " + barCode.getBarCode()),
                // displayImage(),
              ],
            ),
          )),
    );
  }

  Widget displayImage() {
    return new SizedBox(
        height: 300.0,
        width: 400.0,
        child: new Text('Sorry nothing to display'));
  }

// Method for scanning barcode....
  Future barcodeScanning() async {
//imageSelectorGallery();
    final barCode = Provider.of<BarCode>(context);
    bool isFound = true;
    try {
      String barcode = await BarcodeScanner.scan();
      barCode.setBarCode(barcode);
      print(barCode.getBarCode());
      if (barCode.getBarCode().length > 1 && isFound == true) {
        setState(() => {});
        isFound = false;
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        barCode.setBarCode(this.errorHandler = "No camera Permission!");
      } else {
        barCode.setBarCode(this.errorHandler = 'Unknown error: $e');
      }
    } on FormatException {
      barCode.setBarCode(this.errorHandler = 'Nothing captured.');
    } catch (e) {
      barCode.setBarCode(this.errorHandler = 'Unknown error: $e');
    }
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          body: ProductDetails(),
        );
      },
    ));
  }
}*/

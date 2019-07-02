import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import './productDetails.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Scan> {
  String _reader = '';
  Permission permission = Permission.Camera;

  @override
  Widget build(BuildContext context) {
    print(_reader);
    scan();
    if (_reader.length > 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetails()),
      );
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }

  requestPermission() async {
    var resultTemp = await SimplePermissions.requestPermission(permission);
    bool result = resultTemp == 'true';
    setState(
      () => new SnackBar(
            backgroundColor: Colors.red,
            content: new Text(" $result"),
          ),
    );
  }

  scan() async {
    try {
      String reader = await BarcodeScanner.scan();

      if (!mounted) {
        return;
      }

      setState(() => this._reader = reader);
      print(_reader);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        requestPermission();
      } else {
        setState(() => _reader = "unknown exception $e");
      }
    } on FormatException {
      setState(() => _reader =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => _reader = 'Unknown error: $e');
    }
  }
}

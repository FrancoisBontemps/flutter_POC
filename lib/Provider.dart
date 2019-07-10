import 'package:flutter/material.dart';

class BarCode with ChangeNotifier{
  String _barCode ='';
  BarCode(this._barCode);

  getBarCode() => _barCode;
  setBarCode(String barCode) => _barCode = barCode;
}

class OnProductPage with ChangeNotifier{
  bool _onProductPage = false;
  OnProductPage();

  bool getOnProductPage() => _onProductPage;
  setOnProductPage(bool onProductPage) => _onProductPage = onProductPage;
}
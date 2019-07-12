import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuka_like/Provider.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Consumer<BarCode>(builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Second Route"),
            ),
            body: Center(
              child: Text(provider.getBarCode()

              ),
            ),
          );
        })
    );
  }
}
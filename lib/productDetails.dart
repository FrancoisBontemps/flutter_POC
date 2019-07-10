import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuka_like/Provider.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnProductPage>(
        builder: (context) => OnProductPage(),
        child: Consumer<OnProductPage>(builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Second Route"),
            ),
            body: Center(
              child: RaisedButton(
                onPressed: () {
                  print('onProductpage PRODUCT SCREEN : ' + provider.getOnProductPage().toString());
                  provider.setOnProductPage(true);
                  print('onProductpage PRODUCT SCREEN AFTER UPDATE : ' + provider.getOnProductPage().toString());
                  Navigator.of(context).pop(context);
                },
                child: Text('Go back!'),
              ),
            ),
          );
        })
    );
  }
}

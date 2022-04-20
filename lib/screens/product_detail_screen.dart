import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final products = Provider.of<Products>(context);
    final product= products.items.firstWhere((element) => element.id==productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
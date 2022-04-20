import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';


class ProductItem extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
  final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {product.toggleFavourite();},
            icon: Icon(
              product.isFavourite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
            ),
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

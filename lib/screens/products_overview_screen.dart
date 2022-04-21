import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
// import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context,listen: false);
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: ((FilterOptions value) {
              if (value == FilterOptions.Favourites) {
                // productsData.showFavourites();
                setState(() {
                  _showOnlyFavourites = true;
                });
              } else {
                // productsData.showAll();
                setState(() {
                  _showOnlyFavourites = false;
                });
              }
            }),
            itemBuilder: ((context) => [
                  const PopupMenuItem(
                    child: Text('Only Favourites'),
                    value: FilterOptions.Favourites,
                  ),
                  const PopupMenuItem(
                    child: Text('Show All'),
                    value: FilterOptions.All,
                  ),
                ]),
            icon: const Icon(Icons.more_vert),
          ),
          Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {Navigator.of(context).pushNamed(CartScreen.routeName);},
              ),
              value: cart.itemCount.toString(),
              color: Colors.deepOrange),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}

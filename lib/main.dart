import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: ((context) => Auth()),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(itemss: [], authToken: '', userId: ''),
            // ignore: unnecessary_null_comparison
            update: (ctx, auth, previous) => Products(
                authToken: auth.token == null ? '' : auth.token!,
                itemss: previous!.items == null ? [] : previous.items,
                userId: auth.userId),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', [], ''),
            update: (ctx, auth, previous) => Orders(auth.token,
                previous!.orders == null ? [] : previous.orders, auth.userId),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ShopApp',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                    future: auth.tryAutoLogin(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              // AuthScreen.routeName:(context) => AuthScreen(),
            },
          ),
        ));
  }
}

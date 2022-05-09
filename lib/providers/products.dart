import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  late List<Product> itemss = [
    
  ];

  // var _showFavouritesOnly= false;
  final String authToken;
  Products({required this.authToken,required this.itemss});
  List<Product> get items {
    return [...itemss];
  }

  List<Product> get favourites {
    return itemss.where((element) => element.isFavourite == true).toList();
  }

  // void showFavourites(){
  //   _showFavouritesOnly=true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavouritesOnly=false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return itemss.firstWhere((element) => element.id == id);
  }

  // Future<void> addProduct(Product prod) {
  //   final url = Uri.https(
  //       'shop-app-29cf9-default-rtdb.firebaseio.com', '/products.json');
  //   return http
  //       .post(
  //     url,
  //     body: jsonEncode(
  //       {
  //         'title': prod.title,
  //         'description': prod.description,
  //         'price': prod.price,
  //         'imageUrl': prod.imageUrl,
  //         'isFavourite': prod.isFavourite,
  //       },
  //     ),
  //   )
  //       .then((response) {
  //         // print(jsonDecode(response.body));
  //     final newProduct = Product(
  //       id: jsonDecode(response.body)['name'],
  //       title: prod.title,
  //       description: prod.description,
  //       price: prod.price,
  //       imageUrl: prod.imageUrl,
  //     );
  //     itemss.insert(0, newProduct);
  //     notifyListeners();
  //   }).catchError((error){
  //     throw error;
  //   });
  // }

  Future<void> addProduct(Product prod) async {
    final Uri url = Uri.parse("https://shop-app-29cf9-default-rtdb.firebaseio.com/products.json?auth=$authToken");
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': prod.title,
            'description': prod.description,
            'price': prod.price,
            'imageUrl': prod.imageUrl,
            'isFavourite': prod.isFavourite,
          },
        ),
      );
      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: prod.title,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl,
      );
      itemss.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product prod) async {
    final prodIndex = itemss.indexWhere((pro) => pro.id == id);
    if (prodIndex > 0) {
      final Uri url = Uri.parse("https://shop-app-29cf9-default-rtdb.firebaseio.com/products/${prod.id}.json?auth=$authToken");
      await http.patch(url,body: jsonEncode({
        'title': prod.title,
        'description': prod.description,
        'price': prod.price,
        'imageUrl': prod.imageUrl,
      }));
      itemss[prodIndex] = prod;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void delProduct(String id) {
    final url = Uri.https('shop-app-29cf9-default-rtdb.firebaseio.com', '/products/$id.json?auth=$authToken');
    final existingProductIndex = items.indexWhere((element) => element.id==id);
    final existingProduct =  itemss[existingProductIndex];
    
    itemss.removeAt(existingProductIndex);
    http.delete(url).catchError((error){
      itemss.insert(existingProductIndex,existingProduct);
      notifyListeners();
    });
    notifyListeners();
  }
  

  Future<void> fetchAndSetProducts() async {
    final Uri url = Uri.parse("https://shop-app-29cf9-default-rtdb.firebaseio.com/products.json?auth=$authToken");

    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if(extractedData==null)
      {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavourite: prodData['isFavourite']),
        );
      });
      
      itemss = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

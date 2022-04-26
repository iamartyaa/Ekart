import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${double.parse(cartData.totalAmount.toStringAsFixed(3))}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartData: cartData),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cartData.itemCount,
            itemBuilder: (context, i) => ci.CartItem(
              id: cartData.items.values.toList()[i].id,
              productId: cartData.items.keys.toList()[i],
              title: cartData.items.values.toList()[i].title,
              quantity: cartData.items.values.toList()[i].quantity,
              price: cartData.items.values.toList()[i].price,
            ),
          )),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: ((widget.cartData.totalAmount<=0) )? null: () async {
        setState(() {
          isLoading=true;
        });
        await Provider.of<Orders>(context,listen: false).addOrder(
          widget.cartData.items.values.toList(),
          double.parse(widget.cartData.totalAmount.toStringAsFixed(3)),
        );
        setState(() {
          isLoading=false;
        });
        widget.cartData.clear();
      },
      child:isLoading ? Center(child: CircularProgressIndicator()) : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}

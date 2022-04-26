import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading =false;
  @override
  void initState() {
    // TODO: implement initState
    // Future.delayed(Duration.zero).then((value) async{
    //   setState(() {
        isLoading=true;
    //   });
      Provider.of<Orders>(context,listen: false).fetchAndSetProducts();
      setState(() {
        isLoading=false;
      });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: isLoading? Center(child: CircularProgressIndicator()): ListView.builder(itemBuilder: (ctx,i) {
        return OrderItem(orderData.orders[i]);
      },itemCount: orderData.orders.length,),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shopapp/providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: expanded? min(widget.order.products.length * 20.0 + 142, 200) :95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$ ${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy - hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(!expanded ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
            
              AnimatedContainer(
                duration: Duration(milliseconds: 300),

                padding: const EdgeInsets.all(10),
                height: expanded ? min(widget.order.products.length * 20.0 + 40, 180): 0,
                child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${prod.quantity} x \$ ${prod.price}',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    //Way 1
    // double sum = 0;
    // user.cart
    //     .map((e) => sum = sum + ((e['quantity'] * e['product']['price'])))
    //     .toList();

    //Way 2
    // double sum = 0;
    // user.cart.forEach((item) {
    //   sum = sum + ((item['quantity'] * item['product']['price']));
    // });
    // can user for loop also

    // OR
    //Way 3
    double sum = user.cart.fold<double>(0, (previousValue, element) {
      return previousValue +
          ((element['quantity'] * element['product']['price']));
    });

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'SubTotal ',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '\$$sum',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}

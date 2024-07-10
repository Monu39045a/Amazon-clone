import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  // //Temporay list
  // List list = [
  //   'https://picsum.photos/250?image=9',
  //   'https://picsum.photos/250?image=9',
  //   'https://picsum.photos/250?image=9',
  //   'https://picsum.photos/250?image=9',
  // ];

  final AccountService accountService = AccountService();

  List<Order>? orders;

  @override
  void initState() {
    super.initState();
    fetchMyOrders();
  }

  void fetchMyOrders() async {
    orders = await accountService.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: const Text(
                      "Your Orders",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 16,
                        color: GlobalVariables.selectedNavBar,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 170,
                padding: const EdgeInsets.only(left: 10, top: 20, right: 0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orders!.length,
                    itemBuilder: ((context, index) {
                      return SingleProduct(
                        image: orders![index].products[0].images[0],
                      );
                    })),
              )
            ],
          );
  }
}

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  int currentStatus = 0;
  final AdminServices adminServices = AdminServices();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentStatus = widget.order.status;
  }

  void navigateToSearchScreen(String searchQuery) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(
        context: context,
        status: status,
        order: widget.order,
        onSucess: () {
          setState(() {
            currentStatus += 1;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      // initialValue: searchQuery,
                      controller: _searchController,
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          // beacuse we need a splash effect
                          onTap: () {
                            navigateToSearchScreen(_searchController.text);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: "Search Aamazon.in",
                        hintStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "View Order Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.black12.withOpacity(0.05),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Date   : ${DateFormat().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.order.orderAt),
                      )}",
                    ),
                    Text("Order ID       : ${widget.order.orderAt}"),
                    Text("Order Total  : \$${widget.order.totalPrice}"),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Purchase Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12.withOpacity(0.05),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; ++i)
                      Row(
                        children: [
                          Image.network(
                            widget.order.products[i].images[0],
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.products[i].name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  'Qty : ${widget.order.quantity[0]}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Tracking",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Stepper(
                  currentStep: currentStatus,
                  controlsBuilder: (context, details) {
                    if (user.type == 'admin' && details.currentStep <= 3) {
                      return CustomButton(
                          text: 'Done',
                          onTap: () => changeOrderStatus(details.currentStep));
                    }
                    return const SizedBox();
                  },
                  steps: [
                    Step(
                      title: const Text('Order Placed'),
                      content: const Text('Your Order is been placed'),
                      isActive: currentStatus > 0,
                      state: currentStatus > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Order Confirmed'),
                      content:
                          const Text('Your Order is comfirmed by the Vendor'),
                      isActive: currentStatus > 1,
                      state: currentStatus > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Packed'),
                      content: const Text(
                        'your order is packed and ready to shipped',
                      ),
                      isActive: currentStatus > 2,
                      state: currentStatus > 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Shipped'),
                      content: const Text('your order is being shipped '),
                      isActive: currentStatus > 3,
                      state: currentStatus > 3
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Delivered'),
                      content: const Text('your order is has been delivered'),
                      isActive: currentStatus == 4,
                      state: currentStatus == 4
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

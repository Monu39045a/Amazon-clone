import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/raddress';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  //controller
  final TextEditingController _flatBuildingController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  //formKey
  final _addressFormKey = GlobalKey<FormState>();

  //Variables
  final List<PaymentItem> _paymentItems = [];
  String addressTobeUsed = "";

  //Objects
  final AddressServices addressServices = AddressServices();

  //config
  bool isTestMode = true;
  late final Future<PaymentConfiguration> googlePayConfigFuture;

  @override
  void initState() {
    super.initState();
    _paymentItems.add(
      PaymentItem(
          amount: widget.totalAmount,
          label: 'Total Amount',
          status: PaymentItemStatus.final_price),
    );
    // if (isTestMode) {
    //   googlePayConfigFuture =
    //       PaymentConfiguration.testEnvironment(); // Use test environment
    // } else {
    //   googlePayConfigFuture = PaymentConfiguration.fromAsset(
    //       'google_pay.json'); // Use production config
    // }
    googlePayConfigFuture = PaymentConfiguration.fromAsset('google_pay.json');
  }

  @override
  void dispose() {
    super.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _flatBuildingController.dispose();
    _cityController.dispose();
  }

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressTobeUsed);
      addressServices.placeOrder(
        context: context,
        address: addressTobeUsed,
        totalSum: double.parse(widget.totalAmount),
      );
    }
  }

  void processOrder() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.address.isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressTobeUsed);
    }
    try {
      addressServices.placeOrder(
        context: context,
        address: addressTobeUsed,
        totalSum: double.parse(widget.totalAmount),
      );
    } on Exception catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  // used with OnTap
  void payPressed(String addressFromProvider) {
    addressTobeUsed = "";

    bool isForm = _areaController.text.isNotEmpty ||
        _cityController.text.isNotEmpty ||
        _pincodeController.text.isNotEmpty ||
        _flatBuildingController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressTobeUsed =
            '${_flatBuildingController.text},${_areaController.text} ,${_cityController.text} - ${_pincodeController.text}';
        processOrder();
      } else {
        throw Exception('Please Enter all the values! ');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressTobeUsed = addressFromProvider;
      processOrder();
    } else {
      showSnackBar(context, 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "OR",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _flatBuildingController,
                      hintText: 'Flat, House no, Building',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _areaController,
                      hintText: 'Area , Street',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: _cityController,
                      hintText: 'Town/ City',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: 'Place Order : COD',
                onTap: () => payPressed(address),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<PaymentConfiguration>(
                future: googlePayConfigFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return GooglePayButton(
                      width: double.infinity,
                      height: 50,
                      paymentConfiguration: snapshot.data!,
                      paymentItems: _paymentItems,
                      type: GooglePayButtonType.buy,
                      margin: const EdgeInsets.only(
                        top: 15,
                      ),
                      onPaymentResult: onGooglePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      onPressed: () => payPressed(address),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

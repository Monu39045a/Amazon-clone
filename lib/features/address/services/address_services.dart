import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/save-address'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
        body: jsonEncode({
          'address': address,
        }),
      );
      if (context.mounted) {
        httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            User user = userProvider.user
                .copyWith(address: jsonDecode(response.body)['address']);
            userProvider.setUserFromModel(user);
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "An Error occured ${e.toString()}");
      }
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      print("hi");
      http.Response response = await http.post(Uri.parse('$uri/api/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: jsonEncode(
            {
              'cart': userProvider.user.cart,
              'address': address,
              'totalPrice': totalSum,
            },
          ));

      if (context.mounted) {
        print("Sucess");
        httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Your order has been placed');
            User user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        print("error");
        showSnackBar(context, "An Error occured ${e.toString()}");
      }
    }
  }
}

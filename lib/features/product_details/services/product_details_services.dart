import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductDetailsService {
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // print("hello 1");
      print(product.id);
      http.Response response = await http.post(
        Uri.parse('$uri/api/add-product-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
        body: jsonEncode(
          {'id': product.id!},
        ),
      );
      // print("hello 2");
      if (context.mounted) {
        httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            User user = userProvider.user.copyWith(
              cart: jsonDecode(response.body)['cart'],
            );
            userProvider.setUserFromModel(user);
            showSnackBar(context, "Item Added to Card Sucessfully!!");
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        // print(e.toString());
        showSnackBar(context, 'An error occured ${e.toString()}');
      }
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    try {
      // Implement rate product
      // we need token of the user that's why we need provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // print(product);
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
        body: jsonEncode(
          {
            'id': product.id,
            'rating': rating,
          },
        ),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {},
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'An error occured ${e.toString()}');
      }
    }
  }
}

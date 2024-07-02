import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductDetailsService {
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

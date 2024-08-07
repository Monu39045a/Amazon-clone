import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartService {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/remove-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(
          {
            'productId': product.id!,
          },
        ),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            User user = userProvider.user.copyWith(
              cart: jsonDecode(response.body)['cart'],
            );
            userProvider.setUserFromModel(user);
            showSnackBar(context, "Item removed from Cart Sucessfully!!");
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'An error Occured ${e.toString()}');
      }
    }
  }
}

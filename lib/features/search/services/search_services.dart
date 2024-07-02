import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchServices {
  Future<List<Product>> fetchquerySearchProducts({
    required BuildContext context,
    required String query,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/search/$query'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (context.mounted) {
        // print(jsonDecode(response.body)); Json data , response was in String
        httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            final decodeddata = jsonDecode(response.body);
            //Convert to Product instance
            for (var productdata in decodeddata) {
              productList.add(
                Product.fromJson(
                  jsonEncode(productdata),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'An error occurred: ${e.toString()}');
      }
    }
    // print(productList);
    return productList;
  }
}

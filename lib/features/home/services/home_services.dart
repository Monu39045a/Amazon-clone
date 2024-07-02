import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    // print('$uri/api/products?category=$category'); URI
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
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

  Future<Product> fetchDealOfTheDay({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      price: 0,
      category: '',
      images: [],
    );
    // we cannnot use this over here because if there are no products.
    //It will make it null and then the Loader will keep on loading
    //Product? product; so it is better to initialize and check if name.isEmpty
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/deal-of-the-day'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (context.mounted) {
        httpErrorHandle(
          context: context,
          response: response,
          onSuccess: () {
            product = Product.fromJson(jsonEncode(jsonDecode(response.body)));
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'An error occurred: ${e.toString()}');
      }
    }
    return product;
  }
}

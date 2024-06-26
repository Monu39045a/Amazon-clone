import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double quantity,
    required double price,
    required String category,
    required List<File> images,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false).user; can directy user
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudanary = CloudinaryPublic('dguncm9yb', 'fy27bdr7');

      // Url of all the images that are stored in the Cloudinary
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; ++i) {
        CloudinaryResponse res = await cloudanary.uploadFile(
          CloudinaryFile.fromFile(
            images[i].path,
            resourceType: CloudinaryResourceType.Image,
            folder: name,
          ),
        );
        imageUrls.add(res.secureUrl); //Download url or upload url
      }

      // print(category);
      //Product Model
      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        price: price,
        category: category,
        images: imageUrls,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token
        },
        body: product.toJson(),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            if (context.mounted) {
              showSnackBar(context, "Product added Sucessfully!");
              Navigator.pop(context);
            }
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'An error occurred: ${e.toString()}');
      }
    }
  }

  //get all product
  // Future<List<Product>> fetchAllProducts(BuildContext context) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   final List<Product> allProducts = [];

  //   try {
  //     http.Response res = await http.get(
  //       Uri.parse('$uri/admin/get-products'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': userProvider.user.token
  //       },
  //     );
  //       httpErrorHandle(
  //         response: res,
  //         context: context,
  //         onSuccess: () {
  //         if (context.mounted) {
  //           // we are getting res as a Json we need to convert it into a Product model
  //           // print(res.body);
  //           for (int i = 0; i < jsonDecode(res.body).length; ++i) {
  //             allProducts.add(
  //               Product.fromJson(
  //                 jsonEncode(
  //                   jsonDecode(res.body)[i],
  //                 ),
  //               ),
  //             );
  //           }
  //         },
  //       );
  //       // print(allProducts.runtimeType);
  //       // print(allProducts);
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       showSnackBar(context, "Error fetching product $e");
  //     }
  //   }
  //   return allProducts;
  // }

  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final List<Product> allProducts = [];

    try {
      final response = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      if (context.mounted) {
        httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            if (context.mounted) {
              final decodedData = jsonDecode(response.body);
              for (var productData in decodedData) {
                allProducts.add(Product.fromJson(jsonEncode(productData)));
              }
            }
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Error fetching products: ${e.toString()}");
      }
    }
    return allProducts;
  }

  // delete Product
  void deletedProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSucess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/admin/delete-product'),
        body: jsonEncode({
          'id': product.id,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            onSucess();
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, "Error Deleting product: ${e.toString()}");
      }
    }
  }
}

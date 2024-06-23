import 'dart:io';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required int quantity,
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

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            if (context.mounted) {
              showSnackBar(context, "Product added Sucessfully!");
              Navigator.pop(context);
            }
          });
    } catch (e) {
      showSnackBar(context, 'An error occurred: ${e.toString()}');
    }
  }
}

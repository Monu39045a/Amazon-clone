import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  //signup user

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required VoidCallback onSuccess,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        token: '',
        type: '',
      );

      //here in body we have to pass json we have already created user which is type json only
      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account Created! Login with the same credentials',
          );
          onSuccess();
        },
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'An error occurred: ${e.toString()}');
      }
    }
  }
}

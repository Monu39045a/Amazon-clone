import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/home/screens/home_screen.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  //Sign In
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    try {
      //here in body we have to pass json we have already created user which is type json only
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      // print(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          // jsonDecode because we have res.body as a JSON and we are storing it as a String and then we are extracting token
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
          // onSuccess();
        },
      );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'An error occurred: ${e.toString()}');
      }
    }
  }

  // get User Data [sharedpreference token verification ]
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      // http.Response res = await http.post(Uri.parse('$uri/tokenIsValid'){

      // });
      //   //here in body we have to pass json we have already created user which is type json only
      //   http.Response res = await http.post(
      //     Uri.parse('$uri/api/signin'),
      //     body: jsonEncode({'email': email, 'password': password}),
      //     headers: <String, String>{
      //       'Content-Type': 'application/json; charset=UTF-8'
      //     },
      //   );

      // httpErrorHandle(
      //   response: res,
      //   context: context,
      //   onSuccess: () async {
      //     SharedPreferences prefs = await SharedPreferences.getInstance();
      //     Provider.of<UserProvider>(context, listen: false).setUser(res.body);
      //     // jsonDecode because we have res.body as a JSON and we are storing it as a String and then we are extracting token
      //     await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
      //     Navigator.pushNamedAndRemoveUntil(
      //         context, HomeScreen.routeName, (route) => false);
      //     // onSuccess();
      //   },
      // );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'An error occurred: ${e.toString()}');
      }
    }
  }
}

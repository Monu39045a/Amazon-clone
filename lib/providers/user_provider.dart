import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
  );

  User get user => _user;

  // Assign String type data
  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners(); // notify all to rebuild
  }

  // if we have User model data then
  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void removeFromCart(dynamic productId) {
    _user = _user.copyWith(
      cart: _user.cart.where((item) => item['id'] != productId).toList(),
    );
    notifyListeners();
  }
}

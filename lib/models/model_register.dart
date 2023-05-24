// models/model_register.dart
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  String email = "";
  String password = "";
  String passwordConfirm = "";
  String sex="";
  String old="";
  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setPasswordConfirm(String passwordConfirm) {
    this.passwordConfirm = passwordConfirm;
    notifyListeners();
  }

  void setsex(String sex) {
    this.sex = sex;
    notifyListeners();
  }

  void setold(String old) {
    this.old = old;
    notifyListeners();
  }
}
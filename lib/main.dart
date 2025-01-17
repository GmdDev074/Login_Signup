import 'package:flutter/material.dart';
import 'package:test_app/forgot_password.dart';
import 'package:test_app/login.dart';
import 'package:test_app/register.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'login',
    debugShowCheckedModeBanner: false,
    routes: {
      'login': (context)=> MyLogin(),
      'register': (context) => MyRegister(),
      'forgot_password': (context) => MyForgotPassword()
    },
  ));
}


import 'package:chat_apps/auth/login_or_register.dart';
import 'package:chat_apps/themes/light_mode.dart';
import 'package:flutter/material.dart';


void main() {
 runApp(const MyApp());
}
class MyApp extends StatelessWidget { 
const MyApp({super.key});

@override

Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home:  LoginOrRegister(), 
  theme: lightMode,
  );
}
}
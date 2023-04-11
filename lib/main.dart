import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paye_ton_kawa/products_page.dart';

import 'boxes.dart';
import 'login_page.dart';

void main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  await Hive.initFlutter();
  box = await Hive.openBox<String>('jwt_token_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paye ton kawa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: box.containsKey("jwt_token")
          ? const ProductsPage()
          : const LoginPage(),
    );
  }
}

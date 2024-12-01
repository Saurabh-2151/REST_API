import 'package:flutter/material.dart';
import 'package:rest__api/api_methods/fetch_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductsScreen(),
    );
  }
}

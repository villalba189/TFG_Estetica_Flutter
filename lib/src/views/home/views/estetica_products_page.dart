import 'package:estetica_app/src/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3000,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.colorGreen,
      ),
      child: const Center(
        child: Text('Productos'),
      ),
    );
  }
}

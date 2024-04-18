import 'package:estetica_app/src/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.colorRed,
      ),
      child: const Center(
        child: Text('Services'),
      ),
    );
  }
}

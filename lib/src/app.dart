import 'package:estetica_app/src/routes/routes.dart';
import 'package:flutter/material.dart';

import 'styles/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Estetica app TFG',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        canvasColor: Colors.transparent,
      ),
      routerConfig: router,
    );
  }
}

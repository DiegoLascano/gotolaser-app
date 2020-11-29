import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/custom_styles.dart';
import 'package:go_to_laser_store/providers/products_provider.dart';
import 'package:go_to_laser_store/screens/auth/signin_screen.dart';
import 'package:go_to_laser_store/screens/auth_check_screen.dart';
import 'package:go_to_laser_store/screens/navigation/home_screen.dart';
import 'package:go_to_laser_store/screens/store/products_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:go_to_laser_store/screens/auth/auth_home_screen.dart';
import 'package:go_to_laser_store/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GoTo Laser Store',
        home: HomeScreen(),
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: CustomStyles.customTextTheme,
          primarySwatch: tealVividSwatch,
          // accentColor: yellowVividSwatch[600],
        ),
      ),
    );
  }
}

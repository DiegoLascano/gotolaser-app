import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/providers/products_provider.dart';
import 'package:go_to_laser_store/screens/auth/signin_screen.dart';
import 'package:go_to_laser_store/screens/auth_check_screen.dart';
import 'package:go_to_laser_store/screens/navigation/home_screen.dart';
import 'package:go_to_laser_store/screens/store/products_screen.dart';
import 'package:go_to_laser_store/services/woocommerce_service.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:go_to_laser_store/styles/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:go_to_laser_store/screens/auth/auth_home_screen.dart';
import 'package:go_to_laser_store/services/auth_service.dart';

void main() => runApp(MyApp()
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => ProductsProvider()),
    //     Provider(
    //       create: (_) => WoocommerceService(),
    //     )
    //   ],
    //   child: MyApp(),
    // ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GoTo Laser Store',
        home: HomeScreen(),
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: AppTextStyles.customTextTheme,
          // primarySwatch: purpleSwatch
          primaryColor: AppColors.secondary,
          // accentColor: yellowVividSwatch[600],
        ),
      ),
    );
  }
}

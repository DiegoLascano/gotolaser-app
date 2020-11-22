import 'package:flutter/material.dart';
import 'package:go_to_laser_store/screens/auth/signin_screen.dart';
import 'package:go_to_laser_store/screens/auth_check_screen.dart';
import 'package:go_to_laser_store/screens/navigation/home_screen.dart';
import 'package:provider/provider.dart';

import 'package:go_to_laser_store/screens/auth/auth_home_screen.dart';
import 'package:go_to_laser_store/services/auth_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GoTo Laser Store',
        home: HomeScreen(),
      ),
    );
  }
}

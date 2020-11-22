import 'package:flutter/material.dart';
import 'package:go_to_laser_store/screens/auth/auth_home_screen.dart';
import 'package:go_to_laser_store/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return AuthHomeScreen();

    // return StreamBuilder(
    //   stream: stream,
    //   builder: (BuildContext context, AsyncSnapshot snapshot){
    //   if (snapshot.connectionState == ConnectionState.active) {
    //     final user = snapshot.data;
    //     if (user == null) {
    //       return AuthHomeScreen.create(context);
    //     } else {
    //       return Provider<Database>(
    //         create: (_) => FirestoreDatabase(uid: user.uid),
    //         child: HomeScreen(),
    //       );
    //     }
    //   } else {
    //     return Scaffold(
    //       body: Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //     );
    //   }
    // );
  }
}

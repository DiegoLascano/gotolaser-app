// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:go_to_laser_store/services/auth_service.dart';
//
// class AuthBloc {
//   AuthBloc({
//     @required this.auth,
//     @required this.isLoading,
//   });
//   final AuthBase auth;
//   final ValueNotifier<bool> isLoading;
//
//   Future<User> _authenticate(Future<User> Function() authMethod) async {
//     try {
//       isLoading.value = true;
//       return await authMethod();
//     } catch (e) {
//       isLoading.value = false;
//       rethrow;
//     }
//   }
//
//   Future<User> signInAnonymously() async =>
//       await _authenticate(auth.signInAnonymously);
//   Future<User> signInWithGoogle() async =>
//       await _authenticate(auth.signInWithGoogle);
// }

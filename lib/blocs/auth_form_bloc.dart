import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_to_laser_store/blocs/validators.dart';
import 'package:go_to_laser_store/services/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class AuthFormBloc with Validators {
  AuthFormBloc({@required this.auth});

  final AuthBase auth;
  // Stream controllers changed to BehaviorSubject in order to use rxdart combine2
  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _signingController = BehaviorSubject<bool>.seeded(false);

  // Fetch data from stream
  Stream<String> get firstNameStream =>
      _firstNameController.stream.transform(validateFirstName);
  Stream<String> get lastNameStream =>
      _lastNameController.stream.transform(validateLastName);
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get signingStream => _signingController.stream;

  // Combine streams
  Stream<bool> get loginValidStream =>
      Rx.combineLatest3(emailStream, passwordStream, signingStream, (e, p, s) {
        return (s == true) ? false : true;
      });
  Stream<bool> get registerValidStream => Rx.combineLatest4(firstNameStream,
      lastNameStream, emailStream, passwordStream, (n, l, e, p) => true);

  // Insert values to the stream
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(bool) get changeIsSigning => _signingController.sink.add;

  // Get last value of the streams
  String get firstName => _firstNameController.value;
  String get lastName => _lastNameController.value;
  String get email => _emailController.value;
  String get password => _passwordController.value;
  bool get isSigning => _signingController.value;

  // Future<User> _authenticate(Future<User> Function() authMethod) async {
  //   try {
  //     changeIsSigning(true);
  //     return await authMethod();
  //   } catch (e) {
  //     changeIsSigning(false);
  //     rethrow;
  //   }
  // }
  //
  // Future<User> signInWithEmailAndPassword() async => await _authenticate(
  //     () => auth.signInWithEmailAndPassword(email, password));
  // Future<User> createUserWithEmailAndPassword() async => await _authenticate(
  //     () => auth.createUserWithEmailAndPassword(email, password));

  dispose() {
    _firstNameController?.close();
    _lastNameController?.close();
    _emailController?.close();
    _passwordController?.close();
    _signingController?.close();
  }
}

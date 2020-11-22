import 'dart:async';

class Validators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      Pattern emailPattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(emailPattern);
      if (regExp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('Incorrect email');
      }
    },
  );
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError('3 caracteres mínimo');
      }
    },
  );

  final validateFirstName = StreamTransformer<String, String>.fromHandlers(
    handleData: (name, sink) {
      if (name.length >= 3) {
        sink.add(name);
      } else {
        sink.addError('3 caracteres mínimo');
      }
    },
  );

  final validateLastName = StreamTransformer<String, String>.fromHandlers(
    handleData: (lastName, sink) {
      if (lastName.length >= 3) {
        sink.add(lastName);
      } else {
        sink.addError('3 caracteres mínimo');
      }
    },
  );
}

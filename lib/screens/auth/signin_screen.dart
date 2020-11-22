import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_to_laser_store/blocs/auth_form_bloc.dart';
import 'package:go_to_laser_store/screens/auth/signup_screen.dart';
import 'package:go_to_laser_store/services/auth_service.dart';
import 'package:go_to_laser_store/widgets/common/platform_exception_alert_dialog.dart';
import 'package:go_to_laser_store/widgets/signin/signin_button.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key key, @required this.bloc}) : super(key: key);

  final AuthFormBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<AuthFormBloc>(
      create: (_) => AuthFormBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<AuthFormBloc>(
        builder: (context, bloc, _) => SignInScreen(bloc: bloc),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    try {
      // await bloc.signInWithEmailAndPassword();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Error al iniciar sesión',
        exception: e,
      ).show(context);
    }
  }

  void _createUserWithEmail(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => SignUpScreen.create(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _createForm(context),
          SafeArea(
            child: _createNavigation(context),
          ),
        ],
      ),
    );
  }

  Widget _createNavigation(BuildContext context) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Ingresa a tu',
            style: TextStyle(
                fontSize: 40.0,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'cuenta',
            style: TextStyle(
                fontSize: 40.0,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(30.0, 80.0, 30.0, 0.0),
          child: Column(
            children: <Widget>[
              _createHeader(context),
              SizedBox(height: 40.0),
              _createEmailInput(),
              SizedBox(height: 20.0),
              _createPassInput(),
              SizedBox(height: 40.0),
              _createSubmit(context),
              SizedBox(height: 60.0),
              _createRegisterButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createEmailInput() {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            // textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              isDense: false,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30.0)),
              // icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'ejemplo@correo.com',
              labelText: 'Email',
              // counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            // onChanged: (value) => bloc.changeEmail(value),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _createPassInput() {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          // padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30.0)),
              // icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
              // counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _createSubmit(BuildContext context) {
    return StreamBuilder(
      stream: bloc.loginValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          // margin: EdgeInsets.symmetric(horizontal: 40.0),
          width: double.infinity,
          child: SignInButton(
            text: 'Ingresar',
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).primaryColorLight,
            onPressed: snapshot.hasData
                ? (snapshot.data ? () => _submit(context) : null)
                : null,
          ),
        );
      },
    );
  }

  Widget _createRegisterButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Aún no tienes cuenta?'),
        FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(
            'Registrate aquí',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () => _createUserWithEmail(context),
        ),
      ],
    );
  }
}

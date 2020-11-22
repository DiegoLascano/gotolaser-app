import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_to_laser_store/blocs/auth_form_bloc.dart';
import 'package:go_to_laser_store/screens/auth/signin_screen.dart';
import 'package:go_to_laser_store/screens/auth/signup_screen.dart';
import 'package:go_to_laser_store/services/auth_service.dart';
import 'package:go_to_laser_store/widgets/common/platform_exception_alert_dialog.dart';
import 'package:go_to_laser_store/widgets/signin/signin_button.dart';
import 'package:provider/provider.dart';

class AuthHomeScreen extends StatelessWidget {
  // const AuthHomeScreen({Key key, @required this.bloc}) : super(key: key);
  // final AuthBloc bloc;

  // static Widget create(BuildContext context) {
  //   final auth = Provider.of<AuthBase>(context);
  //   return ChangeNotifierProvider<ValueNotifier<bool>>(
  //     create: (_) => ValueNotifier<bool>(false),
  //     child: Consumer<ValueNotifier<bool>>(
  //       builder: (_, isLoading, __) => Provider<AuthBloc>(
  //         create: (_) => AuthBloc(auth: auth, isLoading: isLoading),
  //         child: Consumer<AuthBloc>(
  //             builder: (context, bloc, _) => AuthHomeScreen(bloc: bloc)),
  //       ),
  //     ),
  //   );
  // }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Error al iniciar sesión',
      exception: exception,
    ).show(context);
  }

  void _createUserWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SignUpScreen.create(context),
      ),
    );
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SignInScreen.create(context),
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      // await bloc.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> _signInWithGoogle(BuildContext context) async {
  //   try {
  //     await bloc.signInWithGoogle();
  //   } on PlatformException catch (e) {
  //     if (e.code != 'ERROR_ABORTED_BY_USER') {
  //       _showSignInError(context, e);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final isLoading = Provider.of<ValueNotifier<bool>>(context);
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _createLoginButton(context),
              Column(
                children: <Widget>[
                  _createCardSwiper(false),
                  _createRegisterButtons(context, false),
                  // _createCardSwiper(isLoading.value),
                  // _createRegisterButtons(context, isLoading.value),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createLoginButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text(
          'Ingresar',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onPressed: () => _signInWithEmail(context),
      ),
    );
  }

  Widget _createCardSwiper(bool isLoading) {
    if (isLoading) {
      return SizedBox(
        height: 400.0,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return SizedBox(
        height: 400.0,
        child: Center(
          child: Text('Is NOT loading'),
        ),
      );
    }
  }

  Widget _createRegisterButtons(BuildContext context, bool isLoading) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40.0),
          width: double.infinity,
          child: SignInButton(
            text: 'Registrar Nueva Cuenta',
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).primaryColorLight,
            onPressed: isLoading ? null : () => _createUserWithEmail(context),
          ),
        ),
        SizedBox(height: 10.0),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 40.0),
        //   width: double.infinity,
        //   child: SocialSignInButton(
        //     text: 'Continuar con Facebook',
        //     color: Colors.grey[350],
        //     imagePath: 'assets/logos/facebook-logo.png',
        //     disabledColor: Theme.of(context).disabledColor,
        //     onPressed: isLoading ? null : () {},
        //   ),
        // ),
        // SizedBox(height: 10.0),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 40.0),
        //   width: double.infinity,
        //   child: SocialSignInButton(
        //     text: 'Continuar con Google',
        //     color: Colors.grey[350],
        //     imagePath: 'assets/logos/google-logo.png',
        //     disabledColor: Theme.of(context).disabledColor,
        //     onPressed: isLoading ? null : () => _signInWithGoogle(context),
        //   ),
        // ),
        SizedBox(height: 10.0),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40.0),
          width: double.infinity,
          child: SignInButton(
            text: 'Anonimamente',
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            disabledColor: Theme.of(context).primaryColorLight,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ),
      ],
    );
  }
}

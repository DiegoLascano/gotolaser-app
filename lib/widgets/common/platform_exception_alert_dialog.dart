import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:go_to_laser_store/widgets/common/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
        );

  static String _message(PlatformException exception) {
    if (exception.message ==
        'PERMISSION_DENIED: Missing or insufficient permissions.') {
      return 'Missing or insufficient permissions.';
    }
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'ERROR_WEAK_PASSWORD': 'Tu contraseña es muy débil.',
    'ERROR_INVALID_EMAIL': 'El correo ingresado es erroneo',
    'ERROR_EMAIL_ALREADY_IN_USE': 'El correo ingresado ya existe.',
    'ERROR_WRONG_PASSWORD': 'Contraseña incorrecta.',
    'ERROR_USER_NOT_FOUND': 'Usuario no existe o fue eliminado.',
    'ERROR_USER_DISABLED': 'Usuario bloqueado',
    'ERROR_TOO_MANY_REQUESTS': 'Demasiados intentos de inicio de sesión.',
    'ERROR_OPERATION_NOT_ALLOWED':
        'Cuentas con usuario y contraseña no están habilitadas.',
  };
}

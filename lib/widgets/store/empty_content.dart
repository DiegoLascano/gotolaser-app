import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.title = 'Lista Vacía',
    this.message =
        'Por ahora no existe contenido para esta sección. Pronto lo actualizaremos ',
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}

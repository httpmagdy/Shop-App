import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('An error occurred!'),
      content: Text('Something went wrong.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Oky!'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

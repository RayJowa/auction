import 'package:flutter/material.dart';

class Toast extends StatelessWidget {

  final String message ;
  const Toast({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Center(child: Text(message)),
    );
  }
}

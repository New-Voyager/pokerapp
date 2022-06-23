import 'package:flutter/material.dart';

class DialogNew extends StatelessWidget {
  const DialogNew({Key key}) : super(key: key);

  static Future<void> show(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 30.0,
        ),
        child: DialogNew(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

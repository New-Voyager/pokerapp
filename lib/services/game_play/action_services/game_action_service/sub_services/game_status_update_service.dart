import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatusUpdateService {
  GameStatusUpdateService._();

  static void updateStatus({
    BuildContext context,
    var status,
  }) {
    Provider.of<ValueNotifier<String>>(
      context,
      listen: false,
    ).value = status['tableStatus'];
  }
}

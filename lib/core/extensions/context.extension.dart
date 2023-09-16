import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  Future<T?> push<T>(Widget page) =>
      Navigator.push<T>(this, _transitTo(() => page));

  Future<bool> pop<T>([T? result]) => Navigator.maybePop(this, result);
}

const double _kDefaultDuration = .25;

typedef PageBuilder = Widget Function();

Route<T> _transitTo<T>(PageBuilder pageBuilder,
    [double duration = _kDefaultDuration]) {
  return MaterialPageRoute(builder: (context) => pageBuilder());
}

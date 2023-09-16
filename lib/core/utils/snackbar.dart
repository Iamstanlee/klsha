import 'package:flutter/material.dart';
import 'package:klsha/core/design_system/color.dart';

enum SnackbarType {
  info,
  error,
  success,
}

class SnackbarFactory {
  final String? message;
  final SnackbarType snackbarType;
  final int? duration;

  SnackbarFactory._({
    required this.snackbarType,
    this.duration,
    this.message,
  });

  void show(BuildContext context) {
    if (message == null) {
      return;
    }

    late final Color backgroundColor;

    switch (snackbarType) {
      case SnackbarType.info:
        backgroundColor = AppColor.black;
        break;
      case SnackbarType.error:
        backgroundColor = AppColor.error500;
        break;
      case SnackbarType.success:
        backgroundColor = AppColor.success500;
        break;
    }
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration ?? 3),
        content: Text(message!),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class Snackbar {
  Snackbar._();

  static SnackbarFactory info(
    String? message, {
    int? duration,
  }) {
    return SnackbarFactory._(
      message: message,
      snackbarType: SnackbarType.info,
      duration: duration,
    );
  }

  static SnackbarFactory error(
    String? message, {
    int? duration,
  }) {
    return SnackbarFactory._(
      message: message,
      snackbarType: SnackbarType.error,
      duration: duration,
    );
  }

  static SnackbarFactory success(
    String? message, {
    int? duration,
  }) {
    return SnackbarFactory._(
      message: message,
      snackbarType: SnackbarType.success,
      duration: duration,
    );
  }
}

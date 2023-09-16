import 'package:flutter/material.dart';
import 'package:klsha/core/design_system/color.dart';
import 'package:klsha/core/design_system/dimension.dart';
import 'package:klsha/core/design_system/typography.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String title;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key,
      style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimension.xs)),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: const BorderSide(color: AppColor.black),
          fixedSize: const Size(double.maxFinite, 50),
          backgroundColor: AppColor.black),
      onPressed: onPressed,
      child: isLoading
          ? const _ButtonLoadingAnimation()
          : Text(
              title,
              style: AppTypography.body1,
            ),
    );
  }
}

class _ButtonLoadingAnimation extends StatelessWidget {
  const _ButtonLoadingAnimation();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppDimension.lg,
      width: AppDimension.lg,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(AppColor.gray100),
      ),
    );
  }
}

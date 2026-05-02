import 'package:flutter/material.dart';
import '../../config/colors/app_colors.dart';
import '../../config/typography/app_typography.dart';

enum ButtonType { filled, outlined, text }

class CustomAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType buttonType;
  final Color backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  const CustomAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonType = ButtonType.filled,
    this.backgroundColor = AppColors.kAppPrimary,
    this.foregroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.filled:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor ?? AppColors.kAppWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          child: _buildChild(),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: backgroundColor,
            side: BorderSide(color: backgroundColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          child: _buildChild(),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          child: _buildChild(),
        );
    }
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.kAppWhite),
      );
    }
    return Text(text, style: AppTypography.style16SemiBold);
  }
}

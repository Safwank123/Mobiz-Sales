import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../../config/colors/app_colors.dart';
import '../../config/typography/app_typography.dart';
import '../extensions/app_extensions.dart';
import '../common_widgets/custom_app_button.dart';

abstract class AppPrompts {
  static void showSuccess({required String message}) => toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.flat,
    title: Text(message, style: AppTypography.style16Regular),
    autoCloseDuration: const Duration(seconds: 3),
    backgroundColor: Colors.white,
    foregroundColor: AppColors.kAppSuccess,
  );

  static void showError({required String message}) => toastification.show(
    type: ToastificationType.error,
    style: ToastificationStyle.flat,
    title: Text(message, style: AppTypography.style16Regular),
    autoCloseDuration: const Duration(seconds: 3),
    backgroundColor: Colors.white,
    foregroundColor: AppColors.kAppError,
  );

  static Future<T?> showConfirmDialog<T>(
    BuildContext context, {
    required String title,
    String? description,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = AppColors.kAppSuccess,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) => showDialog<T>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.kAppWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.style20Bold),
            if (description != null) ...[8.heightBox, Text(description, style: AppTypography.style16Regular)],
            24.heightBox,
            Row(
              children: [
                CustomAppButton(
                  onPressed: onCancel ?? () => Navigator.pop(context),
                  text: cancelText,
                  buttonType: ButtonType.outlined,
                  backgroundColor: AppColors.kAppDisabled,
                ).expanded(),
                16.widthBox,
                CustomAppButton(
                  onPressed: onConfirm,
                  text: confirmText,
                  buttonType: ButtonType.filled,
                  backgroundColor: confirmColor,
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

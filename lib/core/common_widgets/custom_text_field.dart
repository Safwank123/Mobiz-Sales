import 'package:flutter/material.dart';
import '../../config/colors/app_colors.dart';
import '../../config/typography/app_typography.dart';
import '../../config/constants/app_constants.dart';
import '../extensions/app_extensions.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.disableAllBorder = false,
    this.isPassword = false,
    this.readOnly = false,
    this.filled = true,
    this.enabled = true,
    this.controller,
    this.keyboardType,
    this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor = AppColors.kAppWhite,
    this.labelText,
    this.onChanged,
    this.onTap,
    this.headingLabelText,
    this.isRequired = false,
  });

  final String? hintText;
  final bool disableAllBorder;
  final bool isPassword;
  final bool readOnly;
  final bool filled;
  final bool enabled;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final int? maxLines;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final String? labelText;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final String? headingLabelText;
  final bool isRequired;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (widget.headingLabelText != null)
        Text.rich(
          TextSpan(
            text: widget.headingLabelText,
            style: AppTypography.style16Regular,
            children: widget.isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: AppTypography.style16Regular.copyWith(color: AppColors.kAppError),
                    ),
                  ]
                : [],
          ),
        ).pOnly(bottom: 10),
      TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        initialValue: widget.initialValue,
        obscureText: widget.isPassword && !isPasswordVisible,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: widget.disableAllBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(borderRadius),
                )
              : null,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                  onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                )
              : widget.suffixIcon,
          filled: widget.filled,
          fillColor: widget.fillColor,
          labelText: widget.labelText,
          enabled: widget.enabled,
        ),
      ),
    ],
  );
}

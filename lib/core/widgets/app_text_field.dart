import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starter_forge/core/utils/constants.dart';

/// Enhanced text field widget with validation and consistent styling
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.initialValue,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.showCharacterCount = false,
    this.variant = AppTextFieldVariant.outlined,
  });
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final bool showCharacterCount;
  final AppTextFieldVariant variant;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget? suffixIcon = widget.suffixIcon;

    // Add password visibility toggle for password fields
    if (widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(
          _showPassword ? Icons.visibility_off : Icons.visibility,
          color: colorScheme.onSurfaceVariant,
        ),
        onPressed: () {
          setState(() {
            _showPassword = !_showPassword;
            _obscureText = !_showPassword;
          });
        },
      );
    }

    // Build input decoration based on variant
    InputDecoration getInputDecoration() {
      switch (widget.variant) {
        case AppTextFieldVariant.outlined:
          return InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding:
                widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: widget.maxLines == 1 ? 16 : 12,
                ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          );

        case AppTextFieldVariant.filled:
          return InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding:
                widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: widget.maxLines == 1 ? 16 : 12,
                ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
          );

        case AppTextFieldVariant.underlined:
          return InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding:
                widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding,
                  vertical: 12,
                ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
          );
      }
    }

    final textField = TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      decoration: getInputDecoration(),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      maxLength: widget.showCharacterCount ? widget.maxLength : null,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
    );

    // Add character count if needed and not showing in decoration
    if (widget.showCharacterCount && widget.maxLength != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textField,
          if (!widget.showCharacterCount) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '${widget.controller?.text.length ?? widget.initialValue?.length ?? 0}/${widget.maxLength}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      );
    }

    return textField;
  }
}

/// Text field variants
enum AppTextFieldVariant { outlined, filled, underlined }

import 'package:flutter/material.dart';
import 'package:starter_forge/core/utils/constants.dart';

/// Enhanced button widget with loading states and variants
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine button colors based on variant
    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;

      switch (variant) {
        case AppButtonVariant.primary:
          return colorScheme.primary;
        case AppButtonVariant.secondary:
          return colorScheme.secondary;
        case AppButtonVariant.outline:
          return Colors.transparent;
        case AppButtonVariant.text:
          return Colors.transparent;
        case AppButtonVariant.error:
          return colorScheme.error;
        case AppButtonVariant.success:
          return Colors.green;
      }
    }

    Color getForegroundColor() {
      if (foregroundColor != null) return foregroundColor!;

      switch (variant) {
        case AppButtonVariant.primary:
          return colorScheme.onPrimary;
        case AppButtonVariant.secondary:
          return colorScheme.onSecondary;
        case AppButtonVariant.outline:
          return colorScheme.primary;
        case AppButtonVariant.text:
          return colorScheme.primary;
        case AppButtonVariant.error:
          return colorScheme.onError;
        case AppButtonVariant.success:
          return Colors.white;
      }
    }

    // Determine button size
    EdgeInsets getPadding() {
      if (padding != null) return padding!;

      switch (size) {
        case AppButtonSize.small:
          return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        case AppButtonSize.medium:
          return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
        case AppButtonSize.large:
          return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
      }
    }

    double getFontSize() {
      switch (size) {
        case AppButtonSize.small:
          return 14;
        case AppButtonSize.medium:
          return 16;
        case AppButtonSize.large:
          return 18;
      }
    }

    // Build button style
    ButtonStyle getButtonStyle() {
      return ElevatedButton.styleFrom(
        backgroundColor: getBackgroundColor(),
        foregroundColor: getForegroundColor(),
        padding: getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.borderRadius,
          ),
          side: variant == AppButtonVariant.outline
              ? BorderSide(color: colorScheme.primary, width: 1.5)
              : BorderSide.none,
        ),
        elevation:
            variant == AppButtonVariant.text ||
                variant == AppButtonVariant.outline
            ? 0
            : 2,
        textStyle: TextStyle(
          fontSize: getFontSize(),
          fontWeight: FontWeight.w600,
        ),
      );
    }

    Widget buildButtonContent() {
      if (isLoading) {
        return SizedBox(
          height: getFontSize() + 4,
          width: getFontSize() + 4,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(getForegroundColor()),
          ),
        );
      }

      if (icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: getFontSize() + 2),
            const SizedBox(width: 8),
            Text(text),
          ],
        );
      }

      return Text(text);
    }

    return ElevatedButton(
      onPressed: (isEnabled && !isLoading) ? onPressed : null,
      style: getButtonStyle(),
      child: buildButtonContent(),
    );
  }
}

/// Button variants
enum AppButtonVariant { primary, secondary, outline, text, error, success }

/// Button sizes
enum AppButtonSize { small, medium, large }

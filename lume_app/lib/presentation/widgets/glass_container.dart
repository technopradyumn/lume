import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withOpacity(0.85),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? AppColors.borderDefault,
        ),
      ),
      child: child,
    );
  }
}

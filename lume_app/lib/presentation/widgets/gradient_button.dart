import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSmall;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(isSmall ? 8 : 12),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentStart.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(isSmall ? 8 : 12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmall ? 16 : 24,
              vertical: isSmall ? 10 : 14,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, size: isSmall ? 16 : 18, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: isSmall ? 12 : 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

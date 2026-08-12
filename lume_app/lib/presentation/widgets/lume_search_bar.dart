import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LumeSearchBar extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  const LumeSearchBar({super.key, this.onSubmitted, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: TextField(
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: const InputDecoration(
          hintText: 'Search videos, topics...',
          hintStyle: TextStyle(fontSize: 13, color: AppColors.textTertiary),
          prefixIcon: Icon(Icons.search, size: 18, color: AppColors.textTertiary),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

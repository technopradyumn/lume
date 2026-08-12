import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';

class ChannelAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool showOnline;
  final bool showGradientBorder;

  const ChannelAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 36,
    this.showOnline = false,
    this.showGradientBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: showGradientBorder ? AppColors.accentGradient : null,
              border: !showGradientBorder
                  ? Border.all(color: AppColors.borderDefault, width: 2)
                  : null,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _buildFallback(),
                      errorWidget: (_, __, ___) => _buildFallback(),
                    )
                  : _buildFallback(),
            ),
          ),
          if (showOnline)
            Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bgSurface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.accentGradient,
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.35,
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/colors/app_colors.dart';

class CustomImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final double borderRadius;
  final bool isCircular;

  const CustomImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius = 0,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: isCircular
          ? BorderRadius.circular((width ?? height ?? 0) / 2)
          : BorderRadius.circular(borderRadius),
    ),
    child: ClipRRect(
      borderRadius: isCircular
          ? BorderRadius.circular((width ?? height ?? 0) / 2)
          : BorderRadius.circular(borderRadius),
      child: _buildImage(),
    ),
  );

  Widget _buildImage() {
    if (imageUrl.isSvg) {
      return _buildSvgImage();
    } else if (imageUrl.isNetworkImage) {
      return _buildNetworkImage();
    } else {
      return _buildAssetImage();
    }
  }

  Widget _buildSvgImage() => imageUrl.contains('http')
      ? SvgPicture.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        )
      : SvgPicture.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );

  Widget _buildNetworkImage() => CachedNetworkImage(
    imageUrl: imageUrl,
    width: width,
    height: height,
    fit: fit,
    color: color,
    errorWidget: (context, url, error) {
      log('Network Image load error: $url\nError: $error');
      return _defaultErrorWidget();
    },
  );

  Widget _buildAssetImage() => Image.asset(
    imageUrl,
    width: width,
    height: height,
    fit: fit,
    color: color,
    errorBuilder: (context, error, stackTrace) {
      log('Asset Image load error: $imageUrl\nError: $error\nStackTrace: $stackTrace');
      return _defaultErrorWidget();
    },
  );

  Widget _defaultErrorWidget() => Container(
    color: AppColors.kAppDisabled,
    child: const Icon(Icons.broken_image, color: AppColors.kAppWhite),
  );
}

extension ImageUrlExtension on String {
  bool get isSvg => toLowerCase().endsWith('.svg');

  bool get isNetworkImage {
    final lowerCase = toLowerCase();
    return lowerCase.startsWith('http://') || lowerCase.startsWith('https://') || lowerCase.startsWith('www.');
  }
}

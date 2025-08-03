import 'dart:io';
import 'dart:math';

import 'package:apliko/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    this.url,
    this.file,
    this.size,
    this.fit = BoxFit.contain,
    this.borderRadius = 0,
    this.onTap,
    this.withLoading = true,
    this.border,
    this.openImage = true,
    this.placeholder,
    this.placeholderAsset,
    this.originalImageUrl,
  });
  final bool openImage;
  final String? originalImageUrl;
  final bool withLoading;
  final Widget? placeholder;
  final String? placeholderAsset;
  final Border? border;
  final VoidCallback? onTap;
  final String? url;
  final File? file;
  final double? borderRadius, size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return url != null && file == null
        ? CachedNetworkImage(
          imageUrl: url!,
          fit: fit,
          imageBuilder:
              (context, imageProvider) => Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  border: border,
                ),
              ),
          placeholder:
              (_, __) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.greyText,
                  shape: BoxShape.circle,
                ),
              ),
          errorWidget:
              (_, __, ___) =>
                  placeholder ??
                  _PlaceHolderImage(
                    height: size,
                    asset: placeholderAsset,
                    border: border,
                  ),
        )
        : file != null
        ? Image.file(file!, fit: fit)
        : placeholder ??
            _PlaceHolderImage(
              height: size,
              asset: placeholderAsset,
              border: border,
            );
  }
}

class _PlaceHolderImage extends StatelessWidget {
  const _PlaceHolderImage({required this.height, this.asset, this.border});

  final double? height;
  final Border? border;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(border: border, shape: BoxShape.circle),
      child: Image.asset(
        asset ?? Assets.assetsImagesPerson,
        cacheHeight: max(height?.toInt() ?? 0, 105),
        cacheWidth: max(height?.toInt() ?? 0, 105),
      ).clipRRect(all: 100),
    );
  }
}

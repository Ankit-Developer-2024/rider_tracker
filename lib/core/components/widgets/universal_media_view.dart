import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';
import 'package:rider_tracker/core/utility/utils.dart';


class UniversalMediaView extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final String? path;
  final String? placeHolderPath;
  final double? imageWidth;
  final double? imageHeight;
  final BoxFit fit;
  final Widget? errorWidget;
  final Widget? placeHolder;
  final bool isImageRound;
  final bool isRepeat;
  final Function? onTap;
  final String? mediaTypeEnum;
  final Color? tintColor;
  final Color background;
  final Color borderColor;
  final bool isClickable;
  final BorderRadius? borderRadius;
  final BorderRadius? backgroundRadius;
  final bool useResizeImage;
  final bool isCached;

  const UniversalMediaView({
    super.key,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    required this.path,
    this.placeHolderPath,
    this.imageWidth,
    this.imageHeight,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeHolder,
    this.isImageRound = false,
    this.isRepeat = true,
    this.onTap,
    this.mediaTypeEnum = '',
    this.tintColor,
    this.background = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.isClickable = false,
    this.borderRadius,
    this.backgroundRadius,
    this.useResizeImage = true,
    this.isCached = true,
  });

  @override
  Widget build(BuildContext context) {
    return isClickable
        ? InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
            child: Container(
              width: imageWidth,
              height: imageHeight,
              margin: margin,
              decoration: isImageRound
                  ? BoxDecoration(shape: BoxShape.circle, color: background, border: Border.all(color: borderColor))
                  : BoxDecoration(color: background, borderRadius: backgroundRadius),
              child: Padding(
                  padding: padding,
                  child: ClipRRect(
                    borderRadius: borderRadius ?? BorderRadius.all(isImageRound ? Radius.circular(imageHeight ?? 2 / 2) : const Radius.circular(0.0)),
                    child: _getImageView(isCached: isCached, isHttpOnly: false),
                  )),
            ),
          )
        : Container(
            width: imageWidth,
            height: imageHeight,
            margin: margin,
            decoration: isImageRound
                ? BoxDecoration(shape: BoxShape.circle, color: background, border: Border.all(color: borderColor))
                : BoxDecoration(color: background, borderRadius: backgroundRadius),
            child: Padding(
                padding: padding,
                child: ClipRRect(
                  borderRadius: borderRadius ?? BorderRadius.all(isImageRound ? Radius.circular(imageHeight ?? 2 / 2) : const Radius.circular(0.0)),
                  child: _getImageView(isCached: isCached, isHttpOnly: false),
                )),
          );
  }

  Widget? _getImageView({bool isCached = true, bool isHttpOnly = false}) {
    MediaType imageType = getImageType(path ?? '');
    if (imageType == MediaType.networkImage) {
      var url = isHttpOnly ? path ?? ''.replaceFirst('https', 'http') : path;
      // appLog("IMAGE_PATH U ===> $url");
      return !isCached
          ? Image.network(
              url ?? '',
              width: imageWidth,
              height: imageHeight,
              cacheHeight: useResizeImage && imageHeight != null ? imageHeight!.toInt() * 2000 : null,
              cacheWidth: useResizeImage && imageWidth != null ? imageWidth!.toInt() * 2000 : null,
              fit: fit,
              headers: const {"Connection": "Keep-Alive", "Keep-Alive": "timeout=5, max=1000"},
              errorBuilder: (context, error, stackTrace) => Container(child: errorHolderImage()),
              loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : placeHolderImage()!,
            )
          : CachedNetworkImage(
              imageUrl: url ?? '',
              width: imageWidth,
              height: imageHeight,
              memCacheHeight: useResizeImage && imageHeight != null ? imageHeight!.toInt() * 2000 : null,
              memCacheWidth: useResizeImage && imageWidth != null ? imageWidth!.toInt() * 2000 : null,
              maxHeightDiskCache: useResizeImage && imageHeight != null ? imageHeight!.toInt() * 2000 : null,
              maxWidthDiskCache: useResizeImage && imageWidth != null ? imageWidth!.toInt() * 2000 : null,
              fit: fit,
              errorWidget: (context, url, error) => Container(child: errorHolderImage()),
              placeholder: (context, url) => Container(child: placeHolderImage()),
            );
    } else if (imageType == MediaType.assetImage) {
      return Image.asset(
        path ?? '',
        width: imageWidth,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(child: errorHolderImage()),
      );
    } else if (imageType == MediaType.networkSVG) {
      return SvgPicture.network(
        path ?? '',
        width: imageWidth,
        colorFilter: tintColor != null ? ColorFilter.mode(tintColor!, BlendMode.color) : null,
        fit: fit,
        placeholderBuilder: (BuildContext context) => Container(child: placeHolderImage()),
      );
    } else if (imageType == MediaType.assetSVG) {
      return SvgPicture.asset(
        path ?? '',
        width: imageWidth,
        height: imageHeight,
        colorFilter: tintColor != null ? ColorFilter.mode(tintColor!, BlendMode.srcIn) : null,
        fit: fit,
        placeholderBuilder: (BuildContext context) => Container(child: placeHolderImage()),
      );
    } else if (imageType == MediaType.networkLottie) {
      return Lottie.network(
        path ?? '',
        fit: fit,
        width: imageWidth,
        repeat: isRepeat,
        errorBuilder: (context, error, stackTrace) {
          appLog("lottie error: $error");
          return placeHolderImage() ?? Container();
        },
      );
    } else if (imageType == MediaType.assetLottie) {
      return Lottie.asset(
        path ?? '',
        fit: fit,
        width: imageWidth,
        repeat: isRepeat,
        errorBuilder: (context, error, stackTrace) {
          appLog("lottie error: $error");
          return placeHolderImage() ?? Container();
        },
      );
    } else {
      return placeHolder ?? errorHolderImage();
    }
  }

  MediaType getImageType(String? path) {
    if (path != null && path.isNotEmpty) {
      if (isUrlCorrect(path) && (mediaTypeEnum != null ? mediaTypeEnum!.isNotEmpty : mediaTypeEnum != null)) {
        if (mediaTypeEnum == "SVG") {
          return MediaType.networkSVG;
        } else if (mediaTypeEnum == "LOTTIE") {
          return MediaType.networkLottie;
        } else if (mediaTypeEnum == "PNG") {
          return MediaType.networkImage;
        } else if (mediaTypeEnum == "IMAGE") {
          return MediaType.networkImage;
        } else {
          return MediaType.error;
        }
      } else if (isUrlCorrect(path) && (mediaTypeEnum != null ? mediaTypeEnum!.isEmpty : mediaTypeEnum == null)) {
        // Fallback in case imageTypeEnum is null from backend
        if (path.endsWith("svg") || path.contains('.svg?')) {
          return MediaType.networkSVG;
        } else if (path.endsWith("json") || path.contains('.json?')) {
          return MediaType.networkLottie;
        } else if (path.endsWith("png") ||
            path.endsWith("jpg") ||
            path.endsWith("jpeg") ||
            path.endsWith("gif") ||
            path.contains('.png?') ||
            path.contains('.jpg?') ||
            path.contains('.jpeg?') ||
            path.contains('.gif?')) {
          return MediaType.networkImage;
        } else {
          return MediaType.error;
        }
      } else {
        if (path.endsWith("svg")) {
          return MediaType.assetSVG;
        } else if (path.endsWith("json")) {
          return MediaType.assetLottie;
        } else if (path.endsWith("png") || path.endsWith("jpg") || path.endsWith("jpeg") || path.endsWith("gif")) {
          return MediaType.assetImage;
        } else {
          return MediaType.error;
        }
      }
    } else {
      return MediaType.error;
    }
  }

  Widget? placeHolderImage() {
    return placeHolderPath != null
        ? UniversalMediaView(
            path: placeHolderPath ?? '',
            imageWidth: imageWidth,
            imageHeight: imageHeight,
            fit: fit,
          )
        : placeHolder ??
            Container(
              height: imageHeight ?? 100,
              width: imageWidth ?? 100,
              color: AppColors.grey600,
            );
  }

  Widget? errorHolderImage() {
    return placeHolderPath != null
        ? UniversalMediaView(
            path: placeHolderPath ?? '',
            imageWidth: imageWidth,
            imageHeight: imageHeight,
            fit: fit,
          )
        : errorWidget ??
            Container(
              height: imageHeight ?? 100,
              width: imageWidth ?? 100,
              color: AppColors.grey600,
            );
  }
}

enum MediaType {
  networkSVG,
  networkLottie,
  networkImage,
  error,
  assetSVG,
  assetLottie,
  assetImage,
}

import 'package:flutter/material.dart';
import 'package:rider_tracker/core/styles/app_text_styles.dart';

import '../../styles/app_colors.dart';


class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPress;
  final bool isEnabled;
  final String? title;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final TextStyle? titleStyle;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  /// defaults to giving 10 px
  final double leftIconTitleSpacing;

  /// defaults to giving 10 px
  final double rightIconTitleSpacing;

  const PrimaryButton({
    super.key,
    this.title,
    this.onPress,
    this.isEnabled = true,
    this.leftIcon,
    this.rightIcon,
    this.padding,
    this.backgroundColor = AppColors.primary,
    this.disabledBackgroundColor = AppColors.grey300,
    this.titleStyle,
    this.borderRadius,
    this.leftIconTitleSpacing = 10,
    this.rightIconTitleSpacing = 10,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onPress : null,
      child: Container(
        alignment: Alignment.center,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          color: isEnabled ? backgroundColor : disabledBackgroundColor,
          border: border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leftIcon != null) leftIcon!,
            if (title != null)
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: leftIcon != null ? leftIconTitleSpacing : 0,
                    right: rightIcon != null ? rightIconTitleSpacing : 0,
                  ),
                  child: Text(
                    title!,
                    style: titleStyle ??
                        AppTextStyles.regular14P(
                          color: AppColors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (rightIcon != null) rightIcon!,
          ],
        ),
      ),
    );
  }
}

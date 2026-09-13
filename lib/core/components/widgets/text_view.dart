import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final String? title;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final Alignment? alignment;
  final BoxDecoration decoration;
  final double? height;
  final double? width;
  final TextOverflow? textOverflow;
  final String? id;
  final int? maxLines;
  final bool excludeSemantics;

  const TextView(
      {Key? key,
      this.margin = const EdgeInsets.all(0),
      this.padding = const EdgeInsets.all(0),
      required this.title,
      this.textStyle,
      this.textAlign = TextAlign.left,
      this.alignment,
      this.decoration = const BoxDecoration(),
      this.height,
      this.width,
      this.textOverflow = TextOverflow.visible,
      this.maxLines, this.excludeSemantics = false,
      this.id = "UNUSED_LABEL"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: margin,
      alignment: alignment,
      decoration: decoration,
      height: height,
      width: width,
      child: Padding(
        padding: padding,
        child: Semantics(
          label: id,
          excludeSemantics: excludeSemantics,
          child: Text(
            title ?? '',
            overflow: textOverflow,
            maxLines: maxLines,
            style: textStyle,
            textAlign: textAlign,
            key: id == null ? null : Key(id!),
          ),
        ),
      ),
    );
  }
}

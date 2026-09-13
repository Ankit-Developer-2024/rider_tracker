import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider_tracker/core/styles/app_colors.dart';

class AppTextStyles {
  static TextStyle regular10P({Color? color}) => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle medium10P({Color? color, TextDecoration? decoration}) => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.justBlack,
        decoration: decoration,
      );

  static TextStyle light12P({Color? color}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle light14P({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle regular12P({Color? color}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle regular12I({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle medium12P({Color? color}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle medium12I({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle regular14P({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle regular20P({Color? color}) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle medium14P({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle medium16P({Color? color}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.justBlack,
      );

      static TextStyle medium18P({Color? color}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle medium20P({Color? color}) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.justBlack,
      );    

  static TextStyle bold14P({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle regular16P({Color? color}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle semibold10P({Color? color}) => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle semibold18P({Color? color}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.justBlack,
      );
  static TextStyle semiBold16P({Color? color,}) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle semiBold14P({Color? color,}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle semiBold12P({Color? color,}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.justBlack,
      );
  static TextStyle semiBold18P({Color? color}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.justBlack,
      );

  static TextStyle light9P({Color? color}) => GoogleFonts.poppins(
        fontSize: 9,
        fontWeight: FontWeight.w300,
        color: color ?? AppColors.black,
      );

  static TextStyle light10P({Color? color}) => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w300,
        color: color ?? AppColors.subTextColor,
      );

  static TextStyle semiBold20P({Color? color}) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.justBlack,
      );


  static TextStyle semiBold27P({Color? color}) => GoogleFonts.poppins(
    fontSize: 27,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.justBlack,
  );

    static TextStyle semiBold30P({Color? color}) => GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.justBlack,
  );

  static TextStyle regular12PU({Color? color})=>GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    shadows: [ Shadow(color: color?? AppColors.black, offset: const Offset(0, -1.1))],
    color: Colors.transparent,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.justGrey60,
    decorationThickness: 0.9,
  );

  static TextStyle medium14PInter({Color? color})=>GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: color??AppColors.justBlack
  );


  static TextStyle semiBold12PU({Color? color})=>GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    shadows: [ Shadow(color: color?? AppColors.black, offset: const Offset(0, -1.1))],
    color: Colors.transparent,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.darkRed,
    decorationThickness: 0.9,
  );


  static TextStyle regular24P({Color? color})=>GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: color??AppColors.justBlack
  );

  static TextStyle regular34P({Color? color})=>GoogleFonts.poppins(
      fontSize: 34,
      fontWeight: FontWeight.normal,
      color: color??AppColors.justBlack
  );

  static TextStyle medium22P({Color? color})=>GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: color??AppColors.justBlack
  );

  static TextStyle medium24P({Color? color})=>GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: color??AppColors.justBlack
  );

  static TextStyle medium28P({Color? color})=>GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: color??AppColors.justBlack
  );

  static TextStyle semiBold24P({Color? color})=>GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color??AppColors.justBlack
  );

  static TextStyle bold20P({Color? color})=>GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: color??AppColors.justBlack
  );

  static TextStyle bold24P({Color? color})=>GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: color??AppColors.justBlack
  );

  static TextStyle bold26P({Color? color})=>GoogleFonts.poppins(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: color??AppColors.justBlack
  );
}

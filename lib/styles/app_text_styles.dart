import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:go_to_laser_store/styles/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // pair-font sansita(headline)-una(title)-signika/nunitoSans(body)
  static TextTheme customTextTheme = TextTheme(
    headline1: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 46,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
    ),
    headline2: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
    ),
    headline3: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
    ),
    headline4: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
    ),
    subtitle1: GoogleFonts.nunito(
      textStyle: TextStyle(
        // fontStyle: FontStyle.italic,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryText,
      ),
    ),
    subtitle2: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryText,
      ),
    ),
    //signika
    bodyText1: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.descriptionText,
      ),
    ),

    /// this is the default for the rest of the app
    bodyText2: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.descriptionText,
      ),
    ),

    button: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryText,
      ),
    ),
  );
}

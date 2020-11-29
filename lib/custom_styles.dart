import 'package:flutter/material.dart';
import 'package:go_to_laser_store/color_swatches.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStyles {
  static TextTheme customTextTheme = TextTheme(
    headline1: GoogleFonts.sansita(
      textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: greySwatch.shade900,
      ),
    ),
    subtitle1: GoogleFonts.unna(
      textStyle: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: greySwatch.shade900,
      ),
    ),
    subtitle2: GoogleFonts.unna(
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: greySwatch.shade800,
      ),
    ),
    //signika
    bodyText1: GoogleFonts.nunitoSans(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: greySwatch.shade700,
      ),
    ),

    /// this is the default for the rest of the app
    bodyText2: GoogleFonts.signika(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: greySwatch.shade700,
      ),
    ),
  );
}

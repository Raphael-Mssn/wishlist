// define a ThemeData
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishlist/shared/theme/colors.dart';

ThemeData get theme => ThemeData(
      fontFamily: 'Truculenta',
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.background,
        dividerColor: Colors.transparent,
        indicatorColor: AppColors.primary,
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        // Necessary for setting the selectionHandleColor
        primaryColor: AppColors.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        showCloseIcon: true,
        closeIconColor: AppColors.background,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        dismissDirection: DismissDirection.horizontal,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.darkGrey,
        contentTextStyle: GoogleFonts.truculenta(
          color: AppColors.background,
          fontSize: 22,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
        selectionColor: AppColors.primary.withOpacity(0.3),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: GoogleFonts.truculenta(
          fontSize: 20,
          color: AppColors.darkGrey,
        ),
        labelStyle: GoogleFonts.truculenta(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          color: AppColors.darkGrey,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );

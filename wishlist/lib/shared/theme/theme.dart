import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/gen/fonts.gen.dart';
import 'package:wishlist/shared/theme/colors.dart';

ThemeData get theme => ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      primaryColorDark: AppColors.darkOrange,
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.background,
        dividerColor: Colors.transparent,
        indicatorColor: AppColors.primary,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        // Necessary for setting the selectionHandleColor
        primaryColor: AppColors.makara,
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
        contentTextStyle: const TextStyle(
          fontFamily: FontFamily.truculenta,
          color: AppColors.background,
          fontSize: 22,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
        selectionColor: AppColors.primary.withOpacity(0.3),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelStyle: TextStyle(
          fontFamily: FontFamily.truculenta,
          fontSize: 20,
          color: AppColors.darkGrey,
        ),
        labelStyle: TextStyle(
          fontFamily: FontFamily.truculenta,
          fontSize: 20,
          fontStyle: FontStyle.italic,
          color: AppColors.darkGrey,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );

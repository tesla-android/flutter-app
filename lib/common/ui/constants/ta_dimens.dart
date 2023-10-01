// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class TADimens {
  static const PADDING_XXXS_VALUE = 2.0;
  static const PADDING_XXS_VALUE = 4.0;
  static const PADDING_XS_VALUE = 6.0;
  static const PADDING_S_VALUE = 8.0;
  static const PADDING_SEMI_S_VALUE = 10.0;
  static const PADDING_VALUE = 12.0;
  static const PADDING_L_VALUE = 18.0;
  static const PADDING_SEMI_L_VALUE = 22.0;
  static const PADDING_XL_VALUE = 25.0;
  static const PADDING_XXL_VALUE = 30.0;
  static const PADDING_XXXL_VALUE = 40.0;

  static const PADDING_XXXS = EdgeInsets.all(PADDING_XXXS_VALUE);
  static const PADDING_XXS = EdgeInsets.all(PADDING_XXS_VALUE);
  static const PADDING_XS = EdgeInsets.all(PADDING_XS_VALUE);
  static const PADDING_S = EdgeInsets.all(PADDING_S_VALUE);
  static const PADDING = EdgeInsets.all(PADDING_VALUE);
  static const PADDING_L = EdgeInsets.all(PADDING_L_VALUE);
  static const PADDING_XL = EdgeInsets.all(PADDING_XL_VALUE);
  static const PADDING_XXL = EdgeInsets.all(PADDING_XXL_VALUE);
  static const PADDING_XXXL = EdgeInsets.all(PADDING_XXXL_VALUE);

  static const VERTICAL_PADDING_S =
  EdgeInsets.only(top: PADDING_S_VALUE, bottom: PADDING_S_VALUE);
  static const VERTICAL_PADDING =
  EdgeInsets.only(top: PADDING_VALUE, bottom: PADDING_VALUE);
  static const VERTICAL_PADDING_L =
  EdgeInsets.only(top: PADDING_L_VALUE, bottom: PADDING_L_VALUE);

  static const ROUND_BORDER_RADIUS_XXS = 8.0;
  static const ROUND_BORDER_RADIUS_XS = 10.0;
  static const ROUND_BORDER_RADIUS_S = 16.0;
  static const ROUND_BORDER_RADIUS = 18.0;
  static const ROUND_BORDER_RADIUS_L = 24.0;
  static const ROUND_BORDER_RADIUS_XL = 28.0;
  static const ROUND_BORDER_RADIUS_XXL = 34.0;

  static const ELEVATION_XXS = 4.0;
  static const ELEVATION_XS = 6.0;
  static const ELEVATION_S = 8.0;
  static const ELEVATION = 10.0;
  static const ELEVATION_L = 12.0;
  static const ELEVATION_XL = 14.0;
  static const ELEVATION_XXL = 16.0;

  static const baseContentMargin = 16.0;
  static const halfBaseContentMargin = 8.0;

  static const halfBasePadding = EdgeInsets.all(halfBaseContentMargin);
  static const halfBasePaddingHorizontal =
      EdgeInsets.symmetric(horizontal: halfBaseContentMargin);
  static const halfBasePaddingVertical =
      EdgeInsets.symmetric(vertical: halfBaseContentMargin);

  static const basePadding = EdgeInsets.all(baseContentMargin);
  static const basePaddingHorizontal =
      EdgeInsets.symmetric(horizontal: baseContentMargin);
  static const basePaddingVertical =
      EdgeInsets.symmetric(vertical: baseContentMargin);

  static const splashPageLogoHeight = 200.0;
  static const splashPageRadius = 25.0;

  static const donationTextWidth = 300.0;
  static const donationQRSize = 250.0;

  static const backendErrorIconSize = 80.0;

  static const statusBarIconSize = 20.0;

  static const settingsTileTrailingWidthDense = 200.0;
  static const settingsTileTrailingWidth = 450.0;
  static const settingsPageTableMaxWidth = 1024.0;
}

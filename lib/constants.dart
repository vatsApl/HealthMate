import 'package:clg_project/resourse/app_colors.dart';
import 'package:clg_project/resourse/dimens.dart';
import 'package:flutter/material.dart';

const kTitleTextStyle = TextStyle(
  fontSize: Dimens.pixel_30,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.underline,
);

const kLabelTextStyle = TextStyle(
  fontSize: Dimens.pixel_18,
);

const kOutlineButtonTextStyle = TextStyle(
  fontSize: Dimens.pixel_18,
  fontWeight: FontWeight.bold,
  letterSpacing: Dimens.pixel_1,
);

const kTextFormFieldLabelStyle = TextStyle(
  fontSize: Dimens.pixel_12,
  fontWeight: FontWeight.w400,
  color: AppColors.klabelColor,
);

const kDivider = Divider(
  color: Color(0xffE1E1E1),
  thickness: Dimens.pixel_1,
);

const kDescText1 = TextStyle(
  fontWeight: FontWeight.w400,
  color: AppColors.klabelColor,
);

const kDescText2 = TextStyle(
  fontWeight: FontWeight.w400,
  color: AppColors.kDefaultBlackColor,
  height: Dimens.pixel_1_point_2,
);

const kSuffixIconPadding = EdgeInsets.only(
  top: Dimens.pixel_4,
);

const kPrefixIconPadding = EdgeInsets.only(
  right: Dimens.pixel_12,
  top: Dimens.pixel_6,
);

const kSelectDocsTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: Dimens.pixel_12,
);

const kDefaultEmptyListStyle = TextStyle(
  fontSize: Dimens.pixel_22,
  fontWeight: FontWeight.w500,
);

const kSignOffLabelTextStyle = TextStyle(
  fontWeight: FontWeight.w300,
  color: AppColors.kDefaultBlackColor,
);

const kSignOffTimeTextStyle = TextStyle(
  fontSize: Dimens.pixel_18,
  fontWeight: FontWeight.w500,
  color: AppColors.kDefaultBlackColor,
);

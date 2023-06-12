import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resourse/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final Color? baseColor;
  final Color borderColor;
  final Color? errorColor;
  final TextInputType? inputType;
  final bool? obscureText;
  final dynamic validator;
  final FocusNode? focusNode;
  final dynamic onChanged;
  final Function? obscureTap;
  final SvgPicture? svgPrefixIcon;
  final SvgPicture? svgSuffixIcon;
  final String? suffixIcon;
  final Color? icColor;
  final bool readOnly;
  final Function? onTap;
  final bool enabled;
  final TextStyle? hintStyle;
  final int? maxLines;
  final bool autoFocus;

  const CustomTextFormField({
    this.hint,
    this.controller,
    this.baseColor,
    this.borderColor = AppColors.klabelColor,
    this.errorColor,
    this.inputType = TextInputType.text,
    this.obscureText,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.svgPrefixIcon,
    this.svgSuffixIcon,
    this.suffixIcon = '',
    this.obscureTap,
    this.icColor,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.hintStyle,
    this.maxLines,
    this.autoFocus = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isShowPass = true;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: AppColors.kDefaultPurpleColor,
      ),
      child: TextFormField(
        maxLines: widget.maxLines,
        style: const TextStyle(height: 1.0, color: AppColors.klabelColor),
        textAlignVertical: TextAlignVertical.bottom,
        textCapitalization:
            TextCapitalization.sentences, // previously was words
        keyboardType: widget.inputType,
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        autofocus: widget.autoFocus,
        onTap: () {
          widget.onTap;
        },
        validator: widget.validator,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: widget.hintStyle,
          focusColor: AppColors.kDefaultPurpleColor,
          prefixIcon: widget.svgPrefixIcon != null
              ? Padding(
                  padding: kPrefixIconPadding,
                  child: widget.svgPrefixIcon,
                )
              : null,
          suffixIcon: widget.svgSuffixIcon != null
              ? IconButton(
                  onPressed: () {
                    widget.obscureTap;
                  },
                  icon: Padding(
                    padding: kSuffixIconPadding,
                    child: widget.svgSuffixIcon,
                  ),
                )
              : null,
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
          ),
        ),
      ),
    );
  }
}

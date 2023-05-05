import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/app_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

// enum colorChange {
//   defaultColor,
//   errorColor,
//   sucessColor
// }

class Validate {
  //colors: //FocusNode focusNode,
  static dynamic validateEmailColor(String value) {
    // print('object${focusNode.hasFocus}');
    // if (focusNode.hasFocus==true) {
    if (value.isEmpty) {
      return Colors.red;
    } else if (!EmailValidator.validate(value)) {
      return Colors.red;
    } else if (EmailValidator.validate(value)) {
      return Colors.green;
    } else {
      return AppColors.klabelColor;
    }
  }

  static dynamic validatePasswordColor(FocusNode focusNode, String value) {
    if (focusNode.hasFocus == true) {
      if (value.isEmpty) {
        return Colors.red;
      } else if (!validatePasswordBool(value)) {
        return Colors.red;
      } else if (validatePasswordBool(value)) {
        return Colors.green;
      } else {
        return AppColors.klabelColor;
      }
    } else {
      return AppColors.klabelColor;
    }
  }

  static dynamic validateColorForEmptyTextFiled(
      FocusNode focusNode, String value) {
    // print('object${focusNode.hasFocus}');
    if (focusNode.hasFocus == true) {
      if (value.isEmpty) {
        return Colors.red;
      } else {
        return Colors.green;
      }
    } else {
      return AppColors.klabelColor;
    }
  }

  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    } else if (!EmailValidator.validate(value)) {
      return 'Please enter a valid Email';
    } else {
      return null;
    }
  }

  static bool validateEmailBool(String? value) {
    // if (focusNode.hasFocus==true){
    if (value!.isEmpty) {
      return false;
    } else if (!EmailValidator.validate(value)) {
      return false;
    } else {
      return true;
    }
    // }
    // return false;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the password';
    } else if (value.length < 8) {
      return 'Please enter atleast 8 character';
    }
    return null;
  }

  static bool validatePasswordBool(String? value) {
    if (value!.isEmpty) {
      return false;
    } else if (value.length < 8) {
      return false;
    } else {
      return true;
    }
  }

  //validate fname, lname:
  static String? validateName(String? value) {
    // print("object call");
    if (value!.isEmpty) {
      return 'Please enter the name';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Please enter valid name';
    }
    return null;
  }

  //validate fname, lname color
  static dynamic validateNameColor(FocusNode focusNode, String value) {
    if (focusNode.hasFocus == true) {
      if (value.isEmpty) {
        return Colors.red;
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        return Colors.red;
      } else if (validateNameBool(value)) {
        return Colors.green;
      } else {
        return AppColors.klabelColor;
      }
    } else {
      return AppColors.klabelColor;
    }
  }

  static bool validateNameBool(String? value) {
    if (value!.isEmpty) {
      return false;
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static String? validateNum(String? value) {
    if (value == null) {
      return 'Please enter a number';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  //phone number validate
  static String? validatePhoneNumber(String? value) {
    if (value!.length != 10) {
      return 'Please Enter valid phone number';
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a numeric phone number';
    }
    return null;
  }

  static dynamic validatePhoneNumberColor(FocusNode focusNode, String value) {
    if (focusNode.hasFocus == true) {
      if (value.length != 10) {
        return Colors.red;
      } else if (!RegExp(r'^\d+$').hasMatch(value)) {
        return Colors.red;
      } else if (validatePhoneNumberBool(value)) {
        return Colors.green;
      } else {
        return AppColors.klabelColor;
      }
    } else {
      return AppColors.klabelColor;
    }
  }

  static bool validatePhoneNumberBool(String? value) {
    if (value!.length != 10) {
      return false;
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  //confirm pass
  // static String? validateConfirmPass({
  //   required String value,
  //   required String pass,
  // }) {
  //   debugPrint('validate cpass called');
  //   if (value!.isEmpty) {
  //     return 'Please enter the password';
  //   } else if (value.length < 8) {
  //   } else if (value != pass) {
  //     return 'Password do not matched';
  //   }
  //   return null;
  // }

  static dynamic validateConfirmPassColor(FocusNode focusNode, String value,
      TextEditingController pass, TextEditingController cPass) {
    if (focusNode.hasFocus == true) {
      if (value.length < 8) {
        return Colors.red;
      } else if (pass.text != cPass.text) {
        return Colors.red;
      } else if (validateConfirmPassBool(pass.text, cPass)) {
        return Colors.green;
      } else {
        return AppColors.klabelColor;
      }
    } else {
      return AppColors.klabelColor;
    }
  }

  static bool validateConfirmPassBool(String pass, cPass) {
    if (cPass!.length < 8) {
      return false;
    } else if (pass != cPass) {
      return false;
    } else {
      return true;
    }
  }

  //validate address
  static String? validateAddress(String? value) {
    if (value!.isEmpty) {
      return 'Please enter the Address';
    } else {
      return null;
    }
  }

  static dynamic validateAddressColor(FocusNode focusNode, String value) {
    if (focusNode.hasFocus == true) {
      if (value.isEmpty) {
        return Colors.red;
      } else if (validateAddressBool(value)) {
        return Colors.green;
      } else {
        return AppColors.klabelColor;
      }
    }
    return AppColors.klabelColor;
  }

  static bool validateAddressBool(String? value) {
    if (value!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // validate postcode of address
  static String? validatePostcode(String? value) {
    final n = num.tryParse(value!);
    if (n == null) {
      return 'Please enter the postcode';
    } else {
      return null;
    }
  }

  static bool validatePostcodeBool(String? value) {
    final n = num.tryParse(value!);
    if (n == null) {
      return false;
    } else {
      return true;
    }
  }

  static String? validateRejectReason(String? value) {
    if (value!.isEmpty) {
      return 'Reason is required';
    } else {
      return null;
    }
  }
}

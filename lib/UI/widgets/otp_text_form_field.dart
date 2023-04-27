import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpTextFormField extends StatelessWidget {
  OtpTextFormField(
      {super.key, required this.otpController, this.first, this.last});

  TextEditingController otpController;
  bool? first, last;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.0,
      width: 40.0,
      child: TextFormField(
        controller: otpController,
        autofocus: true,
        showCursor: false,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            // changed from length to .isempty
            FocusScope.of(context).previousFocus();
          }
        },
        maxLength: 1,
        style: const TextStyle(
          fontSize: 16.0,
        ),
        decoration: const InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2.0),
          ),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}

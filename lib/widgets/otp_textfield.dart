import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpTextFormFieldPre extends StatelessWidget {
  OtpTextFormFieldPre({super.key, required this.otpController, this.first, this.last});

  TextEditingController otpController;
  bool? first, last;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      width: 54,
      child: TextFormField(
        controller: otpController,
        autofocus: true,
        showCursor: false,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        style: Theme.of(context).textTheme.titleLarge,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}

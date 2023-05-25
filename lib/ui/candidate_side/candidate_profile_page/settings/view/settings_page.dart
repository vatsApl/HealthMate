/// pending to create settings page

// import 'package:clg_project/widgets/elevated_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../UI/widgets/custom_textfield.dart';
// import '../../UI/widgets/title_text.dart';
// import '../../constants.dart';
// import '../../custom_widgets/custom_widget_helper.dart';
// import '../../resourse/app_colors.dart';
// import '../../resourse/images.dart';
//
// class SettingsPage extends StatefulWidget {
//   const SettingsPage({Key? key}) : super(key: key);
//
//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomWidgetHelper.appBar(
//         context: context,
//         action: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SvgPicture.asset(
//             Images.ic_true,
//             height: 28.0,
//           ),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 23.0,
//               ),
//               TitleText(title: 'Settings'),
//               const SizedBox(
//                 height: 48.0,
//               ),
//               const Text(
//                 'Password',
//                 style: kTextFormFieldLabelStyle,
//               ),
//               const CustomTextFormField(),
//               const SizedBox(
//                 height: 26.0,
//               ),
//               const Text(
//                 'New password',
//                 style: kTextFormFieldLabelStyle,
//               ),
//               const CustomTextFormField(),
//               const SizedBox(
//                 height: 26.0,
//               ),
//               const Text(
//                 'Confirm password',
//                 style: kTextFormFieldLabelStyle,
//               ),
//               const CustomTextFormField(),
//               const SizedBox(
//                 height: 40.0,
//               ),
//               ElevatedBtn(
//                   btnTitle: 'Submit',
//                   bgColor: AppColors.kDefaultPurpleColor,
//                   onPressed: () {}),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

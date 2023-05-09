import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../../UI/widgets/title_text.dart';
import '../../../../bottom_navigation/main_page.dart';
import '../../../../constants.dart';
import '../../../../resourse/app_colors.dart';
import '../../../../resourse/dimens.dart';
import '../../../../resourse/images.dart';
import '../../../../resourse/shared_prefs.dart';
import '../../../../resourse/strings.dart';
import '../../../../validations.dart';
import '../../../../widgets/elevated_button.dart';
import '../../../client_side/client_main_page.dart';
import '../../../auth/signup/signup_page.dart';
import '../../forgot_password/view/forgot_password.dart';
import '../bloc/signin_bloc.dart';
import '../bloc/signin_event.dart';
import '../bloc/signin_state.dart';
import '../model/signin_model.dart';
import '../repo/signin_repository.dart';

class SigninPage extends BasePageScreen {
  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends BasePageScreenState<SigninPage> with BaseScreen {
  final _formKey = GlobalKey<FormState>();
  bool isShow = true;
  bool isLoading = false;
  int? userId;
  int? userType;
  String? firstName;
  String? lastName;
  String? roleName;
  String? email;
  String? phone;
  String? clientName;
  String? avatar;
  bool? isEmailVerified;
  bool? isPasswordVeified;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool isEmailFocused = false;
  bool isVisible = false;

  final _signinBloc = SigninBloc(SigninRepository());

  @override
  void initState() {
    isSystemPop(true);
    super.initState();
  }

  @override
  Widget body() {
    return BlocProvider<SigninBloc>(
      create: (BuildContext context) => _signinBloc,
      child: BlocListener<SigninBloc, SigninState>(
        listener: (context, state) {
          if (state is SigninLoadingState) {
            setState(() {
              isVisible = true;
            });
          }
          if (state is SigninLoadedState) {
            setState(() {
              isVisible = false;
            });
            var responseBody = state.response;
            var signinResponse = SigninModel.fromJson(responseBody);
            if (signinResponse.code == 200) {
              var userId = signinResponse
                  .data?[0].id; //pref id which pass into URL of home page card
              // var userIdInt = signinResponse.data?[0].id;
              firstName = signinResponse.data?[0].firstName;
              roleName = signinResponse.data?[0].roleName;
              lastName = signinResponse.data?[0].lastName;
              email = signinResponse.data?[0].email;
              phone = signinResponse.data?[0].phone;
              avatar = signinResponse.data?[0].avatar;

              // store the data in shared prefs
              PreferencesHelper.setString(
                  PreferencesHelper.KEY_AVATAR, avatar ?? '');
              PreferencesHelper.setString(
                  PreferencesHelper.KEY_CLIENT_AVATAR, avatar ?? '');
              //clientSide
              clientName = signinResponse.data?[0].practiceName;
              PreferencesHelper.setString(PreferencesHelper.KEY_CLIENT_NAME,
                  clientName.toString()); //client name
              PreferencesHelper.setString(PreferencesHelper.KEY_USER_ID,
                  userId.toString()); //previous type of userId
              PreferencesHelper.setString(
                  PreferencesHelper.KEY_FIRST_NAME, firstName.toString());
              PreferencesHelper.setString(
                  PreferencesHelper.KEY_ROLE_NAME, roleName.toString());

              Fluttertoast.showToast(
                msg: "${signinResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              PreferencesHelper.setBool(PreferencesHelper.KEY_USER_LOGIN, true);
              PreferencesHelper.setInt(PreferencesHelper.KEY_USER_TYPE,
                  int.parse(signinResponse.type.toString()));

              // Navigate to home screen after verified according to the type Client or candidate:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<ValueNotifier<int>>.value(
                    value: ValueNotifier<int>(0),
                    child: signinResponse.type == 2
                        ? MainPage()
                        : ClientMainPage(),
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                msg: "${signinResponse.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
            // switch (state.response.code) {
            //   case 200:
            //     var signinResponse = SigninModel.fromJson(state.signinModel);
            //     var userId = signinResponse.data?[0]
            //         .id; //pref id which pass into URL of home page card
            //     var userIdInt = signinResponse.data?[0].id;
            //     firstName = signinResponse.data?[0].firstName;
            //     roleName = signinResponse.data?[0].roleName;
            //     lastName = signinResponse.data?[0].lastName;
            //     email = signinResponse.data?[0].email;
            //     phone = signinResponse.data?[0].phone;
            //     avatar = signinResponse.data?[0].avatar;
            //
            //     // store the data locally
            //     PreferencesHelper.setString(
            //         PreferencesHelper.KEY_AVATAR, avatar ?? '');
            //     PreferencesHelper.setString(
            //         PreferencesHelper.KEY_CLIENT_AVATAR, avatar ?? '');
            //     //clientSide
            //     var signinClientResponse = SigninClientResponse.fromJson(json);
            //     clientName = signinClientResponse.data?[0].practiceName;
            //     PreferencesHelper.setString(PreferencesHelper.KEY_CLIENT_NAME,
            //         clientName.toString()); //client name
            //
            //     PreferencesHelper.setInt(
            //         PreferencesHelper.KEY_USER_ID_INT, userIdInt!);
            //     PreferencesHelper.setString(PreferencesHelper.KEY_USER_ID,
            //         userId.toString()); //previous type of userId
            //     PreferencesHelper.setString(
            //         PreferencesHelper.KEY_FIRST_NAME, firstName.toString());
            //     PreferencesHelper.setString(
            //         PreferencesHelper.KEY_ROLE_NAME, roleName.toString());
            //
            //     Fluttertoast.showToast(
            //       msg: "${json['message']}",
            //       toastLength: Toast.LENGTH_SHORT,
            //       gravity: ToastGravity.BOTTOM,
            //       timeInSecForIosWeb: 1,
            //       backgroundColor:
            //           json['code'] == 200 ? Colors.green : Colors.red,
            //       textColor: Colors.white,
            //       fontSize: 16.0,
            //     );
            //     if (json['code'] == 200) {
            //       setState(() {
            //         isVisible = false;
            //       });
            //       PreferencesHelper.setBool(
            //           PreferencesHelper.KEY_USER_LOGIN, true);
            //       PreferencesHelper.setInt(
            //           PreferencesHelper.KEY_USER_TYPE, json['type']);
            //
            //       // Navigate to home screen after verified according to the type Client or candidate:
            //       Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) =>
            //               ChangeNotifierProvider<ValueNotifier<int>>.value(
            //             value: ValueNotifier<int>(0),
            //             child:
            //                 json['type'] == 2 ? MainPage() : ClientMainPage(),
            //           ),
            //         ),
            //       );
            //     }
            // }
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Dimens.pixel_16,
                  Dimens.pixel_0,
                  Dimens.pixel_16,
                  Dimens.pixel_16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Dimens.pixel_23,
                    ),
                    TitleText(
                      title: Strings.sign_in_welcome_back,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_48,
                    ),
                    Text(
                      Strings.sign_in_email_label,
                      style: kTextFormFieldLabelStyle,
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          secondary: AppColors.kDefaultPurpleColor,
                        ),
                      ),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: emailFocusNode,
                        validator: Validate.validateEmail,
                        style: TextStyle(
                          color: isEmailVerified == null
                              ? null
                              : isEmailVerified == true
                                  ? Colors.green
                                  : Colors.red,
                          height: Dimens.pixel_1,
                        ),
                        // onChanged: (val) {
                        //   setState(() {
                        //     Validate.validateEmail(val);
                        //   });
                        // },
                        // textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: Strings.sign_in_hint_enter_email_address,
                          prefixIcon: Padding(
                            padding: kPrefixIconPadding,
                            child: SvgPicture.asset(
                              Images.ic_mail,
                              fit: BoxFit.scaleDown,
                              color: isEmailVerified == null
                                  ? AppColors.klabelColor
                                  : isEmailVerified == true
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                          suffixIcon: isEmailVerified == null
                              ? null
                              : isEmailVerified == true
                                  ? Padding(
                                      padding: kSuffixIconPadding,
                                      child: SvgPicture.asset(
                                        Images.ic_true,
                                        fit: BoxFit.scaleDown,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Padding(
                                      padding: kSuffixIconPadding,
                                      child: SvgPicture.asset(
                                        Images.ic_error,
                                        fit: BoxFit.scaleDown,
                                        color: Colors.red,
                                      ),
                                    ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: isEmailVerified == null
                                  ? AppColors.kDefaultPurpleColor
                                  : isEmailVerified == true
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_26,
                    ),
                    const Text(
                      Strings.sign_in_password_label,
                      style: kTextFormFieldLabelStyle,
                    ),
                    Stack(
                      children: [
                        TextFormField(
                          // onChanged: (val) {
                          //   setState(() {
                          //     Validate.validatePasswordBool(val);
                          //   });
                          // },
                          style: TextStyle(
                            height: Dimens.pixel_1,
                            color: isPasswordVeified == null
                                ? AppColors.klabelColor
                                : isPasswordVeified == true
                                    ? Colors.green
                                    : Colors.red,
                          ),
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: passController,
                          validator: Validate.validatePassword,
                          focusNode: passwordFocusNode,
                          obscureText: isShow ? true : false,
                          decoration: InputDecoration(
                            hintText: Strings.sign_in_hint_enter_password,
                            prefixIcon: Padding(
                              padding: kPrefixIconPadding,
                              child: SvgPicture.asset(
                                Images.ic_password,
                                fit: BoxFit.scaleDown,
                                color: isPasswordVeified == null
                                    ? null
                                    : isPasswordVeified == true
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: isPasswordVeified == null
                                    ? AppColors.kDefaultPurpleColor
                                    : isPasswordVeified == true
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: Dimens.pixel_0,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isShow = !isShow;
                              });
                            },
                            icon: isShow
                                ? Padding(
                                    padding: kSuffixIconPadding,
                                    child: SvgPicture.asset(
                                      Images.ic_eye,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  )
                                : Padding(
                                    padding: kSuffixIconPadding,
                                    child: SvgPicture.asset(
                                      Images.ic_eye_off,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Dimens.pixel_8,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                          );
                        },
                        child: const Text(
                          Strings.text_forgot_password,
                          style: TextStyle(
                            color: AppColors.kDefaultBlackColor,
                            fontSize: Dimens.pixel_12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_30,
                    ),
                    ElevatedBtn(
                      btnTitle: Strings.text_submit,
                      isLoading: isVisible,
                      bgColor: AppColors.kDefaultPurpleColor,
                      onPressed: () {
                        setState(() {});
                        isEmailVerified =
                            Validate.validateEmailBool(emailController.text);
                        isPasswordVeified =
                            Validate.validatePasswordBool(passController.text);
                        if (_formKey.currentState!.validate() &&
                            isEmailVerified == true &&
                            isPasswordVeified == true) {
                          _signinBloc.add(SigninButtonPressed(
                            email: emailController.text,
                            password: passController.text,
                          ));
                        }
                      },
                    ),
                    const SizedBox(
                      height: Dimens.pixel_30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          Strings.text_dont_have_an_account,
                          style: TextStyle(
                            color: AppColors.kDefaultBlackColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          width: Dimens.pixel_2,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: const Text(
                            Strings.text_sign_up,
                            style: TextStyle(
                              fontSize: Dimens.pixel_16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kDefaultPurpleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

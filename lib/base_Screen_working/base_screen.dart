import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../resourse/images.dart';

abstract class BasePageScreen extends StatefulWidget {}

abstract class BasePageScreenState<Page extends BasePageScreen>
    extends State<Page> {
  bool _isBack = true;
  bool _isSave = false;
  bool _isAppBar = true;
  bool _isSystemPop = false;

  void onClickBackButton(){
    _isSystemPop ? SystemNavigator.pop() : Navigator.pop(context) ;
  }

  void onClickSaveButton(){
    print('data updated');
  }

  void isBackButton(bool isBack) {
    _isBack = isBack;
  }

  void isSaveButton(bool isSave) {
    _isSave = isSave;
  }

  void isSystemPop(bool isSystemPop) {
    _isSystemPop = isSystemPop;
  }

  void isAppbar(bool isAppBar) {
    _isAppBar = isAppBar;
  }
}

mixin BaseScreen<Page extends BasePageScreen> on BasePageScreenState<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: _isAppBar
            ? AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                leading: GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
                    onClickBackButton();
                  },
                  child: _isBack
                      ? SvgPicture.asset(
                          Images.ic_left_arrow,
                          fit: BoxFit.scaleDown,
                        )
                      : Container(),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      onClickSaveButton();
                    },
                    child: _isSave
                        ? Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: SvgPicture.asset(
                              Images.ic_true,
                              height: 28.0,
                            ),
                        )
                        : Container(),
                  ),
                ],
              )
            : null,
        body: Container(
          child: body(),
          color: Colors.white,
        ),
    );
  }

  Widget body();
}

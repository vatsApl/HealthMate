// Not used in project, just for refrence of base screen
import 'package:clg_project/base_Screen_working/second_Screen.dart';
import 'package:flutter/material.dart';
import 'base_screen.dart';

class HomeScreen extends BasePageScreen {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends BasePageScreenState<HomeScreen> with BaseScreen {
  bool isButtonTapped = false;

  @override
  void initState() {
    isBackButton(false);
    super.initState();
  }

  // TO GIVE THE TITLE OF THE APP BAR
  @override
  String appBarTitle() {
    return "Home";
  }

  @override
  void isBackButton(bool isBack) {
    super.isBackButton(isBack);
  }

  // THIS IS BACK BUTTON CLICK HANDLER
  @override
  void onClickBackButton() {
    print("BACK BUTTON CLICKED FROM HOME");
    Navigator.of(context).pop();
  }

  // THIS IS RIGHT BAR BUTTON CLICK HANDLER
  @override
  void onClickCartButton() {
    print("CART BUTTON CLICKED");
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SecondScreen()));
  }

  // THIS WILL RETURN THE BODY OF THE SCREEN
  @override
  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("HOME SCREEN BODY"),
          ElevatedButton(
            onPressed: () {
              if(!isButtonTapped) {
                setState(() {
                  isButtonTapped = true;
                });
              }
            },
            child: Text(isButtonTapped ? "BUTTON TAPPED" : "BUTTON NOT TAPPED"),
          )
        ],
      ),
    );
  }

  // @override
  // void onClickSaveButton() {
  //   print('Data updated');
  // }

}
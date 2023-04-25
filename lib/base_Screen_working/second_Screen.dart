// Not used in project, just for refrence of base screen
import 'package:flutter/material.dart';
import 'base_screen.dart';

class SecondScreen extends BasePageScreen {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends BasePageScreenState<SecondScreen> with BaseScreen {

  @override
  void initState() {
    isSaveButton(false);
    super.initState();
  }

  @override
  void isSaveButton(bool isCart) {
    super.isSaveButton(isCart);
  }

  @override
  String appBarTitle() {
    return "Cart";
  }

  @override
  Widget body() {
    return Center(
      child: Text("CART SCREEN BODY"),
    );
  }

  @override
  void onClickBackButton() {
    print("BACK BUTTON CLICKED FROM CART");
    Navigator.of(context).pop();
  }

  @override
  void onClickCartButton() {
    print("CART BUTTON CLICKED");
  }

  // @override
  // void onClickSaveButton() {
  //   print('data updated');
  // }
}
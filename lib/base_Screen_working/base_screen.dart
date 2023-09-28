import 'package:clg_project/helper/socket_io_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_svg/svg.dart';
import '../resourse/images.dart';

abstract class BasePageScreen extends StatefulWidget {}

abstract class BasePageScreenState<Page extends BasePageScreen>
    extends State<Page> with Observer, WidgetsBindingObserver {
  bool _isBack = true;
  bool _isSave = false;
  bool _isAppBar = true;
  bool _isSystemPop = false;

  void onClickBackButton() {
    _isSystemPop ? SystemNavigator.pop() : Navigator.pop(context);
  }

  void onClickSaveButton() {
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
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    SocketUtilsClient.instance.connectToSocket();
    // SocketUtils.instance.setConnectListener(onConnect);
    SocketUtilsClient.instance.setConnectingListener(onConnecting);
    SocketUtilsClient.instance.setOnDisconnectListener(onDisconnect);
    SocketUtilsClient.instance.reconnectAttempt(onReConnect);
    SocketUtilsClient.instance.setOnErrorListener(onError);
    SocketUtilsClient.instance.setOnConnectionErrorListener(onConnectError);
    SocketUtilsClient.instance.setOnPingListener(onConnectAgain);
    super.initState();
  }

  onConnecting(data) {
    print('Connecteing $data');
  }

  onDisconnect(data) {
    print('onDisconnect $data');
  }

  onReConnect(data) {
    print("onReConnect$data");
    SocketUtilsClient.instance.connectToSocket();
  }

  onError(data) async {
    print('onError $data');
    if (data == "errorrr:{message: Not Authorised}") {
      await SocketUtilsClient.instance.initSocket();
    }
  }

  onConnectError(data) {
    print('onConnectError $data');
  }

  onConnectAgain() {
    SocketUtilsClient.instance.connectToSocket();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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

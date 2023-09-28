import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/user_detail_shared_pref/user_detail_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class SocketUtilsClient {
  IO.Socket? socket;

  static final instance = SocketUtilsClient();
  static var loginUserObj = {};

  initSocket() async {
    socket = await configerSocket();
    print('socket: ${socket}');
    connectToSocket();
    setConnectListener(onConnectdata);
    setNotifyNewMessageListner(onChatNewMessageReceived);

    // socket?.connect();
    // socket?.onConnect((_) {
    //   print('Socket Connection established');
    //   print('socket status: ${socket?.connected}');
    //   loginUserObj = UserDetailSharedPref.loginUserDetails;
    //   debugPrint('UserDetails from shared prefs: ${loginUserObj.toString()}');
    // });
    // socket?.onDisconnect((_) => print('Socket Connection Disconnection'));
    // socket?.onConnectError((err) => print(err));
    // socket?.onError((err) => print(err));
  }

  sendMessage({
    required TextEditingController messageController,
    required int userId,
    required String userType,
    required int receiverId,
    required String messageType,
  }) {
    if (null == socket) {
      debugPrint("Socket is Null, Cannot send message");
      return;
    }
    debugPrint("----------- Send Text Message ------------");
    // print("TextMessage${chatMessageModel.message}");
    // _socket?.emit("", chatMessageModel.toJson());
    String message = messageController.text.trim();
    if (message.isEmpty) return;
    Map messageMap = {
      'socket_id': SocketUtilsClient.instance.socket?.id,
      'message': message,
      'sender_id': userId,
      'sender_type': userType,
      'receiver_id': receiverId,
      'time': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'message_type': messageType,
    };

    socket?.emit('sendNewMessage', messageMap);
    debugPrint('Send messageMap: ${messageMap.toString()}');
  }

  configerSocket() {
    return IO.io(DataURL.socketServerURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionDelay': 1000,
      'reconnectionDelayMax': 5000,
      'reconnectionAttempts': 7,
      'force new connection': true,
    });
  }

  connectToSocket() {
    // if (socket == null) {
    //   debugPrint('socket is null');
    //   // return;
    // }
    if (socket?.connected == false) {
      debugPrint('connecting to socket');
      socket?.connect();
    }
  }

  onConnectdata(data) {
    print('Connected from singlton $data');
    if (socket != null) {
      print('Socket id  ${socket?.id}');
      PreferencesHelper.setString(
          PreferencesHelper.KEY_SOCKET_ID, socket?.id.toString() ?? "");
    }
  }

  // receiverOnline() {
  //   //
  // }

  onChatNewMessageReceived(data) {
    Observable.instance.notifyObservers([
      "_MessageListPageState",
    ], notifyName: "NotifyMessage", map: data);
    Observable.instance.notifyObservers([
      "_ChatScreenPageState",
    ], notifyName: "NotifyMessage", map: data);
  }

  setConnectListener(Function onConnect) {
    socket?.onConnect((data) {
      onConnect(data);
      // SocketUtils.instance
      //    .checkOnline(PreferenceUtils.getString(Strings.USERID), "true");
      print("Socket Connected");
    });
  }

  // setOnReceiverOnlineListener(Function receiverOnline) {
  //   socket?.on("consultant_status", (data) {
  //     print("consultant_status:$data");
  //
  //     ///No need to send this status
  //     // checkOnline(PreferenceUtils.getString(Strings.USERID),
  //     //     _socket?.connected == true ? "true" : "false");
  //     receiverOnline(data);
  //   });
  // }

  /// listen on new message received
  setNotifyNewMessageListner(Function data) {
    print('listen message called ${socket?.connected}');
    socket?.on("messageShow", (message) {
      data(message);
      print("Data is: $message");
      // if (PreferenceUtils.getBoolen(Strings.TOCheckCurrentPageIsMessage) ==
      //     false) {
      //   // if current pagee is msg then do not update unread count bcoz updated in messagepage.
      //   final firstNotifier = Provider.of<BadgeNotifier>(
      //       NavigationService.navigatorKey.currentState!.context,
      //       listen: false);
      //   Future.delayed(Duration(milliseconds: 100), () {
      //     firstNotifier.ChangeValue(data["sender_unread_count"] ?? 0);
      //     PreferenceUtils.setInt(
      //         Strings.BADGECOUNT, data["sender_unread_count"] ?? 0);
      //   });
      // }
      // onChatNewMessageReceived(data);
    });
  }

  setConnectingListener(Function onConnecting) {
    socket?.onConnecting((data) {
      onConnecting(data);
      // checkOnline(PreferenceUtils.getString(Strings.USERID),
      //      _socket?.connected == true ? "true" : "false");
    });
  }

  setOnDisconnectListener(Function onDisconnect) {
    socket?.onDisconnect((data) {
      print("onDisconnect $data");
      //  checkOnline(PreferenceUtils.getString(Strings.USERID),_socket?.connected == true ? "true" : "false");
      onDisconnect(data);
    });
  }

  reconnectAttempt(Function onReConnect) {
    socket?.onReconnectAttempt((data) {
      onReConnect(data);
    });
  }

  setOnErrorListener(Function onError) {
    socket?.onError((error) {
      onError("errorrr:$error");
      closeConnection();
      connectToSocket();
    });
  }

  setOnConnectionErrorListener(Function onConnectError) {
    socket?.onConnectError((data) async {
      onConnectError(data);
    });
  }

  setOnPingListener(Function onError) {
    socket?.onPing((error) {
      onError("errorrr:$error");
    });
  }

  closeConnection() {
    if (null != socket) {
      print("Close Connection");
      socket?.dispose();
      socket?.clearListeners();
      socket?.destroy();
      socket?.io.disconnect();
      socket!.io.close();
      socket!.io.destroy(socket);
    }
  }

  // listenMessages(Function data) {
  //   print('listen message called ${socket?.connected}');
  //   socket?.on('messageShow', (message) {
  //     data(message);
  //     debugPrint('Data is: ${message}');
  //   });
  // }
  // socket.on('getMessageEvent', (newMessage) {
  // messageList.add(MessageModel.fromJson(data));
  // });

  // dispose the connection
  @override
  void disposeSocket() {
    socket?.disconnect();
    socket?.dispose();
  }
}

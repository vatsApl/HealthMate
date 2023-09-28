import 'package:clg_project/helper/socket_io_client.dart';
import 'package:clg_project/resourse/shared_prefs.dart';

class UserDetailSharedPref {
  // var loginUserDetails = {};

  static var loginUserDetails = {
    'user_id': PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID),
    'socket_id': SocketUtilsClient.instance.socket?.id,
    'user_name': PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE) == 1
        ? PreferencesHelper.getString(PreferencesHelper.KEY_CLIENT_NAME)
        : '${PreferencesHelper.getString(PreferencesHelper.KEY_FIRST_NAME)}'
            '${PreferencesHelper.getString(PreferencesHelper.KEY_LAST_NAME)}',
    'user_email': '${PreferencesHelper.getString(PreferencesHelper.KEY_EMAIL)}',
    'user_type': PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE) == 1
        ? 'client'
        : 'candidate',
  };
}

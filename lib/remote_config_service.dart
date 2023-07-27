import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  ///
  // settings should be used for development only, not for an app running in production
  setConfigSetting() async {
    print('called setConfigSetting');
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
  }

  setConfigDefaults() async {
    await remoteConfig.setDefaults(const {
      "example_param_1": 42,
      "example_param_2": 3.14159,
      "example_param_3": true,
      "example_param_4": "Hello, world!",
    });
  }

  ///
  static initializeRemoteConfig() async {
    if (remoteConfig == null) {
      remoteConfig = await FirebaseRemoteConfig.instance;
      print('remoteConfig: $remoteConfig');
      remoteConfig.ensureInitialized();
      // set default values
      // Map<String, dynamic> setDefaultValue = {
      //   "example_param_1": 42,
      //   "example_param_2": 3.14159,
      //   "example_param_3": true,
      //   "example_param_4": "Hello, world!",
      // };
    }
    // await remoteConfig?.setDefaults(setDefaultValue);
    remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: Duration.zero,
      ),
    );

    try {
      await remoteConfig.fetch();
      var configFetchAndActivate = await remoteConfig.fetchAndActivate();

      print('configFetchAndActivate: $configFetchAndActivate');
      print('Last fetch status: ' + remoteConfig.lastFetchStatus.toString());
      print('Last fetch time: ' + remoteConfig.lastFetchTime.toString());

      remoteConfig.getString('app_title');
      print('getString app_title: ${remoteConfig.getString('app_title')}');
      remoteConfig.getBool('notifications');
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
}

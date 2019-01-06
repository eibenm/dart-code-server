import 'package:server_app/src/sdk_manager.dart';
import 'package:server_app/services.dart' as services;

main(List<String> args) async {
  await SdkManager.sdk.init();
  await services.main(args);
}

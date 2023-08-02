import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:solarisdemo/ivory_app.dart';

import '../config.dart';

Future<void> main() async {
  await dotenv.load();
  ClientConfigData clientConfig = ClientConfig.getClientConfig();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(IvoryApp(clientConfig: clientConfig));
}

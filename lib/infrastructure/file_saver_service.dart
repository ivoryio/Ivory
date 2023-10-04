import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';

class FileSaverService {
  const FileSaverService();

  static Future<void> saveFile({required String name, String? ext, required Uint8List bytes, String? mimeType}) async {
    if (Platform.isIOS) {
      // Open the share sheet. This has option to save to files
      final xFile = XFile.fromData(bytes, name: name, mimeType: mimeType);
      Share.shareXFiles([xFile]);
    } else {
      // Ask for storage permission
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        return;
      }

      // Save to downloads
      Directory saveDir = Directory('/storage/emulated/0/Download');
      if (!saveDir.existsSync()) {
        saveDir = Directory('/storage/emulated/0/Downloads');
      }
      final file = File('${saveDir.path}/$name$ext');
      await file.writeAsBytes(bytes);

      // Show notification that file is downloaded
      FlutterLocalNotificationsPlugin().show(
        name.hashCode,
        'Bill downloaded',
        'File is in your Downloads folder',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            highImportanceChannelId,
            highImportanceChannelId,
          ),
        ),
      );
    }
  }
}

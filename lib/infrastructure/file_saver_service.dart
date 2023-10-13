import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
      try {
        await _writeLocalFile(name: name, extension: ext!, bytes: bytes);

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
      } catch (error) {
        FlutterLocalNotificationsPlugin().show(
          name.hashCode,
          'Bill download failed',
          'Please try again',
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
}

Future<void> _writeLocalFile({required String name, required String extension, required Uint8List bytes}) async {
  Directory downloadDirectory = Directory('/storage/emulated/0/Download');

  final path = downloadDirectory.path;
  final fileObject = File('$path/$name.$extension');

  final file = await fileObject.writeAsBytes(bytes);

  if (!(await file.exists())) {
    log("File not saved");
    throw Exception('File not saved');
  }
}

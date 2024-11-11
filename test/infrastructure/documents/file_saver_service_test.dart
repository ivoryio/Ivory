import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/documents/file_saver_service.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

import '../../setup/platform.dart';
import 'file_saver_service_mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;

  setUp(() {
    mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
  });

  group('saveFile', () {
    group("android platform", () {
      setUpAll(() {
        setPlatformOverride(TargetPlatform.android);
      });

      test('when the file is saved it should show a success notification', () async {
        // given
        final fileSaverService = FileSaverService();
        fileSaverService.flutterLocalNotificationsPlugin = mockFlutterLocalNotificationsPlugin;

        const name = 'document';
        const ext = 'pdf';
        final bytes = Uint8List.fromList([0, 1, 2, 3, 4]);

        final mockFile = MockFile();

        int existsCallCount = 0;
        when(mockFile.exists()).thenAnswer((_) async {
          // The first call is to check if file exists before writing
          // The second call is to check if file exists after writing
          existsCallCount++;
          return existsCallCount > 1;
        });
        when(mockFile.writeAsBytes(any, mode: anyNamed('mode'), flush: anyNamed('flush'))).thenAnswer(
          (_) async => mockFile,
        );

        IOOverrides.runZoned(
          () async {
            // when
            await fileSaverService.saveFile(name: name, ext: ext, bytes: bytes);

            // then
            expect(
              verify(mockFile.writeAsBytes(captureAny, mode: FileMode.write, flush: false)).captured.first,
              equals(bytes),
            );

            verify(mockFlutterLocalNotificationsPlugin.show(
              name.hashCode,
              'File downloaded',
              'File is in your Downloads folder',
              any,
            ));
          },
          createDirectory: (String path) => FakeDownloadDirectory(),
          createFile: (String path) => mockFile,
        );
      });

      test("when the file can't be saved it should show a failure notification", () async {
        // given
        final fileSaverService = FileSaverService();
        fileSaverService.flutterLocalNotificationsPlugin = mockFlutterLocalNotificationsPlugin;

        const name = 'document';
        const ext = 'pdf';
        final bytes = Uint8List.fromList([0, 1, 2, 3, 4]);

        IOOverrides.runZoned(
          () async {
            // when
            await fileSaverService.saveFile(name: name, ext: ext, bytes: bytes);

            // then
            verify(mockFlutterLocalNotificationsPlugin.show(
              name.hashCode,
              'File download failed',
              'Please try again',
              any,
            ));
          },
          createDirectory: (String path) => FakeDownloadDirectory(),
          createFile: (String path) => FakeInexistentFile(),
        );
      });

      test("when the file already exists it should show a failure notification", () async {
        // given
        final fileSaverService = FileSaverService();
        fileSaverService.flutterLocalNotificationsPlugin = mockFlutterLocalNotificationsPlugin;

        const name = 'document';
        const ext = 'pdf';
        final bytes = Uint8List.fromList([0, 1, 2, 3, 4]);

        IOOverrides.runZoned(
          () async {
            // when
            await fileSaverService.saveFile(name: name, ext: ext, bytes: bytes);

            // then
            verify(mockFlutterLocalNotificationsPlugin.show(
              name.hashCode,
              'File download failed',
              'File already exists',
              any,
            ));
          },
          createDirectory: (String path) => FakeDownloadDirectory(),
          createFile: (String path) => FakeFile(),
        );
      });
    });
    group("iOS platform", () {
      setUpAll(() {
        setPlatformOverride(TargetPlatform.iOS);
      });

      test("when the file is saved, it should use the share sheet", () async {
        // given
        final fileSaverService = FileSaverService();

        final mockShare = MockSharePlatform();
        SharePlatform.instance = mockShare;

        const name = 'document';
        const ext = 'pdf';
        final bytes = Uint8List.fromList([0, 1, 2, 3, 4]);

        await fileSaverService.saveFile(name: name, ext: ext, bytes: bytes);

        // then
        final xfiles = verify(
          mockShare.shareXFiles(captureAny),
        ).captured.first as List<XFile>;

        expect(await xfiles.firstOrNull?.readAsBytes(), equals(bytes));
      });
    });
  });
}

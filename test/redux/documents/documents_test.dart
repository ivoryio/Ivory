import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';
import 'package:solarisdemo/redux/documents/download/download_document_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import '../auth/auth_mocks.dart';
import 'documents_mocks.dart';

void main() {
  final user = MockUser();
  final authentionInitializedState = AuthenticationInitializedState(user, AuthType.onboarding);

  const document1 = Document(
    id: "documentId1",
    documentType: DocumentType.creditCardContract,
    fileType: "PDF",
    fileSize: "1.2MB",
  );

  const document2 = Document(
    id: "documentId2",
    documentType: DocumentType.creditCardSecci,
    fileType: "PDF",
    fileSize: "1.2MB",
  );

  group("Fetching documents", () {
    test("When documents are fetched with succes then the state should change to fetched", () async {
      // given
      final store = createTestStore(
        documentsService: FakeDocumentsService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          documentsState: DocumentsInitialLoadingState(),
        ),
      );
      final appState = store.onChange.firstWhere((element) => element.documentsState is DocumentsFetchedState);

      // when
      store.dispatch(GetDocumentsCommandAction());

      // then
      expect((await appState).documentsState, isA<DocumentsFetchedState>());
    });

    test("When documents are fetched with error then the state should change to error", () async {
      // given
      final store = createTestStore(
        documentsService: FakeFailingDocumentsService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          documentsState: DocumentsInitialLoadingState(),
        ),
      );
      final appState = store.onChange.firstWhere((element) => element.documentsState is DocumentsErrorState);

      // when
      store.dispatch(GetDocumentsCommandAction());

      // then
      expect((await appState).documentsState, isA<DocumentsErrorState>());
    });
  });

  group("Downloading documents", () {
    test("When a document has started downloading, the state should change to loading", () async {
      // given
      final store = createTestStore(
        fileSaverService: FakeFileSaverService(),
        documentsService: FakeDocumentsService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          downloadDocumentState: DownloadDocumentInitialState(),
        ),
      );
      final appState =
          store.onChange.firstWhere((element) => element.downloadDocumentState is DocumentDownloadingState);

      // when
      store.dispatch(DownloadDocumentCommandAction(document: document1));

      // then
      expect((await appState).downloadDocumentState, isA<DocumentDownloadingState>());
    });

    test("When a document has been downloaded, the state should change to downloaded", () async {
      // given
      final store = createTestStore(
        fileSaverService: FakeFileSaverService(),
        documentsService: FakeDocumentsService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          downloadDocumentState: DownloadDocumentInitialState(),
        ),
      );
      final appState = store.onChange.firstWhere((element) => element.downloadDocumentState is DocumentDownloadedState);

      // when
      store.dispatch(DownloadDocumentCommandAction(document: document2));

      // then
      expect((await appState).downloadDocumentState, isA<DocumentDownloadedState>());
    });

    test("When a document has failed downloading, the state should change to failed", () async {
      // given
      final store = createTestStore(
        fileSaverService: FakeFileSaverService(),
        documentsService: FakeFailingDocumentsService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          downloadDocumentState: DownloadDocumentInitialState(),
        ),
      );
      final appState =
          store.onChange.firstWhere((element) => element.downloadDocumentState is DocumentDownloadErrorState);

      // when
      store.dispatch(DownloadDocumentCommandAction(document: document1));

      // then
      expect((await appState).downloadDocumentState, isA<DocumentDownloadErrorState>());
    });
  });
}

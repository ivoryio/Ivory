import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/documents/confirm/confirm_documents_state.dart';
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
    fileSize: 1024,
  );

  const document2 = Document(
    id: "documentId2",
    documentType: DocumentType.creditCardSecci,
    fileType: "PDF",
    fileSize: 2048,
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

    test("When documents are fetched but the list is empty it should retry", () async {
      // given
      int getDocumentsAttempts = 0;
      final documentsService = MockDocumentsService();

      final store = createTestStore(
        documentsService: documentsService,
        initialState: createAppState(
          authState: authentionInitializedState,
          documentsState: DocumentsInitialLoadingState(),
        ),
      );
      final appState = store.onChange.firstWhere((element) => element.documentsState is DocumentsFetchedState);

      when(documentsService.getPostboxDocuments(user: anyNamed('user'))).thenAnswer(
        (_) async {
          getDocumentsAttempts++;
          if (getDocumentsAttempts == 1) {
            return GetDocumentsSuccessResponse(documents: const []);
          } else {
            return GetDocumentsSuccessResponse(documents: const [document1, document2]);
          }
        },
      );

      // when
      store.dispatch(GetDocumentsCommandAction());

      // then
      expect((await appState).documentsState, isA<DocumentsFetchedState>());
      expect(getDocumentsAttempts, 2);
    });

    test("When documents are fetched but the list is empty it should retry and fail", () async {
      // given
      int getDocumentsAttempts = 0;
      final documentsService = MockDocumentsService();

      final store = createTestStore(
        documentsService: documentsService,
        initialState: createAppState(
          authState: authentionInitializedState,
          documentsState: DocumentsInitialLoadingState(),
        ),
      );
      final appState = store.onChange.firstWhere((element) => element.documentsState is DocumentsErrorState);

      when(documentsService.getPostboxDocuments(user: anyNamed('user'))).thenAnswer(
        (_) async {
          getDocumentsAttempts++;
          return GetDocumentsSuccessResponse(documents: const []);
        },
      );

      // when
      store.dispatch(GetDocumentsCommandAction());

      // then
      expect((await appState).documentsState, isA<DocumentsErrorState>());
      expect(((await appState).documentsState as DocumentsErrorState).errorType, DocumentsErrorType.emptyList);
      expect(getDocumentsAttempts, 11);
    });

    test("When less than two documents are fetched, retry until two or more are fetched", () async {
      // given
      int getDocumentsAttempts = 0;
      final documentsService = MockDocumentsService();

      final store = createTestStore(
        documentsService: documentsService,
        initialState: createAppState(
          authState: authentionInitializedState,
          documentsState: DocumentsInitialLoadingState(),
        ),
      );
      final appState = store.onChange.firstWhere((element) => element.documentsState is DocumentsFetchedState);

      when(documentsService.getPostboxDocuments(user: anyNamed('user'))).thenAnswer(
        (_) async {
          getDocumentsAttempts++;
          if (getDocumentsAttempts == 1) {
            return GetDocumentsSuccessResponse(documents: const []);
          } else if (getDocumentsAttempts == 2) {
            return GetDocumentsSuccessResponse(documents: const [document1]);
          } else {
            return GetDocumentsSuccessResponse(documents: const [document1, document2]);
          }
        },
      );

      // when
      store.dispatch(GetDocumentsCommandAction());

      // then
      expect((await appState).documentsState, isA<DocumentsFetchedState>());
      expect(getDocumentsAttempts, 3);
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
      store.dispatch(DownloadDocumentCommandAction(
        document: document1,
        downloadLocation: DocumentDownloadLocation.postbox,
      ));

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
      store.dispatch(DownloadDocumentCommandAction(
        document: document2,
        downloadLocation: DocumentDownloadLocation.postbox,
      ));

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
      store.dispatch(DownloadDocumentCommandAction(
        document: document1,
        downloadLocation: DocumentDownloadLocation.postbox,
      ));

      // then
      expect((await appState).downloadDocumentState, isA<DocumentDownloadErrorState>());
    });
  });

  group("Confirming documents", () {
    test("When confirming documents, the state should change loading", () async {
      // given
      final store = createTestStore(
        documentsService: FakeDocumentsService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          confirmDocumentsState: ConfirmDocumentsInitialState(),
        ),
      );
      final appState =
          store.onChange.firstWhere((element) => element.confirmDocumentsState is ConfirmDocumentsLoadingState);

      // when
      store.dispatch(ConfirmDocumentsCommandAction(documents: [document1, document2]));

      // then
      expect((await appState).confirmDocumentsState, isA<ConfirmDocumentsLoadingState>());
    });

    test("When documents are confirmed then the state should change to confirmed", () async {
      // given
      final store = createTestStore(
        documentsService: FakeDocumentsService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          confirmDocumentsState: ConfirmDocumentsInitialState(),
        ),
      );
      final appState = store.onChange.firstWhere((element) => element.confirmDocumentsState is ConfirmedDocumentsState);

      // when
      store.dispatch(ConfirmDocumentsCommandAction(documents: [document1, document2]));

      // then
      expect((await appState).confirmDocumentsState, isA<ConfirmedDocumentsState>());
    });

    test("When documents failed confirming then the state should change to error", () async {
      // given
      final store = createTestStore(
        documentsService: FakeFailingDocumentsService(),
        initialState: createAppState(
          authState: authentionInitializedState,
          confirmDocumentsState: ConfirmDocumentsInitialState(),
        ),
      );
      final appState =
          store.onChange.firstWhere((element) => element.confirmDocumentsState is ConfirmDocumentsErrorState);

      // when
      store.dispatch(ConfirmDocumentsCommandAction(documents: [document1, document2]));

      // then
      expect((await appState).confirmDocumentsState, isA<ConfirmDocumentsErrorState>());
    });
  });
}

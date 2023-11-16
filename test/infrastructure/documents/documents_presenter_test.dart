import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/documents/documents_presenter.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';
import 'package:solarisdemo/redux/documents/confirm/confirm_documents_state.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';
import 'package:solarisdemo/redux/documents/download/download_document_state.dart';

void main() {
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

  test("When documents are loading, it should loading view model", () {
    // given
    final documentsState = DocumentsInitialLoadingState();
    final downloadDocumentState = DownloadDocumentInitialState();
    final confirmDocumentsState = ConfirmDocumentsInitialState();

    // when
    final viewModel = DocumentsPresenter.present(
      documentsState: documentsState,
      downloadDocumentState: downloadDocumentState,
      confirmDocumentsState: confirmDocumentsState,
    );

    // then
    expect(viewModel, isA<DocumentsLoadingViewModel>());
  });

  test("When documents are fetched, it should return fetched view model", () {
    // given
    final documentsState = DocumentsFetchedState(documents: const [document1, document2]);
    final downloadDocumentState = DownloadDocumentInitialState();
    final confirmDocumentsState = ConfirmDocumentsInitialState();

    // when
    final viewModel = DocumentsPresenter.present(
      documentsState: documentsState,
      downloadDocumentState: downloadDocumentState,
      confirmDocumentsState: confirmDocumentsState,
    );

    // then
    expect(viewModel, isA<DocumentsFetchedViewModel>());
    expect((viewModel as DocumentsFetchedViewModel).documents, [document1, document2]);
  });

  test("When documents have failed to fetch, it should return error view model", () {
    // given
    final documentsState = DocumentsErrorState(errorType: DocumentsErrorType.unknown);
    final downloadDocumentState = DownloadDocumentInitialState();
    final confirmDocumentsState = ConfirmDocumentsInitialState();

    // when
    final viewModel = DocumentsPresenter.present(
      documentsState: documentsState,
      downloadDocumentState: downloadDocumentState,
      confirmDocumentsState: confirmDocumentsState,
    );

    // then
    expect(viewModel, isA<DocumentsErrorViewModel>());
  });

  group("Downloading", () {
    test("When a document is downloading, it should return downloading view model", () {
      // given
      final documentsState = DocumentsFetchedState(documents: const [document1, document2]);
      final downloadDocumentState = DocumentDownloadingState(document: document1);
      final confirmDocumentsState = ConfirmDocumentsInitialState();

      // when
      final viewModel = DocumentsPresenter.present(
        documentsState: documentsState,
        downloadDocumentState: downloadDocumentState,
        confirmDocumentsState: confirmDocumentsState,
      );

      // then
      expect(viewModel, isA<DocumentDownloadingViewModel>());
    });

    test("When a document has finished downloading, it should return documents fetched view model", () {
      // given
      final documentsState = DocumentsFetchedState(documents: const [document1, document2]);
      final downloadDocumentState = DocumentDownloadedState();
      final confirmDocumentsState = ConfirmDocumentsInitialState();

      // when
      final viewModel = DocumentsPresenter.present(
        documentsState: documentsState,
        downloadDocumentState: downloadDocumentState,
        confirmDocumentsState: confirmDocumentsState,
      );

      // then
      expect(viewModel, isA<DocumentsFetchedViewModel>());
    });

    test("When a document has failed to download, it should return documents fetched view model", () {
      // given
      final documentsState = DocumentsFetchedState(documents: const [document1, document2]);
      final downloadDocumentState = DocumentDownloadErrorState(errorType: DocumentsErrorType.unknown);
      final confirmDocumentsState = ConfirmDocumentsInitialState();

      // when
      final viewModel = DocumentsPresenter.present(
        documentsState: documentsState,
        downloadDocumentState: downloadDocumentState,
        confirmDocumentsState: confirmDocumentsState,
      );

      // then
      expect(viewModel, isA<DocumentsFetchedViewModel>());
    });
  });

  group("Confirming", () {
    test("When documents are confirming, it should return confirming view model", () {
      // given
      final documentsState = DocumentsFetchedState(documents: const [document1, document2]);
      final downloadDocumentState = DownloadDocumentInitialState();
      final confirmDocumentsState = ConfirmDocumentsLoadingState();

      // when
      final viewModel = DocumentsPresenter.present(
        documentsState: documentsState,
        downloadDocumentState: downloadDocumentState,
        confirmDocumentsState: confirmDocumentsState,
      );

      // then
      expect(viewModel, isA<DocumentsConfirmingViewModel>());
    });

    test("When documents are confirmed, it should return documents fetched view model", () {
      // given
      final documentsState = DocumentsFetchedState(documents: const [document1, document2]);
      final downloadDocumentState = DownloadDocumentInitialState();
      final confirmDocumentsState = ConfirmedDocumentsState();

      // when
      final viewModel = DocumentsPresenter.present(
        documentsState: documentsState,
        downloadDocumentState: downloadDocumentState,
        confirmDocumentsState: confirmDocumentsState,
      );

      // then
      expect(viewModel, isA<ConfirmedDocumentsViewModel>());
    });

    test("When documents failed confirming, it should return confirm error view model", () {
      // given
      final documentsState = DocumentsFetchedState(documents: const [document1, document2]);
      final downloadDocumentState = DownloadDocumentInitialState();
      final confirmDocumentsState = ConfirmDocumentsErrorState(errorType: DocumentsErrorType.unknown);

      // when
      final viewModel = DocumentsPresenter.present(
        documentsState: documentsState,
        downloadDocumentState: downloadDocumentState,
        confirmDocumentsState: confirmDocumentsState,
      );

      // then
      expect(viewModel, isA<ConfirmDocumentsErrorViewModel>());
    });
  });
}

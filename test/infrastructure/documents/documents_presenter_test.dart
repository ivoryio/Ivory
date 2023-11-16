import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/documents/documents_presenter.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';
import 'package:solarisdemo/redux/documents/download/download_document_state.dart';

void main() {
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

  test("When documents are loading, it should loading view model", () {
    // given
    final documentsState = DocumentsInitialLoadingState();
    final downloadDocumentState = DownloadDocumentInitialState();

    // when
    final viewModel = DocumentsPresenter.present(
      documentsState: documentsState,
      downloadDocumentState: downloadDocumentState,
    );

    // then
    expect(viewModel, isA<DocumentsLoadingViewModel>());
  });

  test("When documents are fetched, it should return fetched view model", () {
    // given
    final documentsState = DocumentsFetchedState(documents: const [document1, document2]);
    final downloadDocumentState = DownloadDocumentInitialState();

    // when
    final viewModel = DocumentsPresenter.present(
      documentsState: documentsState,
      downloadDocumentState: downloadDocumentState,
    );

    // then
    expect(viewModel, isA<DocumentsFetchedViewModel>());
    expect((viewModel as DocumentsFetchedViewModel).documents, [document1, document2]);
  });

  test("When documents have failed to fetch, it should return error view model", () {
    // given
    final documentsState = DocumentsErrorState(errorType: DocumentsErrorType.unknown);
    final downloadDocumentState = DownloadDocumentInitialState();

    // when
    final viewModel = DocumentsPresenter.present(
      documentsState: documentsState,
      downloadDocumentState: downloadDocumentState,
    );

    // then
    expect(viewModel, isA<DocumentsErrorViewModel>());
  });
}

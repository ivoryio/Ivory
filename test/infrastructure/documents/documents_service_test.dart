import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';

import '../../redux/auth/auth_mocks.dart';
import '../../setup/mock_http_client.dart';
import 'documents_service_mocks.dart';

void main() {
  // Loading from a static string.
  dotenv.testLoad(fileInput: '''API_BASE_URL=test.test''');

  group('getPostboxDocuments', () {
    final mockUser = MockUser();

    test('When response is an empty list it should return success', () async {
      // given
      final documentsService = DocumentsService();
      final httpClient = MockHttpClient();

      documentsService.client = httpClient;

      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => DocumentsHttpResponse.emptyList,
      );

      // when
      final response = await documentsService.getPostboxDocuments(user: mockUser);

      // then
      expect(response, isA<GetDocumentsSuccessResponse>());
    });

    test('When response is a list of documents it should return success', () async {
      // given
      final documentsService = DocumentsService();
      final httpClient = MockHttpClient();

      documentsService.client = httpClient;

      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => DocumentsHttpResponse.creditCardContractAndSecci,
      );

      // when
      final response = await documentsService.getPostboxDocuments(user: mockUser);

      // then
      expect(response, isA<GetDocumentsSuccessResponse>());
      expect(
        response as GetDocumentsSuccessResponse,
        equals(
          GetDocumentsSuccessResponse(
            documents: const [
              MockDocuments.creditCardContract,
              MockDocuments.creditCardSecci,
            ],
          ),
        ),
      );
    });

    test("When document type is unknown it should return succes with unknown document type", () async {
      // given
      final documentsService = DocumentsService();
      final httpClient = MockHttpClient();

      documentsService.client = httpClient;

      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => DocumentsHttpResponse.unknownDocument,
      );

      // when
      final response = await documentsService.getPostboxDocuments(user: mockUser);

      // then
      expect(response, isA<GetDocumentsSuccessResponse>());
      expect(
        response as GetDocumentsSuccessResponse,
        equals(
          GetDocumentsSuccessResponse(
            documents: const [MockDocuments.unknownDocument],
          ),
        ),
      );
    });

    test("When response is not a list it should return error", () async {
      // given
      final documentsService = DocumentsService();
      final httpClient = MockHttpClient();

      documentsService.client = httpClient;

      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
        (_) async => DocumentsHttpResponse.invalid,
      );

      // when
      final response = await documentsService.getPostboxDocuments(user: mockUser);

      // then
      expect(response, isA<DocumentsServiceErrorResponse>());
      expect(
        response as DocumentsServiceErrorResponse,
        equals(
          DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown),
        ),
      );
    });

    test("When the request is throwing an error it should return error", () async {
      // given
      final documentsService = DocumentsService();
      final httpClient = MockHttpClient();

      documentsService.client = httpClient;

      when(httpClient.get(any, headers: anyNamed("headers"))).thenThrow(Exception("error"));

      // when
      final response = await documentsService.getPostboxDocuments(user: mockUser);

      // then
      expect(response, isA<DocumentsServiceErrorResponse>());
      expect(
        response as DocumentsServiceErrorResponse,
        equals(
          DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown),
        ),
      );
    });
  });
}

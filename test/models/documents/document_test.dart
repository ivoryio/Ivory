import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/documents/document.dart';

void main() {
  group("parsing document types", () {
    const List<String> inputs = [
      "CREDIT_CARD_CONTRACT",
      "CREDIT_CARD_SECCI",
      "QES_DOCUMENT",
      "UNKNOWN_DOCUMENT_TYPE",
    ];
    const List<DocumentType> expectedOutputs = [
      DocumentType.creditCardContract,
      DocumentType.creditCardSecci,
      DocumentType.qesDocument,
      DocumentType.unknown,
    ];

    for (var i = 0; i < inputs.length; i++) {
      test("when input is '${inputs[i]}' then it should return ${expectedOutputs[i]}", () {
        // given
        final input = inputs[i];

        // when
        final output = DocumentTypeParser.parse(input);

        // then
        expect(output, equals(expectedOutputs[i]));
      });
    }
  });

  group("fileName", () {
    const inputDocuments = [
      Document(
        id: "1",
        fileType: "pdf",
        fileSize: 100,
        documentType: DocumentType.creditCardContract,
      ),
      Document(
        id: "2",
        fileType: "pdf",
        fileSize: 100,
        documentType: DocumentType.creditCardSecci,
      ),
      Document(
        id: "3",
        fileType: "pdf",
        fileSize: 100,
        documentType: DocumentType.qesDocument,
      ),
      Document(
        id: "4",
        fileType: "pdf",
        fileSize: 100,
        documentType: DocumentType.unknown,
      ),
    ];
    final expectedOutputs = [
      "credit_card_contract_1",
      "credit_card_secci_2",
      "qes_document_3",
      "4",
    ];

    for (var i = 0; i < inputDocuments.length; i++) {
      test("when document type is '${inputDocuments[i].documentType}' then it should return ${expectedOutputs[i]}", () {
        // given
        final input = inputDocuments[i];

        // when
        final output = input.fileName;

        // then
        expect(output, equals(expectedOutputs[i]));
      });
    }
  });
}

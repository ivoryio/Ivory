import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import '../auth/auth_mocks.dart';
import 'documents_mocks.dart';

void main() {
  final user = MockUser();
  final authentionInitializedState = AuthenticationInitializedState(user, AuthType.onboarding);

  test("When fetching documents the state should change to loading", () async {
    // given
    final store = createTestStore(
      documentsService: FakeDocumentsService(),
      initialState: createAppState(
        authState: authentionInitializedState,
        documentsState: DocumentsInitialState(),
      ),
    );
    final appState = store.onChange.firstWhere((element) => element.documentsState is DocumentsLoadingState);

    // when
    store.dispatch(GetDocumentsCommandAction());

    // then
    expect((await appState).documentsState, isA<DocumentsLoadingState>());
  });

  test("When documents are fetched with succes then the state should change to fetched", () async {
    // given
    final store = createTestStore(
      documentsService: FakeDocumentsService(),
      initialState: createAppState(
        authState: authentionInitializedState,
        documentsState: DocumentsInitialState(),
      ),
    );
    final appState = store.onChange.firstWhere((element) => element.documentsState is DocumentsFetchedState);

    // when
    store.dispatch(GetDocumentsCommandAction());

    // then
    expect((await appState).documentsState, isA<DocumentsFetchedState>());
  });
}

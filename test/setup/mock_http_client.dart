import 'dart:convert';

import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements Client {
  @override
  Future<Response> get(Uri? url, {Map<String, String>? headers}) async {
    return super.noSuchMethod(
      Invocation.method(#get, [url], {#headers: headers}),
      returnValue: Future.value(Response("{}", 200)),
      returnValueForMissingStub: Future.value(Response("{}", 200)),
    );
  }

  @override
  Future<Response> post(Uri? url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.noSuchMethod(
      Invocation.method(#post, [url], {#headers: headers, #body: body, #encoding: encoding}),
      returnValue: Future.value(Response("{}", 200)),
      returnValueForMissingStub: Future.value(Response("{}", 200)),
    );
  }

  @override
  Future<Response> patch(Uri? url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.noSuchMethod(
      Invocation.method(#patch, [url], {#headers: headers, #body: body, #encoding: encoding}),
      returnValue: Future.value(Response("{}", 200)),
      returnValueForMissingStub: Future.value(Response("{}", 200)),
    );
  }

  @override
  Future<Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.noSuchMethod(
      Invocation.method(#delete, [url], {#headers: headers, #body: body, #encoding: encoding}),
      returnValue: Future.value(Response("{}", 200)),
      returnValueForMissingStub: Future.value(Response("{}", 200)),
    );
  }
}

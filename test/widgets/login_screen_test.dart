import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/screens/login/login_screen.dart';

void main(){
testWidgets('Should have a title', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginScreen(),));

  Finder title = find.text('Login');

  expect(title, findsOneWidget);
});
}
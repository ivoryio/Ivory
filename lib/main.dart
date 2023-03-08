import 'package:flutter/material.dart';

import 'package:solaris_structure_1/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

class AppScaffold extends StatefulWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  State createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solaris')),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: calculateSelectedIndex(context),
        onTap: (value) => onTap(value, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Transfer'),
          BottomNavigationBarItem(icon: Icon(Icons.account_box), label: 'Hub'),
        ],
      ),
    );
  }
}

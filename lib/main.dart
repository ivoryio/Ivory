import 'package:flutter/material.dart';
import 'package:solaris_structure_1/src/pages/hub.dart';

import 'src/pages/home.dart';
import 'src/pages/transfer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Solaris App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AppScreen());
  }
}

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  var selectedPageIndex = 0;
  Widget page = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    switch (selectedPageIndex) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const TransferScreen();
        break;
      case 2:
        page = const HubScreen();
        break;
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Solaris App")),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedPageIndex,
            onTap: (pageIndex) => setState(() => selectedPageIndex = pageIndex),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: "Transfer"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Hub")
            ]),
        body: page);
  }
}

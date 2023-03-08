import 'package:flutter/material.dart';
import 'cubits/login_cubit/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solaris_structure_1/router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Builder(builder: (context) {
        return MaterialApp.router(
          routerConfig: AppRouter(context.read<LoginCubit>()).router,
        );
      }),
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
      appBar: AppBar(
        title: const Text('Solaris'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<LoginCubit>().logout();
            },
          )
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: AppRouter.calculateSelectedIndex(context),
        onTap: (pageIndex) => AppRouter.navigateToPage(pageIndex, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Transfer'),
          BottomNavigationBarItem(icon: Icon(Icons.account_box), label: 'Hub'),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'router/router.dart';
import 'services/auth_service.dart';
import 'cubits/auth_cubit/auth_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final materialTheme = ThemeData();

    final cupertinoTheme =
        MaterialBasedCupertinoThemeData(materialTheme: materialTheme);

    return BlocProvider(
      create: (context) => AuthCubit(
        authService: AuthService(context: context),
      ),
      child: Builder(builder: (context) {
        return PlatformApp.router(
          routerConfig: AppRouter(context.read<AuthCubit>()).router,
          material: (context, platform) => MaterialAppRouterData(
            theme: materialTheme,
          ),
          cupertino: (context, platform) => CupertinoAppRouterData(
            theme: cupertinoTheme,
          ),
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
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
    return PlatformScaffold(
      iosContentBottomPadding: true,
      iosContentPadding: true,
      appBar: PlatformAppBar(
        title: const Text('Solaris'),
        trailingActions: [
          PlatformIconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          )
        ],
      ),
      body: widget.child,
    );
  }
}

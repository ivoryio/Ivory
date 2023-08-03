import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/router/router.dart';
import 'package:solarisdemo/services/auth_service.dart';

import '../config.dart';
import '../cubits/auth_cubit/auth_cubit.dart';

class IvoryApp extends StatefulWidget {
  static final routeObserver = RouteObserver<PageRoute<dynamic>>();

  final ClientConfigData clientConfig;

  const IvoryApp({
    super.key,
    required this.clientConfig,
  });

  @override
  State<IvoryApp> createState() => _IvoryAppState();
}

class _IvoryAppState extends State<IvoryApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authService: AuthService(),
      ),
      child: Builder(builder: (context) {
        return MaterialApp.router(
          routerConfig: AppRouter(context.read<AuthCubit>()).router,
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          theme: widget.clientConfig.uiSettings.themeData,
          builder: (context, child) {
            return Scaffold(
              body: Material(
                child: child,
              ),
            );
          },
        );
      }),
    );
  }
}

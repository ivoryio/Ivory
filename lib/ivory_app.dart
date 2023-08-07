import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/router/router.dart';
import 'package:solarisdemo/services/auth_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../config.dart';
import '../cubits/auth_cubit/auth_cubit.dart';

class IvoryApp extends StatefulWidget {
  static final routeObserver = RouteObserver<PageRoute<dynamic>>();


  final ClientConfigData clientConfig;
  final Store<AppState> store;

  const IvoryApp({
    super.key,
    required this.clientConfig,
    required this.store
  });

  @override
  State<IvoryApp> createState() => _IvoryAppState();
}

class _IvoryAppState extends State<IvoryApp> {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: widget.store,
      child: BlocProvider(
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
      ),
    );
  }
}

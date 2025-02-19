import "package:faithwave_app/src/features/auth/cubits/auth_cubit.dart";
import "package:faithwave_app/src/features/todo/cubits/todo_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:faithwave_app/src/router/router.dart";
import "package:faithwave_app/src/env.dart";

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.light,
      fontFamily: "Montserrat",
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey[400]),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppEnv.I.flavor.colors.primary),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppEnv.I.flavor.colors.primary,
          ),
        ),
      ),
    );
    final darkTheme = ThemeData.dark();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => TodoCubit(context.read<AuthCubit>()),
        ),
      ],
      child: MaterialApp.router(
        restorationScopeId: AppEnv.I.flavor.id,
        localizationsDelegates: const [
          // S.delegate,
          // GlobalMaterialLocalizations.delegate,
          // GlobalWidgetsLocalizations.delegate,
          // GlobalCupertinoLocalizations.delegate,
        ],
        // supportedLocales: S.delegate.supportedLocales,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: router,
        builder: EasyLoading.init(),
      ),
    );
  }
}

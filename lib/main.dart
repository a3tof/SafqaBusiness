import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safqaseller/core/helper_functions/on_generate_routes.dart';
import 'package:safqaseller/core/services/background_notification_worker.dart';
import 'package:safqaseller/core/services/foreground_notification_poller.dart';
import 'package:safqaseller/core/services/notification_service.dart';
import 'package:safqaseller/core/network/dio_client.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/adaptive_layout/view/adaptive_layout_view.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model.dart';
import 'package:safqaseller/features/auth/view_model/auth/auth_view_model_state.dart';
import 'package:safqaseller/features/profile/view_model/profile_view_model.dart';
import 'package:safqaseller/generated/l10n.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await getIt<NotificationService>().init();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    notificationSyncTaskId,
    notificationSyncTaskId,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );

  await getIt<DioHelper>().ensureSessionIsValid();

  // Restore persisted auth + profile state before app starts.
  getIt<AuthViewModel>().loadFromCache();
  getIt<ProfileViewModel>().loadFromCache();

  runApp(const SafqaSeller());
}

class SafqaSeller extends StatefulWidget {
  const SafqaSeller({super.key});

  // ignore: library_private_types_in_public_api
  static _SafqaSellerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_SafqaSellerState>();

  @override
  State<SafqaSeller> createState() => _SafqaSellerState();
}

class _SafqaSellerState extends State<SafqaSeller> with WidgetsBindingObserver {
  Locale _locale = const Locale('en');
  StreamSubscription<AuthViewModelState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLocale();
    _bindForegroundNotificationPolling();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<NotificationService>().handleInitialNotificationNavigation();
    });
  }

  void _loadLocale() {
    final saved = getIt<CacheHelper>().getData(key: CacheKeys.language);
    Locale locale;
    if (saved == 'arabic') {
      locale = const Locale('ar');
    } else if (saved == 'english') {
      locale = const Locale('en');
    } else {
      final sys =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      locale = sys == 'ar' ? const Locale('ar') : const Locale('en');
    }
    setState(() => _locale = locale);
  }

  void setLocale(Locale locale) => setState(() => _locale = locale);

  void _bindForegroundNotificationPolling() {
    final authViewModel = getIt<AuthViewModel>();
    _handleAuthState(authViewModel.state);
    _authSubscription = authViewModel.stream.listen(_handleAuthState);
  }

  void _handleAuthState(AuthViewModelState state) {
    final poller = getIt<ForegroundNotificationPoller>();
    if (state is AuthAuthenticated) {
      poller.start();
      return;
    }

    poller.stop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    if (getIt<AuthViewModel>().state is AuthAuthenticated) {
      unawaited(getIt<DioHelper>().ensureSessionIsValid(redirectToLogin: true));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authSubscription?.cancel();
    getIt<ForegroundNotificationPoller>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthViewModel>.value(value: getIt<AuthViewModel>()),
        BlocProvider<ProfileViewModel>.value(value: getIt<ProfileViewModel>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: getIt<GlobalKey<NavigatorState>>(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: _locale.languageCode == 'ar' ? 'Cairo' : 'Inter',
            ),
            locale: _locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            initialRoute: AdaptiveLayoutView.routeName,
            onGenerateRoute: onGenerateRoutes,
            home: const AdaptiveLayoutView(),
          );
        },
      ),
    );
  }
}

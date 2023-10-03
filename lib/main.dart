import 'dart:async';
import 'dart:ui';
import 'package:ecommerce_app/src/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // * For more info on error handling, see:
  // * https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    setUrlStrategy(PathUrlStrategy());
    GoRouter.optionURLReflectsImperativeAPIs = true;

    // * This code will present some error UI if any uncaught exception happens
    registerErrorHandler();

    // * Entry point of the app
    runApp(const ProviderScope(
      child: MyApp(),
    ));

    // ErrorWidget.builder = (FlutterErrorDetails details) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.red,
    //       title: Text('An error occurred'.hardcoded),
    //     ),
    //     body: Center(child: Text(details.toString())),
    //   );
    // };
  }, (Object error, StackTrace stack) {
    // * Log any errors to console
    debugPrint(error.toString());
  });
}

void registerErrorHandler() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
    // myErrorsHandler.onErrorDetails(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint(error.toString());
    return true;
  };
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled2/web_authentication_session_example.screen.dart';
import 'chrome_safari_browser_example.screen.dart';
import 'headless_in_app_webview.screen.dart';
import 'in_app_browser_example.screen.dart';
import 'in_app_webiew_example.screen.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets');


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  await Permission.storage.request();
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();

  // if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
  //   // final availableVersion = await WebViewEnvironment.getAvailableVersion();
  //   assert(availableVersion != null, 'Failed to find an installed WebView2 runtime or non-stable Microsoft Edge installation.');
  //
  //   webViewEnvironment = await WebViewEnvironment.create(settings:
  //   WebViewEnvironmentSettings(
  //       userDataFolder: 'custom_path'
  //   ));
  // }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(initialRoute: '/', routes: {
        '/': (context) => InAppWebViewExampleScreen(),
      });
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return MaterialApp(initialRoute: '/', routes: {
        // '/': (context) => InAppWebViewExampleScreen(),
        // '/InAppBrowser': (context) => InAppBrowserExampleScreen(),
        '/': (context) => InAppBrowserExampleScreen(),
        '/HeadlessInAppWebView': (context) =>
            HeadlessInAppWebViewExampleScreen(),
        '/WebAuthenticationSession': (context) =>
            WebAuthenticationSessionExampleScreen(),
      });
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return MaterialApp(initialRoute: '/', routes: {
        '/': (context) => InAppWebViewExampleScreen(),
        '/InAppBrowser': (context) => InAppBrowserExampleScreen(),
        '/HeadlessInAppWebView': (context) =>
            HeadlessInAppWebViewExampleScreen(),
      });
    }
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => InAppWebViewExampleScreen(),
      '/InAppBrowser': (context) => InAppBrowserExampleScreen(),
      '/ChromeSafariBrowser': (context) => ChromeSafariBrowserExampleScreen(),
      '/HeadlessInAppWebView': (context) => HeadlessInAppWebViewExampleScreen(),
      '/WebAuthenticationSession': (context) =>
          WebAuthenticationSessionExampleScreen(),
    });
  }
}
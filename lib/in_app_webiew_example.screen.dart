import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer.dart';

class InAppWebViewExampleScreen extends StatefulWidget {
  @override
  _InAppWebViewExampleScreenState createState() =>
      _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true,
      allowContentAccess: true,
      allowFileAccess: true,
      useOnDownloadStart: true,
      javaScriptEnabled: true,
  );

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    urlController.text="";
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              id: 1,
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = contextMenuItemClicked.id;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.macOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("InAppWebView")),
        drawer: myDrawer(context: context),
        body: SafeArea(
            child: Column(children: <Widget>[
          TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
            controller: urlController,
            keyboardType: TextInputType.text,
            onSubmitted: (value) {
              var url = WebUri(value);
              if (url.scheme.isEmpty) {
                url = WebUri((!kIsWeb
                        ? "https://www.google.com/search?q="
                        : "https://www.bing.com/search?q=") +
                    value);
              }
              webViewController?.loadUrl(urlRequest: URLRequest(url: url));
            },
          ),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                  URLRequest(url: WebUri('https://togumoguuat.doctime.com.bd'),headers:
                  {
                    "Authorization": "Bearer 0ec17b12053af6595e617a3a3db4027daf0ebd51c93a6ae5e651b882ee5c800a",
                    "platform": "Android",
                    "version": "2.2.31(231)"}

                  ),
                  // initialUrlRequest: URLRequest(
                  //     url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") +
                  //         'page.html')),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialSettings: settings,
                  contextMenu: contextMenu,
                  pullToRefreshController: pullToRefreshController,
                  onLoadStart: (controller, url) async {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(uri)) {
                        // Launch the App
                        await launchUrl(
                          uri,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController?.endRefreshing();
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                  },
                  onDownloadStartRequest: (controller, url) async {
                    // print("onDownloadStart1111 ${url.url}");
                    // Directory? tempDir = await getExternalStorageDirectory();
                    // setState(() {});
                    // print(
                    //     "onDownload ${url.url.toString()}\n ${tempDir!.path}");
                    // await FlutterDownloader.enqueue(
                    //   url: url.url.toString(),
                    //   fileName: url.suggestedFilename,
                    //   //================File Name
                    //   savedDir: tempDir.path,
                    //   showNotification: true,
                    //   requiresStorageNotLow: false,
                    //   openFileFromNotification: true,
                    //   saveInPublicStorage: true,
                    // );

                    print("Download Start: ${url.url}");
                    // Check if the file is a PDF
                    if (url.url.toString().toLowerCase().endsWith('.pdf')) {
                      // Open PDF viewer using url_launcher
                      // ignore: deprecated_member_use
                      if (await canLaunchUrl(url.url)) {
                        // ignore: deprecated_member_use
                        await launchUrl(url.url);
                      } else {
                        log("Could not launch PDF viewer");
                      }
                    } else {
                      // Launch for other file types
                      if (await canLaunchUrl(url.url)) {
                        await launchUrl(url.url);
                      } else {
                        log("Could not launch file");
                      }
                      //log("Handle other file types or open in-app viewer");
                    }

                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, isReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("consoleMessage $consoleMessage");
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  webViewController?.goBack();
                },
              ),
              ElevatedButton(
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  webViewController?.goForward();
                },
              ),
              ElevatedButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  webViewController?.reload();
                },
              ),
            ],
          ),
        ])));
  }
}

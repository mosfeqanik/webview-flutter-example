
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

PointerInterceptor myDrawer({required BuildContext context}) {
  var children = [
    ListTile(
      title: Text('InAppWebView'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/');
      },
    ),
    ListTile(
      title: Text('InAppBrowser'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/InAppBrowser');
      },
    ),
    ListTile(
      title: Text('ChromeSafariBrowser'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/ChromeSafariBrowser');
      },
    ),
    ListTile(
      title: Text('WebAuthenticationSession'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/WebAuthenticationSession');
      },
    ),
    ListTile(
      title: Text('HeadlessInAppWebView'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/HeadlessInAppWebView');
      },
    ),
  ];
  if (kIsWeb) {
    children = [
      ListTile(
        title: Text('InAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
      )
    ];
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    children = [
      // ListTile(
      //   title: Text('InAppWebView'),
      //   onTap: () {
      //     Navigator.pushReplacementNamed(context, '/');
      //   },
      // ),
      // ListTile(
      //   title: Text('InAppBrowser'),
      //   onTap: () {
      //     Navigator.pushReplacementNamed(context, '/InAppBrowser');
      //   },
      // ),
      ListTile(
        title: Text('InAppBrowser'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
      ListTile(
        title: Text('WebAuthenticationSession'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/WebAuthenticationSession');
        },
      ),
      ListTile(
        title: Text('HeadlessInAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/HeadlessInAppWebView');
        },
      ),
    ];
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux) {
    children = [
      ListTile(
        title: Text('InAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
      ListTile(
        title: Text('InAppBrowser'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/InAppBrowser');
        },
      ),
      ListTile(
        title: Text('HeadlessInAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/HeadlessInAppWebView');
        },
      ),
    ];
  }
  return PointerInterceptor(
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('flutter_inappwebview example'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ...children
        ],
      ),
    ),
  );
}
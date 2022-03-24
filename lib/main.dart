import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_example/sample_menu.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'navigation_controls.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
      const MaterialApp(debugShowCheckedModeBanner: false, home: WebviewExample()));
}

class WebviewExample extends StatefulWidget {
  final String url;
  const WebviewExample({Key? key, this.url = 'hh.ru'}) : super(key: key);

  @override
  _WebviewExampleState createState() => _WebviewExampleState();
}

class _WebviewExampleState extends State<WebviewExample> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  // var _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title:  Text(widget.url),// TextButton(child: Text(widget.url, style: TextStyle(color: Colors.white,)), onPressed: changeUrl),
    actions: <Widget>[
    NavigationControls(_controller.future),
    SampleMenu(_controller.future),
    ],
    ),
    body: Builder(builder: (BuildContext context) {
    return WebView(
    //   userAgent: "http.agent",
    initialUrl: "https://" + widget.url,
    javascriptMode: JavascriptMode.unrestricted,
    onWebViewCreated: (WebViewController webViewController) {
    _controller.complete(webViewController);
    },
    gestureNavigationEnabled: true,
    );
    })
    ,
    );
  }

/*void changeUrl() {
    _editingController = TextEditingController(text: widget.url);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 16,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white70,
              contentPadding: EdgeInsets.all(10.0),
            ),
            onSubmitted: (newUrl) {
              if (newUrl.startsWith("https://")) {
                setState(() {
                  widget.url = newUrl;
                });
              } else {
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Введите корректное название сайта начиная с https://')),
                );
              }
            },
            autofocus: true,
            controller: _editingController,
          ),
        );
      },
    );
  } */
}

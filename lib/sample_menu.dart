import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_example/websites_list.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main.dart';
import 'models/menu_options.dart';

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller, {Key? key}) : super(key: key);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();
  var _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.addToFavorite:
                _addToFavorite(context, controller.data!);
                break;
              case MenuOptions.favoriteWebsites:
                _navigateToFavourites(context);
                break;
              case MenuOptions.clearCookies:
                _onClearCookies(context);
                break;
              case MenuOptions.followTheLink:
                _followTheLink(context,controller.data!);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.addToFavorite,
              child: const Text('Добавить в Избранное'),
              enabled: controller.hasData,
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.favoriteWebsites,
              child: Text('Избранное'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('Очистить cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.followTheLink,
              child: Text('Перейти...'),
            ),
          ],
        );
      },
    );
  }

  void _addToFavorite(
    BuildContext context,
    WebViewController controller,
  ) async {
    final String url = (await controller.currentUrl())!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var websitesList = prefs.getStringList('website');
    websitesList ??= [];
    print(websitesList);
    if (!websitesList.contains(url)) {
      websitesList.add(url);
      await prefs.setStringList('website', websitesList);
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Добавлен сайт $url')),
      );
    } else {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Этот сайт $url уже в Избранном')),
      );
    }
  }

  void _navigateToFavourites(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const WebsitesList()));
  }

  void _followTheLink(
      BuildContext context, WebViewController controller) async {
    _editingController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 16,
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white70,
              contentPadding: EdgeInsets.all(10.0),
              hintText: "https://...",
            ),
            onSubmitted: (newUrl) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => WebviewExample(url: newUrl)),(Route<dynamic> route) => false);
            },
            autofocus: true,
            controller: _editingController,
          ),
        );
      },
    );
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message;
    if (!hadCookies) {
      message = 'Cookies отсутствуют.';
    } else {
      message = 'Cookies очищены.';
    }
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

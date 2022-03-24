import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class WebsitesList extends StatefulWidget {
  const WebsitesList({Key? key}) : super(key: key);

  @override
  State<WebsitesList> createState() => _WebsitesListState();
}

class _WebsitesListState extends State<WebsitesList> {
  final List<Widget> _widgetsList = [];
  bool isLoading = false;

  @override
  void initState() {
    getWebsites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Избранное"),
      ),
      body: Column(children: isLoading ? [Container()] : _widgetsList),
    );
  }

  getWebsites() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _websitesList = prefs.getStringList('website');
    _websitesList ??= [];
    for (var website in _websitesList) {
      website = website.replaceAll("https://", "");
      setState(() {
        _widgetsList.add(TextButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) => WebviewExample(url: website)),(Route<dynamic> route) => false),
            child: Text(
              website,
              style: const TextStyle(color: Colors.black),
            )));
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}

import 'dart:io';

import 'package:chitr/profile/ui/profile_page.dart';
import 'package:chitr/util/bottom_nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'home/ui/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkInternet();
    return MaterialApp(
      title: 'Chitr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF212121),
        accentColor: Colors.white,
      ),
      home: ChangeNotifierProvider<BottomNavBarProvider>(
        builder: (context) => BottomNavBarProvider(),
        child: MainPage(),
      ),
    );
  }
  checkInternet() {
    final result = InternetAddress.lookup('google.com');
    result.then((resp) {
      Fluttertoast.showToast(msg: "Hi, You are Online!");
    }).catchError((e) {
      Fluttertoast.showToast(msg: "Hi, You seem to be Offline!");
    });
  }
}

class MainPage extends StatelessWidget {
  final currentTab = [
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavBarProvider>(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: currentTab[provider.currentIndex],
    );
  }
}

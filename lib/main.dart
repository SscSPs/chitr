import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'home/ui/home_page.dart';
import 'profile/ui/profile_page.dart';
import 'util/bottom_nav_bar_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  bool isInternetAvailable;

  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chitr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF000000),
        accentColor: Colors.white,
      ),
      home: ChangeNotifierProvider<BottomNavBarProvider>(
        builder: (context) => BottomNavBarProvider(),
        child: MainPage(
          currentPage: isInternetAvailable != null && isInternetAvailable
              ? HomePage(onSettingsPressed: checkInternet)
              : FallBackPage(
                  onPress: checkInternet,
                  internetAvailable: isInternetAvailable,
                ),
        ),
      ),
    );
  }

  checkInternet() {
    print("checkInternet Called");
    InternetAddress.lookup('pixabay.com').then((resp) {
      if (isInternetAvailable == null || !isInternetAvailable) {
        Fluttertoast.showToast(msg: "Hi, You are Online!");
        setState(() {
          isInternetAvailable = true;
        });
      } else {
        Fluttertoast.showToast(msg: "You are already Online!");
      }
    }).catchError((e) {
      if (isInternetAvailable == null || isInternetAvailable) {
        Fluttertoast.showToast(msg: "Hi, You seem to be Offline!");
        setState(() {
          isInternetAvailable = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Still No Internet :/");
      }
    });
  }
}

class MainPage extends StatelessWidget {
  final currentPage;

  MainPage({this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // So we don't have a app bar
        child: AppBar(),
      ),
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: currentPage,
    );
  }
}

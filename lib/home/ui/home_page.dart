import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitr/home/model/ImageModel.dart';
import 'package:chitr/image/ui/image_page.dart';
import 'package:chitr/search/searchPage.dart';
import 'package:chitr/util/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'custom_card.dart';

class HomePage extends StatefulWidget {
  final Function() onSettingsPressed;

  HomePage({this.onSettingsPressed});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int initialXAxisElements = 5;
  static int initialYAxisElements = 5;
  static double majorAxisViewPortFractions = 0.8;
  static double minorAxisViewPortFractions = 0.7;
  static bool majorAxisIsX = true;
  static int majorAxisCount =
      majorAxisIsX ? initialXAxisElements : initialYAxisElements;
  static int minorAxisCount =
      majorAxisIsX ? initialYAxisElements : initialXAxisElements;
  static int majorOffset = (majorAxisCount / 2).floor();
  static int minorOffset = (minorAxisCount / 2).floor();

  static int initialElementsCount = majorAxisCount * minorAxisCount;
  List<CachedNetworkImage> imageWidgets = [];
  List<PreloadPageController> controllers = [];
  List<Hits> hits;

  @override
  void initState() {
    _loadImages();
    for (int i = 0; i < minorAxisCount; i++)
      controllers.add(PreloadPageController(
        viewportFraction: majorAxisViewPortFractions,
        initialPage: minorOffset,
      ));
    super.initState();
  }

  _animatePage(int page, int index) {
    for (int i = 0; i < minorAxisCount; i++) {
      if (i != index) {
        controllers[i].animateToPage(
          page,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }
  }

  _loadImages() async {
    var imageModel = await ApiProvider().getRandomImages(initialElementsCount);
    hits = imageModel.hits;
    for (Hits one in hits) {
      var temp;
      if (one == null || one.webformatURL == null) {
        temp = null;
      } else {
        temp = CachedNetworkImage(
          imageUrl: one.webformatURL,
          fit: BoxFit.cover,
        );
      }
      imageWidgets.add(temp);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: PreloadPageView.builder(
        controller: PreloadPageController(
          viewportFraction: minorAxisViewPortFractions,
          initialPage: majorOffset,
        ),
        itemCount: minorAxisCount,
        preloadPagesCount: minorAxisCount,
        scrollDirection: majorAxisIsX ? Axis.vertical : Axis.horizontal,
        itemBuilder: (context, mainIndex) {
          return PreloadPageView.builder(
            itemCount: majorAxisCount,
            preloadPagesCount: majorAxisCount,
            controller: controllers[mainIndex],
            scrollDirection: majorAxisIsX ? Axis.horizontal : Axis.vertical,
            physics: ClampingScrollPhysics(),
            onPageChanged: (page) {
              _animatePage(page, mainIndex);
            },
            itemBuilder: (context, index) {
              var hitIndex = (mainIndex * majorAxisCount) + index;
              var hit;
              if (hits != null) {
                hit = hits[hitIndex];
              }
              return GestureDetector(
                onTap: () {
                  if (hits != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePage(
                          heroTag: hitIndex.toString(),
                          model: hit,
                          cachedNetworkImage: _getImageWidget(hitIndex),
                        ),
                      ),
                    );
                  }
                },
                child: CustomCard(
                  heroTag: hitIndex.toString(),
                  title: hit?.user,
                  description: hit?.tags,
                  cachedNetworkImageWidget: _getImageWidget(hitIndex),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            child: FloatingActionButton(
              heroTag: "searchFAB",
              child: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
            ),
            padding: EdgeInsets.all(10),
          ),
          Padding(
            child: FloatingActionButton(
              heroTag: "settingsFAB",
              child: Icon(Icons.refresh),
              onPressed: () {
                widget.onSettingsPressed();
                Fluttertoast.showToast(msg: "Hi!");
              },
            ),
            padding: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }

  _getImageWidget(int hitIndex) {
    if (hitIndex < imageWidgets.length) {
      return imageWidgets[hitIndex];
    }
    return null;
  }
}

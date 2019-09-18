import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitr/home/model/ImageModel.dart';
import 'package:chitr/image/ui/image_page.dart';
import 'package:chitr/search/searchPage.dart';
import 'package:chitr/util/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'custom_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int initialXAxisElements = 5;
  static int initialYAxisElements = 5;
  static int initialElementsCount = initialYAxisElements * initialXAxisElements;
  static bool majorAxisIsX = true;
  List<CachedNetworkImage> imageWidgets = [];
  List<PreloadPageController> controllers = [];
  List<Hits> hits;
  var viewPortFractions = 0.7;
  static int majorAxisCount =
      majorAxisIsX ? initialXAxisElements : initialYAxisElements;
  static int minorAxisCount =
      majorAxisIsX ? initialYAxisElements : initialXAxisElements;
  static int majorOffset = (majorAxisCount / 2).floor();
  static int minorOffset = (minorAxisCount / 2).floor();

  @override
  void initState() {
    _loadImages();
    for (int i = 0; i < minorAxisCount; i++)
      controllers.add(PreloadPageController(
          viewportFraction: viewPortFractions, initialPage: minorOffset));
    super.initState();
  }

  _animatePage(int page, int index) {
    for (int i = 0; i < minorAxisCount; i++) {
      if (i != index) {
        controllers[i].animateToPage(page,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
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
          fit: one.imageHeight > one.imageWidth
              ? BoxFit.fitWidth
              : BoxFit.fitHeight,
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
            viewportFraction: viewPortFractions, initialPage: majorOffset),
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
                    cachedNetworkImageWidget: _getImageWidget(hitIndex)),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            child: FloatingActionButton(
              heroTag: "searchFAB",
              child: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
            ),
            padding: EdgeInsets.all(10),
          ),
          FloatingActionButton(
            heroTag: "settingsFAB",
            child: Icon(Icons.settings),
            onPressed: () {
              Fluttertoast.showToast(msg: "Hi!");
            },
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

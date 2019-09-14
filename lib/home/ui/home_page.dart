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
  List<PreloadPageController> controllers = [];
  List<Hits> hits;
  var viewPortFractions = 0.7;
  var initialOffset = 2;

  @override
  void initState() {
    _loadImages();
    controllers = [
      PreloadPageController(
          viewportFraction: viewPortFractions, initialPage: initialOffset),
      PreloadPageController(
          viewportFraction: viewPortFractions, initialPage: initialOffset),
      PreloadPageController(
          viewportFraction: viewPortFractions, initialPage: initialOffset),
      PreloadPageController(
          viewportFraction: viewPortFractions, initialPage: initialOffset),
      PreloadPageController(
          viewportFraction: viewPortFractions, initialPage: initialOffset),
    ];
    super.initState();
  }

  _animatePage(int page, int index) {
    for (int i = 0; i < 5; i++) {
      if (i != index) {
        controllers[i].animateToPage(page,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    }
  }

  _loadImages() async {
    var imageModel = await ApiProvider().getRandomImages(25);
    hits = imageModel.hits;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: PreloadPageView.builder(
        controller: PreloadPageController(
            viewportFraction: viewPortFractions, initialPage: initialOffset),
        itemCount: 5,
        preloadPagesCount: 5,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, mainIndex) {
          return PreloadPageView.builder(
            itemCount: 5,
            preloadPagesCount: 5,
            controller: controllers[mainIndex],
            scrollDirection: Axis.horizontal,
            physics: ClampingScrollPhysics(),
            onPageChanged: (page) {
              _animatePage(page, mainIndex);
            },
            itemBuilder: (context, index) {
              var hitIndex = (mainIndex * 5) + index;
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
                          imageBoxFit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                },
                child: CustomCard(
                  heroTag: hitIndex.toString(),
                  title: hit?.user,
                  description: hit?.tags,
                  url: hit?.webformatURL,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
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
        )
      ]),
    );
  }
}

import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  CustomCard({
    @required this.heroTag,
    @required this.cachedNetworkImageWidget,
    @required this.title,
    @required this.description,
  });

  final Widget cachedNetworkImageWidget;
  final String heroTag;
  final String title;
  final String description;

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      child: Card(
        color: Theme.of(context).backgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              child: widget.cachedNetworkImageWidget,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: 200.0,
                decoration: _whiteGradientDecoration(),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    (widget.title != null) ? widget.title : '',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (widget.description != null) ? widget.description : '',
                      maxLines: 1,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      tag: widget.heroTag,
    );
  }

  BoxDecoration _whiteGradientDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
          colors: [Colors.black, const Color(0x10000000)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter),
    );
  }
}

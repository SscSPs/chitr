import 'package:flutter/material.dart';

class FallBackPage extends StatelessWidget {
  final Function() onPress;
  final bool internetAvailable;

  FallBackPage({this.onPress, this.internetAvailable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: internetAvailable == null
              ? <Widget>[
                  Text("Checking Your Internet connection"),
                ]
              : <Widget>[
                  Text('Seems Like You are Offline'),
                  Text('Press the Button To Retry'),
                  MaterialButton(
                    onPressed: onPress,
                    color: Theme.of(context).primaryColor,
                    child: Icon(Icons.refresh),
                  ),
                ],
        ),
      ),
    );
  }
}

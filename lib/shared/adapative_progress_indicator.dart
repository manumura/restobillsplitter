import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? const CupertinoActivityIndicator()
        : CircularProgressIndicator(
            backgroundColor: Colors.indigo[100],
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          );
  }
}

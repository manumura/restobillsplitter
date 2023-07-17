import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomAppBar extends HookWidget implements PreferredSizeWidget {
  const CustomAppBar(this.title, [this.actions = const <Widget>[]]);

  final Widget title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

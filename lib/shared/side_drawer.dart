import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:restobillsplitter/shared/about_box_children.dart';
import 'package:restobillsplitter/shared/global_config.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Resto Bill Splitter'),
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
          AboutListTile(
            icon: const Icon(
              Icons.info,
            ),
            applicationIcon: Icon(
              Icons.attach_money_rounded,
              size: 65,
              color: Theme.of(context).colorScheme.secondary,
            ),
            applicationName: _packageInfo.appName,
            applicationVersion: _packageInfo.version,
            applicationLegalese: applicationLegalese,
            aboutBoxChildren: buildAboutBoxChildren(context),
            child: const Text('About'),
          ),
        ],
      ),
    );
  }
}

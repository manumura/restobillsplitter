import 'package:flutter/material.dart';
import 'package:restobillsplitter/pages/privacy_policy_screen.dart';
import 'package:restobillsplitter/pages/terms_and_conditions_screen.dart';

List<Widget> buildAboutBoxChildren(BuildContext context) {
  return <Widget>[
    const SizedBox(
      height: 20,
    ),
    RichText(
      text: const TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text:
                'With Resto Bill Splitter, no more pain to split the restaurant bill with your friends !',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: 'First add some guests. Then add the dishes.',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text:
                'You can then assign the dishes to the guests, and enter the tax.',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: 'The share for each guest is automatically calculated !',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    ),
    const SizedBox(
      height: 20,
    ),
    FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          PrivacyPolicyScreen.routeName,
        );
      },
      child: const Text('Privacy Policy'),
    ),
    FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          TermsAndConditionsScreen.routeName,
        );
      },
      child: const Text('Terms & Conditions'),
    ),
  ];
}

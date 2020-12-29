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
                'Simple Order Manager is your Back Office for all your order management.',
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
                'You can easily create categories and products by category. Then just simply add your products to the order.',
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
                'Mark the order completed to keep track of all your past orders.',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    ),
    RichText(
      text: const TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: 'No more pen and paper, everything is in your pocket !',
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

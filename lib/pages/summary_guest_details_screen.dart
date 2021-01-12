import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';

class SummaryGuestDetailsScreen extends HookWidget {
  static const String routeName = '/summary_guest_detail';

  SummaryGuestDetailsScreen(this.guest);

  final GuestModel guest;
  final Logger logger = getLogger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(
          guest.name,
        ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: guest.dishes == null || guest.dishes.isEmpty
          ? const Center(
              child: Text('Please add a dish first'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final DishModel dish = guest.dishes[index];
                final double totalPerDish = dish.price / dish.guestUuids.length;
                final String totalPerDishAsString =
                    totalPerDish?.toStringAsFixed(2) ?? '0.0';

                return ListTile(
                  title: Text(
                    dish.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '\$${dish.price ?? 0.0}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  trailing: Text(
                    '\$$totalPerDishAsString',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              itemCount: guest.dishes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 2.0,
              ),
            ),
    );
  }
}

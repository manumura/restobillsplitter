import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/shared/app_bar.dart';
import 'package:restobillsplitter/shared/side_drawer.dart';
import 'package:restobillsplitter/state/providers.dart';
import 'package:restobillsplitter/widgets/assign_dish_list_tile.dart';

class AssignScreen extends HookConsumerWidget {
  AssignScreen({super.key});

  static const String routeName = '/assign';

  final Logger logger = getLogger();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BillModel bill = ref.watch(billStateNotifierProvider);
    final List<DishModel> dishes = bill.dishes;

    return Scaffold(
      drawer: const SideDrawer(),
      appBar: const CustomAppBar(
        title: Text('Assign guests to dishes'),
      ),
      body: dishes.isEmpty
          ? const Center(
              child: Text('Please add a dish first'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final DishModel dish = dishes[index];
                return AssignDishListTile(
                  key: ValueKey<String>(dish.uuid),
                  dish: dish,
                );
              },
              itemCount: dishes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 5.0,
              ),
            ),
    );
  }
}

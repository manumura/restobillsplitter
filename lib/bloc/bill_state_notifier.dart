import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:uuid/uuid.dart';

class BillStateNotifier extends StateNotifier<BillModel> {
  BillStateNotifier([BillModel initialBill])
      : super(initialBill ??
            BillModel(
              guests: <GuestModel>[],
              dishes: <DishModel>[],
              tax: 0.0,
              isSplitTaxEqually: false,
            ));

  void addGuest() {
    // TODO
    final int nextIndex = state.guests.length + 1;
    final Uuid uuid = Uuid();
    // final RandomColor randomColor = RandomColor();
    // final Color color = randomColor.randomColor(
    //   colorSaturation: ColorSaturation.mediumSaturation,
    //   colorBrightness: ColorBrightness.primary,
    //   colorHue: ColorHue.multiple(
    //     colorHues: <ColorHue>[
    //       ColorHue.red,
    //       ColorHue.blue,
    //       ColorHue.green,
    //       ColorHue.yellow,
    //     ],
    //   ),
    // );
    final Color color = Colors.primaries[nextIndex % Colors.primaries.length];
    final GuestModel guestToAdd = GuestModel(
        uuid: uuid.v4(), name: 'Guest$nextIndex', color: color, total: 0.0);
    state = state..guests.add(guestToAdd);
  }

  void editGuest(GuestModel guest) {
    final List<GuestModel> newGuests = <GuestModel>[
      for (final GuestModel g in state.guests)
        if (g.uuid == guest.uuid)
          GuestModel(
            uuid: guest.uuid,
            name: guest.name,
            color: guest.color,
            total: guest.total,
          )
        else
          g,
    ];

    // Modify assigned dishes with new guest
    final List<DishModel> newDishes = <DishModel>[];
    if (state.dishes != null) {
      for (final DishModel d in state.dishes) {
        if (d.guests == null) {
          continue;
        }

        final List<GuestModel> guests = <GuestModel>[];
        for (final GuestModel g in d.guests) {
          final GuestModel guestToAdd = g.uuid == guest.uuid
              ? GuestModel(
                  uuid: guest.uuid,
                  name: guest.name,
                  color: guest.color,
                  total: guest.total,
                )
              : g;
          guests.add(guestToAdd);
        }
        final DishModel dishToAdd = DishModel(
            uuid: d.uuid, name: d.name, price: d.price, guests: guests);
        newDishes.add(dishToAdd);
      }
    }

    state = BillModel(
        guests: newGuests,
        dishes: newDishes,
        tax: state.tax,
        isSplitTaxEqually: state.isSplitTaxEqually);
    // print('new state: $state');
  }

  void removeGuest(GuestModel guest) {
    final List<GuestModel> newGuests =
        state.guests.where((GuestModel g) => g.uuid != guest.uuid).toList();

    // Remove guest from assigned dishes
    final List<DishModel> newDishes = <DishModel>[];
    if (state.dishes != null) {
      for (final DishModel d in state.dishes) {
        if (d.guests == null) {
          continue;
        }

        final List<GuestModel> guests =
            d.guests.where((GuestModel g) => g.uuid != guest.uuid).toList();
        final DishModel dishToAdd = DishModel(
            uuid: d.uuid, name: d.name, price: d.price, guests: guests);
        newDishes.add(dishToAdd);
      }
    }

    state = BillModel(
        guests: newGuests,
        dishes: newDishes,
        tax: state.tax,
        isSplitTaxEqually: state.isSplitTaxEqually);
  }

  void addDish() {
    final Uuid uuid = Uuid();
    // TODO
    final int nextIndex = state.dishes.length + 1;
    final DishModel dishToAdd =
        DishModel(uuid: uuid.v4(), name: 'Dish$nextIndex');
    state = state..dishes.add(dishToAdd);
  }

  void editDish(DishModel dish) {
    print('new dish: $dish');
    final List<DishModel> newDishes = <DishModel>[
      for (final DishModel d in state.dishes)
        if (d.uuid == dish.uuid)
          DishModel(
            uuid: dish.uuid,
            name: dish.name,
            price: dish.price,
            guests: dish.guests,
          )
        else
          d,
    ];

    state = BillModel(
        guests: state.guests,
        dishes: newDishes,
        tax: state.tax,
        isSplitTaxEqually: state.isSplitTaxEqually);
  }

  void editDishPrice(DishModel dish, double price) {
    final List<DishModel> newDishes = <DishModel>[
      for (final DishModel d in state.dishes)
        if (d.uuid == dish.uuid)
          DishModel(
            uuid: d.uuid,
            name: d.name,
            price: price,
            guests: d.guests,
          )
        else
          d,
    ];

    // Calculate total per guest for all guests
    final List<GuestModel> newGuests = _getAllGuestsWithTotal(newDishes);

    state = BillModel(
        guests: newGuests,
        dishes: newDishes,
        tax: state.tax,
        isSplitTaxEqually: state.isSplitTaxEqually);
  }

  void assignGuestsToDish(DishModel dish, List<GuestModel> guests) {
    final List<DishModel> newDishes = <DishModel>[
      for (final DishModel d in state.dishes)
        if (d.uuid == dish.uuid)
          DishModel(
            uuid: d.uuid,
            name: d.name,
            price: d.price,
            guests: guests,
          )
        else
          d,
    ];

    // Calculate total per guest for all guests
    final List<GuestModel> newGuests = _getAllGuestsWithTotal(newDishes);

    state = BillModel(
        guests: newGuests,
        dishes: newDishes,
        tax: state.tax,
        isSplitTaxEqually: state.isSplitTaxEqually);
  }

  void removeDish(DishModel dish) {
    final List<DishModel> dishes =
        state.dishes.where((DishModel d) => d.uuid != dish.uuid).toList();
    state = BillModel(
        guests: state.guests,
        dishes: dishes,
        tax: state.tax,
        isSplitTaxEqually: state.isSplitTaxEqually);
  }

  void editTax(double tax) {
    state = BillModel(
        guests: state.guests,
        dishes: state.dishes,
        tax: tax,
        isSplitTaxEqually: state.isSplitTaxEqually);
  }

  void editSplitTaxEqually({bool isSplitTaxEqually}) {
    state = BillModel(
        guests: state.guests,
        dishes: state.dishes,
        tax: state.tax,
        isSplitTaxEqually: isSplitTaxEqually);
  }

  List<GuestModel> _getAllGuestsWithTotal(List<DishModel> currentDishes) {
    final List<GuestModel> currentGuests = state.guests;
    final List<GuestModel> newGuests = <GuestModel>[];
    for (final GuestModel currentGuest in currentGuests) {
      final GuestModel newGuest =
          GuestModel.cloneWithCalculatedTotal(currentGuest, currentDishes);
      newGuests.add(newGuest);
    }

    return newGuests;
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }
}

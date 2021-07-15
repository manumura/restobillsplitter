import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:uuid/uuid.dart';

class BillStateNotifier extends StateNotifier<BillModel> {
  BillStateNotifier([BillModel? initialBill])
      : super(
          initialBill ??
              BillModel(
                guests: <GuestModel>[],
                dishes: <DishModel>[],
                tax: 0,
                isSplitTaxEqually: false,
              ),
        );

  final Logger logger = getLogger();

  int _nextGuestIndex = 1;
  int _nextDishIndex = 1;

  void addGuest() {
    final int nextIndex = _nextGuestIndex;
    _nextGuestIndex++;
    const Uuid uuid = Uuid();
    final Color color = Colors.primaries[nextIndex % Colors.primaries.length];
    final GuestModel guestToAdd = GuestModel(
      uuid: uuid.v4(),
      name: 'Guest$nextIndex',
      color: color,
      dishes: <DishModel>[],
    );
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
            dishes: guest.dishes,
          )
        else
          g,
    ];

    state = BillModel(
      guests: newGuests,
      dishes: state.dishes,
      tax: state.tax,
      isSplitTaxEqually: state.isSplitTaxEqually,
    );
  }

  void removeGuest(GuestModel guest) {
    // Remove guest from assigned dishes
    final List<DishModel> newDishes = <DishModel>[];
    for (final DishModel d in state.dishes) {
      if (d.guestUuids == null) {
        continue;
      }

      final List<String> guestUuids =
          d.guestUuids!.where((String uuid) => uuid != guest.uuid).toList();
      final DishModel newDish = DishModel(
          uuid: d.uuid, name: d.name, price: d.price, guestUuids: guestUuids);
      newDishes.add(newDish);
    }

    final List<GuestModel> newGuests =
        state.guests.where((GuestModel g) => g.uuid != guest.uuid).toList();

    // Update new guests dishes
    final List<GuestModel> newGuestsWithUpdatedDishes = <GuestModel>[];
    for (final GuestModel g in newGuests) {
      final List<DishModel> newGuestDishes = <DishModel>[];
      for (final DishModel d in g.dishes) {
        if (d.guestUuids == null) {
          continue;
        }

        final List<String> guestUuids =
            d.guestUuids!.where((String uuid) => uuid != guest.uuid).toList();
        final DishModel newGuestDish = DishModel(
            uuid: d.uuid, name: d.name, price: d.price, guestUuids: guestUuids);
        newGuestDishes.add(newGuestDish);
      }

      final GuestModel newGuestWithUpdatedDishes = GuestModel(
        uuid: g.uuid,
        name: g.name,
        color: g.color,
        dishes: newGuestDishes,
      );
      newGuestsWithUpdatedDishes.add(newGuestWithUpdatedDishes);
    }

    state = BillModel(
      guests: newGuestsWithUpdatedDishes,
      dishes: newDishes,
      tax: state.tax,
      isSplitTaxEqually: state.isSplitTaxEqually,
    );
  }

  void addDish() {
    const Uuid uuid = Uuid();
    final int nextIndex = _nextDishIndex;
    _nextDishIndex++;
    final DishModel dishToAdd =
        DishModel(uuid: uuid.v4(), name: 'Dish$nextIndex', price: 0.0);
    state = state..dishes.add(dishToAdd);
  }

  void editDish(DishModel dish) {
    final List<DishModel> newDishes = <DishModel>[
      for (final DishModel d in state.dishes)
        if (d.uuid == dish.uuid)
          DishModel(
            uuid: dish.uuid,
            name: dish.name,
            price: dish.price,
            guestUuids: dish.guestUuids,
          )
        else
          d,
    ];

    final List<GuestModel> newGuests = <GuestModel>[];
    for (final GuestModel guest in state.guests) {
      if (guest.dishes.contains(dish)) {
        final List<DishModel> guestDishes = <DishModel>[
          for (final DishModel d in guest.dishes)
            if (d.uuid == dish.uuid)
              DishModel(
                uuid: dish.uuid,
                name: dish.name,
                price: dish.price,
                guestUuids: dish.guestUuids,
              )
            else
              d,
        ];

        final GuestModel newGuest = GuestModel(
          uuid: guest.uuid,
          name: guest.name,
          color: guest.color,
          dishes: guestDishes,
        );
        newGuests.add(newGuest);
      } else {
        final GuestModel newGuest = GuestModel(
          uuid: guest.uuid,
          name: guest.name,
          color: guest.color,
          dishes: guest.dishes,
        );
        newGuests.add(newGuest);
      }
    }

    state = BillModel(
      guests: newGuests,
      dishes: newDishes,
      tax: state.tax,
      isSplitTaxEqually: state.isSplitTaxEqually,
    );
  }

  void removeDish(DishModel dish) {
    final List<DishModel> newDishes =
        state.dishes.where((DishModel d) => d.uuid != dish.uuid).toList();

    // Remove dish in guests
    final List<GuestModel> newGuests = <GuestModel>[];
    for (final GuestModel guest in state.guests) {
      final List<DishModel> newGuestDishes =
          guest.dishes.where((DishModel d) => d.uuid != dish.uuid).toList();
      final GuestModel newGuest = GuestModel(
        uuid: guest.uuid,
        name: guest.name,
        color: guest.color,
        dishes: newGuestDishes,
      );
      newGuests.add(newGuest);
    }

    state = BillModel(
      guests: newGuests,
      dishes: newDishes,
      tax: state.tax,
      isSplitTaxEqually: state.isSplitTaxEqually,
    );
  }

  void assignGuestsToDish(DishModel dish, List<GuestModel?> assignedGuests) {
    final DishModel newDish = DishModel(
      uuid: dish.uuid,
      name: dish.name,
      price: dish.price,
      guestUuids: assignedGuests.map((GuestModel? g) => g!.uuid).toList(),
    );
    final List<DishModel> newDishes = <DishModel>[
      for (final DishModel d in state.dishes)
        if (d.uuid == newDish.uuid) newDish else d,
    ];

    final List<GuestModel> newGuests = <GuestModel>[];
    for (final GuestModel currentGuest in state.guests) {
      // Dish already assigned to guest
      final List<DishModel> guestDishes = <DishModel>[
        for (final DishModel d in currentGuest.dishes)
          if (d.uuid == newDish.uuid) newDish else d,
      ];
      if (currentGuest.dishes.contains(dish)) {
        if (!assignedGuests.contains(currentGuest)) {
          // Unassign guest
          guestDishes.remove(dish);
        }
      } else {
        if (assignedGuests.contains(currentGuest)) {
          // Assign guest
          guestDishes.add(newDish);
        }
      }

      final GuestModel newGuest = GuestModel(
        uuid: currentGuest.uuid,
        name: currentGuest.name,
        color: currentGuest.color,
        dishes: guestDishes,
      );
      newGuests.add(newGuest);
    }

    state = BillModel(
      guests: newGuests,
      dishes: newDishes,
      tax: state.tax,
      isSplitTaxEqually: state.isSplitTaxEqually,
    );
  }

  void editTax(double tax) {
    state = BillModel(
        guests: state.guests,
        dishes: state.dishes,
        tax: tax,
        isSplitTaxEqually: state.isSplitTaxEqually);
  }

  void editSplitTaxEqually({required bool isSplitTaxEqually}) {
    state = BillModel(
        guests: state.guests,
        dishes: state.dishes,
        tax: state.tax,
        isSplitTaxEqually: isSplitTaxEqually);
  }

  @override
  void dispose() {
    logger.d('DISPOSE BillStateNotifier');
    super.dispose();
  }
}

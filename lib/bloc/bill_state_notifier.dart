import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:random_color/random_color.dart';
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
            ));

  void addGuest() {
    final Uuid uuid = Uuid();
    final RandomColor randomColor = RandomColor();
    final Color color = randomColor.randomColor(
      colorSaturation: ColorSaturation.mediumSaturation,
      colorBrightness: ColorBrightness.primary,
      colorHue: ColorHue.multiple(
        colorHues: <ColorHue>[
          ColorHue.red,
          ColorHue.blue,
          ColorHue.green,
          ColorHue.yellow,
        ],
      ),
    );
    // TODO
    final int nextIndex = state.guests.length + 1;
    final GuestModel guestToAdd =
        GuestModel(uuid: uuid.v4(), name: 'Guest$nextIndex', color: color);
    print('guest to add : $guestToAdd');
    state = state..guests.add(guestToAdd);
  }

  void editGuest(GuestModel guest) {
    final List<GuestModel> guests = <GuestModel>[
      for (final GuestModel g in state.guests)
        if (g.uuid == guest.uuid)
          GuestModel(
            uuid: guest.uuid,
            name: guest.name,
            color: guest.color,
          )
        else
          g,
    ];
    state = BillModel(guests: guests, dishes: state.dishes);
    print('new state: $state');
  }

  void removeGuest(GuestModel guest) {
    final List<GuestModel> guests =
        state.guests.where((GuestModel g) => g.uuid != guest.uuid).toList();
    state = BillModel(guests: guests, dishes: state.dishes);
    print('new state: $state');
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
    final List<DishModel> dishes = <DishModel>[
      for (final DishModel d in state.dishes)
        if (d.uuid == dish.uuid)
          DishModel(
            uuid: dish.uuid,
            name: dish.name,
            price: dish.price,
            guest: dish.guest,
          )
        else
          d,
    ];
    state = BillModel(guests: state.guests, dishes: dishes);
    print('new state: $state');
  }

  void removeDish(DishModel dish) {
    final List<DishModel> dishes =
        state.dishes.where((DishModel d) => d.uuid != dish.uuid).toList();
    state = BillModel(guests: state.guests, dishes: dishes);
    print('new state: $state');
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }
}

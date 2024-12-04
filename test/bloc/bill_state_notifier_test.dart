import 'package:flutter_test/flutter_test.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';

void main() {
  late BillStateNotifier billStateNotifier;

  setUp(() async {
    billStateNotifier = BillStateNotifier();
  });

  group('BillStateNotifier', () {
    test('should add,edit,remove guest successfully', () async {
      // Add
      billStateNotifier.addGuest();

      // final BillModel bill = billStateNotifier.state;
      expect(billStateNotifier.guests, isNotEmpty);
      final GuestModel guest1 = billStateNotifier.guests[0];
      expect(guest1, isNotNull);
      expect(guest1.name, 'Guest1');
      expect(guest1.uuid, isNotNull);
      expect(guest1.color, isNotNull);
      expect(guest1.dishes, <DishModel>[]);

      // Edit
      final GuestModel guestToEdit = GuestModel(
        uuid: guest1.uuid,
        name: 'Guest1!!!',
        color: guest1.color,
        dishes: <DishModel>[],
      );
      billStateNotifier.editGuest(guestToEdit);

      expect(billStateNotifier.guests, isNotEmpty);
      final GuestModel guest1Edited = billStateNotifier.guests[0];
      expect(guest1Edited, isNotNull);
      expect(guest1Edited.name, 'Guest1!!!');
      expect(guest1Edited.uuid, isNotNull);
      expect(guest1Edited.color, isNotNull);
      expect(guest1Edited.dishes, <DishModel>[]);

      // Remove
      billStateNotifier.removeGuest(guestToEdit);

      expect(billStateNotifier.guests, isEmpty);
    });

    test('should add,edit,remove dish successfully', () async {
      // Add
      billStateNotifier.addDish();

      // final BillModel bill = billStateNotifier.state;
      expect(billStateNotifier.dishes, isNotEmpty);
      final DishModel dish1 = billStateNotifier.dishes[0];
      expect(dish1, isNotNull);
      expect(dish1.name, 'Dish1');
      expect(dish1.uuid, isNotNull);
      expect(dish1.price, 0.0);
      expect(dish1.guestUuids, isNull);

      // Edit
      final DishModel dishToEdit = DishModel(
        uuid: dish1.uuid,
        name: 'Dish1!!!',
        price: 1.0,
        guestUuids: <String>[],
      );
      billStateNotifier.editDish(dishToEdit);

      expect(billStateNotifier.dishes, isNotEmpty);
      final DishModel dish1Edited = billStateNotifier.dishes[0];
      expect(dish1Edited, isNotNull);
      expect(dish1Edited.name, 'Dish1!!!');
      expect(dish1Edited.uuid, isNotNull);
      expect(dish1Edited.price, 1.0);
      expect(dish1Edited.guestUuids, <String>[]);

      // Remove
      billStateNotifier.removeDish(dishToEdit);

      expect(billStateNotifier.dishes, isEmpty);
    });

    test('should assign guest to dish successfully', () async {
      // Add dish
      billStateNotifier.addDish();
      // Add guests
      for (int i = 0; i < 2; i++) {
        billStateNotifier.addGuest();
      }

      expect(billStateNotifier.dishes, isNotEmpty);
      expect(billStateNotifier.dishes.length, 1);
      expect(billStateNotifier.guests, isNotEmpty);
      expect(billStateNotifier.guests.length, 2);

      billStateNotifier.assignGuestsToDish(
          billStateNotifier.dishes[0], billStateNotifier.guests);

      final DishModel dish = billStateNotifier.dishes[0];
      final GuestModel guest1 = billStateNotifier.guests[0];
      final GuestModel guest2 = billStateNotifier.guests[1];

      expect(dish.guestUuids, <String>[guest1.uuid, guest2.uuid]);
      expect(guest1.dishes, <DishModel>[dish]);
      expect(guest2.dishes, <DishModel>[dish]);
    });

    test('should edit tax successfully', () async {
      billStateNotifier.editTax(22.0);
      expect(billStateNotifier.tax, 22.0);
    });

    test('should edit split tax equally successfully', () async {
      billStateNotifier.editSplitTaxEqually(isSplitTaxEqually: true);
      expect(billStateNotifier.isSplitTaxEqually, true);
    });
  });
}

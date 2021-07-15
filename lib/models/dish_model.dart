class DishModel {
  DishModel({
    required this.uuid,
    required this.name,
    required this.price,
    this.guestUuids,
  });

  String uuid;
  String name;
  double price;
  List<String>? guestUuids = <String>[];

  double? getPriceWithTax({required double taxAsPercentage}) {
    if (taxAsPercentage < 0 || taxAsPercentage > 100) {
      return price;
    }
    return price * (1 + taxAsPercentage / 100);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishModel &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    final int numberOfGuests =
        (guestUuids != null && guestUuids!.isNotEmpty) ? guestUuids!.length : 0;
    return 'DishModel{name: $name, price: $price, guests: $numberOfGuests}';
  }
}

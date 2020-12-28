import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/widgets/assign_guest_to_dish_dialog.dart';

class AssignDishListTile extends HookWidget {
  AssignDishListTile({@required this.key, @required this.dish})
      : assert(key != null && dish != null);

  final Key key;
  final DishModel dish;

  final Logger logger = getLogger();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 1.0),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        onTap: () => _openAssignGuestToDishDialog(context, dish),
        child: ListTile(
          title: Text(
            '${dish.name} ${dish.price != null ? '\$' : ''}${dish.price ?? ''}',
            // style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          subtitle: Wrap(
            children: <Widget>[
              for (Widget w in _buildGuestsTextList()) w,
            ],
          ),
          trailing: _buildSelectGuestButton(context, dish),
        ),
      ),
    );
  }

  List<Widget> _buildGuestsTextList() {
    final List<Widget> guestsTextList = <Widget>[];
    final List<GuestModel> guests = dish.guests;

    if (guests != null && guests.isNotEmpty) {
      guestsTextList.add(const SizedBox(
        height: 5.0,
      ));

      guestsTextList.add(
        RichText(
          text: TextSpan(
            children: <InlineSpan>[
              for (int i = 0; i < guests.length; i++)
                TextSpan(
                  text: i > 0 ? ' ${guests[i].name}' : guests[i].name,
                  style: TextStyle(
                      color: guests[i].color, fontWeight: FontWeight.bold),
                ),
              TextSpan(
                text: dish.guests.length > 1
                    ? ' shared this dish'
                    : ' got this dish',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return guestsTextList;
  }

  Widget _buildSelectGuestButton(BuildContext context, DishModel dish) {
    final Color color = dish.guests == null || dish.guests.isEmpty
        ? Colors.black
        : Colors.black26;
    return IconButton(
      icon: Icon(
        FontAwesomeIcons.userEdit,
        color: color,
      ),
      onPressed: () => _openAssignGuestToDishDialog(context, dish),
    );
  }

  void _openAssignGuestToDishDialog(BuildContext context, DishModel dish) {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return AssignGuestToDishDialog(dish: dish);
      },
    );
  }
}

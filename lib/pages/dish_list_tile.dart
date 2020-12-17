import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/pages/assign_guest_to_dish_dialog.dart';
import 'package:restobillsplitter/state/providers.dart';

class DishListTile extends StatefulHookWidget {
  DishListTile({@required this.key, @required this.dish})
      : assert(key != null && dish != null);

  final Key key;
  final DishModel dish;

  @override
  _DishListTileState createState() => _DishListTileState();
}

class _DishListTileState extends State<DishListTile> {
  final Logger logger = getLogger();

  BillStateNotifier billStateNotifier;

  final TextEditingController _nameTextController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isNameClearVisible = false;

  final TextEditingController _priceTextController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  bool _isPriceClearVisible = false;

  @override
  void initState() {
    super.initState();

    billStateNotifier = context.read(billStateNotifierProvider);

    _nameTextController.addListener(_toggleNameClearVisible);
    _nameTextController.text =
        (widget.dish?.name == null) ? '' : widget.dish.name;
    _nameFocusNode.addListener(_editDishName);

    _priceTextController.addListener(_togglePriceClearVisible);
    _priceTextController.text =
        (widget.dish?.price == null) ? '' : widget.dish.price.toString();
    _priceFocusNode.addListener(_editDishPrice);
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  void _toggleNameClearVisible() {
    setState(() {
      _isNameClearVisible = _nameTextController.text.isNotEmpty;
    });
  }

  void _togglePriceClearVisible() {
    setState(() {
      _isPriceClearVisible = _priceTextController.text.isNotEmpty;
    });
  }

  void _editDishName() {
    if (!_nameFocusNode.hasFocus) {
      print('name lost focus: ${_nameTextController.text}');
      final DishModel dish = DishModel(
        uuid: widget.dish.uuid,
        name: _nameTextController.text,
        price: widget.dish.price,
        guests: widget.dish.guests,
      );
      _editDish(dish);
    }
  }

  void _editDishPrice() {
    if (!_priceFocusNode.hasFocus) {
      print('price lost focus: ${_priceTextController.text}');
      final double price = double.tryParse(
              _priceTextController.text.replaceFirst(RegExp(r','), '.')) ??
          0.00;
      final DishModel dish = DishModel(
        uuid: widget.dish.uuid,
        name: widget.dish.name,
        price: price,
        guests: widget.dish.guests,
      );
      _editDish(dish);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: _deleteDish,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 18,
                child: _buildNameTextField(widget.dish),
              ),
              const Spacer(
                flex: 1,
              ),
              Flexible(
                flex: 9,
                child: _buildPriceTextField(widget.dish),
              ),
              const Spacer(
                flex: 1,
              ),
              Flexible(
                flex: 4,
                child: _buildSelectGuestButton(context, widget.dish),
              ),
            ],
          ),
          for (Widget w in _buildGuestsTextList()) w,
        ],
      ),
    );
  }

  Widget _buildNameTextField(DishModel dish) {
    return TextField(
      maxLength: 50,
      focusNode: _nameFocusNode,
      controller: _nameTextController,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        counterText: '',
        isDense: true,
        // prefixIcon: const Padding(
        //   padding: EdgeInsets.only(left: 5.0),
        //   child: Icon(
        //     Icons.perm_identity,
        //   ),
        // ),
        suffixIcon: !_isNameClearVisible
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  _nameTextController.clear();
                },
                icon: const Icon(
                  Icons.clear,
                )),
        labelText: 'Name',
        contentPadding: const EdgeInsets.all(8.0),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (String value) {
        // TODO
        print('name changed');
      },
      onEditingComplete: () {
        // TODO
        print('name complete');
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
    );
  }

  Widget _buildPriceTextField(DishModel dish) {
    return TextField(
      maxLength: 10,
      controller: _priceTextController,
      focusNode: _priceFocusNode,
      inputFormatters: <TextInputFormatter>[
        // TODO https://medium.com/flutter-community/input-formatting-flutter-5237bf09e61f
        //https://stackoverflow.com/questions/54454983/allow-only-two-decimal-number-in-flutter-input/54456978
        FilteringTextInputFormatter.allow(
          RegExp(r'^(\d+)?\.?\d{0,2}'),
        ),
      ],
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      decoration: InputDecoration(
        counterText: '',
        isDense: true,
        // prefixIcon: const Padding(
        //   padding: EdgeInsets.only(left: 5.0),
        //   child: Icon(
        //     Icons.attach_money,
        //   ),
        // ),
        suffixIcon: !_isPriceClearVisible
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  _priceTextController.clear();
                },
                icon: const Icon(
                  Icons.clear,
                )),
        labelText: 'Price',
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (String value) {
        // TODO
        print('price changed');
      },
      onEditingComplete: () {
        // TODO
        print('price complete');
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
    );
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
      onPressed: () {
        // TODO
        showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return AssignGuestToDishDialog(dish: dish);
          },
        );
      },
    );
  }

  List<Widget> _buildGuestsTextList() {
    final List<Widget> guestsTextList = <Widget>[];
    final List<GuestModel> guests = widget.dish.guests;

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
                text: widget.dish.guests.length > 1
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

  void _editDish(DishModel dish) {
    billStateNotifier.editDish(
      dish,
    );
  }

  void _deleteDish() {
    billStateNotifier.removeDish(
      widget.dish,
    );
  }
}

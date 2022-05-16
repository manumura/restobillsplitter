import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/dish_model.dart';
import 'package:restobillsplitter/shared/utils.dart';
import 'package:restobillsplitter/state/providers.dart';

class DishListTile extends ConsumerStatefulWidget {
  DishListTile({required this.key, required this.dish});

  final Key key;
  final DishModel dish;

  @override
  _DishListTileState createState() => _DishListTileState();
}

class _DishListTileState extends ConsumerState<DishListTile> {
  final Logger logger = getLogger();

  late BillStateNotifier billStateNotifier;

  final TextEditingController _nameTextController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isNameClearVisible = false;

  final TextEditingController _priceTextController = TextEditingController();
  final FocusNode _priceFocusNode = FocusNode();
  bool _isPriceClearVisible = false;

  @override
  void initState() {
    super.initState();

    billStateNotifier = ref.read(billStateNotifierProvider.notifier);

    _nameTextController.addListener(_toggleNameClearVisible);
    _nameTextController.text = widget.dish.name;
    _nameFocusNode.addListener(_editDishName);

    _priceTextController.addListener(_togglePriceClearVisible);
    _priceTextController.text = widget.dish.price.toString();
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
      _saveDishName(_nameTextController.text);
    }
  }

  void _editDishPrice() {
    if (!_priceFocusNode.hasFocus) {
      final double price = parseDouble(_priceTextController.text);
      _saveDishPrice(price);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.3,
        children: <Widget>[
          SlidableAction(
            onPressed: (BuildContext context) => _deleteDish(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 20,
            child: _buildNameTextField(widget.dish),
          ),
          const Spacer(),
          Expanded(
            flex: 13,
            child: _buildPriceTextField(widget.dish),
          ),
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
                ),
              ),
        labelText: 'Name',
        labelStyle: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.all(8.0),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onEditingComplete: () {
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
        // https://medium.com/flutter-community/input-formatting-flutter-5237bf09e61f
        // https://stackoverflow.com/questions/54454983/allow-only-two-decimal-number-in-flutter-input/54456978
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
                ),
              ),
        labelText: 'Price',
        labelStyle: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.all(10.0),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onEditingComplete: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      onTap: () {
        final double price = parseDouble(_priceTextController.text);
        if (price <= 0) {
          _priceTextController.clear();
        }
      },
    );
  }

  void _saveDishName(String name) {
    final DishModel dish = DishModel(
      uuid: widget.dish.uuid,
      name: name,
      price: widget.dish.price,
      guestUuids: widget.dish.guestUuids,
    );
    billStateNotifier.editDish(
      dish,
    );
  }

  void _saveDishPrice(double price) {
    final DishModel dish = DishModel(
      uuid: widget.dish.uuid,
      name: widget.dish.name,
      price: price,
      guestUuids: widget.dish.guestUuids,
    );
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

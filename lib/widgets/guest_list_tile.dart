import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/state/providers.dart';

class GuestListTile extends ConsumerStatefulWidget {
  GuestListTile({required this.key, required this.guest});

  final Key key;
  final GuestModel guest;

  @override
  _GuestListTileState createState() => _GuestListTileState();
}

class _GuestListTileState extends ConsumerState<GuestListTile> {
  final Logger logger = getLogger();

  late BillStateNotifier billStateNotifier;

  final TextEditingController _nameTextController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isNameClearVisible = false;

  @override
  void initState() {
    super.initState();

    billStateNotifier = ref.read(billStateNotifierProvider.notifier);

    _nameTextController.addListener(_toggleNameClearVisible);
    _nameTextController.text = widget.guest.name;

    _nameFocusNode.addListener(_editGuestName);
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

  void _editGuestName() {
    if (!_nameFocusNode.hasFocus) {
      _saveGuestName(_nameTextController.text);
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
            onPressed: (BuildContext context) => _deleteGuest(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Icon(
              FontAwesomeIcons.userLarge,
              color: widget.guest.color,
            ),
            // child: CircleAvatar(
            //   backgroundColor: widget.guest.color ?? Colors.black,
            // ),
          ),
          const Spacer(),
          Expanded(
            flex: 33,
            child: _buildNameTextField(widget.guest),
          ),
        ],
      ),
    );
  }

  Widget _buildNameTextField(GuestModel guest) {
    return TextField(
      maxLength: 50,
      focusNode: _nameFocusNode,
      controller: _nameTextController,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        counterText: '',
        isDense: true,
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(left: 5.0),
        //   child: Icon(
        //     Icons.account_box,
        //     color: guest.color,
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
                  // color: guest.color,
                ),
              ),
        labelText: 'Name',
        labelStyle: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.all(8.0),
        border: const OutlineInputBorder(),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: guest.color),
        // ),
        filled: true,
        fillColor: Colors.white,
        // floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      onEditingComplete: () {
        WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
      },
    );
  }

  void _saveGuestName(String name) {
    billStateNotifier.editGuest(
      GuestModel(
        uuid: widget.guest.uuid,
        name: name,
        color: widget.guest.color,
        dishes: widget.guest.dishes,
      ),
    );
  }

  void _deleteGuest() {
    billStateNotifier.removeGuest(
      widget.guest,
    );
  }
}

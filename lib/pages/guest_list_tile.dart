import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/state/providers.dart';

class GuestListTile extends StatefulHookWidget {
  GuestListTile({@required this.key, @required this.guest})
      : assert(key != null && guest != null);

  final Key key;
  final GuestModel guest;

  @override
  _GuestListTileState createState() => _GuestListTileState();
}

class _GuestListTileState extends State<GuestListTile> {
  final Logger logger = getLogger();

  final TextEditingController _nameTextController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool _isNameClearVisible = false;

  BillStateNotifier billStateNotifier;

  @override
  void initState() {
    super.initState();
    _nameTextController.addListener(_toggleNameClearVisible);
    _nameTextController.text = (widget.guest == null) ? '' : widget.guest.name;

    _nameFocusNode.addListener(_editGuest);

    billStateNotifier = context.read(billStateNotifierProvider);
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

  void _editGuest() {
    if (!_nameFocusNode.hasFocus) {
      _editGuestName(_nameTextController.text);
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
          onTap: _deleteGuest,
        ),
      ],
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: CircleAvatar(
              backgroundColor: widget.guest.color ?? Colors.black,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Flexible(
            flex: 18,
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
                )),
        labelText: 'Name',
        contentPadding: const EdgeInsets.all(8.0),
        border: const OutlineInputBorder(),
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: guest.color),
        // ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (String value) {
        // TODO
        print('changed');
      },
      onEditingComplete: () {
        // TODO
        print('complete');
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
    );
  }

  void _editGuestName(String name) {
    print('lost focus: $name');
    billStateNotifier.editGuest(
      GuestModel(
          uuid: widget.guest.uuid, name: name, color: widget.guest.color),
    );
  }

  void _deleteGuest() {
    billStateNotifier.removeGuest(
      widget.guest,
    );
  }
}

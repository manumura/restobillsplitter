import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/models/guest_model.dart';
import 'package:restobillsplitter/shared/app_bar.dart';
import 'package:restobillsplitter/shared/side_drawer.dart';
import 'package:restobillsplitter/state/providers.dart';
import 'package:restobillsplitter/widgets/guest_list_tile.dart';

class GuestListScreen extends ConsumerStatefulWidget {
  static const String routeName = '/guest_list';

  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends ConsumerState<GuestListScreen> {
  ScrollController? _scrollController;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      final bool isFabVisible =
          _scrollController!.position.userScrollDirection ==
              ScrollDirection.forward;
      if (_isFabVisible != isFabVisible) {
        setState(() => _isFabVisible = isFabVisible);
      }
    });
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BillModel bill = ref.watch(billStateNotifierProvider);
    final List<GuestModel> guests = bill.guests;

    return Scaffold(
      drawer: SideDrawer(),
      appBar: const CustomAppBar(
        Text('Guests'),
      ),
      body: guests.isEmpty
          ? const Center(
              child: Text('Please add a guest first'),
            )
          : ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                final GuestModel guest = guests[index];
                return GuestListTile(
                  key: ValueKey<String>(guest.uuid),
                  guest: guest,
                );
              },
              itemCount: guests.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 2.0,
              ),
            ),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isFabVisible ? 1 : 0,
        child: FloatingActionButton(
          onPressed: () => _addGuest(context),
          child: const Icon(Icons.add),
          tooltip: 'Add a guest',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _addGuest(BuildContext context) {
    final BillStateNotifier billStateNotifier =
        ref.read(billStateNotifierProvider.notifier);
    billStateNotifier.addGuest();
  }
}

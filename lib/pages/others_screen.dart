import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/shared/app_bar.dart';
import 'package:restobillsplitter/shared/side_drawer.dart';
import 'package:restobillsplitter/shared/utils.dart';
import 'package:restobillsplitter/state/providers.dart';

class OthersScreen extends ConsumerStatefulWidget {
  static const String routeName = '/others';

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends ConsumerState<OthersScreen> {
  final Logger logger = getLogger();

  late BillStateNotifier billStateNotifier;

  final TextEditingController _taxTextController = TextEditingController();
  final FocusNode _taxFocusNode = FocusNode();
  bool _isTaxClearVisible = false;
  bool _isTaxValid = true;

  @override
  void initState() {
    super.initState();

    billStateNotifier = ref.read(billStateNotifierProvider.notifier);
    final BillModel bill = ref.read(billStateNotifierProvider);

    _taxTextController.addListener(_togglePriceClearVisible);
    _taxTextController.text = bill.tax.toString();
    _taxFocusNode.addListener(_editTax);
  }

  @override
  void dispose() {
    _taxTextController.dispose();
    super.dispose();
  }

  void _togglePriceClearVisible() {
    setState(() {
      _isTaxClearVisible = _taxTextController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BillModel bill = ref.watch(billStateNotifierProvider);
    final bool isSplitTaxEqually = bill.isSplitTaxEqually;

    return Scaffold(
      drawer: SideDrawer(),
      appBar: const CustomAppBar(
        Text('Others'),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildTaxTextField(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildSplitEquallySwitch(isSplitTaxEqually),
          ),
          // TextButton(
          //   onPressed: () => throw Exception(),
          //   child: const Text("Throw Test Exception"),
          // ),
        ],
      ),
    );
  }

  Widget _buildTaxTextField() {
    return TextField(
      maxLength: 5,
      controller: _taxTextController,
      focusNode: _taxFocusNode,
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
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            FontAwesomeIcons.percent,
          ),
        ),
        suffixIcon: !_isTaxClearVisible
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  _taxTextController.clear();
                },
                icon: const Icon(
                  Icons.clear,
                ),
              ),
        labelText: 'Tax',
        errorText: _isTaxValid ? null : 'Should be between 0 and 100',
        contentPadding: const EdgeInsets.all(10.0),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onEditingComplete: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      onTap: () {
        final double tax = parseDouble(_taxTextController.text);
        if (tax <= 0) {
          _taxTextController.clear();
        }
      },
    );
  }

  Widget _buildSplitEquallySwitch(bool isSplitTaxEqually) {
    return SwitchListTile.adaptive(
      title: const Text('Split tax equally'),
      value: isSplitTaxEqually,
      onChanged: (bool value) => _editSplitTaxEqually(value),
    );
  }

  void _editTax() {
    if (!_taxFocusNode.hasFocus) {
      final double tax = parseDouble(_taxTextController.text);
      final bool isValid = _validateTax(tax);
      if (isValid) {
        billStateNotifier.editTax(tax);
      }
    }
  }

  bool _validateTax(double tax) {
    bool isValid = true;
    if (tax < 0 || tax > 100) {
      isValid = false;
    }
    setState(() => _isTaxValid = isValid);
    return isValid;
  }

  void _editSplitTaxEqually(bool isSplitEqually) {
    billStateNotifier.editSplitTaxEqually(isSplitTaxEqually: isSplitEqually);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:logger/logger.dart';
import 'package:restobillsplitter/bloc/bill_state_notifier.dart';
import 'package:restobillsplitter/helpers/logger.dart';
import 'package:restobillsplitter/models/bill_model.dart';
import 'package:restobillsplitter/state/providers.dart';

class OthersScreen extends StatefulHookWidget {
  static const String routeName = '/others';

  @override
  State<StatefulWidget> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OthersScreen> {
  final Logger logger = getLogger();

  BillStateNotifier billStateNotifier;

  final TextEditingController _taxTextController = TextEditingController();
  final FocusNode _taxFocusNode = FocusNode();
  bool _isTaxClearVisible = false;
  bool _isTaxValid = true;

  @override
  void initState() {
    super.initState();

    billStateNotifier = context.read(billStateNotifierProvider);
    final BillModel bill = context.read(billStateNotifierProvider.state);

    _taxTextController.addListener(_togglePriceClearVisible);
    _taxTextController.text = (bill.tax == null) ? '' : bill.tax.toString();
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
    final BillModel bill = useProvider(billStateNotifierProvider.state);
    final bool isSplitTaxEqually = bill.isSplitTaxEqually;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Others'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
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
        ],
      ),
    );
  }

  Widget _buildTaxTextField() {
    print('_buildTaxTextField');
    return TextField(
      maxLength: 5,
      controller: _taxTextController,
      focusNode: _taxFocusNode,
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
                )),
        labelText: 'Tax',
        errorText: _isTaxValid ? null : 'Should be between 0 and 100',
        contentPadding: const EdgeInsets.all(10.0),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (String value) {
        // TODO
        print('tax changed');
      },
      onEditingComplete: () {
        // TODO
        print('tax complete');
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
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
      final double tax = double.tryParse(
              _taxTextController.text.replaceFirst(RegExp(r','), '.')) ??
          0.0;

      final bool isValid = _validateTax(tax);
      if (isValid) {
        billStateNotifier.editTax(tax);
      }
    }
  }

  bool _validateTax(double tax) {
    bool isValid = true;
    if (tax == null || tax < 0 || tax > 100) {
      isValid = false;
    }
    setState(() => _isTaxValid = isValid);
    return isValid;
  }

  void _editSplitTaxEqually(bool isSplitEqually) {
    billStateNotifier.editSplitTaxEqually(isSplitTaxEqually: isSplitEqually);
  }
}

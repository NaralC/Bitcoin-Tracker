import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String valueInCash = '?';
  Map<String, String> cryptoToCash = {};
  bool isWaiting = false;

  // CupertinoPicker iOSPicker() { //todo: iOS picker/menu is broken (it doesn't update prices properly)
  //   List<Text> pickerItems = [];
  //
  //   for (String currency in currenciesList) {
  //     pickerItems.add(Text(currency));
  //   }
  //
  //   return CupertinoPicker(
  //     backgroundColor: Colors.lightBlueAccent,
  //     itemExtent: 32,
  //     onSelectedItemChanged: (selectedIndex) {
  //       selectedCurrency = selectedIndex.toString();
  //       getData();
  //     },
  //     children: pickerItems,
  //   );
  // }

  DropdownButton<String> dropdownMenu() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
          child: Text(
            currency,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          value: currency);
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            getData();
          },
        );
      },
    );
  }

  void getData() async {
    isWaiting = true;

    try {
      var coinData = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;

      setState(() {
        cryptoToCash = coinData;
      });
    } catch (exception) {
      print(exception);
    }
  }

  List<Widget> buildButtons() {
    List<Widget> buttonList = [];
    for (String coinType in cryptoList) {
      buttonList.add(
        reusableButtons(
            valueInCash: valueInCash,
            selectedCurrency: selectedCurrency,
            selectedCrypto: coinType),
      );
    }
    return buttonList;
  } //todo: implement this button-maker function

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('💱 Coin Tracker 💱')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          reusableButtons(
              valueInCash: isWaiting ? '?' : cryptoToCash['BTC'],
              selectedCurrency: selectedCurrency,
              selectedCrypto: 'BTC'),
          reusableButtons(
              valueInCash: isWaiting ? '?' : cryptoToCash['ETH'],
              selectedCurrency: selectedCurrency,
              selectedCrypto: 'ETH'),
          reusableButtons(
              valueInCash: isWaiting ? '?' : cryptoToCash['LTC'],
              selectedCurrency: selectedCurrency,
              selectedCrypto: 'LTC'),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: Platform.isIOS ? iOSPicker() : androidDropdown(), //todo: use this if the iOS picker ever gets fixed
            child: dropdownMenu(),
          ),
        ],
      ),
    );
  }
}

class reusableButtons extends StatelessWidget {
  const reusableButtons({
    Key key,
    @required this.valueInCash,
    @required this.selectedCurrency,
    this.selectedCrypto,
  }) : super(key: key);

  final String valueInCash;
  final String selectedCurrency;
  final String selectedCrypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $selectedCrypto = $valueInCash $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

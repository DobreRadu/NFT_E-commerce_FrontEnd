import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:nftcommerce/globals.dart' as globals;
import 'package:http/http.dart' as http;

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({super.key});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final Widget space = const SizedBox(
    width: 30,
    height: 30,
  );

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController ccvController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController expDateController = TextEditingController();
  TextEditingController ammountController = TextEditingController();

  List<String> currency = ['eur', 'bitcoin,ron'];
  int indexCurrency = 0;

  final _formKey = GlobalKey<FormState>();

  bool processingData = false;

  bool poor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: SizedBox(
              width: 1000,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Insert Card Details",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    if (!poor)
                      Image.asset(
                        "assets/money.gif",
                        height: 300,
                        width: 300,
                      ),
                    Divider(),
                    TextFormField(
                      controller: cardNumberController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Number',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'Card Number cannot be empty';

                        return null;
                      },
                      onFieldSubmitted: (value) async {
                        addMoney();
                      },
                    ),
                    space,
                    TextFormField(
                      controller: nameController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'NAME',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'name cannot be empty';

                        return null;
                      },
                      onFieldSubmitted: (value) async {
                        addMoney();
                      },
                    ),
                    space,
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: ccvController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'CCV',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty)
                                return 'CCV cannot be empty';

                              return null;
                            },
                            onFieldSubmitted: (value) async {
                              addMoney();
                            },
                          ),
                        ),
                        Spacer(flex: 1),
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: expDateController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Expiration Date',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty)
                                return 'Expiration Date cannot be empty';

                              return null;
                            },
                            onFieldSubmitted: (value) async {
                              addMoney();
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]|/')),
                            ],
                          ),
                        )
                      ],
                    ),
                    space,
                    TextFormField(
                      controller: ammountController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ammount',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'Ammount cannot be empty';

                        return null;
                      },
                      onFieldSubmitted: (value) async {
                        addMoney();
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    space,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            onPressed: processingData
                                ? null
                                : () {
                                    addMoney();
                                  },
                            child: const Text("Add Money")),
                        space,
                        if (poor)
                          // const Text(
                          //   'You poor, go get some money...lol...',
                          //   style: TextStyle(
                          //       color: Colors.red,
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 30),
                          // )
                          Image.asset(
                            "assets/poor.gif",
                            height: 300,
                            width: 300,
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addMoney() async {
    if (_formKey.currentState!.validate()) {
      processingData = true;
      setState(() {});

      //ADD FUNDS===================
      if (Random().nextBool()) {
        try {
          http.Response buyData = await http.post(
            Uri.https(globals.domain, "/account/addFunds"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "id_user": globals.idCont,
              "currency": currency[indexCurrency],
              "price": int.parse(ammountController.text)
            }),
          );

          print(buyData.body);
        } catch (error) {
          debugPrint(error.toString());
        }
        //ADD FUNDS===================
      } else {
        poor = true;
        setState(() {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data is wrong')),
      );
    }
    processingData = false;
    setState(() {});
  }
}

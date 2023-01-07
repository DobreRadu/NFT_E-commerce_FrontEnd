import 'package:flutter/material.dart';

import 'package:nftcommerce/globals.dart' as globals;

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

  final _formKey = GlobalKey<FormState>();

  bool processingData = false;

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
                      "Add Money Here",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                            obscureText: false,
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
                          ),
                        )
                      ],
                    ),
                    space,
                    OutlinedButton(
                        onPressed: processingData
                            ? null
                            : () {
                                addMoney();
                              },
                        child: const Text("Add Money"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addMoney() {
    if (_formKey.currentState!.validate()) {
      processingData = true;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data is wrong')),
      );
    }
    processingData = false;
    setState(() {});
  }
}

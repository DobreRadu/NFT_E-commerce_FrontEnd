import 'package:flutter/material.dart';

import 'package:nftcommerce/globals.dart' as globals;
import 'package:nftcommerce/pages/addMoney.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final Widget space = const SizedBox(
    width: 30,
    height: 30,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                ),
                space,
                Text(
                  "FIRST NAME: ${globals.firstName}",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 20),
                ),
                space,
                Text(
                  "LAST NAME: ${globals.lastName}",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 20),
                ),
                space,
                Text(
                  "PHONE: ${globals.telefon}",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 20),
                ),
                space,
                Text(
                  "EMAIL: ${globals.email}",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 20),
                ),
                space,
                Row(
                  children: [
                    const Text("WALLET:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30)),
                    space,
                    OutlinedButton(
                      child: const Text("ADD MONEY"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddMoneyPage()));
                      },
                    )
                  ],
                ),
                const Divider(),
                space,
                Text(
                  "EURO: ${globals.wallet['euro'] ?? 0}",
                  style: const TextStyle(fontSize: 18),
                ),
                space,
                Text(
                  "LEI: ${globals.wallet['lei'] ?? 0}",
                  style: const TextStyle(fontSize: 18),
                ),
                space,
                Text(
                  "BITCOIN: ${globals.wallet['bitcoin'] ?? 0}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

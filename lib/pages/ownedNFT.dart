import 'package:flutter/material.dart';

class OwnedPage extends StatefulWidget {
  const OwnedPage({super.key});

  @override
  State<OwnedPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<OwnedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("OWNED")],
          ),
        ],
      ),
    );
  }
}

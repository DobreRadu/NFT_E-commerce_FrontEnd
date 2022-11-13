import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;
    double heightContext = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(100, (index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Image.asset(
                    'assets/nftLogo.png',
                    alignment: Alignment.center,
                    width: 400,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text("OWNER:${index} NUME NUME"),
                  Text(
                    "PRICE:${index * 1000.454}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            debugPrint("SHOW MORE SHOPPAGE");
                          },
                          child: Text("SHOW MORE")),
                      Spacer(),
                      OutlinedButton(
                          onPressed: () {
                            debugPrint("ADD TO CART SHOPPAGE");
                          },
                          child: Text("ADD TO CART"))
                    ],
                  )
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }
}

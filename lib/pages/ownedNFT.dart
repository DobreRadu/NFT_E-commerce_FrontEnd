import 'package:flutter/material.dart';
import 'package:nftcommerce/globals.dart' as globals;

class OwnedPage extends StatefulWidget {
  const OwnedPage({super.key});

  @override
  State<OwnedPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<OwnedPage> {
  final Widget spacer20 = const SizedBox(
    width: 20,
    height: 20,
  );

  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;
    double heightContext = MediaQuery.of(context).size.height;
    return (globals.ownedNfts.isEmpty)
        ? const Center(child: Text("YOU OWN NOTHING\nLETS GO BY SOME"))
        : Scaffold(
            body: GridView.count(
              crossAxisCount: (widthContext > 1200)
                  ? 4
                  : (widthContext > 900)
                      ? 3
                      : (widthContext > 600)
                          ? 2
                          : 1,
              children: List.generate(globals.ownedNfts.length, (index) {
                var nft = globals.findNftById(globals.ownedNfts[index]);

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
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "PRICE:${index * 1000.454}",
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton(
                          child: const Text("SHOW MORE"),
                          onPressed: () {
                            showMore(index);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ]),
                    ),
                  ),
                );
              }),
            ),
          );
  }

  void showMore(dynamic nft) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: 500,
              height: 600,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/nftLogo.png',
                        alignment: Alignment.center,
                      ),
                      spacer20,
                      Text(
                        "OWNED:${nft['owner']}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      spacer20,
                      Text(
                        "PRICE:${nft['currency']} ${nft['price']}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      spacer20,
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

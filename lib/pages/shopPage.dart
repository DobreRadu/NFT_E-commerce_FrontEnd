import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nftcommerce/globals.dart' as globals;

import 'package:http/http.dart' as http;

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  final Widget spacer20 = const SizedBox(
    width: 20,
    height: 20,
  );

  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;
    double heightContext = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: (widthContext > 1200)
            ? 4
            : (widthContext > 900)
                ? 3
                : (widthContext > 600)
                    ? 2
                    : 1,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(globals.nfts.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  // Image.asset(
                  //   'assets/nftLogo.png',
                  //   alignment: Alignment.center,
                  //
                  // ),
                  Image.memory(
                    base64Decode(globals.nfts[index]['picture']),
                    width: 400,
                    height: 400,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("OWNER:$index NUME NUME"),
                  Text(
                    "PRICE:${index * 1000.454}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        debugPrint("SHOW MORE SHOPPAGE");
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 241, 241, 241),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
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
                                            "OWNED:${index}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          spacer20,
                                          Text(
                                            "PRICE:${index}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          spacer20,
                                          Text(
                                            "Created:${index}",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          spacer20,
                                          const Text("HISTORY:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30)),
                                          const Divider(),
                                          ...List.generate(index, ((index) {
                                            return Text('Hello $index');
                                          })),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text("SHOW MORE")),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                      onPressed: (ref.watch(globals.buyingNFT))
                          ? null
                          : (nftOwned(index.toString()))
                              ? null
                              : () {
                                  buyNFT(index.toString());
                                },
                      child: (nftOwned(index.toString()))
                          ? Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: const [
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                Text("OWNED"),
                              ],
                            )
                          : const Text("BUY"))
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  bool nftOwned(String id) {
    for (var idNFT in globals.ownedNfts) {
      if (id == idNFT) return true;
    }

    return false;
  }

  void buyNFT(String id_nft) async {
    ref.read(globals.buyingNFT.notifier).update(((state) => true));

    //BUY NFT===================
    http.Response buyData = await http.post(
      Uri.https(globals.domain, "/product/buy"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"id_user": globals.idCont, "id_nft": id_nft}),
    );

    print(buyData.body);
    //BUY NFT===================

    ref.read(globals.buyingNFT.notifier).update(((state) => false));
  }
}

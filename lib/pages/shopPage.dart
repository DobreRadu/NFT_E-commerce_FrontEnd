import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
            width: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "ARTISIUM SHOPPING",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              )
            ],
          ),
          SizedBox(
            height: 20,
            width: 20,
          ),
          Divider(),
          Expanded(
            child: GridView.count(
              childAspectRatio: 0.8,
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
              children: List.generate(ref.watch(globals.nfts).length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Container(
                          width: 200,
                          height: 200,
                          child: Image.memory(
                            base64Decode(
                                ref.read(globals.nfts)[index]['picture']),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                            "COLLECTION:${ref.read(globals.nfts)[index]['collection']}"),
                        Text(
                            "NFT NAME:${ref.read(globals.nfts)[index]['name']}"),
                        Text(
                            "DESCRIPTION:${ref.read(globals.nfts)[index]['description']}"),
                        Text(
                          "PRICE:${ref.read(globals.nfts)[index]['currency']} ${ref.read(globals.nfts)[index]['price']}",
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
                                          color:
                                              Color.fromARGB(255, 61, 61, 61),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        width: 500,
                                        height: 600,
                                        child: Center(
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Image.memory(
                                                      base64Decode(ref.read(
                                                              globals.nfts)[
                                                          index]['picture']),
                                                    ),
                                                  ),
                                                  spacer20,
                                                  Text(
                                                    "NFT NAME:${ref.read(globals.nfts)[index]['name']}",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "COLLECTION:${ref.read(globals.nfts)[index]['collection']}",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "DESCRIPTION:${ref.read(globals.nfts)[index]['description']}",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  spacer20,
                                                  Text(
                                                    "PRICE:${ref.read(globals.nfts)[index]['currency']} ${ref.read(globals.nfts)[index]['price']}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  spacer20,
                                                  const Text("HISTORY:",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30)),
                                                  const Divider(),
                                                  ...List.generate(
                                                      ref
                                                          .read(globals.nfts)[
                                                              index]
                                                              ['historyList']
                                                          .length,
                                                      ((indexHistory) {
                                                    return Text(
                                                        '+ ${ref.read(globals.nfts)[index]['historyList'][indexHistory]['owner']} -> ${ref.read(globals.nfts)[index]['historyList'][indexHistory]['currency']} ${ref.read(globals.nfts)[index]['historyList'][indexHistory]['price']}');
                                                  })),
                                                ],
                                              ),
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
                            onPressed: (ref.watch(globals.buyingNFT) ||
                                    !ref.read(globals.nfts)[index]['visible'])
                                ? null
                                : (nftOwned(ref
                                        .read(globals.nfts)[index]['id']
                                        .toString()))
                                    ? null
                                    : () {
                                        buyNFT(ref
                                            .read(globals.nfts)[index]['id']
                                            .toString());
                                      },
                            child: (nftOwned(ref
                                    .read(globals.nfts)[index]['id']
                                    .toString()))
                                ? Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Text("OWNED"),
                                    ],
                                  )
                                : (!ref.read(globals.nfts)[index]['visible'])
                                    ? Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.crop_square_sharp,
                                            color: Colors.red,
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
          ),
        ],
      ),
    );
  }

  bool nftOwned(String id) {
    for (var idNFT in ref.read(globals.ownedNfts)) {
      if (id == idNFT.toString()) return true;
    }
    return false;
  }

  void buyNFT(String id_nft) async {
    ref.read(globals.buyingNFT.notifier).update(((state) => true));

    print(id_nft + " " + globals.idCont);

    //BUY NFT===================
    http.Response buyData = await http.post(
      Uri.https(globals.domain, "/product/buy"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"id_user": globals.idCont, "id_nft": id_nft}),
    );

    print(buyData.body);
    var buyDataJson = jsonDecode(buyData.body);

    if (buyDataJson['errors']?.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 61, 61, 61),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: 500,
                height: 600,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "The following errors arosed:",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        ...List.generate(buyDataJson['errors'].length, (index) {
                          return Text("- ${buyDataJson['errors'][index]}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ));
                        })
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      globals.wallet = buyDataJson['wallet'];

      for (int i = 0; i < globals.wallet.keys.toList().length; i++) {
        globals.wallet[globals.wallet.keys.toList()[i]] =
            double.parse(globals.wallet[globals.wallet.keys.toList()[i]]);
      }
      ref
          .read(globals.ownedNfts.notifier)
          .update((state) => buyDataJson['nfts'] ?? "");

      for (var i in ref.read(globals.nfts)) {
        if (i['id'].toString() == id_nft.toString()) {
          i['visible'] = false;
        }
      }

      setState(() {});
      dialog("PRUCHASE COMPLETE!");
    }
    //BUY NFT===================

    ref.read(globals.buyingNFT.notifier).update(((state) => false));
  }

  void dialog(String textDialog) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 61, 61, 61),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: 500,
              height: 600,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        textDialog,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

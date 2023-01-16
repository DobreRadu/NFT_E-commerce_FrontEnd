import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nftcommerce/globals.dart' as globals;

class OwnedPage extends ConsumerStatefulWidget {
  const OwnedPage({super.key});

  @override
  ConsumerState<OwnedPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<OwnedPage> {
  final Widget spacer20 = const SizedBox(
    width: 20,
    height: 20,
  );

  TextEditingController pretController = TextEditingController();

  List<String> currency = ['eur', 'bitcoin', 'ron'];
  String currentCurrency = 'eur';

  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;
    double heightContext = MediaQuery.of(context).size.height;
    return (ref.read(globals.ownedNfts).isEmpty)
        ? const Center(child: Text("YOU OWN NOTHING\nLETS GO BY SOME"))
        : Scaffold(
            body: GridView.count(
              childAspectRatio: 0.6,
              crossAxisCount: (widthContext > 1400)
                  ? 3
                  : (widthContext > 1000)
                      ? 2
                      : 1,
              children:
                  List.generate(ref.watch(globals.ownedNfts).length, (index) {
                var nft = globals.findNftById(
                    ref.read(globals.ownedNfts)[index].toString(), ref);

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
                            base64Decode(nft['picture']),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("COLLECTION:${nft['collection']}"),
                        Text("NFT NAME:${nft['name']}"),
                        Text("DESCRIPTION:${nft['description']}"),
                        Text(
                          "PRICE:${nft['currency']} ${nft['price']}",
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
                                          color: Color.fromARGB(
                                              255, 241, 241, 241),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        width: 500,
                                        height: 600,
                                        child: Center(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.memory(
                                                    base64Decode(ref.read(
                                                            globals.nfts)[index]
                                                        ['picture']),
                                                  ),
                                                ),
                                                spacer20,
                                                Text(
                                                  "NFT NAME:${nft['name']}",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "COLLECTION:${nft['collection']}",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "DESCRIPTION:${nft['description']}",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                spacer20,
                                                Text(
                                                  "PRICE:${nft['currency']} ${nft['price']}",
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
                                                    nft[index]['historyList']
                                                        .length, ((index) {
                                                  return Text(
                                                      '-${nft['historyList'][index]}');
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
                        if (!nft['visible'])
                          DropdownButton(
                              value: currentCurrency,
                              items: currency.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                              onChanged: (value) {
                                currentCurrency = value!;
                                setState(() {});
                              }),
                        if (!nft['visible'])
                          TextFormField(
                            controller: pretController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Price',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty)
                                return 'Price cannot be empty';

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]|.')),
                            ],
                          ),
                        spacer20,
                        if (!nft['visible'])
                          OutlinedButton(
                            child: const Text("SELL"),
                            onPressed: () {
                              sellNft(nft);
                            },
                          ),
                      ]),
                    ),
                  ),
                );
              }),
            ),
          );
  }

  void sellNft(dynamic nft) async {
    ref.read(globals.buyingNFT.notifier).update(((state) => true));

    //BUY NFT===================
    http.Response sellData = await http.post(
      Uri.https(globals.domain, "/product/sell"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "id_user": globals.idCont,
        "id_nft": nft['id'],
        "currency": currentCurrency,
        "price": double.parse(pretController.text)
      }),
    );

    print(sellData.body);
    var sellDataJson = jsonDecode(sellData.body);

    if (sellDataJson['errors']?.isNotEmpty) {
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
                        const Text(
                          "The following errors arosed:",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        ...List.generate(sellDataJson['errors'].length,
                            (index) {
                          return Text("- ${sellDataJson['errors'][index]}",
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
      dialog("SELL FOR ${nft['name']} COMPLETE!");
      for (var i in ref.read(globals.nfts)) {
        if (i['id'].toString() == nft['id'].toString()) {
          i['visible'] = true;
          setState(() {});
        }
      }
    }
    ref.read(globals.buyingNFT.notifier).update(((state) => false));
    //BUY NFT===================
  }

  void dialog(String textDialog) {
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
                      Text(
                        textDialog,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
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

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

  List<TextEditingController> pretController = [];

  List<String> currency = ['eur', 'bitcoin', 'ron'];
  String currentCurrency = 'eur';

  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;
    double heightContext = MediaQuery.of(context).size.height;
    return (ref.read(globals.ownedNfts).isEmpty)
        ? const Center(child: Text("YOU OWN NOTHING\nLETS GO BUY SOME"))
        : Scaffold(
            body: GridView.count(
              childAspectRatio: 0.8,
              crossAxisCount: (widthContext > 1400)
                  ? 3
                  : (widthContext > 1000)
                      ? 2
                      : 1,
              children:
                  List.generate(ref.watch(globals.ownedNfts).length, (index) {
                var nft = globals.findNftById(
                    ref.read(globals.ownedNfts)[index].toString(), ref);

                pretController.add(TextEditingController());

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
                                                      base64Decode(
                                                          nft['picture']),
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
                                                      nft['historyList']
                                                              .length ??
                                                          0, ((indexHistory) {
                                                    return Text(
                                                        '+ ${nft['historyList'][indexHistory]['owner']} -> ${nft['historyList'][indexHistory]['currency']} ${nft['historyList'][indexHistory]['price']}');
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
                            controller: pretController[index],
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
                              sellNft(nft, index);
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

  void sellNft(dynamic nft, int index) async {
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
        "price": double.parse(pretController[index].text)
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
          i['currency'] = currentCurrency;
          i['price'] = double.parse(pretController[index].text);
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
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
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
                color: Color.fromARGB(255, 61, 61, 61),
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

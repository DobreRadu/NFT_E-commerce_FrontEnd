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

  String dropdownvalue = "BITCOIN";

  var items = [
    'BITCOIN',
    'RON',
    'EUR',
  ];

  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;
    double heightContext = MediaQuery.of(context).size.height;
    return (ref.read(globals.ownedNfts).isEmpty)
        ? const Center(child: Text("YOU OWN NOTHING\nLETS GO BY SOME"))
        : Scaffold(
            body: GridView.count(
              crossAxisCount: (widthContext > 1400)
                  ? 3
                  : (widthContext > 1000)
                      ? 2
                      : 1,
              children:
                  List.generate(ref.watch(globals.ownedNfts).length, (index) {
                var nft = globals.findNftById(
                    ref.read(globals.ownedNfts)[index], ref);

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
                        DropdownButton(
                          // Initial Value
                          value: dropdownvalue,

                          // Down Arrow Icon
                          icon: const Icon(Icons.money),

                          // Array list of items
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                        spacer20,
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
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        OutlinedButton(
                          child: const Text("SELL"),
                          onPressed: () {},
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

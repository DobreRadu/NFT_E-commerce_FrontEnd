import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nftcommerce/globals.dart' as globals;
import 'package:http/http.dart' as http;

class AddNftPage extends ConsumerStatefulWidget {
  const AddNftPage({super.key});

  @override
  ConsumerState<AddNftPage> createState() => _AddNftPageState();
}

class _AddNftPageState extends ConsumerState<AddNftPage> {
  final Widget space = const SizedBox(
    width: 30,
    height: 30,
  );

  Uint8List currentImage = Uint8List.fromList([]);
  List<String> currency = ['eur', 'bitcoin', 'ron'];
  String currentCurrency = 'eur';

  TextEditingController ammountController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController collectionController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool processingData = false;

  void _pickFiles() async {
    String? _directoryPath;
    String? _extension;
    FileType _pickingType = FileType.any;
    try {
      _directoryPath = null;
      var _paths = (await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
      if (_paths == null) {
        return;
      }
      if (_paths.isNotEmpty) {
        currentImage = _paths.first.bytes!;
        setState(() {});
      }
    } on PlatformException catch (e) {
      debugPrint('Unsupported operation' + e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
    // setState(() {
    //   _fileName =
    //       _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    //   _userAborted = _paths == null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    double widthContext = MediaQuery.of(context).size.width;
    double heightContext = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(80.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (currentImage.isNotEmpty)
                    SizedBox(
                        width: widthContext / 3,
                        child: Image.memory(currentImage)),
                  space,
                  ElevatedButton(
                    onPressed: () => _pickFiles(),
                    child: const Text('Pick image'),
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
                  ),
                  space,
                  TextFormField(
                    controller: collectionController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Collection',
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty)
                        return 'Collection cannot be empty';

                      return null;
                    },
                  ),
                  space,
                  TextFormField(
                    controller: descriptionController,
                    obscureText: false,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty)
                        return 'Description cannot be empty';

                      return null;
                    },
                  ),
                  space,
                  Container(
                    width: 75,
                    height: 50,
                    child: DropdownButton(
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
                  ),
                  space,
                  Container(
                    height: 40,
                    width: 300,
                    child: TextFormField(
                      controller: ammountController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ammount',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'Ammount cannot be empty';

                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]|.')),
                      ],
                    ),
                  ),
                  space,
                  OutlinedButton(
                      onPressed: processingData
                          ? null
                          : () {
                              addnft();
                            },
                      child: const Text("Add nft")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addnft() async {
    if (_formKey.currentState!.validate()) {
      processingData = true;
      setState(() {});

      //ADD FUNDS===================

      try {
        http.Response nftData = await http.post(
          Uri.https(globals.domain, "/product/uploadNFT"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "id_user": globals.idCont,
            "currency": currentCurrency,
            "price": double.parse(ammountController.text),
            "name": nameController.text,
            "collection": collectionController.text,
            "description": descriptionController.text,
            "image": base64Encode(currentImage)
          }),
        );

        print(nftData.body);

        var resultNFT = jsonDecode(nftData.body);

        if (resultNFT['id'] == null) {
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
                          children: const [
                            Text(
                              "The following errors arosed:",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text("We couldn't upload the image!",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        } else {
          ref
              .read(globals.nfts.notifier)
              .update((state) => [...state, resultNFT]);
        }

        dialog("IMAGE ADDED");
        setState(() {});
      } catch (error) {
        dialog("ERROR OCCURED");
        debugPrint(error.toString());
      }
      //ADD FUNDS===================

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data is wrong')),
      );
    }
    processingData = false;
    setState(() {});
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

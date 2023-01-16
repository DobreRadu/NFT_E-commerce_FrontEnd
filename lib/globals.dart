import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

const String domain = "artisimum.azurewebsites.net";

String firstName = '';
String lastName = '';
String idCont = '';

String date = '';
String phone = '';
String email = '';
dynamic wallet = {};

//{id: 5, name: dog, collection: animals, description: null, historyList: [], currency: eur, price: 50, picture:,,visible:true
final nfts = StateProvider<List<dynamic>>((ref) => []);

final ownedNfts = StateProvider<List<dynamic>>((ref) => []);

final mainPageView =
    StateProvider<Widget>((ref) => const Center(child: Text("LOADING...")));

final buyingNFT = StateProvider<bool>((ref) => false);

dynamic findNftById(String id, WidgetRef ref) {
  for (var nft in ref.read(nfts)) {
    if (nft['id'].toString() == id.toString()) {
      return nft;
    }
  }
  return {};
}

void setAccount(dynamic account, WidgetRef ref) {
  firstName = account['firstname'] ?? "";
  lastName = account['lastname'] ?? "";
  idCont = account['id'] ?? "";
  date = account['date'] ?? "";
  phone = account['phone'] ?? "";
  email = account['email'] ?? "";
  wallet = account['wallet'] ?? "";

  for (int i = 0; i < wallet.keys.toList().length; i++) {
    wallet[wallet.keys.toList()[i]] =
        double.parse(wallet[wallet.keys.toList()[i]]);
  }

  ref.read(ownedNfts.notifier).update((state) => account['nfts'] ?? "");
}

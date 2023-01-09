import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

const String domain = "artisimum.azurewebsites.net";

String firstName = '';
String lastName = '';
String idCont = '';

String date = '';
String phone = '';
String email = '';
dynamic wallet = {};
List<dynamic> ownedNfts = [];
List<dynamic> nfts = [];

final mainPageView =
    StateProvider<Widget>((ref) => const Center(child: Text("LOADING...")));

final buyingNFT = StateProvider<bool>((ref) => false);

dynamic findNftById(String id) {
  for (var nft in nfts) {
    if (nft['id'] == id) {
      return nft;
    }
  }
  return {};
}

void setAccount(dynamic account) {
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

  ownedNfts = account['nfts'] ?? "";
}

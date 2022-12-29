import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

String firstName = '';
String lastName = '';
String idCont = '';

String date = '';
String telefon = '';
String email = '';
dynamic wallet = {};
List<String> ownedNfts = [];
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
  firstName = account['firstName'];
  lastName = account['lastName'];
  idCont = account['idCont'];
  date = account['date'];
  telefon = account['telefon'];
  email = account['email'];
  wallet = account['wallet'];
  ownedNfts = account['ownedNfts'];
}

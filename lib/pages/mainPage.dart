import 'package:flutter/material.dart';
import 'package:nftcommerce/globals.dart';
import 'package:nftcommerce/main.dart';
import 'package:nftcommerce/pages/myAccount.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:nftcommerce/pages/ownedNFT.dart';
import 'package:nftcommerce/pages/shopPage.dart';

class MainPage extends riverpod.ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends riverpod.ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();

    Future(() {
      ref.read(mainPageView.notifier).update((state) => ShopPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'assets/nftLogo.png',
                  alignment: Alignment.center,
                  width: 400,
                ),
              ),
              ListTile(
                title: Text("SHOP"),
                onTap: () {
                  ref.read(mainPageView.notifier).update((state) => ShopPage());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("ACCOUNT"),
                onTap: () {
                  ref
                      .read(mainPageView.notifier)
                      .update((state) => MyAccountPage());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("OWNED NFTS"),
                onTap: () {
                  ref
                      .read(mainPageView.notifier)
                      .update((state) => OwnedPage());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "LOGOUT",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Hello,Nume Prenume!"),
        ),
        body: ref.watch(mainPageView));
  }
}

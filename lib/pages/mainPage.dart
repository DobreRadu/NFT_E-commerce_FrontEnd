import 'package:flutter/material.dart';
import 'package:nftcommerce/globals.dart';
import 'package:nftcommerce/pages/myAccount.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nftcommerce/pages/ownedNFT.dart';
import 'package:nftcommerce/pages/shopPage.dart';
import 'package:nftcommerce/globals.dart' as globals;

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();

    Future(() {
      ref.read(mainPageView.notifier).update((state) => const ShopPage());
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
                title: const Text("SHOP"),
                onTap: () {
                  ref
                      .read(mainPageView.notifier)
                      .update((state) => const ShopPage());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("ACCOUNT"),
                onTap: () {
                  ref
                      .read(mainPageView.notifier)
                      .update((state) => const MyAccountPage());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("OWNED NFTS"),
                onTap: () {
                  ref
                      .read(mainPageView.notifier)
                      .update((state) => const OwnedPage());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  "LOGOUT",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  globals.firstName = '';
                  globals.lastName = '';
                  globals.idCont = '';

                  globals.date = '';
                  globals.telefon = '';
                  globals.email = '';
                  globals.wallet = {};
                  globals.ownedNfts = [];
                  globals.nfts = [];
                  setState(() {});
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Hello,${globals.firstName} ${globals.lastName}!"),
        ),
        body: ref.watch(mainPageView));
  }
}

import 'package:flutter/material.dart';
import 'package:nftcommerce/pages/myAccount.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
                title: Text("ACCOUNT"),
                onTap: () {
                  debugPrint("MY ACCOUNT");
                },
              ),
              ListTile(
                title: Text("OWNED NFTS"),
                onTap: () {
                  debugPrint("MY NFTS");
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
        body: const MyAccountPage()

        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),
        );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:nftcommerce/authentication/register.dart';
import 'package:nftcommerce/pages/mainPage.dart';

import 'package:nftcommerce/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool processingData = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN PAGE"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: 600,
            child: Container(
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/nftLogo.png',
                      alignment: Alignment.center,
                      width: 400,
                    ),
                    const Text(
                      "LOGIN",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'Email cannot be empty';
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text)) return "Email is invalid";

                        return null;
                      },
                      onFieldSubmitted: (value) async {
                        login();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty)
                          return 'Password cannot be empty';
                        if (text.length < 8)
                          return "Password has to have atleast 8 characters!";

                        return null;
                      },
                      onFieldSubmitted: (value) async {
                        login();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()));
                            },
                            child: Text("Register NOW")),
                        Spacer(),
                        OutlinedButton(
                            onPressed: () {
                              login();
                            },
                            child: Text("LOGIN"))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      processingData = true;
      setState(() {});

      var userData = {};
      try {
//LOGIN===================
        http.Response loginData = await http.post(
          Uri.https(globals.domain, "/account/login"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "email": emailController.text,
            "password": passwordController.text
          }),
        );

        print(loginData.body);
        userData = jsonDecode(loginData.body);

        // LOGIN===================

      } catch (error) {
        debugPrint("LOGIN/GET NFTS");
        debugPrint(error.toString());
        dialog("An error occured,please try again later!");
        processingData = false;
        setState(() {});
      }

      if (userData['errors']?.isNotEmpty) {
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
                          ...List.generate(userData['errors'].length, (index) {
                            return Text("- ${userData['errors'][index]}",
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
        globals.setAccount(userData);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));

        try {
          //GET NFTS====================
          http.Response getNFTS = await http.post(
            Uri.https(globals.domain, "/product/getList"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({}),
          );

          globals.nfts = jsonDecode(getNFTS.body);
          if (globals.nfts.isNotEmpty) {
            print(globals.nfts
                .first); //{id: 5, name: dog, collection: animals, description: null, historyList: [], currency: eur, price: 50, picture:
          }

          //GET NFTS====================
        } catch (error) {
          debugPrint("LOGIN/GET NFTS");
          debugPrint(error.toString());
          dialog("An error occured,please try again later!");
          processingData = false;
          setState(() {});
        }
      }
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

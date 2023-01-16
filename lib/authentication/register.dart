import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:nftcommerce/globals.dart' as globals;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController numeController = TextEditingController();
  TextEditingController prenumeController = TextEditingController();

  bool processingData = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTER PAGE"),
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
                      "REGISTER",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: numeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'First Name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "First Name cannot be empty!";
                              }
                              return null;
                            },
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: prenumeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Last Name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Last Name cannot be empty!";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: TextFormField(
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
                          ),
                        ),
                        Spacer(flex: 1),
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Phone',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              // if (value!.isEmpty) {
                              //   return "Phone cannot be empty!";
                              // }
                              // if (value.length < 10) {
                              //   return "Phone is not valid!";
                              // }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: TextFormField(
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
                          ),
                        ),
                        Spacer(flex: 1),
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: repasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Retype Password',
                            ),
                            validator: (text) {
                              if (text != passwordController.text)
                                return 'Password is not the same!';

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        OutlinedButton(
                            onPressed: (processingData)
                                ? null
                                : () async {
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate()) {
                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.
                                      processingData = true;
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')),
                                      );

                                      try {
//REGISTER===================
                                        http.Response registerData =
                                            await http.post(
                                          Uri.https(globals.domain,
                                              "/account/register"),
                                          headers: {
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                          body: jsonEncode({
                                            "email": emailController.text,
                                            "password": passwordController.text,
                                            "firstname": prenumeController.text,
                                            "lastname": numeController.text,
                                            "phone": phoneController.text
                                          }),
                                        );

                                        var registerDataJson =
                                            jsonDecode(registerData.body);

                                        if (registerDataJson['errors']
                                            ?.isNotEmpty) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 241, 241, 241),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    width: 500,
                                                    height: 600,
                                                    child: Center(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                              "The following errors arosed:",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            ...List.generate(
                                                                registerDataJson[
                                                                        'errors']
                                                                    .length,
                                                                (index) {
                                                              return Text(
                                                                  "- ${registerDataJson['errors'][index]}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .red,
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
                                          dialog("Register COMPLETE!");
                                        }

                                        //REGISTER===================
                                      } catch (error) {
                                        debugPrint(error.toString());
                                      }
                                    }
                                    processingData = false;

                                    setState(() {});
                                  },
                            child: const Text("Register")),
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

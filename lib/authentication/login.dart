import 'package:flutter/material.dart';
import 'package:nftcommerce/authentication/register.dart';
import 'package:nftcommerce/pages/mainPage.dart';

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
    if (true) {
      //_formKey.currentState!.validate()
      processingData = true;
      setState(() {});

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data is wrong')),
      );
    }
    processingData = false;
    setState(() {});
  }
}

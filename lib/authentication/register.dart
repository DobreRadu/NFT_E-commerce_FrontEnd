import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController numeController = TextEditingController();
  TextEditingController prenumeController = TextEditingController();
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
                              labelText: 'Nume',
                            ),
                          ),
                        ),
                        Spacer(flex: 1),
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: prenumeController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Prenume',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
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
                            onPressed: () {
                              debugPrint("REGISTER");
                            },
                            child: Text("Register")),
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
}

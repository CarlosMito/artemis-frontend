import 'package:flutter/material.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
      content: Builder(
        builder: (context) {
          return Stack(
            children: [
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              Container(
                height: 500,
                width: 320,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 40, top: 20),
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 2,
                            child: Container(
                              height: 4,
                              width: 40,
                              color: const Color.fromARGB(255, 13, 183, 220),
                            ),
                          ),
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: "Righteous",
                              fontSize: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      onChanged: (String text) {
                        _email = text;
                      },
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 183, 220),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                        labelText: "E-mail",
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (String text) {
                        _password = text;
                      },
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 183, 220),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                        labelText: "Senha",
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 13, 183, 220),
                        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 58),
                      ),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox.square(
                                dimension: 18,
                                child: Image.asset(
                                  "assets/images/icons/google-icon.png",
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Continuar com o Google",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Novo por aqui? ",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              "Crie uma conta",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 0, 161, 197),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

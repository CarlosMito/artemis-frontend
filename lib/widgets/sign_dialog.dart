import 'dart:developer';

import 'package:artemis/enums/sign_type.dart';
import 'package:flutter/material.dart';

class SignDialog extends StatefulWidget {
  final SignType signType;
  const SignDialog({super.key, required this.signType});

  @override
  State<SignDialog> createState() => _SignDialogState();
}

class _SignDialogState extends State<SignDialog> {
  // String _email = "";
  // String _password = "";
  // String _confirmPassword = "";

  bool _isSignup = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String get _title => _isSignup ? "Cadastrar" : "Login";
  String get _preText => _isSignup ? "Já possui uma conta? " : "Novo por aqui? ";
  String get _posText => _isSignup ? "Acesse aqui" : "Crie uma conta ";

  @override
  void initState() {
    super.initState();
    _isSignup = widget.signType == SignType.signup;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

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
                      margin: const EdgeInsets.only(bottom: 30, top: 20),
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 2,
                            child: Container(
                              height: 4,
                              width: 40,
                              color: const Color.fromARGB(255, 216, 143, 0),
                            ),
                          ),
                          Text(
                            _title,
                            style: const TextStyle(
                              fontFamily: "Righteous",
                              fontSize: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SignTextField(
                      labelText: "Usuário",
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 12),
                    if (_isSignup)
                      Column(
                        children: [
                          SignTextField(
                            labelText: "E-mail",
                            controller: _emailController,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    SignTextField(
                      labelText: "Senha",
                      controller: _passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    const SizedBox(height: 12),
                    if (_isSignup)
                      SignTextField(
                        labelText: "Confirmar Senha",
                        controller: _confirmPasswordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                    SizedBox(height: _isSignup ? 24 : 12),
                    ElevatedButton(
                      onPressed: () {
                        log(_emailController.text);
                        log(_passwordController.text);
                        log(_confirmPasswordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 216, 143, 0),
                        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 58),
                      ),
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    // NOTE: This is the google signup button. I'm not gonna do it now.
                    // MouseRegion(
                    //   cursor: SystemMouseCursors.click,
                    //   child: GestureDetector(
                    //     onTap: () {},
                    //     child: Container(
                    //       width: double.infinity,
                    //       padding: const EdgeInsets.symmetric(vertical: 10),
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(4),
                    //         border: Border.all(
                    //           color: Colors.black,
                    //           width: 1.5,
                    //         ),
                    //       ),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           SizedBox.square(
                    //             dimension: 18,
                    //             child: Image.asset(
                    //               "assets/images/logos/google.png",
                    //             ),
                    //           ),
                    //           const SizedBox(width: 10),
                    //           const Text(
                    //             "Continuar com o Google",
                    //             style: TextStyle(
                    //               color: Colors.black,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _preText,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSignup = !_isSignup;
                                });
                              },
                              child: Text(
                                _posText,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 0, 161, 197),
                                ),
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

class SignTextField extends StatelessWidget {
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final String labelText;
  final TextEditingController? controller;

  const SignTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 13, 183, 220),
            width: 2,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        labelText: labelText,
      ),
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
    );
  }
}

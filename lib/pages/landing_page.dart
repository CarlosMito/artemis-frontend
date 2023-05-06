import 'package:artemis/widgets/login_dialog.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                      content: Builder(
                        builder: (context) {
                          return const LoginDialog();
                        },
                      ),
                    ));
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}

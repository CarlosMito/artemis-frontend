import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
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
      appBar: const ArtemisAppBar(),
      body: Center(
        child: Container(),
      ),
    );
  }
}

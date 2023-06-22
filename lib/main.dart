import 'package:artemis/enums/landing_section.dart';
import 'package:artemis/pages/explore_page.dart';
import 'package:artemis/pages/landing_page.dart';
import 'package:artemis/pages/text2image_page.dart';
import 'package:artemis/utils/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vrouter/vrouter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Artemis());
}

class Artemis extends StatelessWidget {
  const Artemis({super.key});

  @override
  Widget build(BuildContext context) {
    return VRouter(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      mode: VRouterMode.history,
      initialUrl: "/home",
      routes: [
        VWidget(path: "/home", widget: const LandingPage(startingSection: LandingSection.standard)),
        VWidget(path: "/about", widget: const LandingPage(startingSection: LandingSection.about)),
        VWidget(path: "/contact-me", widget: const LandingPage(startingSection: LandingSection.contactMe)),
        VWidget(path: "/explore", widget: const ExplorePage()),
        VWidget.builder(
          path: "/text2image",
          builder: (context, state) {
            // debugPrint(ModalRoute.of(context)!.settings.arguments.toString());
            return const Text2ImagePage();
          },
        ),
        VRouteRedirector(
          redirectTo: "/home",
          path: r'*',
        ),
      ],
    );
  }
}

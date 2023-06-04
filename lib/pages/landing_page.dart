import 'dart:html';

import 'package:artemis/widgets/app_bar/artemis_app_bar.dart';
import 'package:artemis/widgets/custom/right_triangle_custom_painter.dart';
import 'package:artemis/widgets/custom/star_custom_painter.dart';
import 'package:artemis/widgets/custom/triangle_custom_painter.dart';
import 'package:artemis/widgets/diamond_separator.dart';
// import 'package:artemis/widgets/custom/trailing_custom_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_animate/flutter_animate.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  final Random _random = Random(6);

  List<Widget> _buildStars(double centerX, double centerY, totalStars) {
    List<Widget> stars = [];

    var minStarSize = 5;
    var maxStarSize = 30;
    var radius = 300;
    var limitX = 700;
    var limitY = 700;

    for (var i = 0; i < totalStars; i++) {
      var starSize = _random.nextDouble() * maxStarSize + minStarSize;
      var dx = _random.nextDouble() * limitX - limitX / 2;
      var dy = _random.nextDouble() * limitY - limitY / 2;
      var hypotenuse = sqrt(pow(dx, 2) + pow(dy, 2));

      dx += (dx / hypotenuse) * radius - starSize / 2;
      dy += (dy / hypotenuse) * radius - starSize / 2;

      bool isStar = starSize > (minStarSize + ((maxStarSize - minStarSize) / 5));

      stars.add(Positioned(
        top: centerY,
        left: centerX,
        child: isStar
            ? CustomPaint(
                size: Size(starSize, starSize),
                painter: StarCustomPainter(
                  translateX: dx,
                  translateY: dy,
                  color: const Color.fromARGB(255, 222, 205, 155),
                ),
              )
            : Transform.translate(
                offset: Offset(dx, dy),
                child: Container(
                  width: starSize,
                  height: starSize,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 226, 201, 124),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
      ));
    }

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    final Size windowSize = MediaQueryData.fromView(View.of(context)).size;
    final Size center = Size(windowSize.width / 3, windowSize.height / 2);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const ArtemisAppBar().preferredSize,
        child: const Hero(
          tag: ArtemisAppBar,
          child: ArtemisAppBar(),
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          // Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     //     // CustomPaint(
          //     //     //   size: const Size(400, 400),
          //     //     //   painter: TrailingCustomPainter(color: const Color.fromARGB(255, 222, 205, 155)),
          //     //     // ),
          //     //     // CustomPaint(
          //     //     //   size: const Size(400, 400),
          //     //     //   painter: StarCustomPainter(
          //     //     //     color: const Color.fromARGB(255, 222, 205, 155),
          //     //     //     translateX: 600,
          //     //     //   ),
          //     //     // ),

          //   ],
          // ),
          // FittedBox(
          //   child: Stack(
          //     children: [
          //       // Stack(children: _buildStars(center.width, center.height, 15))
          //       //     .animate(onPlay: (controller) => controller.repeat())
          //       //     .rotate(duration: const Duration(seconds: 70)),
          //       // Stack(children: _buildStars(center.width, center.height, 15))
          //       //     .animate(onPlay: (controller) => controller.repeat())
          //       //     .rotate(duration: const Duration(seconds: 100)),
          // Stack(children: _buildStars(center.width, center.height, 15))
          //     .animate(onPlay: (controller) => controller.repeat())
          //     .rotate(duration: const Duration(seconds: 85)),
          //       Image.asset("assets/images/background/golden-moon-phases.png")
          //           .animate(onPlay: (controller) => controller.repeat())
          //           .rotate(duration: const Duration(seconds: 500), begin: pi, end: 0),
          //     ],
          //   ),
          // ),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 80, top: 80),
                child: Image.asset("assets/images/background/golden-moon-phases.png", width: 800)
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: const Duration(seconds: 500), begin: pi, end: 0),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(right: 80, top: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "EXPERIMENTE",
                      style: TextStyle(
                        color: Color.fromARGB(255, 233, 180, 80),
                        fontFamily: "Lexend",
                        fontWeight: FontWeight.bold,
                        fontSize: 44,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(
                      width: 320,
                      child: Text(
                        "Utilize a ferramenta de Texto à Imagem para criar novas obras rápidamente através de descrições textuais",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Lexend",
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 2,
                      width: 122,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Stack(children: _buildStars(center.width, center.height, 15))
          //     .animate(onPlay: (controller) => controller.repeat())
          //     .rotate(duration: const Duration(seconds: 85)),
          Row(
            children: [
              Expanded(
                child: CustomPaint(
                  size: const Size(60, 70),
                  painter: RightTriangleCustomPainter(color: Colors.white),
                ),
              ),
              Expanded(
                child: Transform.flip(
                  flipX: true,
                  child: CustomPaint(
                    size: const Size(60, 70),
                    painter: RightTriangleCustomPainter(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const AboutSection(),
          Row(
            children: [
              Expanded(
                child: Transform.flip(
                  flipY: true,
                  flipX: true,
                  child: CustomPaint(
                    size: const Size(60, 60),
                    painter: RightTriangleCustomPainter(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Transform.flip(
                  flipY: true,
                  child: CustomPaint(
                    size: const Size(60, 60),
                    painter: RightTriangleCustomPainter(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const ContactMeSection(),
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 920,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 26,
          runSpacing: 26,
          children: [
            FittedBox(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "SOBRE",
                      style: TextStyle(
                        color: Color.fromARGB(255, 216, 143, 0),
                        fontFamily: "Lexend",
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    Container(
                      height: 4,
                      width: 62,
                      color: const Color.fromARGB(255, 216, 143, 0),
                    ),
                    const SizedBox(height: 36),
                    const SizedBox(
                      width: 252,
                      child: Text(
                        "Este site é o resultado do meu projeto final de conclusão do curso de Ciência da Computação, desenvolvido durante minha "
                        "graduação na UFSJ sob a orientação do professor Edimilson Batista dos Santos.",
                        style: TextStyle(
                          fontFamily: "Lexend",
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                const SizedBox(
                  height: 470,
                  width: 810,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 400,
                    width: 800,
                    child: Image.asset(
                      "assets/images/background/ctan-ufsj.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      "assets/images/background/ufsj.jpg",
                      fit: BoxFit.fitWidth,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ContactMeSection extends StatelessWidget {
  const ContactMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 600,
      child: Center(
        child: Column(
          // direction: Axis.vertical,
          // alignment: WrapAlignment.center,
          // crossAxisAlignment: WrapCrossAlignment.center,
          // spacing: 20,
          children: [
            SizedBox(height: 140),
            FittedBox(
              child: Column(
                children: [
                  Text(
                    "CONTATE-ME",
                    style: TextStyle(
                      color: Color.fromARGB(255, 233, 180, 80),
                      fontFamily: "Lexend",
                      fontWeight: FontWeight.bold,
                      fontSize: 44,
                    ),
                  ),
                  DiamondSeparator(
                    color: Colors.white,
                    width: 345,
                    outerIconSize: 0,
                    lineWidth: 1.5,
                    spacing: 12,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  DiamondSeparator(
                    color: Colors.white,
                    width: 250,
                    outerIconSize: 0,
                    lineWidth: 1.5,
                    spacing: 12,
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ContactRow(
              text: "carlosmsmito@gmail.com",
              icon: Icons.mail,
            ),
            SizedBox(height: 20),
            ContactRow(
              text: "(32) 98498-0040",
              icon: Icons.phone,
              flipXLast: true,
            ),
            SizedBox(height: 100),
            SocialNetworkRow(),
          ],
        ),
      ),
    );
  }
}

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool flipXFirst;
  final bool flipXLast;

  const ContactRow({super.key, required this.icon, required this.text, this.flipXFirst = false, this.flipXLast = false});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      children: [
        Transform.flip(
          flipX: flipXFirst,
          child: Icon(icon, color: Colors.white),
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Lexend",
            fontSize: 18,
          ),
        ),
        Transform.flip(
          flipX: flipXLast,
          child: Icon(icon, color: Colors.white),
        ),
      ],
    );
  }
}

class SocialNetworkButton extends StatelessWidget {
  final String assetImage;

  const SocialNetworkButton({super.key, required this.assetImage});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 67, 67, 67),
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              color: Colors.black,
              width: 10,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: Image.asset(
            assetImage,
            width: 28,
            height: 28,
          ),
        ),
      ),
    );
  }
}

class SocialNetworkRow extends StatelessWidget {
  const SocialNetworkRow({super.key});

  Widget buildLongLine({double? up, double? down}) {
    return Container(
      color: const Color.fromARGB(255, 122, 122, 122),
      height: 1,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: up ?? 0, top: down ?? 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        buildLongLine(up: 12),
        buildLongLine(down: 12),
        Row(
          children: [
            Transform.rotate(
              angle: -pi / 2,
              child: CustomPaint(
                size: const Size(60, 60),
                painter: TriangleCustomPainter(color: const Color.fromARGB(255, 122, 122, 122)),
              ),
            ),
            const Spacer(),
            Transform.rotate(
              angle: pi / 2,
              child: CustomPaint(
                size: const Size(60, 60),
                painter: TriangleCustomPainter(color: const Color.fromARGB(255, 122, 122, 122)),
              ),
            ),
          ],
        ),
        const FittedBox(
          child: Wrap(
            spacing: 42,
            children: [
              SocialNetworkButton(assetImage: "assets/images/logos/facebook.png"),
              SocialNetworkButton(assetImage: "assets/images/logos/instagram.png"),
              SocialNetworkButton(assetImage: "assets/images/logos/twitter.png"),
              SocialNetworkButton(assetImage: "assets/images/logos/linkedin.png"),
            ],
          ),
        ),
      ],
    );
  }
}

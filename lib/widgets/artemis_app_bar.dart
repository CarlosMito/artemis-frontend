import 'package:artemis/widgets/login_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ArtemisAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? focus;

  const ArtemisAppBar({Key? key, this.focus})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<ArtemisAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<ArtemisAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          SizedBox.square(
            dimension: 26,
            child: FittedBox(
              child: Image.asset(
                "assets/images/icons/artemis-icon-white.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "ARTEMIS",
            style: TextStyle(
              fontFamily: "Righteous",
              fontSize: 18,
            ),
          ),
          const Spacer(),
          if (MediaQuery.of(context).size.width > 1000)
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
                fontFamily: "Lexend",
              ),
              child: Wrap(
                clipBehavior: Clip.antiAlias,
                spacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Texto à Imagem"),
                  Transform.rotate(angle: math.pi / 4, child: Container(color: Colors.white, width: 5, height: 5)),
                  Text("Explorar"),
                  Transform.rotate(angle: math.pi / 4, child: Container(color: Colors.white, width: 5, height: 5)),
                  Text("Contatos"),
                  Transform.rotate(angle: math.pi / 4, child: Container(color: Colors.white, width: 5, height: 5)),
                  Text("Sobre"),
                ],
              ),
            ),
          const Spacer(),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: "Lexend",
            ),
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const LoginDialog(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: const Text("Entrar"),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text("Cadastrar"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      // flexibleSpace: Container(
      //   color: Colors.red,
      //   width: 10,
      //   height: 10,
      // ),
      // actions: [
      //   Row(
      //     children: [
      //       IconButton(
      //         icon: const Icon(Icons.shopping_cart),
      //         tooltip: 'Open shopping cart',
      //         onPressed: () {
      //           // handle the press
      //         },
      //       ),
      //     ],
      //   ),
      // ],
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
    );
  }
}

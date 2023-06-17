import 'package:artemis/api/api_service.dart';
import 'package:artemis/enums/sign_type.dart';
import 'package:artemis/models/user.dart';
import 'package:artemis/widgets/app_bar/artemis_app_button.dart';
import 'package:artemis/widgets/sign_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:vrouter/vrouter.dart';

class ArtemisAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? focus;
  final Function()? homeOnTap;
  final Function()? aboutOnTap;
  final Function()? contactMeOnTap;

  const ArtemisAppBar({Key? key, this.focus, this.aboutOnTap, this.contactMeOnTap, this.homeOnTap})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<ArtemisAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<ArtemisAppBar> {
  Future<User>? _user;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _user = ArtemisApiService.getLoggedInUserArtemis();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.homeOnTap ?? () => context.vRouter.to("/home"),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 26,
                    child: FittedBox(
                      child: Image.asset(
                        "assets/images/logos/artemis-white.png",
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
                ],
              ),
            ),
          ),
          if (MediaQuery.of(context).size.width > 800)
            Wrap(
              clipBehavior: Clip.antiAlias,
              spacing: 20,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const ArtemisAppButton(
                  text: "Texto à Imagem",
                  route: "/text2image",
                ),
                Transform.rotate(angle: math.pi / 4, child: Container(color: Colors.white, width: 5, height: 5)),
                const ArtemisAppButton(
                  text: "Explorar",
                  route: "/explore",
                ),
                Transform.rotate(angle: math.pi / 4, child: Container(color: Colors.white, width: 5, height: 5)),
                ArtemisAppButton(
                  text: "Sobre",
                  route: "/about",
                  onTap: widget.aboutOnTap,
                ),
                Transform.rotate(angle: math.pi / 4, child: Container(color: Colors.white, width: 5, height: 5)),
                ArtemisAppButton(
                  text: "Contate-me",
                  route: "/contact-me",
                  onTap: widget.contactMeOnTap,
                ),
              ],
            ),
          SizedBox(
            width: 200,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: "Lexend",
              ),
              child: FutureBuilder<User>(
                  future: _user,
                  builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                    if (!snapshot.hasData) return const SizedBox.shrink();

                    List<Widget> children = snapshot.data?.id.toInt() == 0
                        ? [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const SignDialog(signType: SignType.signin),
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
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const SignDialog(signType: SignType.signup),
                                  );
                                },
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
                            )
                          ]
                        : [Text(snapshot.data!.username)];

                    return Row(mainAxisAlignment: MainAxisAlignment.end, children: children);
                  }),
            ),
          )
        ],
      ),
    );
  }
}

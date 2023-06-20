import 'package:artemis/api/api_service.dart';
import 'package:artemis/enums/artemis_placeholder.dart';
import 'package:artemis/enums/sign_type.dart';
import 'package:artemis/models/user.dart';
import 'package:artemis/utils/maps.dart';
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
  final Function()? onLogin;
  final Function()? onLogout;

  const ArtemisAppBar({Key? key, this.focus, this.aboutOnTap, this.contactMeOnTap, this.homeOnTap, this.onLogin, this.onLogout})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<ArtemisAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<ArtemisAppBar> {
  Future<User?>? _user;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _user = ArtemisApiService.getLoggedInUserArtemis();
  }

  void showSignDialog(SignType signType) async {
    Future<User?>? user = await showDialog(
      context: context,
      builder: (_) => SignDialog(signType: signType),
    );

    if (user != null) {
      user.then((value) {
        setState(() {
          _user = user;

          if (widget.onLogin != null) {
            widget.onLogin!();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      // actions: <Widget>[
      //     PopupMenuButton<String>(
      //       onSelected: choiceAction,
      //       itemBuilder: (BuildContext context) {
      //         return Constants.choices.map((String choice) {
      //           return PopupMenuItem<String>(
      //             value: choice,
      //             child: Text(choice),
      //           );
      //         }).toList();
      //       },
      //     )
      //   ],
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
              child: FutureBuilder<User?>(
                  future: _user,
                  builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<Widget> children = [];

                      if (snapshot.data == null) {
                        children.addAll([
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => showSignDialog(SignType.signin),
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
                              onTap: () => showSignDialog(SignType.signup),
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
                        ]);
                      } else {
                        children.addAll([
                          Text(
                            snapshot.data!.username,
                            style: const TextStyle(
                              fontFamily: "Lexend",
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 10),
                          PopupMenuButton<String>(
                            elevation: 0,
                            position: PopupMenuPosition.under,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(imageMapping[ArtemisPlaceholder.userDefault]!),
                              ),
                            ),
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  child: const Text("Sair"),
                                  onTap: () async {
                                    await ArtemisApiService.logoutArtemis();
                                    setState(() {
                                      _user = Future<User?>.value(null);
                                    });

                                    if (widget.onLogin != null) {
                                      widget.onLogin!();
                                    }
                                  },
                                )
                              ];
                            },
                          ),
                        ]);
                      }

                      return Row(mainAxisAlignment: MainAxisAlignment.end, children: children);
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}

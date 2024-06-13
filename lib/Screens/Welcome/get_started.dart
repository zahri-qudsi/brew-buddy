import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../const.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/coffee2.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 30, top: 220, right: 30, bottom: 220),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(144, 0, 0, 0),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 19, 19, 19).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 40, right: 20, bottom: 0, left: 20),
                child: Column(
                  children: [
                    const Text(
                      "Welcome to",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'DeLonghi Sans',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Center(
                      child: Text(
                        "Brew Buddy Coffee Promo",
                        style: TextStyle(
                          color: welcomeTextColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'DeLonghi Serif',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                        style: TextStyle(
                          color: welcomeTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'DeLonghi Sans',
                        ),
                        // textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          onPressed: () {
                            // _show();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(mainButtonColor),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.all(20.0),
                            ),
                            foregroundColor: WidgetStateProperty.all<Color>(
                                welcomeTextColor),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Got it",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'DeLonghi Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(50),
                          // ),
                          // color: mainButtonColor,
                          // textColor: welcomeTextColor,
                          // padding: const EdgeInsets.all(20),
                        ),
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

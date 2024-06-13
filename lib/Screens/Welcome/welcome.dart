// import 'dart:ffi';
import 'dart:ui';
import 'package:brew_buddy/Screens/auth/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../Model/slide.dart';
import '../../const.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late VideoPlayerController controller;
  List<Slide> slide = [];
  List sliderList = [
    "coffee1.jpg",
    "coffee2.jpg",
    "coffee3.jpg",
  ];

  // void _show() {
  //   showDialog(
  //       context: context,
  //       barrierColor: Colors.transparent,
  //       builder: (BuildContext ctx) {
  //         return BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
  //           child: AlertDialog(
  //             elevation: 10,
  //             title: const Text('Title'),
  //             content: const Text('Some content here'),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text('Close'))
  //             ],
  //           ),
  //         );
  //       });
  // }

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/video/Home-Video.mp4')
      ..initialize().then((value) {
        controller.play();
        controller.setVolume(0.0);
        // controller.setLooping(true);
        setState(() {});
      });
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
    controller.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150, right: 20, left: 20),
              child: welcomeSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget welcomeSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Image.asset(
            "assets/images/Logo_DL_P289_Welcome.png",
            fit: BoxFit.contain,
            width: 250,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const Text(
          "The perfect match for unique coffee experiences.",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            // fontStyle: FontStyle.normal,
            color: welcomeTextColor,
            fontFamily: 'DeLonghi Serif',
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        getStartedButtons(),
      ],
    );
  }

  Widget getStartedButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            // _show();
            showDialog(
              context: context,
              builder: (BuildContext context) => welcomePopup(),
            );
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(mainButtonColor),
            padding: WidgetStateProperty.all(
              const EdgeInsets.all(20.0),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(welcomeTextColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          child: const Text(
            "Get Started",
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'DeLonghi Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Login(),
              ),
            );
          },
          style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all<Color>(mainButtonColor),
            padding: WidgetStateProperty.all(
              const EdgeInsets.all(20.0),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(welcomeTextColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: const BorderSide(width: 3, color: welcomeTextColor),
              ),
            ),
          ),
          child: const Text(
            "Login to your account",
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'DeLonghi Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget welcomePopup() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: const Color(0xFF0f1723),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 400,
              padding: const EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'DeLonghi Sans',
                      ),
                      // textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Brew Buddy Coffee World",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'DeLonghi Serif',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Experience coffee to the fullest. No matter what your preference is. Claim your 4 free complimentary coffee now!",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 18,
                        // fontWeight: FontWeight.w400,
                        fontFamily: 'DeLonghi Sans',
                        // letterSpacing: 1.6,
                      ),
                      // textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
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
                            "Coffee Time",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'DeLonghi Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -40,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: welcomeTextColor,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

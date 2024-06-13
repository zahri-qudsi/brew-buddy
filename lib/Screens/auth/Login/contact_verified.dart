import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Components/main_drawer.dart';
import '../../../const.dart';
import '../../CouponCode/promo_codes.dart';

class ContactVerified extends StatefulWidget {
  const ContactVerified({super.key});

  @override
  State<ContactVerified> createState() => _ContactVerifiedState();
}

class _ContactVerifiedState extends State<ContactVerified> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isContactVerify = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(
        authToken: "",
        menuContext: context,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          centerTitle: true,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Image.asset(
              "assets/images/Logo_DL_P289.png",
              fit: BoxFit.contain,
              width: 150,
            ),
          ),
          backgroundColor: backgroundColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: InkWell(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: backgroundColor,
                child: SvgPicture.asset(
                  "assets/images/menu-4.svg",
                  color: welcomeTextColor,
                  width: 34,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const EditProfile(),
                  //   ),
                  // );
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: backgroundColor,
                  child: SvgPicture.asset(
                    "assets/images/account.svg",
                    color: welcomeTextColor,
                    width: 34,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Contact Number Verification",
                    style: TextStyle(
                      fontSize: 22,
                      color: welcomeTextColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'DeLonghi Serif',
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Enter the code received by SMS to your phone.",
                      style: TextStyle(
                        fontSize: 16,
                        color: welcomeTextColor,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'DeLonghi Sans',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      verifyField(),
                      const SizedBox(
                        width: 12,
                      ),
                      verifyField(),
                      const SizedBox(
                        width: 12,
                      ),
                      verifyField(),
                      const SizedBox(
                        width: 12,
                      ),
                      verifyField(),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Not Received ? ",
                          style: TextStyle(
                            fontSize: 20,
                            color: welcomeTextColor,
                          ),
                        ),
                        TextSpan(
                          text: "Send again",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              // var url = "https://flutter-examples.com";
                              // if (await canLaunch(url)) {
                              //   await launch(url);
                              // } else {
                              //   throw 'Could not launch $url';
                              // }
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            verifyButton(),
          ],
        ),
      ),
    );
  }

  Widget verifyField() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          color: verifiedButton,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextField(
            style: const TextStyle(
                color: welcomeTextColor,
                fontSize: 30,
                fontFamily: 'DeLonghi Sans'),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            //  controller: this.code,
            maxLength: 1,
            cursorColor: Theme.of(context).primaryColor,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
      ),
    );
  }

  Widget verifyButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            // minWidth: 360,
            // padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
            onPressed: () {
              // updateProfile();
              // print('sending user');
              showDialog(
                context: context,
                builder: (BuildContext context) => accountVerified(),
              );
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(mainButtonColor),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
              ),
              foregroundColor:
                  WidgetStateProperty.all<Color>(welcomeTextColor),
              shape: WidgetStateProperty.all(const StadiumBorder()),
            ),
            child: const Text(
              'Verify Account',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'DeLonghi Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
            // color: mainButtonColor,
            // shape: const StadiumBorder(),
          ),
        ],
      ),
    );
  }

  Widget accountVerified() {
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
            SizedBox(
              height: 550,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  right: 20,
                  left: 20,
                  // bottom: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        "Your Account has been Verified",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: welcomeTextColor,
                            fontFamily: 'DeLonghi Sans'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Center(
                      child: Text(
                        "At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est",
                        style: TextStyle(
                          fontSize: 16,
                          color: welcomeTextColor,
                          letterSpacing: 1.8,
                          fontFamily: 'DeLonghi Sans',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PromoCodes(
                              authToken: "",
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(mainButtonColor),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(20),
                        ),
                        foregroundColor:
                            WidgetStateProperty.all<Color>(welcomeTextColor),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(
                                width: 3, color: welcomeTextColor),
                          ),
                        ),
                      ),
                      child: const Text(
                        "View my promo codes",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'DeLonghi Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(50),
                      //   side:
                      //       const BorderSide(width: 3, color: welcomeTextColor),
                      // ),
                      // textColor: welcomeTextColor,
                      // padding: const EdgeInsets.all(20),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        // _show();
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const CoffeeMachines(),
                        //   ),
                        // );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(mainButtonColor),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(20.0),
                        ),
                        foregroundColor:
                            WidgetStateProperty.all<Color>(welcomeTextColor),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      child: const Text(
                        "View Coffee Machines",
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
              ),
            ),
            const Positioned(
              top: -60,
              child: CircleAvatar(
                backgroundColor: Color(0xFF233a67),
                radius: 70,
                child: Icon(
                  Icons.check,
                  size: 90,
                  color: welcomeTextColor,
                ),
              ),
            ),
            Positioned(
              top: -60,
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

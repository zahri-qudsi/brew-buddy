import 'dart:ui';
import 'package:brew_buddy/Screens/Dashboard/dashboard_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../Model/TokenModel.dart';
import '../../../api/app_repository.dart';
import '../../../const.dart';
import '../../CouponCode/promo_codes.dart';

class ContactVerify extends StatefulWidget {
  final String phoneNumber;
  final AppRepository appRepo;

  const ContactVerify(
      {super.key, required this.phoneNumber, required this.appRepo});

  @override
  State<ContactVerify> createState() =>
      _ContactVerifyState(phoneNumber: phoneNumber, appRepo: appRepo);
}

class _ContactVerifyState extends State<ContactVerify> {
  final String phoneNumber;
  final AppRepository appRepo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final codeOne = TextEditingController();
  final codeTwo = TextEditingController();
  final codeThree = TextEditingController();
  final codeFour = TextEditingController();

  _ContactVerifyState({required this.appRepo, required this.phoneNumber});

  bool isContactVerify = false;

  bool isLoading = false;
  bool isSendingVerification = false;

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void sendVerification() async {
    setState(() {
      isSendingVerification = true;
    });

    try {
      var phone = phoneNumber;

      bool status = await appRepo.verifyPhone({
        'phone': phone,
      });

      setState(() {
        isSendingVerification = false;
      });

      if (!status) {
        _showSnackBar("Could not locate your account");
      }

      // print(email);
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        isSendingVerification = false;
      });
    }
  }

  login() async {
    try {
      var code1 = codeOne.text;
      var code2 = codeTwo.text;
      var code3 = codeThree.text;
      var code4 = codeFour.text;

      var fullCode = code1 + code2 + code3 + code4;

      if (fullCode.length != 4) {
        _showSnackBar("Invalid verification code");
        return false;
      }

      setState(() {
        isLoading = true;
      });

      TokenModel token =
          await appRepo.login({'phone': phoneNumber, 'password': fullCode});

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(authToken: token.token),
        ),
      );
    } catch (e) {
      _showSnackBar("OTP does not match");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return Scaffold(
      key: _scaffoldKey,

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
        ),
      ),
      // extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                          fontSize: 14,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textFieldOTP(
                          first: true,
                          last: false,
                          focus: focus,
                          controller: codeOne,
                          tiAction: TextInputAction.next,
                        ),
                        textFieldOTP(
                          first: false,
                          last: false,
                          focus: focus,
                          controller: codeTwo,
                          tiAction: TextInputAction.next,
                        ),
                        textFieldOTP(
                          first: false,
                          last: false,
                          focus: focus,
                          controller: codeThree,
                          tiAction: TextInputAction.next,
                        ),
                        textFieldOTP(
                          first: false,
                          last: true,
                          focus: focus,
                          controller: codeFour,
                          tiAction: TextInputAction.next,
                        ),
                        // verifyField(focus, codeOne, TextInputAction.next),
                        // const SizedBox(
                        //   width: 12,
                        // ),
                        // verifyField(focus, codeTwo, TextInputAction.next),
                        // const SizedBox(
                        //   width: 12,
                        // ),
                        // verifyField(focus, codeThree, TextInputAction.next),
                        // const SizedBox(
                        //   width: 12,
                        // ),
                        // verifyField(focus, codeFour, TextInputAction.done),
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
                              fontFamily: 'DeLonghi Sans',
                            ),
                          ),
                          TextSpan(
                            text: isSendingVerification
                                ? "Sending"
                                : "Send again",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontFamily: 'DeLonghi Sans',
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                sendVerification();
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
              isLoading
                  ? const SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: welcomeTextColor,
                        ),
                      ),
                    )
                  : verifyButton(),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verifyField(FocusScopeNode focus, TextEditingController controller,
      TextInputAction tiAction) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: verifiedButton,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextFormField(
            autofocus: true,
            controller: controller,
            style: const TextStyle(
              color: welcomeTextColor,
              fontSize: 30,
              fontFamily: 'DeLonghi Sans',
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            textInputAction: tiAction,
            onChanged: (String value) {
              if (value.length == 1) {
                focus.nextFocus();
              }
              if (value.isEmpty) {
                focus.previousFocus();
              }
            },
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

  Widget textFieldOTP({
    required bool first,
    last,
    required FocusScopeNode focus,
    required TextEditingController controller,
    required TextInputAction tiAction,
  }) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: verifiedButton,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextFormField(
            autofocus: true,
            controller: controller,
            style: const TextStyle(
              color: welcomeTextColor,
              fontSize: 30,
              fontFamily: 'DeLonghi Sans',
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            textInputAction: tiAction,
            onChanged: (String value) {
              if (value.length == 1 && last == false) {
                focus.nextFocus();
              }
              if (value.isEmpty && first == false) {
                focus.previousFocus();
              }
            },
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
              login();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(mainButtonColor),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
              ),
              foregroundColor: WidgetStateProperty.all<Color>(welcomeTextColor),
              shape: WidgetStateProperty.all(
                const StadiumBorder(),
              ),
            ),
            child: const Text(
              'Verify Account',
              style: TextStyle(
                fontSize: 18,
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
              height: 480,
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
                          fontFamily: 'DeLonghi Sans',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
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
                      height: 35,
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
                          const EdgeInsets.all(20.0),
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

import 'package:brew_buddy/Screens/Dashboard/dashboard_screen.dart';
import 'package:brew_buddy/Screens/Welcome/welcome.dart';
import 'package:flutter/material.dart';

import '../../../const.dart';

class DeleteSuccess extends StatefulWidget {
  final String authToken;
  const DeleteSuccess({super.key, required this.authToken});

  @override
  State<DeleteSuccess> createState() =>
      _DeleteSuccessState(authToken: authToken);
}

class _DeleteSuccessState extends State<DeleteSuccess> {
  final String authToken;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _DeleteSuccessState({required this.authToken});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          DashboardScreen(authToken: authToken),
                    ),
                  );
                },
                child: Image.asset(
                  "assets/images/Logo_DL_P289.png",
                  fit: BoxFit.contain,
                  width: 150,
                ),
              ),
            ),
            backgroundColor: backgroundColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),

              // Center(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 2,
              //     color: hr,
              //   ),
              // ),
              Center(
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF233a67),
                        Color(0xFF233a67),
                        Color(0xFF233a67),
                        Color(0xFF1f3560),
                        Color(0xFF1f3560),
                      ],
                    ),
                    // image: DecorationImage(

                    //   image: AssetImage(
                    //     "assets/images/checkMarck.png",

                    //   ),
                    //   fit: BoxFit.cover,
                    // ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(200.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(2, 2.1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Your account has been deactivated and you were logged out",
                        style: TextStyle(
                          fontSize: 25,
                          color: welcomeTextColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'DeLonghi Serif',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              backtoLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget backtoLoginButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          // minWidth: 360,
          // padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
          onPressed: () {
            // if (_formKey.currentState!.validate()) {
            //   updateProfile();
            // }
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Welcome(),
              ),
            );
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
            'Go back',
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
    );
  }
}

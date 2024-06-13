import 'package:brew_buddy/Screens/CouponCode/promo_codes.dart';
import 'package:brew_buddy/Screens/Dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Components/main_drawer.dart';
import '../../const.dart';
import '../auth/EditProfile/edit_profile.dart';

class RedeemCodes extends StatefulWidget {
  final String authToken;
  const RedeemCodes({super.key, required this.authToken});

  @override
  State<RedeemCodes> createState() => _RedeemCodesState(authToken: authToken);
}

class _RedeemCodesState extends State<RedeemCodes> {
  final String authToken;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _RedeemCodesState({required this.authToken});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(
          authToken: authToken,
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
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
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
            leading: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: GestureDetector(
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                          authToken: authToken,
                        ),
                      ),
                    );
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
        backgroundColor: backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "How to Redeem my Codes",
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
              height: 25,
            ),
            Center(
              child: Container(
                width: size.width,
                height: 2,
                color: hr,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/logo-1.png",
                    ),
                    fit: BoxFit.cover,
                  ),
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
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: RichText(
                // textAlign: TextAlign.justify,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "Visit the pop up store in the location you have selected the redeemable coffee product and",
                      style: TextStyle(
                        fontSize: 16,
                        color: welcomeTextColor,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'DeLonghi Sans',
                      ),
                    ),
                    TextSpan(
                      text:
                          "present your QR Code to our staff. They would verify the code and serve you the coffee.",
                      style: TextStyle(
                        fontSize: 16,
                        color: welcomeTextColor,
                        // fontWeight: FontWeight.bold,
                        fontFamily: 'DeLonghi Sans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: RichText(
                textAlign: TextAlign.left,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "if you have any questions please call us on +973 390 78574",
                      style: TextStyle(
                        fontSize: 18,
                        color: welcomeTextColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'DeLonghi Sans',
                      ),
                    ),
                    // TextSpan(
                    //   text: "+973 390 78574",
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     color: welcomeTextColor,
                    //     fontWeight: FontWeight.w700,
                    //     fontFamily: 'DeLonghi Sans',
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextButton(
                onPressed: () {
                  // _show();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PromoCodes(
                        authToken: authToken,
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
                    ),
                  ),
                ),
                child: const Text(
                  "Redeem my Codes",
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
            ),
          ],
        ),
      ),
    );
  }
}

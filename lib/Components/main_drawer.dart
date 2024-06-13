import 'package:brew_buddy/Screens/CoffeeMachines/coffee_machines.dart';
import 'package:brew_buddy/Screens/CouponCode/promo_codes.dart';
import 'package:brew_buddy/Screens/CouponCode/redeem_code.dart';
import 'package:brew_buddy/Screens/Dashboard/dashboard_screen.dart';
import 'package:brew_buddy/Screens/Welcome/welcome.dart';
import 'package:brew_buddy/Screens/auth/EditProfile/edit_profile.dart';
import 'package:brew_buddy/Screens/auth/Login/logout_screen.dart';
import 'package:brew_buddy/api/app_repository.dart';
import 'package:brew_buddy/const.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final String authToken;
  final BuildContext menuContext;
  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  AppRepository? appRepo;

  MainDrawer(
      {super.key,
      Key? keys,
      required this.authToken,
      required this.menuContext}) {
    appRepo = AppRepository(authToken: authToken);
  }

  void logout() async {
    // bool status = await appRepo!.logout({"action": "logout"});

    Navigator.of(menuContext).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Welcome(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Drawer(
        backgroundColor: drawerRight,
        // width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topLeft,
                  // color: drawerLeft,
                  // width: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context, false),
                          icon: const Icon(
                            Icons.close,
                            color: welcomeTextColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  // width: 310,
                  // height: MediaQuery.of(context).size.height,
                  color: drawerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
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
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "About Brew Buddy",
                          style: TextStyle(
                            fontSize: 20,
                            color: welcomeTextColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'DeLonghi Serif',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Brew Buddy is the global brand that offers consumers innovative products with a unique combination of style and experience coffee to performance.",
                          style: TextStyle(
                            fontSize: 14,
                            color: welcomeTextColor,
                            fontFamily: 'DeLonghi Sans',
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextButton(
                              // minWidth: 50,
                              onPressed: () {
                                // _show();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CoffeeMachines(
                                      authToken: authToken,
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    mainButtonColor),
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
                                "Browse all Coffee Machines",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'DeLonghi Sans',
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
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Container(
                            width: 500,
                            height: 3,
                            color: hr,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        buildMenuItem(
                          text: 'Home',
                          onClicked: () => selectedItem(context, 0),
                        ),
                        buildMenuItem(
                          text: 'Edit My Account',
                          onClicked: () => selectedItem(context, 1),
                        ),
                        buildMenuItem(
                          text: 'View My Promo Codes',
                          onClicked: () => selectedItem(context, 2),
                        ),
                        buildMenuItem(
                          text: 'How To Redeem my codes',
                          onClicked: () => selectedItem(context, 5),
                        ),
                        buildMenuItem(
                          text: 'Logout',
                          onClicked: () => selectedItem(context, 4),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    // required IconData icon,
    VoidCallback? onClicked,
  }) {
    return ListTile(
      // leading: Icon(
      //   icon,
      //   color: color,
      // ),
      title: Text(
        text,
        style: const TextStyle(
          // fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: welcomeTextColor,
          fontFamily: 'DeLonghi Sans',
        ),
      ),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    //Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DashboardScreen(authToken: authToken),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditProfile(
              authToken: authToken,
            ),
          ),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PromoCodes(
              authToken: authToken,
            ),
          ),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LogoutScreen(authToken: authToken),
          ),
        );
        break;
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RedeemCodes(authToken: authToken),
          ),
        );
        break;
    }
  }
}

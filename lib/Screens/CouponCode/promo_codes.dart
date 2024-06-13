import 'package:brew_buddy/Model/OrderModel.dart';
import 'package:brew_buddy/Screens/CouponCode/promo_qr.dart';
import 'package:brew_buddy/Screens/Dashboard/dashboard_screen.dart';
import 'package:brew_buddy/api/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Components/main_drawer.dart';
import '../../const.dart';
import '../auth/EditProfile/edit_profile.dart';

class PromoCodes extends StatefulWidget {
  final String authToken;
  const PromoCodes({super.key, required this.authToken});

  @override
  State<PromoCodes> createState() => _PromoCodesState(authToken: authToken);
}

class _PromoCodesState extends State<PromoCodes> {
  final String authToken;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _PromoCodesState({required this.authToken});

  AppRepository appRepo = AppRepository(authToken: "");

  List<OrderModel>? orders;
  bool isOrdersLoading = false;

  @override
  void initState() {
    appRepo = AppRepository(authToken: authToken);

    // TODO: implement initState
    super.initState();
    loadOrders();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void loadOrders() async {
    setState(() {
      isOrdersLoading = true;
    });

    try {
      List<OrderModel> loadedOrders = await appRepo.getMyOrders();

      setState(() {
        orders = loadedOrders;
        isOrdersLoading = false;
      });

      // print(email);
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        //isOrdersLoading = false;
      });
    }
  }

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
        body: SizedBox(
          height: size.height,
          child: Column(
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
                        text: "My Promo Codes ",
                        style: TextStyle(
                          fontSize: 25,
                          color: welcomeTextColor,
                          fontWeight: FontWeight.bold,
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
                height: 20,
              ),
              !isOrdersLoading
                  ? (orders!.isNotEmpty
                      ? Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ...List<Widget>.from(
                                  orders!.map((item) => promoCodeView(item)))
                            ],
                          ),
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 20.0,
                              left: 30.0,
                              right: 30.0,
                            ),
                            child: Text(
                              "Please select your favorite coffee and activate your promo code",
                              style: TextStyle(
                                fontSize: 18,
                                color: welcomeTextColor,
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'DeLonghi Sans',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  String statusString(int? orderStatus) {
    switch (orderStatus) {
      case 0:
        return "Pending";
      case 1:
        return "Redeemed";
      case 2:
        return "Canceled";
      default:
        return "";
    }
  }

  MaterialColor statusColor(int? orderStatus) {
    switch (orderStatus) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
      case 2:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget promoCodeView(OrderModel order) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PromoQR(
                  authToken: authToken,
                  order: order,
                ),
              ),
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding:
                const EdgeInsets.only(top: 15, right: 5, left: 5, bottom: 15),
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
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(1, 2), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 100.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF213861),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                        image: NetworkImage(
                          order.flavour?.image_url ?? "",
                        ),
                        fit: BoxFit.fill),
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 5,
                        color: Color.fromARGB(255, 43, 44, 47),
                        offset: Offset(1, 2), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Promo Code",
                            style: TextStyle(
                              fontSize: 18,
                              color: welcomeTextColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DeLonghi Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Selected Coffee \n",
                            style: TextStyle(
                              fontSize: 16,
                              color: howItWorkBtn,
                              fontFamily: 'DeLonghi Sans',
                            ),
                          ),
                          TextSpan(
                            text: order.flavour?.name,
                            style: const TextStyle(
                              fontSize: 18,
                              color: welcomeTextColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DeLonghi Serif',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(statusString(order.status)),
                      backgroundColor: statusColor(order.status),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 40.0,
                  width: 40.0,
                  decoration: const BoxDecoration(
                    color: promoArrow,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: welcomeTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

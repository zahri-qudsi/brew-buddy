import 'package:brew_buddy/Model/MachineModel.dart';
import 'package:brew_buddy/Model/OrderModel.dart';
import 'package:brew_buddy/Screens/CouponCode/redeem_code.dart';
import 'package:brew_buddy/Screens/Dashboard/dashboard_screen.dart';
import 'package:brew_buddy/api/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/main_drawer.dart';
import '../../const.dart';
import '../auth/EditProfile/edit_profile.dart';

class PromoQR extends StatefulWidget {
  final OrderModel order;
  final String authToken;
  const PromoQR({super.key, required this.order, required this.authToken});

  @override
  State<PromoQR> createState() =>
      _PromoQRState(authToken: authToken, order: order);
}

class _PromoQRState extends State<PromoQR> {
  final OrderModel order;
  final String authToken;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _PromoQRState({required this.order, required this.authToken});

  late LoopPageController _pageController;
  final int _currentPage = 0;
  String dataString = "";

  AppRepository appRepo = AppRepository(authToken: "");
  bool isMachinesLoading = false;
  List<MachineModel>? machines;

  @override
  void initState() {
    appRepo = AppRepository(authToken: authToken);

    loadMachines();
    // TODO: implement initState
    super.initState();
    _pageController =
        LoopPageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void loadMachines() async {
    setState(() {
      isMachinesLoading = true;
    });

    try {
      List<MachineModel> loadedMachines = await appRepo.getMachines();

      setState(() {
        machines = loadedMachines;
        isMachinesLoading = false;
      });

      // print(email);
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        isMachinesLoading = false;
      });
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      _showSnackBar('Could not open URL');
    }
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Center(
                        child: QrImageView(
                          data: order.orderNumber.toString(),
                          backgroundColor: welcomeTextColor,
                          size: 250,
                        ),
                      ),
                    ),
                    Text(
                      "Promo Code #${order.orderNumber}",
                      style: const TextStyle(
                        fontSize: 25,
                        color: welcomeTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DeLonghi Serif',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        width: 500,
                        height: 3,
                        color: hr,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50,
                        right: 50,
                        top: 25,
                        bottom: 25,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: welcomeTextColor,
                                  fontFamily: 'DeLonghi Sans',
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  order.store!.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: welcomeTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'DeLonghi Sans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Selected Coffee",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: welcomeTextColor,
                                  fontFamily: 'DeLonghi Sans',
                                ),
                              ),
                              Text(
                                order.flavour?.name ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: welcomeTextColor,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'DeLonghi Sans',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Promo Status",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: welcomeTextColor,
                                  fontFamily: 'DeLonghi Sans',
                                ),
                              ),
                              Chip(
                                labelPadding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                label: Text(
                                  statusString(order.status),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'DeLonghi Sans',
                                  ),
                                ),
                                backgroundColor: statusColor(order.status),
                                elevation: 6.0,
                                shadowColor: Colors.grey[60],
                                padding: const EdgeInsets.all(8.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 500,
                        height: 3,
                        color: hr,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RedeemCodes(
                              authToken: authToken,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "How to redeem your promo code",
                        style: TextStyle(
                          fontSize: 18,
                          color: howItWorkBtn,
                          decoration: TextDecoration.underline,
                          decorationColor: howItWorkBtn,
                          fontFamily: 'DeLonghi Sans',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Indulge yourself with the intense \n\n",
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFFbdc2c8),
                                fontFamily: 'DeLonghi Sans',
                              ),
                            ),
                            TextSpan(
                              text: "taste of freshly ground \n\n",
                              style: TextStyle(
                                fontSize: 25,
                                color: welcomeTextColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DeLonghi Serif',
                              ),
                            ),
                            TextSpan(
                              text: "coffee at home",
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFFbdc2c8),
                                fontFamily: 'DeLonghi Sans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.79,
                    child: isMachinesLoading
                        ? const SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: welcomeTextColor,
                              ),
                            ),
                          )
                        : LoopPageView.builder(
                            itemCount: machines!.length,
                            // physics: const ClampingScrollPhysics(),
                            controller: _pageController,
                            itemBuilder: (context, index) {
                              MachineModel machine = machines![index];
                              double cWidth =
                                  MediaQuery.of(context).size.width * 0.6;
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _launchInBrowser(
                                        Uri.parse(machine.link ?? ""));
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => DetailsScreen(data: data)));
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(35),
                                        topRight: Radius.circular(35),
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                      color: welcomeTextColor,
                                      // boxShadow: const [
                                      //   BoxShadow(
                                      //     offset: Offset(0, 4),
                                      //     blurRadius: 4,
                                      //     color: Colors.black26,
                                      //   ),
                                      // ],
                                    ),
                                    width: double.infinity,
                                    height: 400,
                                    // color: Colors.amber,
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(35),
                                          topRight: Radius.circular(35),
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(machine.image ?? ""),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: 300,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            // left: 0,
                                            // bottom: 0,
                                            top: 260,
                                            right: 25,
                                            child: GestureDetector(
                                              onTap: () async {
                                                _launchInBrowser(Uri.parse(
                                                    machine.link ?? ""));
                                              },
                                              child: const CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFF0e203f),
                                                radius: 30,
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            // bottom: 0,
                                            top: 330,
                                            // right: 100,
                                            child: GestureDetector(
                                              onTap: () async {},
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: cWidth,
                                                      child: Text(
                                                        machine.title ?? "",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily:
                                                              'DeLonghi Serif',
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      width: cWidth,
                                                      child: Text(
                                                        machine.description ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              'DeLonghi Sans',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // carouselButtons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

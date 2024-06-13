import 'dart:ui';
import 'package:brew_buddy/Components/main_drawer.dart';
import 'package:brew_buddy/Model/FlavourModel.dart';
import 'package:brew_buddy/Model/StoreModel.dart';
import 'package:brew_buddy/Model/UserModel.dart';
import 'package:brew_buddy/Screens/auth/EditProfile/edit_profile.dart';
import 'package:brew_buddy/Screens/auth/Register/register.dart';
import 'package:brew_buddy/api/app_repository.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loop_page_view/loop_page_view.dart';

import '../../const.dart';

class DashboardScreen extends StatefulWidget {
  final String authToken;

  const DashboardScreen({super.key, required this.authToken});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState(authToken: authToken);
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // late PageController _pageController;
  final String authToken;
  AppRepository appRepo = AppRepository(authToken: "");

  _DashboardScreenState({required this.authToken});

  LoopPageController pageController = LoopPageController();
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  final int _currentPage = 1;
  final pageCont = CarouselController();

  bool isStoresLoading = false;
  bool isFlavoursLoading = false;
  bool isUserLoading = false;
  final bool _autovalidate = false;

  List<FlavourModel>? flavours;
  List<StoreModel>? stores;
  UserModel? user;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  double scaleFactor = .8;
  double pageHeight = 230.0;

  String? selectedStore;
  StoreModel? selectedStoreModel;

  @override
  void initState() {
    appRepo = AppRepository(authToken: authToken);
    loadFlavours();
    loadStores();
    getUser();
    // TODO: implement initState
    super.initState();
    pageController = LoopPageController(
        initialPage: _currentPage, viewportFraction: 0.8, keepPage: true);
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getUser() async {
    setState(() {
      isUserLoading = true;
    });

    try {
      UserModel loadedUser = await appRepo.getProfile();

      setState(() {
        user = loadedUser;
        isUserLoading = false;
      });

      // print(email);
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        isUserLoading = false;
      });
    }
  }

  void loadStores() async {
    setState(() {
      isStoresLoading = true;
    });

    try {
      List<StoreModel> loadedStores = await appRepo.getStores();

      setState(() {
        stores = loadedStores;
        isStoresLoading = false;
      });

      // print(email);
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        isStoresLoading = false;
      });
    }
  }

  void loadFlavours() async {
    setState(() {
      isFlavoursLoading = true;
    });

    try {
      List<FlavourModel> loadedFlavours = await appRepo.getFlavours();

      setState(() {
        flavours = loadedFlavours;
        isFlavoursLoading = false;
      });

      // print(email);
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        isFlavoursLoading = false;
      });
    }
  }

  StoreModel? findSelectedStore(int id) =>
      stores?.firstWhere((store) => store.id == id);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
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
                    builder: (context) => DashboardScreen(authToken: authToken),
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
      body: isFlavoursLoading || isStoresLoading || isUserLoading
          ? const Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  color: welcomeTextColor,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                // autovalidateMode: _autovalidate,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: <Widget>[
                      isUserLoading ||
                              user!.firstName == null && isUserLoading ||
                              user!.firstName != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Welcome ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'DeLonghi Sans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user!.firstName ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'DeLonghi Sans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  " !",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'DeLonghi Sans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 0.85,
                            child: LoopPageView.builder(
                              itemCount: flavours!.length,
                              physics: const BouncingScrollPhysics(),
                              controller: pageController,
                              itemBuilder: (context, index) {
                                return carouselView(index);
                              },
                            ),
                          ),
                          carouselButtons(),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 25, right: 30, left: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                color: textFieldContainer,
                                borderRadius: BorderRadius.circular(50),
                                // border: Border.all(
                                //   color: welcomeTextColor,
                                //   width: 2,
                                // ),
                              ),
                              child: isStoresLoading
                                  ? const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: welcomeTextColor,
                                        ),
                                      ),
                                    )
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField(
                                        validator: (value) => value == null
                                            ? 'field required'
                                            : null,
                                        hint: const Text(
                                          "Select Outlet",
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                            color: welcomeTextColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        icon: const Visibility(
                                          visible: false,
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 30,
                                            color: welcomeTextColor,
                                          ),
                                        ),
                                        value: selectedStore,
                                        dropdownColor: hr,
                                        // isDense: false,
                                        // itemHeight: 50,
                                        items:
                                            stores?.map(buildMenuItem).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedStore = value.toString();
                                            selectedStoreModel =
                                                findSelectedStore(int.parse(
                                                    selectedStore ?? ""));
                                          });
                                        },

                                        isDense: true,
                                        isExpanded: true,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'DeLonghi Sans',
                                        ),
                                        decoration: const InputDecoration(
                                          // contentPadding: EdgeInsets.all(10.0),
                                          enabledBorder: InputBorder.none,
                                          suffixIcon: Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 30,
                                            color: welcomeTextColor,
                                          ),
                                          errorBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            isUserLoading
                                ? const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: welcomeTextColor,
                                      ),
                                    ),
                                  )
                                : TextButton(
                                    // minWidth: 360,
                                    // padding: const EdgeInsets.symmetric(
                                    //     vertical: 18, horizontal: 25),
                                    onPressed: () {
                                      bool limit = user!.limited ?? false;

                                      if (limit) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                limitReached());
                                      } else {
                                        if (_formKey.currentState!.validate()) {
                                          //form is valid, proceed further
                                          _formKey.currentState!
                                              .save(); //save once fields are valid, onSaved method invoked for every form fields

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Register(
                                                selectedFlavour: flavours?[
                                                    pageController.page
                                                        .roundToDouble()
                                                        .toInt()],
                                                selectedStore:
                                                    selectedStoreModel,
                                                authToken: authToken,
                                                user: user,
                                              ),
                                            ),
                                          );
                                        }
                                      }

                                      // updateProfile();
                                      // print('sending user');
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              mainButtonColor),
                                      padding: WidgetStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 18, horizontal: 25),
                                      ),
                                      foregroundColor:
                                          WidgetStateProperty.all<Color>(
                                              welcomeTextColor),
                                      shape: WidgetStateProperty.all(
                                          const StadiumBorder()),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: welcomeTextColor,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Claim your Coupon Code',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: 'DeLonghi Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // color: mainButtonColor,
                                    // shape: const StadiumBorder(),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        howItWorks());
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "How it works?",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: howItWorkBtn,
                                        decoration: TextDecoration.underline,
                                        fontFamily: 'DeLonghi Sans',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget carouselView(int index) {
    return carouselCard(flavours![index]);
  }

  Widget carouselCard(FlavourModel flavor) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Hero(
              tag: flavor.name ?? "",
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DetailsScreen(data: data)));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const RadialGradient(
                        colors: [
                          backgroundColor2,
                          backgroundColor2,
                          backgroundColor1,
                          backgroundColor,
                        ],
                        stops: [0.4, 0.5, 0.7, 1],
                        center: Alignment(0.1, 0.3),
                        focal: Alignment(-0.1, 0.6),
                      ),
                      image: DecorationImage(
                          image: NetworkImage(
                            flavor.image_url ?? "",
                          ),
                          fit: BoxFit.fill),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Colors.black26)
                      ]),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            flavor.name ?? "",
            style: const TextStyle(
              color: welcomeTextColor,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              fontFamily: 'DeLonghi Serif',
            ),
          ),
        ),
      ],
    );
  }

  void next() {
    pageCont.nextPage(duration: _kDuration, curve: _kCurve);
  }

  void previous() {
    pageCont.previousPage(duration: _kDuration, curve: _kCurve);
  }

  Widget carouselButtons() {
    return Positioned(
      top: 0.0,
      right: 10.0,
      left: 10.0,
      bottom: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              pageController.previousPage(duration: _kDuration, curve: _kCurve);
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                border: Border.all(
                  color: welcomeTextColor,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: welcomeTextColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              pageController.nextPage(duration: _kDuration, curve: _kCurve);
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                border: Border.all(
                  color: welcomeTextColor,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: welcomeTextColor,
              ),
            ),
          ),
        ],
      ), //Icon
    );
  }

  DropdownMenuItem<String> buildMenuItem(StoreModel store) {
    return DropdownMenuItem(
      value: store.id.toString(),
      child: Text(
        store.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'DeLonghi Sans',
        ),
      ),
    );
  }

  Widget limitReached() {
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
            const SizedBox(
              height: 300,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 120,
                  right: 20,
                  left: 20,
                  bottom: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "Sorry...",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: welcomeTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "You have reached the maximum limit of 4 cups. Hope you had a wonderful coffee time with Brew Buddy.",
                        style: TextStyle(
                          fontSize: 14,
                          color: welcomeTextColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    // SizedBox(
                    //   height: 30,
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -60,
              child: CircleAvatar(
                backgroundColor: const Color(0xFF233a67),
                radius: 80,
                child: Image.asset(
                  "assets/images/logo-1.png",
                  fit: BoxFit.cover,
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

  Widget howItWorks() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: const Color(0xFF0f1723),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;

            double avatarRadius =
                screenWidth * 0.2; // Adjust the radius based on screen width
            double dialogHeight = screenHeight *
                0.65; // Adjust dialog height based on screen height

            return Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: dialogHeight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: avatarRadius + 20,
                      right: 20,
                      left: 20,
                      bottom: 50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            "How it works",
                            style: TextStyle(
                              fontSize: screenWidth *
                                  0.06, // Adjust font size based on screen width
                              fontWeight: FontWeight.bold,
                              color: welcomeTextColor,
                              fontFamily: 'DeLonghi Serif',
                            ),
                          ),
                        ),
                        SizedBox(
                            height: screenHeight *
                                0.03), // Adjust space based on screen height
                        Center(
                          child: Text(
                            "Visit the pop up store in the location you have selected the redeemable coffee product and present your QR Code to our staff. They would verify the code and serve you the coffee.",
                            style: TextStyle(
                              fontSize: screenWidth *
                                  0.035, // Adjust font size based on screen width
                              color: welcomeTextColor,
                              fontFamily: 'DeLonghi Sans',
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(
                            height: screenHeight *
                                0.035), // Adjust space based on screen height
                        Center(
                          child: Text(
                            "if you have any questions please call us on +97 339 078 574",
                            style: TextStyle(
                              fontSize: screenWidth *
                                  0.04, // Adjust font size based on screen width
                              fontWeight: FontWeight.bold,
                              color: welcomeTextColor,
                              fontFamily: 'DeLonghi Sans',
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(
                            height: screenHeight *
                                0.04), // Adjust space based on screen height
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                mainButtonColor),
                            padding: WidgetStateProperty.all(
                              EdgeInsets.all(screenWidth *
                                  0.05), // Adjust padding based on screen width
                            ),
                            foregroundColor: WidgetStateProperty.all<Color>(
                                welcomeTextColor),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          child: Text(
                            "Coffee Time",
                            style: TextStyle(
                              fontSize: screenWidth *
                                  0.045, // Adjust font size based on screen width
                              fontFamily: 'DeLonghi Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -avatarRadius,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF233a67),
                    radius: avatarRadius,
                    child: Image.asset(
                      "assets/images/logo-1.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -avatarRadius,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: welcomeTextColor,
                      size: screenWidth *
                          0.1, // Adjust icon size based on screen width
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

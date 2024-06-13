import 'package:brew_buddy/Screens/Welcome/welcome.dart';
import 'package:brew_buddy/api/app_repository.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../const.dart';

class LogoutScreen extends StatefulWidget {
  final String authToken;

  const LogoutScreen({super.key, required this.authToken});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState(authToken: authToken);
}

class _LogoutScreenState extends State<LogoutScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // late PageController _pageController;
  final String authToken;
  AppRepository appRepo = AppRepository(authToken: "");

  _LogoutScreenState({required this.authToken});

  PageController pageController = PageController(viewportFraction: 0.85);
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  final int _currentPage = 1;
  final pageCont = CarouselController();

  bool isLogoutLoading = false;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  double scaleFactor = .8;
  double pageHeight = 230.0;

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void logout() async {
    try {
      bool status = await appRepo.logout({"action": "logout"});

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Welcome(),
        ),
      );

      // print(email);
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        //isOrdersLoading = false;
      });
    }
  }

  @override
  void initState() {
    appRepo = AppRepository(authToken: authToken);
    logout();
    // TODO: implement initState
    super.initState();
    pageController = PageController(
        initialPage: _currentPage, viewportFraction: 0.8, keepPage: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        body: isLogoutLoading
            ? const Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    color: welcomeTextColor,
                  ),
                ),
              )
            : const Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    color: welcomeTextColor,
                  ),
                ),
              ));
  }
}

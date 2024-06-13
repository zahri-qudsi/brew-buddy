import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../Components/main_drawer.dart';
import '../../../Components/text_field_container.dart';
import '../../../Model/FlavourModel.dart';
import '../../../Model/StoreModel.dart';
import '../../../Model/UserModel.dart';
import '../../../api/app_repository.dart';
import '../../../const.dart';
import '../../CouponCode/promo_codes.dart';
import '../../Dashboard/dashboard_screen.dart';
import '../EditProfile/edit_profile.dart';

class Register extends StatefulWidget {
  final FlavourModel? selectedFlavour;
  final StoreModel? selectedStore;
  final UserModel? user;
  final String authToken;

  const Register(
      {super.key,
      required this.selectedFlavour,
      required this.selectedStore,
      required this.user,
      required this.authToken});

  @override
  State<Register> createState() => _RegisterState(
      selectedFlavour: selectedFlavour,
      selectedStore: selectedStore,
      user: user,
      authToken: authToken);
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final FlavourModel? selectedFlavour;
  final StoreModel? selectedStore;
  final UserModel? user;
  final String authToken;

  AppRepository appRepo = AppRepository(authToken: "");

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();

  final panelController = PanelController();

  _RegisterState(
      {required this.selectedFlavour,
      required this.selectedStore,
      required this.user,
      required this.authToken});

  bool checkBoxValue = false;
  bool isLoading = false;
  bool formVisible = false;

  @override
  void initState() {
    appRepo = AppRepository(authToken: authToken);
    checkForm();
    // TODO: implement initState
    super.initState();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void checkForm() {
    if ((user?.firstName == null || user?.firstName?.length == 0) ||
        (user?.lastName == null || user?.lastName?.length == 0) ||
        (user?.email == null || user?.email?.length == 0)) {
      setState(() {
        formVisible = true;
      });
    }
  }

  placeOrder() async {
    if (formVisible) {
      if (firstName.text.isEmpty) {
        _showSnackBar("Please provide your first name");
        return false;
      }

      if (lastName.text.isEmpty) {
        _showSnackBar("Please provide your last name");
        return false;
      }

      if (email.text.isEmpty) {
        _showSnackBar("Please provide your email address");
        return false;
      }

      if (!checkBoxValue) {
        _showSnackBar("Terms & Conditions should be agreed");
        return false;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool orderStatus = await appRepo.placeOrder({
        "flavour_id": selectedFlavour?.id.toString(),
        "store_id": selectedStore?.id.toString(),
        "firstname": firstName.text,
        "lastname": lastName.text,
        "email": email.text
      });

      if (orderStatus) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PromoCodes(
              authToken: authToken,
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });

      // print(email);
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      // extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      body: SlidingUpPanel(
        maxHeight: formVisible ? 580 : 150,
        minHeight: 150,
        parallaxEnabled: true,
        controller: panelController,
        color: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(30),
                    gradient: const RadialGradient(
                      colors: [
                        backgroundColor2,
                        backgroundColor2,
                        backgroundColor1,
                        backgroundColor,
                      ],
                      stops: [0.4, 0.5, 0.7, 1],
                      // center: Alignment(0.1, 0.3),
                      focal: Alignment(-0.1, 0.6),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        selectedFlavour?.image_url ?? "",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Your Selection\n\n",
                      style: TextStyle(
                        fontSize: 16,
                        color: howItWorkBtn,
                        fontFamily: 'DeLonghi Sans',
                      ),
                    ),
                    TextSpan(
                      text: selectedFlavour?.name ?? "",
                      style: const TextStyle(
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
          ],
        ),
        panelBuilder: (ScrollController sc) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Color(0xFF062037),
              ),
              child: SingleChildScrollView(
                controller: sc,
                child: registerForm(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget registerForm() {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: formVisible ? 0 : 40.0,
              bottom: 40,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                if (formVisible)
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 30),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "\n\n\n Fill in the details below to claim your \nfree Coffee.",
                            style: TextStyle(
                                fontSize: 18,
                                color: welcomeTextColor,
                                fontFamily: 'DeLonghi Sans'
                                // fontWeight: FontWeight.bold,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                if (formVisible) firstnameField(),
                if (formVisible) lastnameField(),
                if (formVisible) emailAddressField(),
                if (formVisible)
                  Padding(
                    padding: const EdgeInsets.only(right: 0, left: 0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: checkBoxValue,
                          onChanged: (value) {
                            setState(() {
                              checkBoxValue = value!;
                            });
                          },
                          activeColor: Colors.grey,
                          focusColor: mainButtonColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          side: const BorderSide(
                            color: welcomeTextColor,
                            width: 2,
                          ),
                        ),
                        const Text(
                          "I Agree to the ",
                          style: TextStyle(
                            fontSize: 16,
                            color: welcomeTextColor,
                            fontFamily: 'DeLonghi Sans',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) =>
                                  termsConditions(),
                            );
                          },
                          child: const Text(
                            "Terms & Conditions",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontFamily: 'DeLonghi Sans',
                            ),
                          ),
                        ),
                        // RichText(
                        //   textAlign: TextAlign.center,
                        //   text: const TextSpan(
                        //     children: [
                        //       // TextSpan(
                        //       //   text:
                        //       // ),
                        //       TextSpan(
                        //         text:
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      user!.isDeleted == 0
                          ? isLoading
                              // ignore: prefer_const_constructors
                              ? SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: welcomeTextColor,
                                    ),
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    placeOrder();
                                    // _show();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            mainButtonColor),
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.all(20.0),
                                    ),
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                            welcomeTextColor),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    "Place Order",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'DeLonghi Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                          : const Text(
                              "Please Activate your account to place the order",
                              style: TextStyle(
                                fontSize: 16,
                                color: howItWorkBtn,
                                fontFamily: 'DeLonghi Sans',
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget firstnameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'First Name',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: welcomeTextColor,
          ),
        ),
        TextFieldContainer(
          child: TextFormField(
            controller: firstName,
            decoration: const InputDecoration(
              // hintText: 'First Name',
              fillColor: welcomeTextColor,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 18, color: welcomeTextColor),
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }

  Widget lastnameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Last Name',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: welcomeTextColor,
          ),
        ),
        TextFieldContainer(
          child: TextFormField(
            controller: lastName,
            decoration: const InputDecoration(
              // hintText: 'First Name',
              fillColor: welcomeTextColor,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 18, color: welcomeTextColor),
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }

  Widget contactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Number',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: welcomeTextColor,
          ),
        ),
        TextFieldContainer(
          child: TextFormField(
            // controller: _phoneController,
            autofillHints: const [AutofillHints.telephoneNumber],
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              // hintText: 'First Name',
              fillColor: welcomeTextColor,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 18, color: welcomeTextColor),
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }

  Widget emailAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: welcomeTextColor,
          ),
        ),
        TextFieldContainer(
          child: TextFormField(
            controller: email,
            decoration: const InputDecoration(
              // hintText: 'First Name',
              fillColor: welcomeTextColor,
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 18, color: welcomeTextColor),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (value) {
              if (value!.isEmpty) {
                return 'This field is required';
              }
              if (!value.contains('@')) {
                return "A valid email should contain '@'";
              }
              if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ).hasMatch(value)) {
                return "Please enter a valid email";
              }
              return null;
            },
            // onChanged: (value) =>
            //     context.read<SignupBloc>().add(SignupEmailChange(email: value)),
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
      ],
    );
  }

  Widget termsConditionPopup() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200.0),
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
                height: 455,
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 25,
                  right: 25,
                  bottom: 40,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Welcome to The Brew Buddy Coffee App!",
                            style: TextStyle(
                              color: welcomeTextColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            "\nTerms & Conditions",
                            style: TextStyle(
                              color: welcomeTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "These terms and conditions outline the rules and regulations for the use of The Brew Buddy Coffee App. By accessing this app we assume you accept these terms and conditions in full.\n\n",
                                  style: TextStyle(
                                    color: welcomeTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "1.	This offer / campaign can be used and avail only in The Kingdom of Bahrain by its Citizens and residence.\n",
                                  style: TextStyle(
                                    color: welcomeTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "2.	This offer / campaign can be used and avail only in given or specified locations in the app.\n",
                                  style: TextStyle(
                                    color: welcomeTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "3.	Person who has registered with CPR (Bahrain Combined ID) can avail four (4) coffees for 30 days or 1 month from the first use of the Brew Buddy Coffee App.\n",
                                  style: TextStyle(
                                    color: welcomeTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "4.	Person who can avail or re register four (4) times in the app and avail the coffee in given 30 days period.\n",
                                  style: TextStyle(
                                    color: welcomeTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "5.	Person who has registed in The Brew Buddy Coffee App will accept the terms of using personal information for Brew Buddy Bahrain’s future communication purpose.\n",
                                  style: TextStyle(
                                    color: welcomeTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: "6.	Promotion period\n",
                                  style: TextStyle(
                                    color: welcomeTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: "7.	Availing locations\n",
                                  style: TextStyle(
                                    color: welcomeTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const Text(
                          //   "These terms and conditions outline the rules and regulations for the use of The Brew Buddy Coffee App. By accessing this app we assume you accept these terms and conditions in full.\n",
                          //   style: TextStyle(
                          //     color: welcomeTextColor,
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w400,
                          //     // letterSpacing: 1.6,
                          //   ),
                          //   textAlign: TextAlign.left,
                          // ),
                        ],
                      ),
                    ),
                  ],
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
      ),
    );
  }

  Widget termsConditions() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: const Color(0xFF0f1723),
        child: buildChild(context),
      ),
    );
  }

  buildChild(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Positioned(
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.of(context).pop();
        //     },
        //     child: const Icon(
        //       Icons.close,
        //       color: welcomeTextColor,
        //       size: 40,
        //     ),
        //   ),
        //   top: -40,
        //   right: 0,
        // ),
        Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 25,
            right: 25,
            bottom: 30,
          ),
          child: Column(
            children: [
              const Text(
                "Welcome to The Brew Buddy Coffee App!",
                style: TextStyle(
                  color: welcomeTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "\nTerms & Conditions",
                style: TextStyle(
                  color: welcomeTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "These terms and conditions outline the rules and regulations for the use of The Brew Buddy Coffee App. By accessing this app we assume you accept these terms and conditions in full.\n\n",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text:
                          "1.	This offer / campaign can be used and avail only in The Kingdom of Bahrain by its Citizens and residence.\n\n",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text:
                          "2.	This offer / campaign can be used and avail only in given or specified locations in the app.\n\n",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text:
                          "3.	Person who has registered with CPR (Bahrain Combined ID) can avail four (4) coffees for 30 days or 1 month from the first use of the Brew Buddy Coffee App.\n\n",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text:
                          "4.	Person who can avail or re register four (4) times in the app and avail the coffee in given 30 days period.\n\n",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text:
                          "5.	Person who has registed in The Brew Buddy Coffee App will accept the terms of using personal information for Brew Buddy Bahrain’s future communication purpose.\n\n",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "6.	Promotion period\n\n",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "7.	Availing locations\n",
                      style: TextStyle(
                        color: welcomeTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () {
                      // _show();
                      Navigator.of(context).pop();
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
                      "Ok Got it",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'DeLonghi Sans',
                      ),
                    ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(50),
                    // ),
                    // color: mainButtonColor,
                    // textColor: welcomeTextColor,
                    // padding: const EdgeInsets.all(15),
                  ),
                ],
              ),
              // const Text(
              //   "These terms and conditions outline the rules and regulations for the use of The Brew Buddy Coffee App. By accessing this app we assume you accept these terms and conditions in full.\n",
              //   style: TextStyle(
              //     color: welcomeTextColor,
              //     fontSize: 16,
              //     fontWeight: FontWeight.w400,
              //     // letterSpacing: 1.6,
              //   ),
              //   textAlign: TextAlign.left,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

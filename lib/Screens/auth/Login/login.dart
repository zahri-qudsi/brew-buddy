import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Components/text_field_container.dart';
import '../../../api/app_repository.dart';
import '../../../const.dart';
import 'contact_verify.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final phoneNumber = TextEditingController();
  final tcCountryCode = TextEditingController(text: "+973");
  AppRepository appRepo = AppRepository(authToken: "");
  bool isLoading = false;

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(message),
            // InkWell(
            //   onTap: () {
            //     // Navigator.pop(context);
            //   },
            //   child: const Icon(
            //     Icons.close,
            //     color: Colors.white,
            //   ),
            // )
          ],
        ),
      ),
      backgroundColor: mainButtonColor,
      duration: const Duration(seconds: 10),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: backgroundColor,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      behavior: SnackBarBehavior.floating,
      // elevation: 1.0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void sendVerification() async {
    setState(() {
      isLoading = true;
    });

    try {
      var phone = phoneNumber.text;

      if (phone.isEmpty) {
        print('Phone number is empty');
        _showSnackBar("Phone number cannot be empty");
        setState(() {
          isLoading = false;
        });
        return;
      }

      print('Phone number to verify: $phone');

      bool status;
      try {
        status = await appRepo.verifyPhone({'phone': phone});
        print('Verification status: $status');
      } catch (e) {
        print('API call failed: $e');
        showSnackBar(
            "Your account has been deactivated. Please contact us to reactivate your account. \n\nEmail: support@digitrolly.com");
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        isLoading = false;
      });

      if (status) {
        print('Navigation to ContactVerify');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactVerify(
              phoneNumber: phone,
              appRepo: appRepo,
            ),
          ),
        );
      } else {
        print('Could not locate account');
        _showSnackBar("Could not locate your account");
      }
    } catch (e) {
      print('Exception caught: $e');
      showSnackBar(
          "Your account has been deactivated. Please contact us to reactivate your account. \n\nEmail: support@digitrolly.com");
      setState(() {
        isLoading = false;
      });
    }
  }

  // void login(BuildContext context) async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     var email = emailController.text;
  //     var password = passwordController.text;

  //     TokenModel userToken = await appRepo.login({
  //       'email': email,
  //       'password': password,
  //     });

  //     setState(() {
  //       isLoading = false;
  //     });
  //     _showSnackBar("Login successful");
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => DashboardScreen(
  //           authToken: userToken,
  //         ),
  //       ),
  //     );
  //     // print(email);
  //   } catch (e) {
  //     _showSnackBar("These credentials do not match our records.");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "Login to your account",
                  style: TextStyle(
                    fontSize: 25,
                    color: welcomeTextColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'DeLonghi Serif',
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "Your registered contact number",
                  style: TextStyle(
                    fontSize: 19,
                    color: welcomeTextColor,
                    // fontWeight: FontWeight.w500,
                    fontFamily: "DeLonghi Sans",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: countryCode(),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          child: contactField(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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
                        : loginButton()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget countryCode() {
    return TextFieldContainer(
      child: TextFormField(
        controller: tcCountryCode,
        enabled: false,
        autofillHints: const [AutofillHints.telephoneNumber],
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          // hintText: 'Contact Number',
          border: InputBorder.none,
          labelStyle: TextStyle(
            color: welcomeTextColor,
            fontSize: 18,
            fontFamily: 'DeLonghi Sans',
          ),
        ),
        style: const TextStyle(
          fontSize: 20.0,
          color: welcomeTextColor,
          fontFamily: 'DeLonghi Sans',
        ),
      ),
    );
  }

  Widget contactField() {
    return TextFieldContainer(
      child: TextFormField(
        controller: phoneNumber,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        autofillHints: const [AutofillHints.telephoneNumber],
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          // hintText: 'Contact Number',
          border: InputBorder.none,
          labelStyle: TextStyle(
            color: welcomeTextColor,
            fontSize: 18,
            fontFamily: 'DeLonghi Sans',
          ),
        ),
        style: const TextStyle(
          fontSize: 20.0,
          color: welcomeTextColor,
          fontFamily: 'DeLonghi Sans',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget loginButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          // minWidth: 360,
          // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          onPressed: () {
            sendVerification();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(mainButtonColor),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(welcomeTextColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          child: const Text(
            'Login with mobile number',
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

import 'package:brew_buddy/Model/UserModel.dart';
import 'package:brew_buddy/Screens/Dashboard/dashboard_screen.dart';
import 'package:brew_buddy/Screens/auth/EditProfile/delete_success.dart';
import 'package:brew_buddy/Screens/auth/Login/contact_verify.dart';
import 'package:brew_buddy/api/app_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Components/main_drawer.dart';
import '../../../Components/text_field_container.dart';
import '../../../const.dart';

class EditProfile extends StatefulWidget {
  final String authToken;
  const EditProfile({super.key, required this.authToken});

  @override
  State<EditProfile> createState() => _EditProfileState(authToken: authToken);
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final String authToken;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();

  _EditProfileState({required this.authToken});

  AppRepository appRepo = AppRepository(authToken: "");

  UserModel? user;
  bool isUserLoading = false;
  bool isProfileUpdating = false;
  bool isProfileDeleting = false;
  bool _isShown = false;

  int isDeleted = 0;

  @override
  void initState() {
    appRepo = AppRepository(authToken: authToken);

    getUser();
    // TODO: implement initState
    super.initState();
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

      firstName.text = loadedUser.firstName ?? "";
      lastName.text = loadedUser.lastName ?? "";
      phone.text = loadedUser.phone ?? "";
      email.text = loadedUser.email ?? "";

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

  void updateProfile() async {
    setState(() {
      isProfileUpdating = true;
    });

    try {
      bool status = await appRepo.updateProfile({
        "firstname": firstName.text,
        "lastname": lastName.text,
        "phone": phone.text,
        "email": email.text
      });

      setState(() {
        isProfileUpdating = false;
      });

      getUser();
      _showSnackBar("Your Profile Updated");
      // print(email);
    } catch (e) {
      _showSnackBar("");

      setState(() {
        isProfileUpdating = false;
      });
    }
  }

  void deleteProfile() async {
    setState(() {
      isProfileDeleting = true;
    });

    try {
      bool status = await appRepo.deleteProfile({
        "firstname": firstName.text,
        "lastname": lastName.text,
        "phone": phone.text,
        "email": email.text
      });

      setState(() {
        isProfileDeleting = false;
      });

      getUser();
      // _showSnackBar("Your Profile Deleted");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DeleteSuccess(
            authToken: authToken,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isProfileDeleting = false;
      });
    }
  }

  void activateProfile() async {
    setState(() {
      isProfileDeleting = true;
    });

    try {
      bool status = await appRepo.deleteProfile({
        "firstname": firstName.text,
        "lastname": lastName.text,
        "phone": phone.text,
        "email": email.text
      });

      setState(() {
        isProfileDeleting = false;
      });

      getUser();
      // _showSnackBar("Your Profile Deleted");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(authToken: authToken),
        ),
      );
    } catch (e) {
      setState(() {
        isProfileDeleting = false;
      });
    }
  }

  void deleteAccount(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'Are you sure you want to Delete your account? This action is not reversible.',
            ),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () {
                  setState(() {
                    _isShown = false;
                    isProfileDeleting = true;
                    deleteProfile();
                    Navigator.of(context).pop();
                  });
                },
                isDefaultAction: true,
                isDestructiveAction: true,
                child: const Text('Yes'),
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                isDefaultAction: false,
                isDestructiveAction: false,
                child: const Text('No'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                // onTap: () => _scaffoldKey.currentState?.openDrawer(),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Edit My Details",
                style: TextStyle(
                  fontSize: 25,
                  color: welcomeTextColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'DeLonghi Serif',
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
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30),
              child: isUserLoading
                  ? const Center(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: welcomeTextColor,
                          ),
                        ),
                      ),
                    )
                  : profileUpdateform(),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileUpdateform() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            firstnameField(),
            lastnameField(),
            contactField(),
            emailAddressField(),
            isProfileUpdating
                ? const SizedBox(
                    width: 80,
                    height: 80,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: welcomeTextColor,
                      ),
                    ),
                  )
                : saveInfoButton(),
            const SizedBox(
              height: 10,
            ),
            // isProfileDeleting
            //     ? Container(
            //         width: 80,
            //         height: 80,
            //         child: const Center(
            //           child: CircularProgressIndicator(
            //             color: welcomeTextColor,
            //           ),
            //         ),
            //       )
            //     : deleteAccButton(),
            if (user!.isDeleted == 1) activateAccButton() else deleteAccButton()
          ],
        ),
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
            fontFamily: 'DeLonghi Sans',
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
            style: const TextStyle(
              fontSize: 18,
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
        ),
        const SizedBox(
          height: 20,
        ),
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
            fontFamily: 'DeLonghi Sans',
          ),
        ),
        TextFieldContainer(
          child: TextFormField(
            controller: lastName,
            decoration: const InputDecoration(
              // hintText: 'First Name',
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 18,
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
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget contactField() {
    // bool isPhone(String input) =>
    //     RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
    //         .hasMatch(input);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Number',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: welcomeTextColor,
            fontFamily: 'DeLonghi Sans',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: 160,
              decoration: BoxDecoration(
                color: textFieldContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: phone,
                autofillHints: const [AutofillHints.telephoneNumber],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 18,
                  color: welcomeTextColor,
                  fontFamily: 'DeLonghi Sans',
                ),
                // validator: (value) {
                //   if (value!.length == 0) {
                //     return 'Please enter mobile number';
                //   } else if (!isPhone(value)) {
                //     return 'Please enter valid mobile number';
                //   }
                //   return null;
                // },
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: welcomeTextColor),
                backgroundColor: verifiedButton,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ContactVerify(
                      phoneNumber: user?.phone ?? "",
                      appRepo: appRepo,
                    ),
                  ),
                )
              },
              icon: Icon(
                Icons.check_circle,
                color: user?.verified == 1 ? Colors.green : Colors.grey,
              ),
              label: const Text(
                'Verified',
                style: TextStyle(
                  fontSize: 18,
                  color: welcomeTextColor,
                  fontFamily: 'DeLonghi Sans',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
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
            fontFamily: 'DeLonghi Sans',
          ),
        ),
        TextFieldContainer(
          child: TextFormField(
            controller: email,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 18,
              color: welcomeTextColor,
              fontFamily: 'DeLonghi Sans',
            ),
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
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget saveInfoButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          // minWidth: 360,
          // padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              updateProfile();
            }
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
            'Save',
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

  Widget deleteAccButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          // minWidth: 360,
          // padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
          onPressed: () async {
            // if (_formKey.currentState!.validate()) {
            //   updateProfile();
            // }
            deleteAccount(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(welcomeTextColor),
            shape: WidgetStateProperty.all(
              const StadiumBorder(),
            ),
          ),
          child: const Text(
            'Delete Acccount',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'DeLonghi Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          // color: Colors.red,
          // shape: const StadiumBorder(),
        ),
      ],
    );
  }

  Widget activateAccButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          // minWidth: 360,
          // padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
          onPressed: () async {
            // if (_formKey.currentState!.validate()) {
            //   updateProfile();
            // }
            activateProfile();

            _showSnackBar('Your account has been activated');
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
            ),
            foregroundColor: WidgetStateProperty.all<Color>(welcomeTextColor),
            shape: WidgetStateProperty.all(
              const StadiumBorder(),
            ),
          ),
          child: const Text(
            'Activate Acccount',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'DeLonghi Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          // color: Colors.green,
          // shape: const StadiumBorder(),
        ),
      ],
    );
  }
}

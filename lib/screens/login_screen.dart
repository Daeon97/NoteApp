import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:note_app/database/database.dart';
import 'package:note_app/screens/home_screen.dart';
import 'package:note_app/style/app_style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int screenState = 0;

  String otpPin = "";
  String countryDial = "+91";
  String verId = "";

  final _formKey = GlobalKey<FormState>();

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 30),
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Authentication completed", Colors.green);
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Authentication failed", Colors.red);
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP sent", Colors.green);
        verId = verificationId;
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("Timeout", Colors.red);
        setState(() {
          screenState = 0;
        });
      },
    );
  }

  Future<void> verifyOTP() async {
    await FirebaseAuth.instance
        .signInWithCredential(
          PhoneAuthProvider.credential(verificationId: verId, smsCode: otpPin),
        )
        .then((user) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (c) => const HomeScreen(),
            ),
            (route) => false))
        .catchError((e) => showSnackBarText('Invalid OTP!', Colors.red));
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          screenState = 0;
        });
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppStyle.mainColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppStyle.mainColor,
          title: Text(
            'Log in',
            style: AppStyle.appBarText,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              screenState == 0 ? stateRegister() : stateOTP(),
              GestureDetector(
                onTap: () async {
                  if (screenState == 0) {
                    if (_formKey.currentState!.validate()) {
                      // create an instance of our database
                      var database = DataBase();

                      // check if the user phone number exists
                      var userQueryDocumentSnapshot = await database.userExists(
                        mobileNumber: phoneController.text,
                      );
                      
                      if (userQueryDocumentSnapshot != null) {
                        // if the user phone number exists then check if the username matches
                        final userNameMatches = await database.userNameMatches(
                          queryDocumentSnapshot: userQueryDocumentSnapshot,
                          userName: usernameController.text,
                        );

                        if (userNameMatches) {
                          // if the username matches proceed to the rest of the auth flow
                          verifyPhone(countryDial + phoneController.text);
                        } else {
                          // if the username does not match, throw an error to the user
                          showSnackBarText(
                            'Incorrect username. Please enter a correct username',
                            Colors.red,
                          );
                        }
                      } else {
                        // if the user phone number does not exist check if the username has been taken
                        var userNameTaken = await database.userNameTaken(
                          mobileNumber: phoneController.text,
                          userName: usernameController.text,
                        );

                        if (userNameTaken) {
                          // if the user name is taken throw an error to the user
                          showSnackBarText(
                            'Username already taken. Please enter a different username',
                            Colors.red,
                          );
                        } else {
                          // if the user name is not taken proceed to the rest of the auth flow
                          verifyPhone(countryDial + phoneController.text);
                        }
                      }
                    }
                  } else {
                    if (otpPin.length >= 6) {
                      // create an instance of our database
                      var database = DataBase();

                      // check if the user phone number exists
                      // this is necessary so we do not add the user to the database twice

                      // if you remove this check and just call database.addUser
                      // the user will be duplicated in the database which is
                      // something we do not want
                      var userQueryDocumentSnapshot = await database.userExists(
                        mobileNumber: phoneController.text,
                      );
                      
                      if (userQueryDocumentSnapshot != null) {
                        // if the user exist in the database already then verify the OTP
                        verifyOTP();
                      } else {
                        // if the user does not exist in the database then add the user to the database
                        database
                            .addUser(
                          mobileNumber: phoneController.text,
                          userName: usernameController.text,
                        )
                            .then((value) {
                          log('added number');
                          // verify the OTP after adding the user to the database
                          verifyOTP();
                        });
                      }
                    } else {
                      showSnackBarText('Enter OTP correctly!', Colors.red);
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue[300],
                  ),
                  child: const Center(
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6),
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

  Widget stateRegister() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Username',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
          ),
          TextFormField(
            controller: usernameController,
            validator: (name) {
              if (name!.isEmpty) {
                return 'Name cannot be empty';
              } else if (name.startsWith(RegExp(
                  r'''[ +×÷=/_€£¥₩;'`~\°•○●□■♤♡◇♧☆▪︎¤《》¡¿!@#$%^&*(),.?":{}|<>]'''))) {
                return 'Name cannot start with special characters';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
                isDense: true),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Phone number',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
          ),
          IntlPhoneField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d+(?:-\d+)?$'),
              )
            ],
            controller: phoneController,
            validator: (value) {
              if (value!.number.isEmpty) {
                return 'Phone number cannot be empty';
              }
              return null;
            },
            initialValue: countryDial,
            showCountryFlag: false,
            showDropdownIcon: false,
            initialCountryCode: "IN",
            onCountryChanged: (newCountry) {
              setState(() {
                countryDial = "+${newCountry.dialCode}";
              });
            },
            decoration: InputDecoration(
              isDense: true,
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "We just sent a code to ", style: AppStyle.appBarText),
              TextSpan(
                  text: countryDial + phoneController.text,
                  style: AppStyle.blackText17),
              TextSpan(
                  text: "\nEnter the code here and we can continue!",
                  style: AppStyle.blackText14)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            textStyle: const TextStyle(color: Colors.black),
            onChanged: (value) {
              setState(() {
                otpPin = value;
              });
            },
            pinTheme:
                PinTheme(activeColor: Colors.black, inactiveColor: Colors.blue),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Didn't recieve the code ?   ",
                  style: AppStyle.blackText15),
              WidgetSpan(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    screenState = 0;
                  });
                },
                child: Text(
                  'Resend',
                  style: AppStyle.blackText14,
                ),
              ))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void showSnackBarText(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }
}

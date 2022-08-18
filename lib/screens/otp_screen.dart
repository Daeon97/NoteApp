// // ignore_for_file: must_be_immutable
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:note_app/screens/home_screen.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class OTPScreen extends StatefulWidget {
//   OTPScreen({
//     Key? key,
//     required this.phoneController,
//     required this.countryDial,
//     required this.otpPin,
//     required this.verId,
//   }) : super(key: key);
//   final TextEditingController phoneController;
//   final String countryDial;
//   String otpPin;
//   final String verId;
//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   Future<void> verifyOTP() async {
//     await FirebaseAuth.instance
//         .signInWithCredential(
//           PhoneAuthProvider.credential(
//               verificationId: widget.verId, smsCode: widget.otpPin),
//         )
//         .whenComplete(() => Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (c) => HomeScreen(),
//             ),
//             (route) => false));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       const TextSpan(
//                           text: "We just sent a code to ",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 15)),
//                       TextSpan(
//                           text:
//                               widget.countryDial + widget.phoneController.text,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 17)),
//                       const TextSpan(
//                           text: "\nEnter the code here and we can continue!",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14))
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                   ),
//                   child: PinCodeTextField(
//                     appContext: context,
//                     length: 6,
//                     textStyle: const TextStyle(color: Colors.white),
//                     onChanged: (value) {
//                       setState(() {
//                         widget.otpPin = value;
//                       });
//                     },
//                     pinTheme: PinTheme(
//                         activeColor: Colors.white, inactiveColor: Colors.blue),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       const TextSpan(
//                           text: "Didn't recieve the code ?   ",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 15)),
//                       WidgetSpan(
//                           child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text(
//                           'Resend',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                               color: Colors.white),
//                         ),
//                       ))
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//             GestureDetector(
//               onTap: () {
//                 if (widget.otpPin.length >= 4) {
//                   verifyOTP();
//                 } else {
//                   showSnackBarText('Enter OTP correctly!');
//                 }
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.blue[300],
//                 ),
//                 child: const Center(
//                   child: Text(
//                     'CONTINUE',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.6),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void showSnackBarText(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(text),
//       ),
//     );
//   }
// }

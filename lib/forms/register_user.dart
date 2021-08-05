// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:health_assistant/utils/validator.dart';
// import 'package:health_assistant/widgets/buttons.dart';
// import 'package:health_assistant/widgets/fields.dart';

// Widget registerPatientForm(BuildContext context) {
//   return Container(
//     child: Column(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width * 0.8,
//         ),
//         RegisterField(
//           hintText: 'Enter First Name',
//           keyBoardType: TextInputType.name,
//           validator: emptyFieldValidator,
//           icon: Icon(
//             Icons.verified_user,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter Last Name',
//           keyBoardType: TextInputType.name,
//           validator: emptyFieldValidator,
//           icon: Icon(
//             Icons.verified_user,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter Valid Password',
//           keyBoardType: TextInputType.visiblePassword,
//           validator: passwordValidator,
//           icon: Icon(
//             Icons.lock,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Confirm Password',
//           keyBoardType: TextInputType.visiblePassword,
//           validator: passwordValidator,
//           icon: Icon(
//             Icons.lock,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter Valid Email',
//           keyBoardType: TextInputType.emailAddress,
//           validator: emailValidator,
//           icon: Icon(
//             Icons.email_outlined,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter Phone Number',
//           keyBoardType: TextInputType.phone,
//           validator: emailValidator,
//           icon: Icon(
//             Icons.phone,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         submitBtn(),
//       ],
//     ),
//   );
// }

// Widget registerDoctorForm(BuildContext context) {
//   return Container(
//     child: Column(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width * 0.8,
//         ),
//         RegisterField(
//           hintText: 'Enter First Name',
//           keyBoardType: TextInputType.name,
//           validator: emptyFieldValidator,
//           icon: Icon(
//             Icons.verified_user,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter Last Name',
//           keyBoardType: TextInputType.name,
//           onSaved: (String lastName) {
//             _lastName = lastName;
//           },
//           validator: emptyFieldValidator,
//           icon: Icon(
//             Icons.verified_user,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter Valid Password',
//           keyBoardType: TextInputType.visiblePassword,
//           validator: passwordValidator,
//           icon: Icon(
//             Icons.lock,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Confirm Password',
//           keyBoardType: TextInputType.visiblePassword,
//           validator: passwordValidator,
//           icon: Icon(
//             Icons.lock,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter Valid Email',
//           keyBoardType: TextInputType.emailAddress,
//           validator: emailValidator,
//           icon: Icon(
//             Icons.email_outlined,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter Phone Number',
//           keyBoardType: TextInputType.phone,
//           validator: emptyFieldValidator,
//           icon: Icon(
//             Icons.phone,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Practice',
//           keyBoardType: TextInputType.text,
//           validator: emptyFieldValidator,
//           icon: Icon(
//             Icons.local_hospital_outlined,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         RegisterField(
//           hintText: 'Enter 5 Digit License Number',
//           keyBoardType: TextInputType.number,
//           validator: emptyFieldValidator,
//           icon: Icon(
//             Icons.verified_outlined,
//             color: Colors.lightBlueAccent,
//           ),
//         ),
//         submitBtn(),
//       ],
//     ),
//   );
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_assistant/pages/user_details_page.dart';
import 'package:health_assistant/utils/validator.dart';
import 'package:health_assistant/widgets/fields.dart';
import 'package:path/path.dart';
import 'login_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterPage extends StatefulWidget {
  static const String id = 'register_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<String> labels = ['Register Patient', 'Register Doctor'];
  //int counter = 0;
  String validEmail, newUsersName;
  File imageFile;
  String url;
  TextEditingController emailField = TextEditingController();
  TextEditingController validPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Widget registerForm(BuildContext context) {
  //   switch (counter) {
  //     case 0:
  //       return (registerPatientForm(context));
  //     // case 1:
  //     //   return (registerDoctorForm(context));
  //     default:
  //       return Container(color: Colors.transparent);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Register Here",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade900,
                    fontSize: 20),
              ),
              leading: IconButton(
                key: Key('registerBackButton'),
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.pink.shade900,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ),
            body: Form(
              key: _formkey,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 75),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        Colors.amber.shade50,
                        Colors.pink.shade50,
                        Colors.purple.shade100
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      registerPatientForm(context),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget registerPatientForm(BuildContext context) {
    return Container(
        height: 600,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              Stack(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.pink.shade800,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.pink.shade100,
                        backgroundImage: imageFile == null
                            ? null
                            : FileImage(
                                imageFile,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: -5,
                      right: -25,
                      child: RawMaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(
                                      'Add a photo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink.shade900),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(children: [
                                        InkWell(
                                            onTap: () {
                                              _getFromCamera();
                                              Navigator.of(context).pop();
                                            },
                                            splashColor: Colors.pinkAccent,
                                            child: Row(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Icon(
                                                      Icons.camera,
                                                      color:
                                                          Colors.pink.shade900,
                                                    )),
                                                Text('Camera',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors
                                                            .pink.shade900,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ],
                                            )),
                                        InkWell(
                                            onTap: () {
                                              _getFromGallery();
                                            },
                                            splashColor: Colors.pinkAccent,
                                            child: Row(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Icon(
                                                      Icons.photo_album,
                                                      color:
                                                          Colors.pink.shade900,
                                                    )),
                                                Text('Gallery',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors
                                                            .pink.shade900,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ],
                                            )),
                                      ]),
                                    ));
                              });
                        },
                        elevation: 10,
                        fillColor: Colors.white,
                        child: Icon(
                          Icons.add_a_photo,
                          color: Color.fromARGB(255, 194, 1, 129),
                        ),
                        shape: CircleBorder(),
                      )),
                ],
              ),
              InputTextField(
                key: Key('registerUsernameField'),
                labelText: 'Full Name',
                hintText: 'Enter Full Name',
                obscureText: false,
                keyBoardType: TextInputType.name,
                validator: emptyFieldValidator,
                onSaved: (input) => newUsersName = input,
                icon: Icon(
                  Icons.verified_user,
                  color: Colors.pink.shade900,
                ),
              ),
              InputTextField(
                key: Key('registerEmailField'),
                labelText: 'Email',
                controller: emailField,
                hintText: 'Enter Valid Email',
                obscureText: false,
                keyBoardType: TextInputType.emailAddress,
                validator: emailValidator,
                onSaved: (input) => validEmail = input,
                icon: Icon(
                  Icons.email_outlined,
                  color: Colors.pink.shade900,
                ),
              ),
              InputTextField(
                key: Key('registerPasswordField'),
                labelText: 'Password',
                hintText: 'Enter Valid Password',
                obscureText: true,
                keyBoardType: TextInputType.text,
                validator: passwordValidator,
                onSaved: (input) => validPassword.text = input,
                controller: validPassword,
                icon: Icon(
                  Icons.lock,
                  color: Colors.pink.shade900,
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                          'Password must: \n\nConsist at least 6 characters \nConsist of 1 uppercase letter \nConsist 1 digit \nConsist 1 special character'))),
              InputTextField(
                key: Key('confirmPasswordField'),
                labelText: 'Confirm Password',
                hintText: 'Confirm Password',
                obscureText: true,
                keyBoardType: TextInputType.text,
                controller: confirmPassword,
                validator: (String value) {
                  if (value.isEmpty) return 'Field cannot Be Empty';
                  if (confirmPassword.text != validPassword.text)
                    return "Passwords Do Not Match";
                  else
                    return null;
                },
                onSaved: (value) => confirmPassword.text = value,
                icon: Icon(
                  Icons.lock,
                  color: Colors.pink.shade900,
                ),
              ),
              userDetailsBtn(context),
            ],
          ),
        ));
  }

  _getFromGallery() async {
    XFile pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }

  _getFromCamera() async {
    XFile pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }

  updateProfile() async {
    // Map<String, dynamic> map = Map();
    // if (imageFile != null) {
    //   String url = await uploadImage();
    //   map['profileImage'] = url;
    // }
    // map['userName'] = userName.text;

    final String url = await uploadImage();

    await FirebaseFirestore.instance
        .collection("images")
        .doc(emailField.text)
        .set({
      "url": url,
      "name": emailField.text,
    });
  }

  Future<String> uploadImage() async {
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(FirebaseAuth.instance.currentUser.uid +
            "_" +
            basename(imageFile.path))
        .putFile(imageFile);

    url = await taskSnapshot.ref.getDownloadURL();

    return taskSnapshot.ref.getDownloadURL();
  }

  Widget userDetailsBtn(BuildContext context) {
    return Container(
      alignment: FractionalOffset.bottomCenter,
      child: ElevatedButton(
        key: Key('userDetailsBtn'),
        onPressed: () {
          final formState = _formkey.currentState;
          if (formState.validate()) {
            formState.save();
            uploadImage();
            updateProfile();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        new UserDetailsPage(validEmail, confirmPassword.text)));
          } else
            return 'unsuccessfully registered user';
        },
        child: Text(
          'Next',
          style: TextStyle(fontSize: 20, color: Colors.white),
          key: Key('nextBtn'),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 70),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            primary: Colors.cyan),
      ),
    );
  }
}

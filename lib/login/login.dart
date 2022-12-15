// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:desktop/common/constant.dart';
import 'package:desktop/common/dialog.dart';
import 'package:desktop/controller/userController.dart';
import 'package:desktop/home/home.dart';
import 'package:desktop/model/permissionModel.dart';
import 'package:desktop/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final UserController userController = Get.put(UserController());
  UserModel user = UserModel();
  List<PermissionModel> permissions = [];

  bool isHoverAddNew = false;
  bool isHoverRefresh = false;
  bool isUsernameRequired = false;
  bool isPasswordRequired = false;
  bool isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    usernameController.text = "admin";
    passwordController.text = "admin";
    initLoad();
  }

  Future<void> initLoad() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> handleSubmitClick() async {
    try {
      print('handleSubmitClick');
      print(usernameController.text);
      print(passwordController.text);

      isUsernameRequired = usernameController.text == "";
      isPasswordRequired = passwordController.text == "";

      if (isUsernameRequired || isPasswordRequired) {
        setState(() {});
        return;
      }

      var bytes = convert.utf8.encode(passwordController.text);
      var digest = sha256.convert(bytes);
      var password = digest.toString();

      print(password);

      var body = convert.json.encode(
        {
          'username': usernameController.text,
          'password': password,
        },
      );

      var client = http.Client();
      var url = Uri.parse("$kUrl/user/auth");
      var resp = await client.post(url, headers: kHeader, body: body);
      print(resp.body);
      if (resp.statusCode == 200) {
        var tmp = userModelFromJson(resp.body);
        if (tmp.isNotEmpty) {
          user = tmp[0];
          userController.setUser(user);
          //get permission

          body = convert.json.encode(
            {
              'username': usernameController.text,
            },
          );

          client = http.Client();
          url = Uri.parse("$kUrl/permission/list");
          resp = await client.post(url, headers: kHeader, body: body);
          print(resp.body);
          if (resp.statusCode == 200) {
            var tmp2 = permissionModelFromJson(resp.body);
            userController.setPermission(tmp2);
            Get.offAll(HomePage());
          }
        } else {
          Dialogs.errorDialog(context, "Invalid username or password.");
        }
      }
    } catch (e) {
      print(e);
      Dialogs.errorDialog(context, kRuntimeErrorMessage);
    }
  }

  Widget showLoading() {
    return Container(
      color: kPrimaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Image.asset(
                      "assets/images/logo1.png",
                      fit: BoxFit.fill,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  ClipRRect(
                    child: Image.asset(
                      "assets/images/logo3.png",
                      fit: BoxFit.fill,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SpinKitFadingCircle(
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                "Loading, please wait...",
                // style: TextStyle(
                //   color: Colors.white,
                //   fontSize: 16.0,
                //   decoration: TextDecoration.none,
                // ),
                style: GoogleFonts.roboto(
                  fontSize: 20.0,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return showLoading();

    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: kPrimaryColor,
                child: Center(
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/images/logo1.png",
                      fit: BoxFit.fill,
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        // ignore: sort_child_properties_last
                        child: Image.asset(
                          "assets/images/logo2.png",
                          fit: BoxFit.fill,
                          width: 300,
                          height: 300,
                        ),
                        //borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Ready to Login",
                        textAlign: TextAlign.center,
                        style: kHeaderStyle(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Username",
                      textAlign: TextAlign.left,
                      style: kNormalText(false),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: formKey1,
                      child: TextFormField(
                        onFieldSubmitted: (value) => handleSubmitClick(),
                        textAlign: TextAlign.center,
                        controller: usernameController,
                        maxLines: 1,
                        maxLength: 100,
                        onChanged: (value) => {
                          setState(() {
                            isUsernameRequired = false;
                            isPasswordRequired = false;
                          })
                        },
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black),
                        decoration: InputDecoration(
                          counterText: "",
                          labelStyle: GoogleFonts.lato(color: Colors.grey),
                          hintStyle: GoogleFonts.lato(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: kSelectorColor),
                          ),
                        ),
                      ),
                    ),
                    if (isUsernameRequired)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                        child: kRequired(),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Password",
                      textAlign: TextAlign.left,
                      style: kNormalText(false),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: formKey2,
                      child: TextFormField(
                        onFieldSubmitted: (value) => handleSubmitClick(),
                        textAlign: TextAlign.center,
                        controller: passwordController,
                        maxLines: 1,
                        maxLength: 100,
                        obscureText: true,
                        onChanged: (value) => {
                          setState(() {
                            isUsernameRequired = false;
                            isPasswordRequired = false;
                          })
                        },
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black),
                        decoration: InputDecoration(
                          counterText: "",
                          labelStyle: GoogleFonts.lato(color: Colors.grey),
                          hintStyle: GoogleFonts.lato(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: kSelectorColor),
                          ),
                        ),
                      ),
                    ),
                    if (isPasswordRequired)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                        child: kRequired(),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => {},
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            child: Text(
                              "Forgot password?",
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 14,
                                  fontFeatures: [
                                    FontFeature.proportionalFigures()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => handleSubmitClick(),
                            onHover: (value) {
                              setState(() {
                                isHoverRefresh = value;
                              });
                            },
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Container(
                              width: 180,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isHoverRefresh
                                    ? Colors.deepOrangeAccent
                                    : kPrimaryColor,
                                border: Border.all(
                                  color: Colors.blueGrey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.key_rounded,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "SIGN IN",
                                      style: kButtonStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

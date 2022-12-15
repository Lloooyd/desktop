// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:desktop/common/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  final Function loadingCallback;
  const WelcomePage({
    Key? key,
    required this.loadingCallback,
  }) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Image.asset(
                    "assets/images/logo2.png",
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
                    "assets/images/logo1.png",
                    fit: BoxFit.fill,
                    width: 200,
                    height: 200,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "DOCUMENT REQUEST SYSTEM FOR REGISTRAR'S OFFICE OF",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 24,
                fontFeatures: [FontFeature.proportionalFigures()],
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ),
          Text(
            "PAMANTASAN NG LUNGSOD NG SAN PABLO",
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 24,
                fontFeatures: [FontFeature.proportionalFigures()],
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

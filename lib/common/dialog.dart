// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:ui';

import 'package:desktop/common/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 60.0,
            child: Center(
              child: Text(
                'Success',
                style: GoogleFonts.openSans(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          content: Text(
            body,
            style: GoogleFonts.openSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(kLightColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: () =>
                                Navigator.of(context).pop(DialogAction.cancel),
                            child: Text(
                              "No",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(kLightColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: () =>
                                Navigator.of(context).pop(DialogAction.yes),
                            child: Text(
                              "Yes",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.cancel;
  }

  static Future<DialogAction> confirmationDialog(
      BuildContext context, String title, String message) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 240,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        title,
                        style: GoogleFonts.openSans(
                          fontSize: 20.0,
                          color: kLightColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        message,
                        style: GoogleFonts.openSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kLightColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () => Navigator.of(context)
                                  .pop(DialogAction.cancel),
                              child: Text(
                                "No",
                                style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          SizedBox(
                            width: 120,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kLightColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(context).pop(DialogAction.yes),
                              child: Text(
                                "Yes",
                                style: GoogleFonts.openSans(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
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
              Positioned(
                top: -20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: const Icon(
                    Icons.question_mark_rounded,
                    size: 80.0,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return (action != null) ? action : DialogAction.cancel;
  }

  static Future<DialogAction> deleteDialog(
      BuildContext context, String message) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          bool isHoverNo = false;
          bool isHoverYes = false;

          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: 260,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kSelectorColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      height: 60.0,
                      child: Center(
                        child: Text(
                          'Delete',
                          style: GoogleFonts.openSans(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          message,
                          style: GoogleFonts.openSans(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () =>
                              {Navigator.of(context).pop(DialogAction.cancel)},
                          onHover: (value) {
                            setState(() {
                              isHoverNo = value;
                            });
                          },
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            width: 120,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isHoverNo
                                  ? Colors.deepOrangeAccent
                                  : kSelectorColor,
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
                                    Icons.cancel_rounded,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "No",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () =>
                              {Navigator.of(context).pop(DialogAction.yes)},
                          onHover: (value) {
                            setState(() {
                              isHoverYes = value;
                            });
                          },
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: Container(
                            width: 120,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isHoverYes
                                  ? Colors.deepOrangeAccent
                                  : kSelectorColor,
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
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "Yes",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });

    return (action != null) ? action : DialogAction.cancel;
  }

  static Future<DialogAction> successDialog(
      BuildContext context, String message) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 240,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Success',
                        style: GoogleFonts.openSans(
                          fontSize: 20.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        message,
                        style: GoogleFonts.openSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kLightColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () =>
                              Navigator.of(context).pop(DialogAction.yes),
                          child: Text(
                            "OK",
                            style: GoogleFonts.openSans(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80.0,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return (action != null) ? action : DialogAction.cancel;
  }

  static Future<DialogAction> infoDialog(
      BuildContext context, String message) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 240,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Info',
                        style: GoogleFonts.openSans(
                          fontSize: 20.0,
                          color: kLightColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        message,
                        style: GoogleFonts.openSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kLightColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () =>
                              Navigator.of(context).pop(DialogAction.yes),
                          child: Text(
                            "OK",
                            style: GoogleFonts.openSans(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: const Icon(
                    Icons.info,
                    size: 80.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return (action != null) ? action : DialogAction.cancel;
  }

  static Future<DialogAction> loadDialog(
      context, String title, String message) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              height: 200,
              width: 200,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitFadingCircle(
                          color: kPrimaryColor,
                          size: 75.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: Text(
                            title,
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                fontFeatures: [
                                  FontFeature.proportionalFigures()
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        if (message != "")
                          Center(
                            child: Text(
                              message,
                              style: kNormalText(false),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
    return (action != null) ? action : DialogAction.cancel;
  }

  static Future<DialogAction> errorDialog(
      BuildContext context, String message) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          bool isHoverOK = false;

          return AlertDialog(
            titlePadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: 260,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      height: 60.0,
                      child: Center(
                        child: Text(
                          'Error',
                          style: GoogleFonts.openSans(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          message,
                          style: GoogleFonts.openSans(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () =>
                          {Navigator.of(context).pop(DialogAction.cancel)},
                      onHover: (value) {
                        setState(() {
                          isHoverOK = value;
                        });
                      },
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isHoverOK
                              ? Colors.deepOrangeAccent
                              : kSelectorColor,
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
                                Icons.cancel_rounded,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "OK",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });

    return (action != null) ? action : DialogAction.cancel;
  }

  static Future<DialogAction> versionDialog(
      BuildContext context, String version) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 280,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Text(
                        'SLSU HRMIS',
                        style: GoogleFonts.openSans(
                          fontSize: 20.0,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "Version update required. Kindly contact CISA Personnel.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "Application Version: $version",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kLightColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () => {exit(0)},
                          child: Text(
                            "OK",
                            style: GoogleFonts.openSans(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: const Icon(
                    Icons.security_rounded,
                    size: 80.0,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return (action != null) ? action : DialogAction.cancel;
  }

  // static Future<DialogAction> mobileOtpDialog(
  //   BuildContext context,
  //   String mobile,
  //   String otp,
  // ) async {
  //   final action = await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         titlePadding: const EdgeInsets.all(0),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         content: Stack(
  //           clipBehavior: Clip.none,
  //           alignment: Alignment.topCenter,
  //           children: [
  //             SizedBox(
  //               height: 350,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: Column(
  //                   children: [
  //                     const SizedBox(
  //                       height: 60,
  //                     ),
  //                     Text(
  //                       'Verfication Code',
  //                       style: GoogleFonts.openSans(
  //                         fontSize: 20.0,
  //                         color: kPrimaryColor,
  //                         fontWeight: FontWeight.w700,
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 20,
  //                     ),
  //                     Text(
  //                       "A verification code has been sent to your mobile no.: $mobile",
  //                       textAlign: TextAlign.center,
  //                       style: GoogleFonts.openSans(
  //                         fontSize: 14.0,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 20,
  //                     ),
  //                     Pinput(
  //                       defaultPinTheme: kDefaultPinTheme,
  //                       focusedPinTheme: kDefaultPinTheme.copyDecorationWith(
  //                         border: Border.all(color: kPrimaryColor),
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       submittedPinTheme: kDefaultPinTheme.copyWith(
  //                         decoration: kDefaultPinTheme.decoration?.copyWith(
  //                           color: Color.fromRGBO(234, 239, 243, 1),
  //                         ),
  //                       ),
  //                       onCompleted: (pin) => {
  //                         {
  //                           if (pin != otp)
  //                             {
  //                               Get.snackbar(
  //                                 "CODE",
  //                                 "Invalid verification code",
  //                                 snackPosition: SnackPosition.BOTTOM,
  //                                 icon: Icon(
  //                                   Icons.error_rounded,
  //                                   color: Colors.red,
  //                                 ),
  //                               )
  //                             }
  //                           else
  //                             {Navigator.of(context).pop(DialogAction.yes)}
  //                         }
  //                       },
  //                       pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
  //                     ),
  //                     const SizedBox(
  //                       height: 20,
  //                     ),
  //                     SizedBox(
  //                       width: 120,
  //                       height: 50,
  //                       child: ElevatedButton(
  //                         style: ButtonStyle(
  //                           foregroundColor:
  //                               MaterialStateProperty.all<Color>(Colors.white),
  //                           backgroundColor:
  //                               MaterialStateProperty.all<Color>(kLightColor),
  //                           shape: MaterialStateProperty.all<
  //                               RoundedRectangleBorder>(
  //                             RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.0),
  //                             ),
  //                           ),
  //                         ),
  //                         onPressed: () =>
  //                             Navigator.of(context).pop(DialogAction.abort),
  //                         child: Text(
  //                           "Cancel",
  //                           style: GoogleFonts.openSans(
  //                             fontSize: 16.0,
  //                             color: Colors.white,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               top: -10,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(30.0),
  //                 child: const Icon(
  //                   Icons.lock_open_rounded,
  //                   size: 80.0,
  //                   color: kSelectorColor,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //   return (action != null) ? action : DialogAction.abort;
  // }
}

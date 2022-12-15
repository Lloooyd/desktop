// ignore_for_file: unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

const kLightColor = Color(0xff008037);
const kPrimaryColor = Color(0xff008037);
const kSelectorColor = kPrimaryColor;
const kHoverColor = Color.fromARGB(255, 187, 222, 251);

// const kRed = Color.fromARGB(215, 205, 120, 120);
// const kGreen = Color.fromARGB(215, 120, 205, 124);
// const kOrange = Color.fromARGB(255, 218, 187, 146);
// const kOrangeBorder = Color.fromARGB(255, 219, 166, 95);
// const kLightColor2 = Color.fromARGB(255, 84, 90, 107);
// const kBackgroundMenu = Color.fromARGB(255, 230, 230, 230);
// const kTextFillColor = Color.fromARGB(255, 147, 171, 184);
const kNoImage =
    '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E3XHY0Aed0V31xoHh+6maYStEWOSqPgZ+mOKi/4RfQP+fub/AL+f/WoA4Y9K9EvVMdhp0ZGGWAAj04FQQaJ4fsJluA7zshyqs2Rn6UXdy13cGRuB0UegoAgooooAKKKKAClpKWgAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigDGk8S2MN09vIk4KOUZtowMHGeucfhWzXCyWTX2q6oiZMkZkkQDuQ44/In8cV0Phu++16aIWP7y3wh91/h/wAPwoAtf2tB/a39nbJPO/vYG37u71z09qv1zH/M9f5/55Vu32oW2nxCS4k25ztUDJY+1AFqiuZbxeodglkSueCZcEj6YrY0/VrTUgRA5DgZaNxhgP8APp60AXqqahqEOm26zTK7Kz7AEAJzgnufardYPiz/AJBUX/Xcf+gtQAf8JZYf88rn/vlf8as2fiGxvZhCpeN2OFEgxuPsQT+tQ6FY2k2i28ktrA7ndlmjBJ+Y1leJ7G3tJoJYIxH5oYMqjC8Y5A7daAOworOfUHttBjvpF81/KRmGduSce3vWY/i2MRRlLUs7Al134C88DOOfWgDpKKp3upwafbLNcblL/djGCxPfvjj61ir4vUuoeyIXPJEuSB9MUAdNRVSLUI7nTmu7UGXCEiMfe3Afd+tVdI1pdVeVDCImjAIG/cWHfsOnH50AatQXt3HY2j3MoYomMhRzycf1qtq2qLpVukhjEjO+0Jv2nGOT0+n51FNqKv4fN9PZhlYAmBzkEbsDqPoelAFrT9Qh1K3aaFXVVfYQ4AOcA9j71brM0S7hvLJ5IbVLZRIVKJjBOBzwB6/pVO88U29vMY7eEz7Thn3bV/DrmgDforF07xHb30wgkjMErHC5bKn2z60t/r39n6kttNbYjbafN8z+E9TjHbn8qANmiquo3n2CwkufL8zZj5c4zkgdfxqLSdS/tS1afyvK2uUxu3dgfQetAF+isb+3t+s/2fDbeZ8+wyeZjGPvcEdufritmgAooooAKKKKACiiigAooooA5jRf+Rp1D/tp/wChioph/YHiNZgNtrP1wOAp6jp2POB2x61Lov8AyNOof9tP/QxWnr1h9v01ti5mi+dMDk+o6Z5Hb1xQBmf8z1/n/nlVbW2a98SR2krERK6RgKegbBJ+vP6Cq2gyPLr9qznJClenYIQP0Fa3iDSbma5S+s1y6r8wThsjkMPU9vXgUAb0dtDFbC3SJRCF27MZGP61yKqNK8WLDbZEZkVNpJPysBkfhnj6CrC+K7iKHyprQG4UFWYtt+b3XH5jP5VJo2l3k+pf2jqCMMfMvmdWbp07Afh2xQB09YPiz/kFRf8AXcf+gtW9WD4s/wCQVF/13H/oLUAZmnf2/wDYI/sX/Hvzs/1fqc9eeuamXQdT1G6WfUpQgzhvmBbaPQDgf/rNa/h3/kBW3/Av/QjWpQBla+qp4fnRFCqoQAAYAG4VneGLC2nspppoUlYybAJFDAAAHjP1/lWl4i/5AVz/AMB/9CFVfCf/ACCpf+u5/wDQVoAyNdkaTxGUdDMqFFWMcFhgHbxzySfzrSk1W4ltjbv4fnMJXbs+YDH/AHzxTfEOkztcrqFmrM/G9UzuBHRh+nT0+tQr4um8nDWiGXB+YOQue3H/ANegB3hiC8tr2ZZYJYonjyd8ZALAjHJHuaZGjaR4sCYxDO2FCqPuseBjsA38q19EfVJYWk1DAUn5AybX/HpgfhmqniqzElml2q/PE21jx90+vrzj8zQBU1zfqevwafGSAgAOQOCeSffjH5Vra+qp4fnRFCqoQAAYAG4Vm+GoHur651OVV5YgYH8ROTjuMD+dafiL/kBXP/Af/QhQBiWMjxeD75kOCZdvTsdoP6GotDvJbKKR4dLkuXZsGVM8Dj5eh+v5Vf0C1S98PXVs5wJJSM+hwuD+BqhbXd94cnkhmg3xO3QkgNgdVPTuM8enSgBNWF1qcyTLpFxDIBh2CMd/p2HSrniG3kl0myvJFPnKirL8mDyO/pg9vehNb1TU7uJLCARopG/PzL/wI44HHbnrW/e2pvNNltnKs7pjPKjd2P0z9aAOd1i8fUNN0uCNlklnwzdjvHy/gMlvyqXSZE0vWtRtpNsUIUuMnJwvIx6/KSfXiqPh2M3erQ+YQVtoyyqVB7/4tnNWvFMZt76G6iIVpY2jbCjnjBP4hsfhQAvheF7m+ub+b5mHAYp1ZjkkHsf/AIquqrM0G1Fro8IwN0g8xiCec9P0xWnQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQB//Z';

// const kUrl = 'https://api.irequest.site/api';
const kUrl = 'http://192.168.1.8:5000/api';

const kHeader = {
  "Content-type": "application/json",
  "Accept": "application/json",
  "Authorization": 'Basic aXJlcXVlc3Q6MXIzcXUzc3Q=',
};

const kNetworkErrorMessage =
    "Network error, please check your internet connection and try again.";
const kRuntimeErrorMessage = "Oops! Something went wrong.";

enum DialogAction { yes, cancel }

const kModules = ["", ""];

Widget kDatePickerTheme(context, child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: kSelectorColor, // header background color
        onPrimary: Colors.white, // header text color
        onSurface: kLightColor, // body text color
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: kLightColor, // button text color
        ),
      ),
    ),
    child: child!,
  );
}

TextStyle kNormalText(bool white) {
  if (white) {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFeatures: [FontFeature.proportionalFigures()],
      ),
    );
  } else {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        fontSize: 14,
        fontFeatures: [FontFeature.proportionalFigures()],
      ),
    );
  }
}

InputDecoration kTextInputDecoration() {
  return InputDecoration(
    counterText: "",
    labelStyle: GoogleFonts.lato(color: Colors.grey),
    hintStyle: GoogleFonts.lato(color: Colors.grey),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: kSelectorColor),
    ),
  );
}

TextStyle kHeaderStyle() {
  return GoogleFonts.roboto(
    textStyle: const TextStyle(
        color: kPrimaryColor,
        fontSize: 18,
        fontFeatures: [FontFeature.proportionalFigures()],
        fontWeight: FontWeight.w500),
  );
}

TextStyle kButtonStyle() {
  return GoogleFonts.roboto(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFeatures: [FontFeature.proportionalFigures()],
      fontWeight: FontWeight.w500,
    ),
  );
}

Future<String> kDatePicker(context) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    firstDate: DateTime.now().subtract(
      const Duration(
        days: (365 * 100),
      ),
    ),
    initialDate: DateTime.now(),
    lastDate: DateTime.now().add(
      const Duration(
        days: (365 * 100),
      ),
    ),
    builder: (context, child) {
      return kDatePickerTheme(context, child);
    },
  );

  if (pickedDate != null) {
    return DateFormat('yyyy-MM-dd').format(pickedDate);
  }
  return "";
}

Widget kLoading() {
  return Center(
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
                "Pls. wait...",
                style: GoogleFonts.lato(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget kRequired() {
  return Text(
    'Required field',
    style: GoogleFonts.roboto(
      textStyle: TextStyle(
          color: Colors.redAccent, fontSize: 14, fontStyle: FontStyle.italic),
    ),
  );
}

Widget kInvalidEmail() {
  return Text(
    'Invalid email format',
    style: GoogleFonts.roboto(
      textStyle: TextStyle(
          color: Colors.redAccent, fontSize: 14, fontStyle: FontStyle.italic),
    ),
  );
}

Widget kLabel(title) {
  return Text(
    '$title',
    style: GoogleFonts.roboto(
      textStyle: TextStyle(
          color: kLightColor, fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );
}

Widget kNoRecord(context) {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "NO RECORD",
              style: GoogleFonts.lato(
                fontSize: 18.0,
                color: kLightColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}

Widget kStatus(status) {
  if (status == 0) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        border: Border.all(
          color: kLightColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      width: 100,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.punch_clock,
            color: Colors.white,
            size: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Pending",
            style: GoogleFonts.lato(
              fontSize: 12.0,
              color: kLightColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  } else if (status == 1) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          color: kLightColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      width: 100,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Approved",
            style: GoogleFonts.lato(
              fontSize: 12.0,
              color: kLightColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  } else if (status == 2) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(
          color: kLightColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      width: 100,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Rejected",
            style: GoogleFonts.lato(
              fontSize: 12.0,
              color: kLightColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        border: Border.all(
          color: kLightColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      width: 100,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.punch_clock,
            color: Colors.white,
            size: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Pending",
            style: GoogleFonts.lato(
              fontSize: 12.0,
              color: kLightColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

InkWell kEditButton({required Function onTap}) {
  return InkWell(
    onTap: () => {onTap()},
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Icon(
        Icons.edit_outlined,
        color: Colors.orangeAccent,
        size: 25.0,
      ),
    ),
  );
}

InkWell kApprovedButton({required Function onTap}) {
  return InkWell(
    onTap: () => {onTap()},
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Icon(
        Icons.check_box_rounded,
        color: Colors.green,
        size: 25.0,
      ),
    ),
  );
}

InkWell kDeleteButton({required Function onTap}) {
  return InkWell(
    onTap: () => {onTap()},
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Icon(
        Icons.remove_circle_outlined,
        color: Colors.redAccent,
        size: 25.0,
      ),
    ),
  );
}

InkWell kPasswordButton({required Function onTap}) {
  return InkWell(
    onTap: () => {onTap()},
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Icon(
        Icons.lock_open_rounded,
        color: kPrimaryColor,
        size: 25.0,
      ),
    ),
  );
}

InkWell kImageButton({required Function onTap}) {
  return InkWell(
    onTap: () => {onTap()},
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Icon(
        Icons.image_rounded,
        color: kSelectorColor,
        size: 25.0,
      ),
    ),
  );
}

InkWell kPrinterButton({required Function onTap}) {
  return InkWell(
    onTap: () => {onTap()},
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Icon(
        Icons.print_rounded,
        color: Colors.green,
        size: 25.0,
      ),
    ),
  );
}

InkWell kViewButton({required Function onTap}) {
  return InkWell(
    onTap: () => {onTap()},
    highlightColor: Colors.transparent,
    focusColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Icon(
        Icons.file_download,
        color: kSelectorColor,
        size: 25.0,
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> list = <String>['','1st Year', '2nd Year', '3rd Year', '4th Year'];

class DropdownButtonWidget extends StatefulWidget {
  final String title; 
  final TextEditingController controller;
  const DropdownButtonWidget({super.key, required this.title, required this.controller});

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    const kLightColor = Color(0xff008037);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [ 
        Visibility(
          visible: false,
          child: TextFormField(
            controller: widget.controller,
            maxLines: 1,
            maxLength: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            widget.title,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: kLightColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: kLightColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(4))
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              isExpanded: true,
              onChanged: (String? value) {
                setState(() {
                  if(value != null ||value != "" ){
                    widget.controller.text = value as String;
                  }
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/services.dart';

import '../../export_files.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.icon,
    required this.text,
    required this.controller,
    this.onChanged ,
    this.inputFormatters,
    this.keyboardType
  });
  Widget icon;
  String text;
  TextEditingController controller;
List<TextInputFormatter>? inputFormatters;
  void Function(String)? onChanged;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        style: TextStyle(
          color: AppConstant.darkColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: AppConstant.primaryColor,
        showCursor: true,
        autofocus: false,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: icon,
          border: searchStyle(),
          focusedBorder: searchStyle(),
          enabledBorder: searchStyle(),
          hintText: text,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

searchStyle<Widget>() {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFFE4E4E4),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(6.r),
    ),
  );
}

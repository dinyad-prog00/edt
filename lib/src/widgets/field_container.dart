import 'package:flutter/material.dart';

Container fieldContainer(
    String text, IconData icon, bool obscure, TextInputType keyboardType,
    {Function(String?)? onSaved,
    Function(String?)? onChanged,
    TextEditingController? controller,
    String? Function(String?)? validator}) {
  return Container(
    margin: EdgeInsets.only(left: 20, right: 20),
    padding: EdgeInsets.only(left: 20, right: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Colors.grey[200],
      boxShadow: [
        BoxShadow(
            offset: Offset(0, 10), blurRadius: 50, color: Color(0xffEEEEEE))
      ],
    ),
    alignment: Alignment.center,
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      cursorColor: Colors.blueAccent,
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blueAccent),
          hintText: text,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none),
    ),
  );
}

import 'package:flutter/material.dart';

import '../theme/constants/colors.dart';
import 'custom_button.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key,required this.text,required this.onTapFunction}) : super(key: key);
  final String text;
  final Function() onTapFunction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.03),
      child: CustomButton(
        buttonColor: primaryColor,
          content: Text(
            text,
            style: TextStyle(fontSize: 16,color: Colors.white),
          ),
          onPressed: onTapFunction,
          width: MediaQuery.of(context).size.width*0.86),
    );
  }
}

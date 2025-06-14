import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../blocs/focus_node_cubit/focus_node_cubit.dart';
import '../../blocs/focus_node_cubit/focus_node_state.dart';
import '../theme/colors.dart';


class CustomTextInput extends StatefulWidget {
  const CustomTextInput(
      {super.key,
        required this.iconUrl,
        required this.focusNode,
        this.obscureText = false,
        required this.controller,
        required this.labelText});

  final String iconUrl;
  final String labelText;
  final FocusNode focusNode;
  final TextEditingController controller;
  final bool obscureText;

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<FocusNodeCubit, FocusNodeChanged>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
          child: SizedBox(
            height: size.height * 0.08,
            child: TextFormField(
              onTap: () {
                context.read<FocusNodeCubit>().focusNodeUpdated();
              },
              focusNode: widget.focusNode,
              controller: widget.controller,
              obscureText: widget.obscureText,
              cursorColor: primaryColor,
              decoration: InputDecoration(
                labelText: widget.labelText,
                icon: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.025),
                  child: SvgPicture.asset(
                    widget.iconUrl,
                    width: 15,
                    height: 15,
                    color: widget.focusNode.hasFocus
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.focusNode.hasFocus
                      ? primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/theme/colors.dart';
import 'package:smart_school/widgets/app_bar_image_widget.dart';
import 'package:smart_school/widgets/app_round_button_widget.dart';
import 'package:smart_school/widgets/app_text_field_widget.dart';
import 'package:smart_school/widgets/loading_widget.dart';

import '../blocs/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formState = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _obscurePassword = true;

  void _handleLogin() {
    if (formState.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final email = emailController.text;
      final password = passController.text;
      context.read<AuthBloc>().add(
        LoginEvent(email: email, password: password),
      );
      // debugPrint("name=$email,pass=$password");
    }
  }
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, "/home");
          } else if (state is LoginFailure) {
            emailController.clear();
            passController.clear();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Form(
          key: formState,
          child: Column(
            children: [
              AppBarImageWidget(),
              SizedBox(height: 30),
              // email
              AppTextFieldWidget(
                controller: emailController,
                hint: "   email",
                label: "name",
                validator: (value) {
                  if (value!.isEmpty ||
                      value.length > 20 ||
                      !value.contains("@")) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              // pass
              AppTextFieldWidget(
                controller: passController,
                hint: "   password",
                label: "password",
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please sure your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 60),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthChecking) {
                    return LoadingWidget();
                  }
                  return Align(
                    alignment: Alignment.center,
                    child: AppRoundButtonWidget(
                      title: "login",
                      onPress: () {
                        _handleLogin();
                      },
                      width: 200,
                      textColor: Colors.white,
                      backGroundColor: primaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

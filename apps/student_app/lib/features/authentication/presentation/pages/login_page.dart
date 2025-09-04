import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/constants/app_colors.dart';
import 'package:core/theme/constants/app_spacing.dart';

import '../blocs/auth_bloc.dart';
import '../widgets/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);
      
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            setState(() => _isLoading = false);
            Navigator.pushReplacementNamed(context, "/home");
          } else if (state is LoginFailure) {
            setState(() => _isLoading = false);
            ErrorSnackBarWidget.show(context: context, message: state.message);
          } else if (state is LogoutSuccess) {
            setState(() => _isLoading = false);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                ? [
                    AppColors.darkBackground,
                    AppColors.darkSurface,
                    AppColors.darkCardBackground,
                  ]
                : [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.white,
                    AppColors.secondary.withValues(alpha: 0.05),
                  ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppSpacing.xl3),
                      
                      // Header Section
                      const LoginHeaderWidget(),
                      
                      SizedBox(height: AppSpacing.xl5),
                      
                      // Login Form
                      LoginFormWidget(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        formKey: _formKey,
                      ),
                      
                      SizedBox(height: AppSpacing.xl3),
                      
                      // Login Button
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthChecking || _isLoading;
                          
                          return LoginButtonWidget(
                            onPressed: _handleLogin,
                            isLoading: isLoading,
                          );
                        },
                      ),
                      
                      SizedBox(height: AppSpacing.xl2),
                      
                      // Test Connection Button (for development)
                      if (const bool.fromEnvironment('DEBUG'))
                        TestConnectionButtonWidget(
                          onPressed: () {
                            Navigator.pushNamed(context, '/test-connection');
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

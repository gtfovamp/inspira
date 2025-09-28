import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_input_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool get _isFormValid {
    return _emailRegex.hasMatch(_emailController.text.trim()) &&
        _passwordController.text.length >= 6;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    setState(() {});
  }

  void _handleLogin(BuildContext context) {
    if (_isFormValid) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  void _navigateToRegister(BuildContext context) {
    context.go(AppRouter.register);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRouter.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(AppRouter.home);
            });
          }
          return Stack(
            children: [
              _buildMainContent(context, state),
              if (state is AuthLoading) const LoadingWidget(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, AuthState state) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                _buildTitle(),
                const SizedBox(height: 20),
                _buildForm(),
                const Spacer(),
                _buildButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Stack(
      children: [
        Text(
          'Вход',
          style: GoogleFonts.pressStart2p(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8924E7),
            shadows: [
              Shadow(
                color: const Color(0xFF8924E7),
                blurRadius: 20,
                offset: Offset.zero,
              ),
              Shadow(
                color: const Color(0xFF6A46F9),
                blurRadius: 30,
                offset: Offset.zero,
              ),
              Shadow(
                color: const Color(0xFF8924E7),
                blurRadius: 40,
                offset: Offset.zero,
              ),
            ],
          ),
        ),
        Text(
          'Вход',
          style: GoogleFonts.pressStart2p(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFEEEEEE),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        AuthInputField(
          label: 'e-mail',
          placeholder: 'Введите электронную почту',
          controller: _emailController,
          isValid: _emailRegex.hasMatch(_emailController.text.trim()),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        AuthInputField(
          label: 'Пароль',
          placeholder: 'Введите пароль',
          controller: _passwordController,
          isPassword: true,
          isValid: _passwordController.text.length >= 6,
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isFormValid ? () => _handleLogin(context) : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: _isFormValid ? null : const Color(0xFF87858F),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: _isFormValid
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF8924E7), Color(0xFF6A46F9)],
                      )
                    : null,
                color: _isFormValid ? null : const Color(0xFF87858F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Войти',
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: _isFormValid
                        ? const Color(0xFFEEEEEE)
                        : const Color(0xFF404040),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => _navigateToRegister(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEEEEEE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Регистрация',
              style: GoogleFonts.roboto(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF131313),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

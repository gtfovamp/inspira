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

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const RegistrationView(),
    );
  }
}

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _emailRegex.hasMatch(_emailController.text.trim()) &&
        _passwordController.text.length >= 6 &&
        _confirmPasswordController.text.length >= 6 &&
        _passwordController.text == _confirmPasswordController.text;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
    _confirmPasswordController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    setState(() {});
  }

  void _handleRegistration(BuildContext context) {
    if (_isFormValid) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingWidget();
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        _buildTitle(),
                        const SizedBox(height: 20),
                        _buildForm(),
                        const Spacer(),
                        _buildButtons(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Stack(
      children: [
        Text(
          'Регистрация',
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
          'Регистрация',
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
          label: 'Имя',
          placeholder: 'Введите ваше имя',
          controller: _nameController,
          isValid: _nameController.text.trim().isNotEmpty,
        ),
        const SizedBox(height: 20),
        AuthInputField(
          label: 'e-mail',
          placeholder: 'Ваша электронная почта',
          controller: _emailController,
          isValid: _emailRegex.hasMatch(_emailController.text.trim()),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 0.5,
          color: const Color(0xFF404040),
        ),
        const SizedBox(height: 20),
        AuthInputField(
          label: 'Пароль',
          placeholder: '8-16 символов',
          controller: _passwordController,
          isPassword: true,
          isValid: _passwordController.text.length >= 6,
        ),
        const SizedBox(height: 20),
        AuthInputField(
          label: 'Подтверждение пароля',
          placeholder: '8-16 символов',
          controller: _confirmPasswordController,
          isPassword: true,
          isValid:
              _confirmPasswordController.text.length >= 6 &&
              _passwordController.text == _confirmPasswordController.text,
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
            onPressed: _isFormValid ? () => _handleRegistration(context) : null,
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
                  'Зарегистрироваться',
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
        TextButton(
          onPressed: () => context.go(AppRouter.login),
          child: Text(
            'Уже есть аккаунт? Войти',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: const Color(0xFF8924E7),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

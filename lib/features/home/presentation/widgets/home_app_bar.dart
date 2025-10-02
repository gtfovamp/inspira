import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/app_router.dart';
import '../bloc/home_bloc.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF604490).withValues(alpha: 0.01),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF604490).withValues(alpha: 0.01),
            blurRadius: 68,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.inner,
          ),
          BoxShadow(
            color: const Color(0xFF604490).withValues(alpha: 0.5),
            blurRadius: 40,
            offset: const Offset(0, 1),
            blurStyle: BlurStyle.inner,
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: 10,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.logout,
                    color: Color(0xFFE94647),
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Галерея',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFEEEEEE),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  final result = await context.push<bool>('/image');
                  if (result == true && context.mounted) {
                    context.read<HomeBloc>().add(RefreshImagesEvent());
                  }
                },
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.format_paint,
                    color: Color(0xFFFFFFFF),
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: const Color(0xFF8924E7).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          title: Text(
            'Выход из аккаунта',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFEEEEEE),
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Вы уверены, что хотите выйти из аккаунта?',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFBBBBBB),
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF333333),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Отмена',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFEEEEEE),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.of(dialogContext).pop();
                      await _performLogout(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE94647),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Выйти',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8924E7),
          ),
        ),
      );

      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        Navigator.of(context).pop();
        context.go(AppRouter.login);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ошибка при выходе: ${e.toString()}',
              style: GoogleFonts.roboto(color: Colors.white),
            ),
            backgroundColor: const Color(0xFFE94647),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}
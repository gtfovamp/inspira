import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusBarWidget extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onSavePressed;
  final String title;

  const StatusBarWidget({
    super.key,
    required this.onBackPressed,
    required this.onSavePressed,
    required this.title,
  });

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
                onTap: onBackPressed,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
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
                onTap: onSavePressed,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: const Icon(
                    Icons.done,
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
}
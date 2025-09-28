import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthInputField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final bool isValid;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? errorText;

  const AuthInputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isPassword = false,
    this.isValid = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.errorText,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  Color get _borderColor {
    if (!widget.isValid && widget.controller.text.isNotEmpty) {
      return const Color(0xFFFF4444);
    }
    if (_isFocused) {
      return const Color(0xFF8924E7);
    }
    if (widget.isValid && widget.controller.text.isNotEmpty) {
      return const Color(0xFF4CAF50);
    }
    return const Color(0xFF87858F);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            border: Border.all(
              color: _borderColor,
              width: _isFocused ? 1.0 : 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 40,
                offset: const Offset(0, 1),
                blurStyle: BlurStyle.inner,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 0),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 0),
                spreadRadius: -3,
              ),
              if (_isFocused)
                BoxShadow(
                  color: const Color(0xFF8924E7).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/widget_cover.png'),
                fit: BoxFit.cover,
                opacity: 0.25,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: _isFocused
                          ? const Color(0xFF8924E7)
                          : const Color(0xFF87858F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _borderColor,
                          width: _isFocused ? 0.5 : 0.3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                _isFocused = hasFocus;
                              });
                            },
                            child: TextField(
                              controller: widget.controller,
                              obscureText: widget.isPassword
                                  ? _obscureText
                                  : false,
                              keyboardType: widget.keyboardType,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFEEEEEE),
                              ),
                              decoration: InputDecoration(
                                hintText: widget.placeholder,
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF87858F),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.isPassword)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF87858F),
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.errorText!,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFFF4444),
              ),
            ),
          ),
        if (widget.isValid &&
            widget.controller.text.isNotEmpty &&
            (widget.errorText == null || widget.errorText!.isEmpty))
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF4CAF50),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Корректно',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

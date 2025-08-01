import 'package:flutter/material.dart';
class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hint;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixIconPressed;

  const InputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hint,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onSuffixIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 57,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType ?? TextInputType.text,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $labelText';
              }
              return null;
            },
        decoration: InputDecoration(
          suffix: suffixIcon != null
              ? onSuffixIconPressed != null
                  ? IconButton(
                      onPressed: onSuffixIconPressed,
                      icon: Icon(suffixIcon),
                    )
                  : Icon(suffixIcon)
              : null,
          labelText: labelText,
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}

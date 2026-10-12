import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.onChanged,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final int maxLines;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: Theme.of(context).inputDecorationTheme.labelStyle),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: widget.obscureText ? _obscured : false,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction ??
              (widget.nextFocusNode != null
                  ? TextInputAction.next
                  : TextInputAction.done),
          onFieldSubmitted: (_) {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20)
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscured ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

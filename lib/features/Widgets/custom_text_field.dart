import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final void Function()? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final String? initialValue;
  final bool enabled;
  final String? errorText;
  final FocusNode? focusNode;
  final String? helperText;
  final int? maxLength;
  final bool showCounter;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final Iterable<String>? autofillHints;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final bool isRequired;
  final String? requiredErrorMessage;
  final Duration? debounceDuration;
  final bool showClearButton;
  final VoidCallback? onClear;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.contentPadding,
    this.autofocus = false,
    this.textInputAction,
    this.onSubmitted,
    this.initialValue,
    this.enabled = true,
    this.errorText,
    this.focusNode,
    this.helperText,
    this.maxLength,
    this.showCounter = false,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autofillHints,
    this.margin,
    this.width,
    this.isRequired = false,
    this.requiredErrorMessage = 'This field is required',
    this.debounceDuration,
    this.showClearButton = false,
    this.onClear,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  bool _showError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleOnChanged(String value) {
    if (widget.debounceDuration != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceDuration!, () {
        widget.onChanged?.call(value);
      });
    } else {
      widget.onChanged?.call(value);
    }

    if (_showError) {
      _validate(value);
    }
  }

  String? _validate(String? value) {
    String? error;

    if (widget.isRequired && (value == null || value.isEmpty)) {
      error = widget.requiredErrorMessage;
    } else if (widget.validator != null) {
      error = widget.validator!(value);
    }

    setState(() {
      _errorText = error ?? widget.errorText;
      _showError = error != null || widget.errorText != null;
    });

    return error;
  }

  Widget? _buildSuffixIcon() {
    final List<Widget> icons = [];

    if (widget.showClearButton && _controller.text.isNotEmpty && widget.enabled) {
      icons.add(
        IconButton(
          icon: const Icon(Icons.clear, size: 20),
          onPressed: () {
            _controller.clear();
            widget.onClear?.call();
            if (widget.onChanged != null) {
              widget.onChanged!('');
            }
            setState(() {
              _showError = false;
              _errorText = null;
            });
          },
        ),
      );
    }

    if (widget.suffixIcon != null) {
      icons.add(widget.suffixIcon!);
    }

    if (icons.isEmpty) return null;
    if (icons.length == 1) return icons.first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: widget.margin,
      child: TextFormField(
        controller: _controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: _handleOnChanged,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onSubmitted,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        validator: _validate,
        initialValue: widget.initialValue,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        textCapitalization: widget.textCapitalization,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        autofillHints: widget.autofillHints,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: widget.enabled ? AppColors.onBackground : AppColors.grey500,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText != null
              ? '${widget.labelText}${widget.isRequired ? '*' : ''}'
              : null,
          hintText: widget.hintText,
          suffixIcon: _buildSuffixIcon(),
          prefixIcon: widget.prefixIcon,
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _showError ? AppColors.error : AppColors.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _showError ? AppColors.error : AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          filled: true,
          fillColor: widget.enabled ? AppColors.surface : AppColors.grey200,
          labelStyle: GoogleFonts.poppins(
            color: _showError
                ? AppColors.error
                : AppColors.onSurfaceVariant,
            fontSize: 14,
          ),
          hintStyle: GoogleFonts.poppins(
            color: AppColors.onSurfaceVariant.withOpacity(0.6),
            fontSize: 14,
          ),
          errorText: _showError ? _errorText : null,
          errorStyle: GoogleFonts.poppins(
            color: AppColors.error,
            fontSize: 12,
          ),
          helperText: widget.helperText,
          helperStyle: GoogleFonts.poppins(
            color: AppColors.onSurfaceVariant.withOpacity(0.6),
            fontSize: 12,
          ),
          counter: widget.showCounter ? null : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safqaseller/core/utils/app_text_styles.dart';

/// A custom PIN input box widget for verification codes
///
/// Features:
/// - Single digit numeric input
/// - Visual error indication (red border)
/// - Auto-clearing error state on input
class CustomPinBox extends StatefulWidget {
  const CustomPinBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.validator,

    /// When null the box sizes itself using the default 60 dp (scaled).
    /// When a value is provided it is used as-is (already in logical pixels).
    this.size,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final double? size;

  @override
  State<CustomPinBox> createState() => _CustomPinBoxState();
}

class _CustomPinBoxState extends State<CustomPinBox> {
  // Constants
  static const double _defaultBoxSize = 60.0;
  static const double _borderWidth = 1.5;
  static const double _borderRadius = 12.0;
  static const Color _normalBorderColor = Color(0xFFE0E0E0);
  static const Color _errorBorderColor = Colors.red;

  // State
  bool _hasError = false;

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

  /// Clears error state when user starts typing
  void _onTextChanged() {
    if (_hasError && widget.controller.text.isNotEmpty) {
      setState(() {
        _hasError = false;
      });
    }
  }

  /// Updates error state based on validation result
  void _updateErrorState(bool hasError) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _hasError = hasError;
        });
      }
    });
  }

  String? _handleValidation(String? value) {
    final isEmpty = value == null || value.isEmpty;
    _updateErrorState(isEmpty);

    if (widget.validator != null) {
      return widget.validator!(value);
    }

    return isEmpty ? '' : null;
  }

  @override
  Widget build(BuildContext context) {
    // When size is explicit (from LayoutBuilder) use it as-is; otherwise scale the default.
    final double resolvedSize = widget.size ?? _defaultBoxSize.rSp(context);

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        border: Border.all(
          color: _hasError ? _errorBorderColor : _normalBorderColor,
          width: _borderWidth,
        ),
        borderRadius: BorderRadius.circular(_borderRadius.rSp(context)),
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyles.semiBold24(context),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          filled: false,
          contentPadding: EdgeInsets.zero,
          errorStyle: TextStyle(height: 0, fontSize: 0),
        ),
        onChanged: widget.onChanged,
        validator: _handleValidation,
      ),
    );
  }
}

// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isDisabled;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 50,
    this.isDisabled = false,
  });

  @override
  _SecondaryButtonState createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _handleTapCancel() {
    if (!widget.isDisabled) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isDisabled ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: widget.width ?? double.infinity,
        height: widget.height,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: widget.isDisabled ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 2),
          boxShadow: [
            if (!widget.isDisabled)
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
          ],
        ),
        transform: _isPressed
            ? (Matrix4.identity()..scale(0.95)) // Efeito de pressionado
            : Matrix4.identity(),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.isDisabled ? Colors.grey.shade600 : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto', // Substitua pela fonte desejada
            ),
          ),
        ),
      ),
    );
  }
}

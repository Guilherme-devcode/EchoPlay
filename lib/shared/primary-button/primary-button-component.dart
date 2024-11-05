// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isDisabled;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.isDisabled = false,
  });

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
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
      onTap: widget.isDisabled
          ? null
          : () {
              if (widget.onPressed != null) {
                widget.onPressed!();
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          gradient: widget.isDisabled
              ? const LinearGradient(
                  colors: [
                    Color(0xFFE0E0E0), // Cor cinza para estado desabilitado
                    Color(0xFFBEBEBE),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFFF5F5F),
                    Color(0xFFE03E3E),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!widget.isDisabled)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 3),
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
              color: widget.isDisabled ? Colors.grey.shade700 : Colors.white,
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

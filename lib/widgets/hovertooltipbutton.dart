import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:godey/const/constant.dart';

class HoverTooltipButton extends StatefulWidget {
  final Widget label;
  final String tooltip;
  final VoidCallback onPressed;

  const HoverTooltipButton({
    super.key,
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  State<HoverTooltipButton> createState() => _HoverTooltipButtonState();
}

class _HoverTooltipButtonState extends State<HoverTooltipButton> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  Timer? _timer;

  void _showTooltip() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context);
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: position.dx,
            top: position.dy + size.height + 8,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.tooltip,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _timer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onEnter(PointerEnterEvent event) {
    _timer = Timer(const Duration(seconds: 2), _showTooltip);
  }

  void _onExit(PointerExitEvent event) {
    _hideTooltip();
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          backgroundColor: cardBackgroundColor,
          foregroundColor: Colors.white,
        ),
        key: _key,
        onPressed: widget.onPressed,
        child: widget.label,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BoundingBoxWidget extends StatefulWidget {
  
  final Rect rect;
  final String label;
  final Function(Rect) onUpdate;
  final VoidCallback onTap;

  const BoundingBoxWidget({
    super.key,
    required this.rect,
    required this.label,
    required this.onUpdate,
    required this.onTap,
  });

  @override
  State<BoundingBoxWidget> createState() => _BoundingBoxWidgetState();
}

class _BoundingBoxWidgetState extends State<BoundingBoxWidget> {
  bool _hovering = false;

  Offset? _dragStart;
  Rect? _dragOriginalRect;

  Offset? _resizeStart;
  Rect? _resizeOriginalRect;

  // Drag handlers
  void _onDragStart(DragStartDetails details) {
    _dragStart = details.globalPosition;
    _dragOriginalRect = widget.rect;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_dragStart == null || _dragOriginalRect == null) return;

    final delta = details.globalPosition - _dragStart!;
    final newRect = _dragOriginalRect!.shift(delta);
    widget.onUpdate(newRect);
  }

  void _onDragEnd(DragEndDetails details) {
    _dragStart = null;
    _dragOriginalRect = null;
  }

  // Resize top-left handlers
  void _onResizeTopLeftStart(DragStartDetails details) {
    _resizeStart = details.globalPosition;
    _resizeOriginalRect = widget.rect;
  }

  void _onResizeTopLeftUpdate(DragUpdateDetails details) {
    if (_resizeStart == null || _resizeOriginalRect == null) return;

    final delta = details.globalPosition - _resizeStart!;
    final newLeft = _resizeOriginalRect!.left + delta.dx;
    final newTop = _resizeOriginalRect!.top + delta.dy;
    final newWidth = _resizeOriginalRect!.right - newLeft;
    final newHeight = _resizeOriginalRect!.bottom - newTop;

    if (newWidth > 20 && newHeight > 20) {
      final newRect = Rect.fromLTWH(newLeft, newTop, newWidth, newHeight);
      widget.onUpdate(newRect);
    }
  }

  void _onResizeTopLeftEnd(DragEndDetails details) {
    _resizeStart = null;
    _resizeOriginalRect = null;
  }

  // Resize bottom-right handlers
  void _onResizeBottomRightStart(DragStartDetails details) {
    _resizeStart = details.globalPosition;
    _resizeOriginalRect = widget.rect;
  }

  void _onResizeBottomRightUpdate(DragUpdateDetails details) {
    if (_resizeStart == null || _resizeOriginalRect == null) return;

    final delta = details.globalPosition - _resizeStart!;
    final newWidth = _resizeOriginalRect!.width + delta.dx;
    final newHeight = _resizeOriginalRect!.height + delta.dy;

    if (newWidth > 20 && newHeight > 20) {
      final newRect = Rect.fromLTWH(
        _resizeOriginalRect!.left,
        _resizeOriginalRect!.top,
        newWidth,
        newHeight,
      );
      widget.onUpdate(newRect);
    }
  }

  void _onResizeBottomRightEnd(DragEndDetails details) {
    _resizeStart = null;
    _resizeOriginalRect = null;
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.label.isEmpty
            ? Colors.red.withOpacity(_hovering ? 0.6 : 0.4)
            : Colors.green.withOpacity(_hovering ? 0.6 : 0.4);

    return Positioned(
      left: widget.rect.left,
      top: widget.rect.top,
      width: widget.rect.width,
      height: widget.rect.height,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          onPanStart: _onDragStart,
          onPanUpdate: _onDragUpdate,
          onPanEnd: _onDragEnd,
          child: Stack(
            children: [
              // Box with border
              Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: widget.label.isEmpty ? Colors.red : Colors.green,
                    width: 2,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      widget.label.isEmpty ? 'No label' : widget.label,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),

              // Resize top-left handle
              Positioned(
                left: 0,
                top: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: _onResizeTopLeftStart,
                  onPanUpdate: _onResizeTopLeftUpdate,
                  onPanEnd: _onResizeTopLeftEnd,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpLeft,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),

              // Resize bottom-right handle
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: _onResizeBottomRightStart,
                  onPanUpdate: _onResizeBottomRightUpdate,
                  onPanEnd: _onResizeBottomRightEnd,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeDownRight,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
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

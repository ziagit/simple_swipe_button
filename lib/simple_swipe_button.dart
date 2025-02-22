import 'package:flutter/material.dart';

class SimpleSwipeButton extends StatefulWidget {
  final String initialText;
  final String completedText;
  final Color backgroundColor;
  final Color swipedBackgroundColor;
  final Color buttonColor;
  final VoidCallback onSwipeComplete;

  const SimpleSwipeButton({
    super.key,
    required this.initialText,
    required this.completedText,
    required this.onSwipeComplete,
    this.backgroundColor = const Color(0xFFD3D3D3),
    this.swipedBackgroundColor = Colors.green,
    this.buttonColor = Colors.white,
  });

  @override
  State<SimpleSwipeButton> createState() => _SimpleSwipeButtonState();
}

class _SimpleSwipeButtonState extends State<SimpleSwipeButton> {
  double _dragPosition = 0.0;
  bool _isCompleted = false;
  double _maxDrag = 0.0;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition += details.delta.dx;
      _dragPosition = _dragPosition.clamp(0.0, _maxDrag);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragPosition > _maxDrag * 0.8) {
      setState(() {
        _dragPosition = _maxDrag;
        _isCompleted = true;
      });
      widget.onSwipeComplete();
    } else {
      setState(() {
        _dragPosition = 0.0;
        _isCompleted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonSize = 50;
        double containerHeight = 60;
        double buttonPadding = (containerHeight - buttonSize) / 2;

        _maxDrag = constraints.maxWidth - buttonSize - buttonPadding * 2;

        return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background that changes dynamically while swiping
              Container(
                height: containerHeight,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: _isCompleted
                        ? [
                            widget.swipedBackgroundColor,
                            widget.swipedBackgroundColor
                          ]
                        : [
                            _dragPosition > 0
                                ? widget.swipedBackgroundColor
                                : widget.backgroundColor,
                            widget.backgroundColor,
                          ],
                    stops: _isCompleted
                        ? [1.0, 1.0]
                        : [
                            (_dragPosition / _maxDrag).clamp(0.0, 1.0),
                            (_dragPosition / _maxDrag).clamp(0.0, 1.0) + 0.1,
                          ],
                  ),
                ),
              ),
              // Text that changes after swipe
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      _isCompleted ? widget.completedText : widget.initialText,
                      key: ValueKey<bool>(
                          _isCompleted), // Ensures proper text change animation
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // Swipe button
              Positioned(
                left: _dragPosition + buttonPadding,
                child: GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Container(
                    width: buttonSize,
                    height: buttonSize,
                    decoration: BoxDecoration(
                      color: widget.buttonColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.arrow_forward, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

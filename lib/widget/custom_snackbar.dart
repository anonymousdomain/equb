import 'package:flutter/material.dart';

class CustomSnackBar extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final Duration duration;

  const CustomSnackBar({
    super.key,
    required this.message,
    required this.isSuccess,
    this.duration = const Duration(seconds: 4),
  });

 @override
  State<CustomSnackBar> createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animationOpacity;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animationOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );

    _animationController?.forward();

    Future.delayed(widget.duration).then((value) {
      if (!_isDismissing) {
        _animationController?.reverse();
        _animationController?.addStatusListener((status) {
          if (status == AnimationStatus.dismissed) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _isDismissing = true;
    _animationController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationOpacity!,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSuccess ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.isSuccess ? Icons.check : Icons.error,
              color: Theme.of(context).textTheme.headline1!.color,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.message,
                style: TextStyle(color: Theme.of(context).textTheme.headline1!.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

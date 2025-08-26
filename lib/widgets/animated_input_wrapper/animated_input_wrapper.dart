import 'package:flutter/material.dart';

class AnimatedInputWrapper extends StatefulWidget {
  final Widget child;
  final int delayMilliseconds;

  const AnimatedInputWrapper({
    super.key,
    required this.child,
    this.delayMilliseconds = 0,
  });

  @override
  State<AnimatedInputWrapper> createState() => _AnimatedInputWrapperState();
}

class _AnimatedInputWrapperState extends State<AnimatedInputWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(opacity: _controller, child: widget.child),
    );
  }
}

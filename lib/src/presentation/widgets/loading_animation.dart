import 'package:flutter/material.dart';

class ChatLoadingAnimation extends StatefulWidget {
  final Color color;
  final double size;

  const ChatLoadingAnimation({
    Key? key,
    this.color = Colors.deepPurple,
    this.size = 50.0,
  }) : super(key: key);

  @override
  State<ChatLoadingAnimation> createState() => _ChatLoadingAnimationState();
}

class _ChatLoadingAnimationState extends State<ChatLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Three dots with staggered animations
    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.33, curve: Curves.easeIn),
      ),
    );

    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeIn),
      ),
    );

    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size / 3;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(_animation1, dotSize),
              const SizedBox(width: 8),
              _buildDot(_animation2, dotSize),
              const SizedBox(width: 8),
              _buildDot(_animation3, dotSize),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDot(Animation<double> animation, double size) {
    return Transform.scale(
      scale: 0.5 + (animation.value * 0.5),
      child: Opacity(
        opacity: 0.3 + (animation.value * 0.7),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
      ),
    );
  }
}

class PulseLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const PulseLoadingIndicator({
    Key? key,
    this.color = Colors.deepPurple,
    this.size = 50.0,
  }) : super(key: key);

  @override
  State<PulseLoadingIndicator> createState() => _PulseLoadingIndicatorState();
}

class _PulseLoadingIndicatorState extends State<PulseLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withOpacity(0.3),
            ),
            child: Center(
              child: Container(
                width: widget.size * _animation.value,
                height: widget.size * _animation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withOpacity(_animation.value),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

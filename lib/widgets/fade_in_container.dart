import 'package:flutter/material.dart';

class FadeInContainer extends StatefulWidget {
  final Widget child;
  final bool visibility;
  const FadeInContainer({
    required this.child,
    required this.visibility,
    super.key});

  @override
  State<FadeInContainer> createState() => _FadeInContainerState();
}

class _FadeInContainerState extends State<FadeInContainer> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            right: widget.visibility ? 0 : 200,
            child: AnimatedOpacity(
              opacity: widget.visibility ? 1 : 0,
              duration: const Duration(milliseconds: 1250),
              child: widget.child,
            ),
          ),
        ]
    );
  }
}

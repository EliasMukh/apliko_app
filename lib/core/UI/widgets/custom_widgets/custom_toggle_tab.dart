import 'package:flutter/material.dart';

class CustomToggleTab extends StatefulWidget {
  final Function(int) callback;
  final List<String> tabTexts;
  final TextStyle activeStyle;
  final TextStyle inactiveStyle;
  final double height;
  final BoxDecoration boxDecoration;
  final BoxDecoration animatedBoxDecoration;
  final double width;
  final double offset;
  final Duration duration;

  const CustomToggleTab({
    super.key,
    required this.callback,
    required this.tabTexts,
     this.height=48,
    required this.boxDecoration,
    required this.animatedBoxDecoration,
    required this.activeStyle,
    required this.inactiveStyle,
    this.width = 350,
    this.offset = 0.02,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<StatefulWidget> createState() => _CustomToggleTabState();
}

class _CustomToggleTabState extends State<CustomToggleTab> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: widget.boxDecoration,
      child: Stack(
        children: [
          AnimatedAlign(
            alignment:
                Alignment((index / (widget.tabTexts.length - 1) * (2 - 2 * widget.offset)) - 1 + widget.offset, 0),
            duration: widget.duration,
            child: Container(
              width: (widget.width / widget.tabTexts.length) - 6,
              height: widget.height * 0.75,
              decoration: widget.animatedBoxDecoration,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < widget.tabTexts.length; i++)
                _buildSwitchTab(
                  i == index,
                  widget.tabTexts[i],
                  i == index ? widget.activeStyle : widget.inactiveStyle,
                  i,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTab(
    bool isLeft,
    String title,
    TextStyle style,
    int i,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          index = i;
          widget.callback(i);
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: widget.width / widget.tabTexts.length,
        height: widget.height,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}

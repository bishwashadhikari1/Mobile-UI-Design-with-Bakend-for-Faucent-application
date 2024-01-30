import 'dart:math';

import 'package:flutter/material.dart';
import 'package:talab/config/theme/app_color_constant.dart';

class SliderButton extends StatefulWidget {
  final double height = 35;
  final animationDuration = const Duration(milliseconds: 300);
  final String? text;
  final Function() onSlided;
  final bool enabled;
  final SliderButtonController? controller;
  const SliderButton(
      {required this.onSlided,
      this.text,
      this.controller,
      this.enabled = true,
      super.key});

  @override
  State<SliderButton> createState() => _SliderButtonState();
}

class SliderButtonController extends ChangeNotifier {
  void reset() {
    notifyListeners();
  }
}

class _SliderButtonState extends State<SliderButton>
    with SingleTickerProviderStateMixin {
  double _sliderRelativePosition = 0.0; // values 0 -> 1
  double _startedDraggingAtX = 0.0;
  late final AnimationController _animationController;
  late final Animation _sliderAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(reset);
    }
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _sliderAnimation =
        CurveTween(curve: Curves.easeInQuad).animate(_animationController);

    _animationController.addListener(() {
      setState(() {
        _sliderRelativePosition = _sliderAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void reset() {
    _animationController.reverse(from: _sliderRelativePosition);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(_radius),
        border: _border,
      ),
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final sliderRadius = widget.height / 2;
          final sliderMaxX = constraints.maxWidth - 2 * sliderRadius;
          final sliderPosX = sliderMaxX * _sliderRelativePosition;
          return Stack(
            children: [
              _buildBackground(
                  width: constraints.maxWidth,
                  backgroundSplitX: sliderPosX + sliderRadius),
              _buildText(),
              _buildSlider(sliderMaxX: sliderMaxX, sliderPositionX: sliderPosX),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground(
      {required double width, required double backgroundSplitX}) {
    return Row(
      children: [
        Container(
          height: 50,
          width: backgroundSplitX,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.only(topLeft: _radius, bottomLeft: _radius),
            color:
                widget.enabled ? AppColorConstant.blue : AppColorConstant.white,
          ),
        ),
        Container(
          height: 50,
          width: width - backgroundSplitX,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(topRight: _radius, bottomRight: _radius),
              color: widget.enabled
                  ? AppColorConstant.grey
                  : AppColorConstant.blue),
        ),
      ],
    );
  }

  Widget _buildText() {
    if (widget.text == null) {
      return const SizedBox();
    }
    return SizedBox(
      height: 50,
      child: Center(
        child: Text(widget.text!,
            style: TextStyle(
                color: widget.enabled ? AppColorConstant.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "sf-medium")),
      ),
    );
  }

  Widget _buildSlider(
      {required double sliderMaxX, required double sliderPositionX}) {
    return Positioned(
      left: sliderPositionX,
      child: GestureDetector(
        onHorizontalDragStart: (start) {
          if (!widget.enabled) {
            return;
          }
          _startedDraggingAtX = sliderPositionX;
          _animationController.stop();
        },
        onHorizontalDragUpdate: (update) {
          if (!widget.enabled) {
            return;
          }
          final newSliderPositionX =
              _startedDraggingAtX + update.localPosition.dx;
          final newSliderRelativePosition = newSliderPositionX / sliderMaxX;
          setState(() {
            _sliderRelativePosition = max(0, min(1, newSliderRelativePosition));
          });
        },
        onHorizontalDragEnd: (end) {
          if (!widget.enabled) {
            return;
          }
          if (_sliderRelativePosition == 1.0) {
            widget.onSlided();
          } else {
            reset();
          }
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(_radius),
            color:
                widget.enabled ? AppColorConstant.white : AppColorConstant.blue,
            border: _border,
          ),
        ),
      ),
    );
  }

  Radius get _radius => Radius.circular(widget.height);
  Border get _border => Border.all(color: AppColorConstant.grey);
}

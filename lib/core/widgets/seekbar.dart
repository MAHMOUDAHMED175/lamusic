import 'package:flutter/material.dart';
import 'package:lamusic/core/utils/colors.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;
  Function? func;

  SeekBar({
    Key? key,
    required this.func,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

// الدالة المساعدة لتنفيذ الكود المشترك
  void _updateValue(double value) {
    if (_dragValue != value) {
      setState(() {
        _dragValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.position.toString().substring(0, 7),
              style: TextStyle(
                color: ColorsApp.orangeColor,
              ),
            ),
            Text(
              '${widget.duration - widget.position}'.substring(0, 7),
              style: TextStyle(
                color: ColorsApp.orangeColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            overlayShape: SliderComponentShape.noOverlay,
            activeTrackColor: ColorsApp.blueColor,
            inactiveTrackColor: ColorsApp.orangeColor,
            thumbColor: ColorsApp.blueColor,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: (_dragValue ?? widget.position.inMilliseconds.toDouble())
                .clamp(0.0, widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              _updateValue(value);
            },
            onChangeEnd: (value) {
              _updateValue(value);
              if (widget.duration.inMicroseconds.toDouble() == value) {
                widget.func!();
              }
              else if (widget.duration.inMicroseconds.toDouble() == value) {
                widget.func!();
              }
              else if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class SliderQuestion extends StatelessWidget{
  final String title;
  final int minValue;
  final int maxValue; 
  final void Function(int) onChanged;
  final int value;
  const SliderQuestion({
    super.key,
    required this.title,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF0D1F3C),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: value.toDouble(),
          min: minValue.toDouble(),
          max: maxValue.toDouble(),
          onChanged: (newValue) => onChanged(newValue.toInt()),
          activeColor: const Color(0xFF8C7F1C),
          inactiveColor: const Color(0xFFD3D3D3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              minValue.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0D1F3C),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              maxValue.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0D1F3C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
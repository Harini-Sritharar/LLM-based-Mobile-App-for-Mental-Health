import 'package:flutter/material.dart';

class CheckboxTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CheckboxTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF123659))),
      trailing: GestureDetector(
        onTap: () {
          onChanged(!value); // Toggle the checkbox value and notify parent
        },
        child: Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFF1c548c),
              width: 2,
            ),
            color: value ? Color(0xFF1c548c) : Colors.transparent,
          ),
          child: value
              ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}

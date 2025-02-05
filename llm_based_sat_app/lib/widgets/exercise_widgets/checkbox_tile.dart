import 'package:flutter/material.dart';

class CheckboxTile extends StatefulWidget {
  final String title;
  final IconData icon;

  const CheckboxTile({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  _CheckboxTileState createState() => _CheckboxTileState();
}

class _CheckboxTileState extends State<CheckboxTile> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon),
      title: Text(widget.title,
          style: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w400,
            color: Color(0xFF123659)
            )),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            _isChecked = !_isChecked;
          });
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
            color: _isChecked ? Color(0xFF1c548c) : Colors.transparent,
          ),
          child: _isChecked
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

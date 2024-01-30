import 'package:flutter/material.dart';

class KDropdownFormField extends StatefulWidget {
  final List<String> options;
  final String value;
  final Function(String) onChanged;

  KDropdownFormField({
    Key? key,
    this.options = const ['Male', 'Female', 'Rainbow'],
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _KDropdownFormFieldState createState() => _KDropdownFormFieldState();
}

class _KDropdownFormFieldState extends State<KDropdownFormField> {
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      borderRadius: BorderRadius.circular(8),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      value: dropdownValue,
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          widget.onChanged(newValue);
        });
      },
    );
  }
}

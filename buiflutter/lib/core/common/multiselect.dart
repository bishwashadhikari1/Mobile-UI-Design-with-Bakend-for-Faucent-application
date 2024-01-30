import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final Function(List<String>) onChanged;

  const MultiSelectChip({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
  });

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.selectedOptions;
  }

  bool isSelected(String option) {
    return selectedOptions.contains(option);
  }

  void toggleSelection(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
      widget.onChanged(selectedOptions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.options.map((String option) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: FilterChip(
            label: Text(option),
            selected: isSelected(option),
            onSelected: (bool selected) {
              toggleSelection(option);
            },
          ),
        );
      }).toList(),
    );
  }
}

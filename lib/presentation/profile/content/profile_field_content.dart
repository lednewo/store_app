import 'package:flutter/material.dart';

class ProfileFieldContent extends StatelessWidget {
  const ProfileFieldContent({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(value, style: textTheme.bodyLarge),
        const Divider(),
      ],
    );
  }
}

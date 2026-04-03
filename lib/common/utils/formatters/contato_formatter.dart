import 'package:flutter/services.dart';

class ContatoFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    text = text.replaceAll(RegExp(r'\D'), '');

    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    String formatted = '';

    if (text.isEmpty) {
      formatted = '';
    } else if (text.length < 3) {
      formatted = '(${text.substring(0, text.length)}';
    } else if (text.length < 7) {
      formatted = '(${text.substring(0, 2)}) ${text.substring(2)}';
    } else if (text.length < 11) {
      formatted =
          '(${text.substring(0, 2)}) ${text.substring(2, 6)}-${text.substring(6)}';
    } else {
      formatted =
          '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7)}';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

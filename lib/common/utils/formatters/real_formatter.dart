import 'package:flutter/services.dart';

class RealFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // extrai apenas dígitos
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // se vazio, retorna vazio (mantendo seleção no início)
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // transforma para double (centavos)
    final value = double.parse(digits) / 100;

    // formata inteiro e centavos
    final fixed = value.toStringAsFixed(2); // "1234.56"
    final parts = fixed.split('.');
    String inteiro = parts[0];
    final centavos = parts[1];

    // insere pontos de milhares
    final buffer = StringBuffer();
    for (int i = 0; i < inteiro.length; i++) {
      final posFromEnd = inteiro.length - i;
      buffer.write(inteiro[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }
    final inteiroFormatado = buffer.toString();

    final newText = 'R\$ $inteiroFormatado,$centavos';

    // coloca o cursor ao final (maneira simples e segura)
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

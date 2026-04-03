extension TextWordsExtension on String {
  String capitalizeEachWord() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String getInitials() {
    final parts = trim().split(' ');

    if (parts.isEmpty) return '';

    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';

    return (first + last).toUpperCase();
  }

  String formatarDuracao() {
    final partes = trim().split(':');
    final horas = int.parse(partes[0]);
    final minutos = int.parse(partes[1]);

    if (horas > 0 && minutos > 0) {
      return '${horas}h ${minutos}min';
    } else if (horas > 0) {
      if (horas > 1) {
        return '$horas horas';
      }
      return '$horas hora';
    } else {
      return '$minutos minutos';
    }
  }

  String toBrazilianDate() {
    if (isEmpty) return '';

    final partes = split(' ').first.split('-');
    if (partes.length != 3) return this;

    final ano = partes[0];
    final mes = partes[1];
    final dia = partes[2];

    return '$dia/$mes/$ano';
  }

  String cpfFormatter() {
    final digits = replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return this;

    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}';
  }

  String cnpjFormatter() {
    final digits = replaceAll(RegExp(r'\D'), '');

    if (digits.length != 14) return this;

    return '${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}.${digits.substring(12, 14)}';
  }

  String phoneFormatter() {
    final digits = replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6, 10)}';
    } else if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
    } else {
      return this;
    }
  }
}

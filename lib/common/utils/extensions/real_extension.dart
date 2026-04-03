extension RealFormatterExtension on double {
  String toReal() {
    final String valueStr = toStringAsFixed(2);
    final List<String> parts = valueStr.split('.');
    final String integerPart = parts[0];
    final String decimalPart = parts[1];

    // Adiciona pontos de milhares
    String formattedInteger = '';
    for (int i = integerPart.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 3 == 0) {
        formattedInteger = '.$formattedInteger';
      }
      formattedInteger = integerPart[i] + formattedInteger;
    }

    return 'R\$ $formattedInteger,$decimalPart';
  }
}

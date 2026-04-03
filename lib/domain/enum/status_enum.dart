enum StatusEnum {
  active('ATIVO'),
  inactive('INATIVO'),
  esgotado('ESGOTADO');

  const StatusEnum(this.value);
  final String value;

  static StatusEnum fromString(String value) {
    return StatusEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => StatusEnum.active,
    );
  }

  String get label {
    switch (this) {
      case StatusEnum.active:
        return 'Ativo';
      case StatusEnum.inactive:
        return 'Inativo';
      case StatusEnum.esgotado:
        return 'Esgotado';
    }
  }
}

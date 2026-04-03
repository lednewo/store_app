enum GenderEnum {
  male('MASCULINO'),
  female('FEMININO'),
  unisex('UNISSEX');

  const GenderEnum(this.label);
  final String label;

  static GenderEnum fromString(String value) {
    return GenderEnum.values.firstWhere(
      (e) => e.label == value,
      orElse: () => GenderEnum.unisex,
    );
  }

  String get value {
    switch (this) {
      case GenderEnum.male:
        return 'Masculino';
      case GenderEnum.female:
        return 'Feminino';
      case GenderEnum.unisex:
        return 'Unissex';
    }
  }
}

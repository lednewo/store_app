enum AudienceEnum {
  adult('ADULTO'),
  child('INFANTIL'),
  teen('ADOLESCENTE');

  const AudienceEnum(this.value);
  final String value;

  static AudienceEnum fromString(String value) {
    return AudienceEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AudienceEnum.adult,
    );
  }

  String get label {
    switch (this) {
      case AudienceEnum.adult:
        return 'Adulto';
      case AudienceEnum.child:
        return 'Infantil';
      case AudienceEnum.teen:
        return 'Adolescente';
    }
  }
}

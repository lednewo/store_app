extension RemoverCaracteresExtension on String {
  String removerCaracteres() {
    return replaceAll(RegExp(r'[./()\s-]'), '').trim();
  }
}

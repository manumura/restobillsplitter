double parseDouble(String value) {
  return double.tryParse(value.replaceFirst(RegExp(r','), '.')) ?? 0.0;
}

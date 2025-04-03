class ErrorsFormatter {

  static Map<String, String> format(Map errors) {
    return errors.map((key, value) => MapEntry(key, value.join(' ')));
  }
}
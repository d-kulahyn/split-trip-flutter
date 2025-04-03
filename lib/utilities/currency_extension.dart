import 'package:intl/intl.dart';

class CurrencyHelper {

  static String format(dynamic value, {String locale = 'en_US', String symbol = ''}) {
    return NumberFormat.currency(locale: locale, symbol: symbol).format(value);
  }
}
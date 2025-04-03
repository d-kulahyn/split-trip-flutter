import 'package:intl/intl.dart';
import 'package:split_trip/enums/category_enum.dart';
import 'package:split_trip/utilities/date_helper.dart';

class ExpenseModel {
  int id;
  String description;
  CategoryEnum _category;
  String currency;
  DateTime _createdAt;
  List payers;
  double generalAmountOfAllPays;
  double owe;
  double paid;

  ExpenseModel({
    required this.id,
    required this.description,
    required CategoryEnum category,
    required this.currency,
    required DateTime createdAt,
    required this.generalAmountOfAllPays,
    required this.owe,
    required this.paid,
    required this.payers,
  }) : _createdAt = createdAt, _category = category;

  String get createdAt => DateFormat(DateHelper.format).format(_createdAt);

  CategoryEnum get category => _category;

  factory ExpenseModel.fromJson(Map<String, dynamic> data) {
    return ExpenseModel(
      id: data['id'],
      owe: (data['owe'] as num).toDouble(),
      paid: (data['paid'] as num).toDouble(),
      payers: data['payers'],
      description: data['description'],
      category: CategoryEnum.fromString(data['category']),
      currency: data['currency'],
      createdAt: DateHelper.fromTimestamp(data['created_at']),
      generalAmountOfAllPays: double.parse(data['generalAmountOfAllPays'].toString()),
    );
  }
}

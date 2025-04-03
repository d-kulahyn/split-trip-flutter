import 'package:split_trip/models/expense_model.dart';

class ExpenseCollection {
  final List<ExpenseModel> items;
  Map<String, double> dailyExpenses;

  ExpenseCollection({required this.items, Map<String, double>? dailyExpenses}): dailyExpenses = dailyExpenses ?? {};

  Map<String, List<ExpenseModel>> groupExpensesByDate() {
    dailyExpenses = {};

    final Map<String, List<ExpenseModel>> grouped = {};

    for (final expense in items) {
      final date = expense.createdAt;

      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(expense);

      dailyExpenses[date] = (dailyExpenses[date] ?? 0) + expense.generalAmountOfAllPays;
    }

    return grouped;
  }

}
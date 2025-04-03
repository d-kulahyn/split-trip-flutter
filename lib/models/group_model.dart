import 'package:split_trip/models/expense_collection.dart';
import 'package:split_trip/models/expense_model.dart';
import 'package:split_trip/models/user_model.dart';
import 'package:split_trip/valueObject/balance.dart';

class GroupModel {
  String id;
  String name;
  String category;
  String finalCurrency;
  int createdBy;
  List<UserModel> members;
  ExpenseCollection? expenses;
  List<dynamic> currencies;
  Map<String, dynamic> rates;
  List<dynamic> balances;
  List<dynamic> debts;
  Balance myBalance;
  bool simplifyDebts;
  String? avatar;

  GroupModel(
      {required this.id,
      required this.name,
      required this.category,
      required this.finalCurrency,
      required this.createdBy,
      required this.currencies,
      this.simplifyDebts = true,
        this.avatar,
      List<UserModel>? members,
        this.expenses,
      List<dynamic>? balances,
      List<dynamic>? debts,
      Balance? myBalance,
      Map<String, dynamic>? rates})
      : members = members ?? [],
        rates = rates ?? {},
        balances = balances ?? [],
        debts = debts ?? [],
        myBalance = myBalance ?? Balance(paid: 0.0, owe: 0.0, balance: 0.0);

  factory GroupModel.fromJson(Map<String, dynamic> data) {
    final List<UserModel> members = [];
    final List<ExpenseModel> expenses = [];

    if (data['members'] != null) {
      for (var user in data['members']) {
        members.add(UserModel.fromJson(user));
      }
    }

    if (data['expenses'] != null) {
      for (var expense in data['expenses']) {
        final ExpenseModel expenseModel = ExpenseModel.fromJson(expense);
        expenses.add(expenseModel);
      }
    }

    return GroupModel(
        id: data['id'],
        name: data['name'],
        category: data['category'],
        finalCurrency: data['final_currency'],
        createdBy: data['created_by'],
        members: members,
        expenses: ExpenseCollection(items: expenses),
        currencies: data['currencies'],
        rates: data['rates'],
        balances: data['balances'],
        debts: data['debts'],
        simplifyDebts: data['simplify_debts'],
        avatar: data['avatar'],
        myBalance: Balance(
            owe: (data['myBalance']['owe'] as num).toDouble(),
            paid: (data['myBalance']['paid'] as num).toDouble(),
            balance: (data['myBalance']['balance'] as num).toDouble()
        ));
  }
}

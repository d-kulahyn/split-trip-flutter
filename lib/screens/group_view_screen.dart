import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:split_trip/enums/debt_status_enums.dart';
import 'package:split_trip/models/auth_model.dart';
import 'package:split_trip/models/expense_collection.dart';
import 'package:split_trip/models/group_model.dart';
import 'package:split_trip/repositories/group_repository.dart';
import 'package:split_trip/repositories/notification_repository.dart';
import 'package:split_trip/screens/group_settings_screen.dart';
import 'package:split_trip/services/auth_service.dart';
import 'package:split_trip/services/overlay_service.dart';
import 'package:split_trip/services/request_service.dart';
import 'package:split_trip/utilities/currency_extension.dart';
import 'package:split_trip/widgets/arrow_back.dart';
import 'package:split_trip/widgets/tab_item_wrapper.dart';

import '../constants/app_constants.dart';
import '../enums/category_enum.dart';
import '../models/expense_model.dart';
import '../services/invite_link_generator.dart';
import '../utilities/date_helper.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/form_wrapper.dart';
import '../widgets/forms/add_expense_form.dart';
import '../widgets/modals/form_modal.dart';
import '../widgets/modals/modal_bottom_sheet.dart';
import '../widgets/theme_components/ThemeIcon.dart';
import '../widgets/theme_components/loader.dart';

class LabeledTab {
  final String key;
  final Tab tab;

  LabeledTab({required this.key, required this.tab});
}

class GroupViewScreen extends StatefulWidget {
  static const String routeName = 'groupViewScreen';

  final GroupModel group;

  const GroupViewScreen({super.key, required this.group});

  @override
  State<GroupViewScreen> createState() => _GroupViewScreenState();
}

class _GroupViewScreenState extends State<GroupViewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  late List debts;
  late ExpenseCollection? expenses;
  late List balances;

  List<LabeledTab> tabs() {
    return [
      buildTab('Expenses'),
      buildTab('Balances'),
      buildTab('Debts'),
    ];
  }

  LabeledTab buildTab(String label) {
    return LabeledTab(
      key: label,
      tab: Tab(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs().length);

    debts = widget.group.debts;
    balances = widget.group.balances;
    expenses = widget.group.expenses;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleLoader() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  //TODO: Expense block start

  Future<void> showCreateExpenseModal(BuildContext context) async {
    final Map<String, dynamic> formData = {};
    final Map<String, dynamic> additional = {"group": widget.group};
    final ValueNotifier<Map<String, dynamic>> errorsNotifier = ValueNotifier({});

    formData['created_at'] = DateTime.now();
    formData['before_currency'] = widget.group.finalCurrency;
    formData['currency'] = widget.group.finalCurrency;
    formData['category'] = CategoryEnum.other.label;

    await modalBottomSheet(
      context,
      FormModal(
        title: 'Add expense',
        body: FormWrapper(
          formData: formData,
          additional: additional,
          errorsNotifier: errorsNotifier,
          body: AddExpenseForm.new,
        ),
        save: () async {
          await create(formData, errorsNotifier);
        },
      ),
    );
  }

  Map<String, dynamic> prepare(Map<String, dynamic> data) {
    return {
      'created_at': DateHelper(dateTime: data['created_at']).timestamp,
      'description': data['description'],
      'currency': data['currency'],
      'category': data['category'],
      'payers': mapUsers(data['payers']),
      'debtors': mapUsers(data['debtors']),
    };
  }

  List<Map<String, dynamic>> mapUsers(dynamic users) {
    if (users == null) return [];

    return users.map<Map<String, dynamic>>((user) => {'id': user['id'], 'amount': user['amount'], 'currency': user['currency']}).toList();
  }

  Future<void> create(Map<String, dynamic> data, ValueNotifier errorsNotifier) async {
    if (!mounted) return;

    final Map<String, dynamic> preparedData = prepare(data);

    final AuthService authService = context.read<AuthService>();

    final GroupRepository groupRepository = context.read<GroupRepository>();

    RequestService.send(context, groupRepository.addExpense(widget.group.id, preparedData), onSuccess: (Map<String, dynamic> data) async {
      setState(() {
        widget.group.expenses?.items.insert(0, ExpenseModel.fromJson(data));
        expenses = widget.group.expenses;
      });
      Navigator.pop(context);
    }, errorsNotifier: errorsNotifier);
  }

  //TODO: Expense block end

  void remindAboutDebt(BuildContext context, int debtId) {
    final NotificationRepository notificationRepository = context.read<NotificationRepository>();
    RequestService.send(context, notificationRepository.debtReminder(debtId), onSuccess: (Map data) {
      OverlayService.showOverlayMessage(data['message']);
    });
  }

  Future<void> markAsPaid(Map debt) async {
    final result = await FlutterPlatformAlert.showAlert(
      windowTitle: 'Confirmation',
      text: 'Are you sure that you want to mark this debt as paid?',
      alertStyle: AlertButtonStyle.yesNo,
    );

    if (result != AlertButton.yesButton || !mounted) return;

    final GroupRepository groupRepository = context.read<GroupRepository>();

    try {
      toggleLoader();

      final Response response = await groupRepository.changeDebtStatus(debt['id'], DebtStatusEnums.paid);

      if (response.statusCode != HttpStatus.ok) return;

      setState(() {
        debt['status'] = DebtStatusEnums.paid.name;
        for (var customerBalance in balances) {
          final Decimal balance = Decimal.parse(customerBalance['balance'].toString());
          final Decimal debtAmount = Decimal.parse(debt['amount'].toString());
          late double result;
          if (customerBalance['customer']['id'] == debt['from']['id']) {
            result = (balance + debtAmount).toDouble();
          }
          if (customerBalance['customer']['id'] == debt['to']['id']) {
            result = (balance - debtAmount).toDouble();
          }
          customerBalance['balance'] = result;
          final AuthService authService = context.read<AuthService>();
          authService.refreshUser();
        }
      });
    } on Exception catch (error) {
      //
    } finally {
      toggleLoader();
    }
  }

  Widget tabsContent(String text) {
    final Map<String, Widget> contents = {
      "Expenses": expenses!.groupExpensesByDate().isNotEmpty
          ? ListView(
              children: expenses!
                  .groupExpensesByDate()
                  .entries
                  .map<Widget>(
                    (MapEntry<String, List<ExpenseModel>> expense) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                expense.key,
                                style: const TextStyle(
                                  color: Color.fromRGBO(99, 104, 116, 1),
                                ),
                              ),
                              Text(
                                "Daily expenses: ${widget.group.expenses!.dailyExpenses[expense.key]}",
                                style: const TextStyle(
                                  color: Color.fromRGBO(99, 104, 116, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...expense.value.map(
                          (ExpenseModel model) => TabItemWrapper(
                            body: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(model.category.icon),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(model.category.label),
                                        Text(
                                          "You paid: ${model.paid}",
                                          style: const TextStyle(
                                            color: Color.fromRGBO(99, 104, 116, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Wrap(
                                            spacing: -15,
                                            clipBehavior: Clip.none,
                                            children: model.payers.map((payer) {
                                              return CircleAvatar(
                                                backgroundImage: payer['avatar'] != null ? NetworkImage(payer['avatar']) : const AssetImage('assets/images/avatar.jpg'),
                                                radius: 10,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${model.generalAmountOfAllPays}")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  )
                  .toList(),
            )
          : const Center(child: Text("No expenses available")),
      "Balances": balances.isNotEmpty
          ? ListView(
              children: balances
                  .map<Widget>(
                    (balance) => TabItemWrapper(
                      body: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 20,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: balance['customer']['avatar'] != null ? NetworkImage(balance['customer']['avatar']) : const AssetImage('assets/images/avatar.jpg'),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text(balance['customer']['name'] ?? ''), if (balance['customer']['id'] == context.read<AuthModel>().user!.id) const Text('You')],
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 5,
                            children: [
                              Text('${CurrencyHelper.format(double.parse(balance['balance'].toString()))} ${widget.group.finalCurrency}'),
                              if (balance['balance'] >= 0.0)
                                SvgPicture.asset(
                                  'assets/images/income.svg',
                                  width: 16,
                                  height: 16,
                                ),
                              if (balance['balance'] < 0.0)
                                SvgPicture.asset(
                                  'assets/images/income_reverse.svg',
                                  width: 16,
                                  height: 16,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )
          : const Center(child: Text("No balances available")),
      "Debts": debts.isNotEmpty
          ? ListView(
              children: debts
                  .where((debt) => debt['status'] == DebtStatusEnums.pending.name)
                  .map<Widget>(
                    (debt) => TabItemWrapper(
                      body: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: debt['from']['avatar'] != null ? NetworkImage(debt['from']['avatar']) : const AssetImage('assets/images/avatar.jpg'),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        debt['from']['name'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: const Color.fromRGBO(167, 167, 202, 0.5),
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 21.1,
                                      color: Color.fromRGBO(175, 175, 224, 0.1),
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: OverflowBox(
                                  maxWidth: 30,
                                  maxHeight: 30,
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/images/to.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: debt['to']['avatar'] != null ? NetworkImage(debt['to']['avatar']) : const AssetImage('assets/images/avatar.jpg'),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [Text(debt['to']['name'] ?? ''), if (debt['to']['id'] == context.read<AuthModel>().user!.id) const Text('You')],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("${CurrencyHelper.format(double.parse(debt['amount'].toString()))} ${widget.group.finalCurrency}"),
                              // Visibility(
                              //   visible: debt['to']['id'] == context.read<AuthModel>().user?.id,
                              //   child: IconButton(
                              //     onPressed: () {
                              //       markAsPaid(debt);
                              //     },
                              //     icon: const Icon(Icons.check_circle),
                              //   ),
                              // ),
                              // Visibility(
                              //   visible: debt['to']['id'] == context.read<AuthModel>().user?.id,
                              //   child: IconButton(
                              //     onPressed: () {
                              //       remindAboutDebt(context, debt['id']);
                              //     },
                              //     icon: const Icon(Icons.alarm_add_outlined),
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )
          : const Center(child: Text("No debts available")),
    };

    return contents[text] ?? const Center(child: Text("Invalid tab"));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.2, 1],
              colors: [
                Color.fromRGBO(216, 222, 255, 1),
                Color.fromRGBO(228, 240, 255, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
        ),
        DefaultTabController(
          length: tabs().length,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10, right: 20),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const ArrowBack(
                          transparent: true,
                        ),
                        Row(
                          children: <Widget>[
                            TextButton(
                              onPressed: () async {
                                Share.share(
                                  "You can join to $appName group by following this link ${InviteLinkGenerator.generate(widget.group.id)}",
                                  subject: 'Check this out!',
                                );
                              },
                              child: const ThemeIconButton(
                                size: 40,
                                iconSize: 16,
                                background: Color.fromRGBO(255, 255, 255, 0.5),
                                iconPath: 'assets/images/share.svg',
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => GroupSettingsScreen(group: widget.group)),
                                  );
                                });
                              },
                              child: const ThemeIconButton(
                                size: 40,
                                iconSize: 16,
                                background: Color.fromRGBO(255, 255, 255, 0.5),
                                iconPath: 'assets/images/settings.svg',
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: AvatarPicker(
                        avatar: widget.group.avatar,
                        radius: 50,
                        onSuccess: (File file) {
                          context.read<GroupRepository>().uploadAvatar(file, widget.group.id);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "${widget.group.name} (${widget.group.finalCurrency})",
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text("You paid ${widget.group.myBalance.paid}"),
                              const SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset(
                                'assets/images/income.svg',
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 1,
                            height: 20,
                            child: VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Text("You owe ${widget.group.myBalance.owe}"),
                              const SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset(
                                'assets/images/income_reverse.svg',
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 45,
                      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      padding: const EdgeInsets.all(5),
                      child: TabBar(
                        indicatorWeight: 0,
                        dividerHeight: 0,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorAnimation: TabIndicatorAnimation.elastic,
                        indicator: BoxDecoration(),
                        labelStyle: const TextStyle(fontSize: 10),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        tabs: [
                          for (final label in ['Expenses', 'Balances', 'Debts'])
                            Tab(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromRGBO(240, 244, 255, 0.5),
                                ),
                                alignment: Alignment.center,
                                child: Text(label),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                            boxShadow: [BoxShadow(blurRadius: 5, color: Color.fromRGBO(167, 167, 202, 0.2), offset: Offset(0, -2))],
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromRGBO(239, 243, 255, 1),
                              ],
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: TabBarView(
                            children: tabs().map((LabeledTab tab) {
                              return tabsContent(tab.key);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isLoading,
                  child: Center(
                    child: screenLoader(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              showCreateExpenseModal(context);
            },
            tooltip: 'Add expense',
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}

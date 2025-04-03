import 'package:flutter/material.dart';
import 'package:split_trip/enums/category_enum.dart';
import 'package:split_trip/screens/annotated_region.dart';
import 'package:split_trip/widgets/system/bottom_navigation.dart';

import '../constants/theme_constants.dart';
import '../providers/group_provider.dart';
import '../providers/loader_provider.dart';
import '../repositories/currency_repository.dart';
import '../repositories/group_repository.dart';
import '../services/request_service.dart';
import '../widgets/form_wrapper.dart';
import '../widgets/group_edit.dart';
import '../widgets/modals/form_modal.dart';
import '../widgets/modals/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'account_screen.dart';
import 'empty_background_modal_screen.dart';
import 'group_list_screen.dart';

class BaseScreen extends StatefulWidget {
  static const String routeName = 'baseScreen';

  final AppBar? appBar;
  final Widget? body;

  const BaseScreen({super.key, this.appBar, this.body});

  @override
  State<BaseScreen> createState() => BaseScreenState();
}

class BaseScreenState extends State<BaseScreen> {
  int currentPageIndex = 0;
  List<dynamic> currencies = [];

  Future<void> getCurrencies() async {
    if (currencies.isNotEmpty) return;

    final currencyRepository = context.read<CurrencyRepository>();
    final List? data = await RequestService.send<List>(context, currencyRepository.codes());

    if (data == null) return;

    setState(() {
      currencies = data;
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrencies();
  }

  bool isModalButton(int index) {
    return index == 1;
  }

  Future<void> showCreateGroupModal(BuildContext context) async {
    final Map<String, dynamic> formData = {'category': CategoryEnum.other.label, 'currency': 'USD'};
    final Map<String, dynamic> additional = {'currencies': currencies};
    final ValueNotifier<Map<String, dynamic>> errorsNotifier = ValueNotifier({});

    await modalBottomSheet(
      context,
      FormModal(
        title: 'Create a Group',
        body: FormWrapper(
          formData: formData,
          additional: additional,
          errorsNotifier: errorsNotifier,
          body: GroupEdit.new,
        ),
        save: () { save(formData, context, errorsNotifier); },
      ),
    );
  }

  Future<void> save(
      Map<String, dynamic> formData,
      BuildContext context,
      ValueNotifier<Map<String, dynamic>> errorsNotifier
      ) async {
    final groupRepository = context.read<GroupRepository>();
    final loader = context.read<LoaderProvider>();

    loader.toggle();

    late Map<String, dynamic>? data;

    data = await RequestService.send(context, groupRepository.create(formData), errorsNotifier: errorsNotifier);

    loader.toggle();

    if (data == null) return;

    context.read<GroupProvider>().addGroup(data);

    Navigator.pop(context);
  }

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Future<bool> onWillPop() async {
    final currentNavigator = navigatorKeys[currentPageIndex].currentState!;
    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          final allowPop = await onWillPop();
          if (allowPop && context.mounted) {
            Navigator.of(context).maybePop();
          }
        }
      },
      child: SystemAnnotatedRegion(
        systemUiOverlayStyle: systemUiOverlayStyle,
          child: Scaffold(
            appBar: widget.appBar,
            body: SafeArea(
              child: IndexedStack(
                index: currentPageIndex,
                children: [
                  Navigator(
                    key: navigatorKeys[0],
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(builder: (_) => const GroupListScreen());
                    },
                  ),
                  Navigator(
                    key: navigatorKeys[1],
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(builder: (_) => const EmptyBackgroundModalScreen());
                    },
                  ),
                  Navigator(
                    key: navigatorKeys[2],
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(builder: (_) => const AccountScreen());
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigation(
                currentScreen: currentPageIndex,
                changeDestination: (index) {
                  if (isModalButton(index)) {
                    showCreateGroupModal(context);

                    return;
                  }

                  if (index == currentPageIndex) {
                    navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);

                    return;
                  }

                  setState(() => currentPageIndex = index);
                },
                currencies: currencies),
          ),
      ),
    );
  }
}

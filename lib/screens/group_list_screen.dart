import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/models/group_model.dart';
import 'package:split_trip/screens/group_view_screen.dart';
import 'package:split_trip/utilities/currency_extension.dart';
import 'package:split_trip/widgets/theme_components/ThemeIcon.dart';

import '../constants/theme_constants.dart';
import '../models/auth_model.dart';
import '../providers/group_provider.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/forms/elements/input_text_form_element.dart';

class GroupListScreen extends StatefulWidget {
  static const String routeName = 'groupScreen';

  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => GroupListScreenState();
}

class GroupListScreenState extends State<GroupListScreen> {
  final TextEditingController textEditingController = TextEditingController();

  String totalBalance(BuildContext context) {
    String sign = context.read<AuthModel>().user!.balance.balance < 0 ? '-' : '+';

    return "$sign ${CurrencyHelper.format(context.read<AuthModel>().user!.balance.balance.abs())} ${context.read<AuthModel>().user!.currency}";
  }

  List<GroupModel> get filteredGroups {
    final groups = context.watch<GroupProvider>().groups;
    final query = textEditingController.text.toLowerCase();

    if (query.isEmpty) return groups;

    return groups.where((group) => group.name.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupProvider>();
    final groups = provider.groups;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            height: 240,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                radius: 0.9,
                center: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(149, 130, 238, 1),
                  Color.fromRGBO(79, 58, 255, 1),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AvatarPicker(radius: 30),
                        Text(
                          "Hi, ${context.read<AuthModel>().user!.name}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        ThemeIconButton(
                          iconPath: 'assets/images/bell-ringing.svg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(239, 243, 255, 1),
                      ],
                    ),
                  ),
                  margin: const EdgeInsets.only(top: 73),
                  padding: const EdgeInsets.only(top: 110),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('My Groups'),
                            Wrap(
                              spacing: 10,
                              children: [
                                ThemeIconButton(
                                  iconSize: 20,
                                  background: Colors.white,
                                  iconPath: 'assets/images/search.svg',
                                ),
                                ThemeIconButton(
                                  iconSize: 12,
                                  background: Colors.white,
                                  iconPath: 'assets/images/filter.svg',
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: RefreshIndicator.adaptive(
                            onRefresh: () => context.read<GroupProvider>().loadGroups(context),
                            child: filteredGroups.isNotEmpty
                                ? ListView.separated(
                                    separatorBuilder: (context, value) {
                                      return const SizedBox(height: 5);
                                    },
                                    itemCount: filteredGroups.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: const Color.fromRGBO(255, 255, 255, 1),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              offset: const Offset(0, 2),
                                              blurRadius: 5,
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            SystemChrome.setSystemUIOverlayStyle(systemGroupViewUiOverlayStyle);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => GroupViewScreen(group: filteredGroups[index]),
                                              ),
                                            );
                                          },
                                          iconColor: Colors.black,
                                          leading: CircleAvatar(
                                            backgroundImage: filteredGroups[index].avatar != null ? NetworkImage(filteredGroups[index].avatar!) : const AssetImage('assets/images/avatar.jpg'),
                                          ),
                                          title: Text(filteredGroups[index].name),
                                          subtitle: Row(
                                            children: [Text('My balance: ${CurrencyHelper.format(filteredGroups[index].myBalance.balance)} ${filteredGroups[index].finalCurrency}')],
                                          ),
                                          trailing: const Icon(size: 15, Icons.arrow_forward_ios_outlined),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.group_off,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No groups available',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Create your first group to get started.',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 160,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
                color: Colors.black,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(231, 236, 255, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total balance'),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: context.read<AuthModel>().user!.balance.balance < 0 ? const Color.fromRGBO(251, 75, 75, 1) : const Color.fromRGBO(32, 168, 86, 1),
                          ),
                          child: Text(
                            totalBalance(context),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color.fromRGBO(232, 232, 234, 1),
                    height: 2,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 15,
                                  children: [
                                    Text(
                                      "${context.read<AuthModel>().user!.currency} ${context.read<AuthModel>().user!.balance.paid}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    SvgPicture.asset('assets/images/income.svg'),
                                  ],
                                ),
                                const Text('You paid'),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            color: Color.fromRGBO(232, 232, 234, 1),
                            thickness: 1,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${context.read<AuthModel>().user!.currency} ${context.read<AuthModel>().user!.balance.owe}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        SvgPicture.asset('assets/images/income_reverse.svg'),
                                      ],
                                    ),
                                    const Text('You owe'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

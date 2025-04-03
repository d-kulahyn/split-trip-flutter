import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:split_trip/constants/app_constants.dart';
import 'package:split_trip/models/group_model.dart';
import 'package:split_trip/repositories/group_repository.dart';
import 'package:split_trip/screens/group_action_screen.dart';
import 'package:split_trip/screens/group_list_screen.dart';
import 'package:split_trip/services/invite_link_generator.dart';

import '../services/group_service.dart';
import '../widgets/theme_components/loader.dart';

class GroupSettingsScreen extends StatefulWidget {
  static const String routeName = 'groupSettingsScreen';

  final GroupModel group;

  const GroupSettingsScreen({super.key, required this.group});

  @override
  State<GroupSettingsScreen> createState() => _GroupSettingsScreenState();
}

class _GroupSettingsScreenState extends State<GroupSettingsScreen> {

  bool isLoading = false;
  late bool simplifiedDebts;

  @override
  void initState() {
    super.initState();

    simplifiedDebts = widget.group.simplifyDebts;
  }

  Future<void> leaveGroup() async {
    if (!mounted) return;

    final bool result = await context.read<GroupService>().leaveGroup(context, widget.group.id);

    if (!result) return;

    Navigator.pushNamedAndRemoveUntil(context, GroupListScreen.routeName, (r) => false);
  }

  Future<void> toggleSimplify() async {
    try {
      toggleLoader();
      final Response response = await context.read<GroupRepository>().toggleSimplify(widget.group.id);
      setState(() {
        simplifiedDebts = !simplifiedDebts;
      });
    } finally {
      toggleLoader();
    }
  }

  void toggleLoader() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Group Settings'),
        actions: [
          TextButton(
            onPressed: () async {
              if (!context.mounted) return;

              Navigator.pushNamed(context, GroupActionScreen.routeName, arguments: {'group': widget.group, 'editMode': true});
            },
            child: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Invite link'),
                    leading: const Icon(Icons.share_outlined),
                    onTap: () {
                      Share.share(
                        "You can join to $appName group by following this link ${InviteLinkGenerator.generate(widget.group.id)}",
                        subject: 'Check this out!',
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Leave group'),
                    leading: const Icon(Icons.logout),
                    onTap: leaveGroup,
                  ),
                  ListTile(
                    title: const Text('Simplify group debts'),
                    leading: const Icon(Icons.monetization_on_outlined),
                    trailing: CupertinoSwitch(
                      value: simplifiedDebts,
                      onChanged: (bool value) {
                        toggleSimplify();
                      },
                    ),
                  ),
                ],
              ),
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
    );
  }
}

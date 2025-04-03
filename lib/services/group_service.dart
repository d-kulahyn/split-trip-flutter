import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import '../models/auth_model.dart';
import '../repositories/group_repository.dart';

class GroupService {

  Future<bool> leaveGroup(BuildContext context, String groupId) async {

    final result = await FlutterPlatformAlert.showAlert(
      windowTitle: 'Confirmation',
      text: 'Are you sure you want to leave this group?',
      alertStyle: AlertButtonStyle.yesNo,
    );

    if (result != AlertButton.yesButton) return false;

    if (!context.mounted) return false;

    GroupRepository groupRepository = context.read<GroupRepository>();
    AuthModel authModel = context.read<AuthModel>();

    final Response response = await groupRepository.leaveGroup(groupId, authModel.user!.id);

    if (response.statusCode != HttpStatus.ok) return false;

    return true;
  }

}
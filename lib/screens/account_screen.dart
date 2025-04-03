import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/models/auth_model.dart';
import 'package:split_trip/models/user_model.dart';
import 'package:split_trip/repositories/auth_repository.dart';
import 'package:split_trip/repositories/profile_repository.dart';
import 'package:split_trip/screens/login_screen.dart';
import 'package:split_trip/services/auth_service.dart';
import 'package:split_trip/services/request_service.dart';
import 'package:split_trip/widgets/form_wrapper.dart';
import 'package:split_trip/widgets/avatar_picker.dart';
import 'package:split_trip/widgets/change_email.dart';
import 'package:split_trip/widgets/change_password.dart';
import 'package:split_trip/widgets/confirm_email.dart';
import 'package:split_trip/widgets/edit_notifications.dart';
import 'package:split_trip/widgets/edit_profile.dart';
import 'package:split_trip/widgets/modals/form_modal.dart';
import 'package:split_trip/widgets/reminder_settings.dart';
import 'package:split_trip/widgets/theme_components/loader.dart';

import '../widgets/modals/modal_bottom_sheet.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = 'accountScreen';

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late UserModel? user;

  @override
  void initState() {
    super.initState();

    user = context.read<AuthModel>().user;
  }

  void logout() {
    context.read<AuthService>().logout(context);
  }

  Future<void> showAccountUpdateModal<T extends Widget>(
      {required BuildContext context,
      required Widget Function({
        required Map<String, dynamic> formData,
        required Map<String, dynamic> errors,
        Map<String, dynamic>? additional,
      }) body,
      required Future<Response> Function(Map<String, dynamic>) apiCall,
      bool updateUser = true,
      String? title,
      Function? onSuccess,
      Function? beforeApiCall}) async {
    final Map<String, dynamic> formData = user!.toJson();
    final ValueNotifier<Map<String, dynamic>> errorsNotifier = ValueNotifier({});

    await modalBottomSheet(
      context,
      FormModal(
        title: title,
        body: FormWrapper(
          formData: formData,
          errorsNotifier: errorsNotifier,
          body: body,
        ),
        save: () async {

          if (beforeApiCall != null) {
            final bool res = beforeApiCall(formData, errorsNotifier);

            if (!res) return;
          }

          if (formData['debt_reminder_period'] != null && formData['debt_reminder_period'] is Period) {
            formData['debt_reminder_period'] = formData['debt_reminder_period'].name;
          }

          final responseData = await RequestService.send(context, apiCall(formData), errorsNotifier: errorsNotifier);

          if (responseData == null) return;

          if (onSuccess != null) onSuccess(formData);

          if (updateUser) {
            setState(() {
              user = UserModel.fromJson(formData);
            });
          }

          Navigator.pop(context, AccountScreen.routeName);
        },
      ),
    );
  }

  Future<void> editNotifications(BuildContext context) async {
    await showAccountUpdateModal(context: context, body: EditNotifications.new, apiCall: (formData) => context.read<ProfileRepository>().updateProfile(formData), title: "Notifications Settings");
  }

  Future<void> changePassword(BuildContext context) async {
    await showAccountUpdateModal(
        context: context, updateUser: false, body: ChangePassword.new, apiCall: (formData) => context.read<ProfileRepository>().changePassword(formData), title: 'Change password');
  }

  Future<void> changeEmail(BuildContext context) async {
    await showAccountUpdateModal(
        context: context,
        body: ChangeEmail.new,
        apiCall: (formData) => context.read<ProfileRepository>().changeEmail(formData),
        title: 'Change email',
        beforeApiCall: (Map<String, dynamic> data, ValueNotifier errorsNotifier) {
          if (data['email'] == user!.email) {
            errorsNotifier.value = {"email": "Email should be another!"};
          }

          return false;
        });
  }

  Future<void> editProfile(BuildContext context) async {
    await showAccountUpdateModal(
      context: context,
      body: EditProfile.new,
      apiCall: (formData) => context.read<ProfileRepository>().updateProfile(formData),
      title: "Change profile",
    );
  }

  Future<void> confirmEmail(BuildContext context) async {
    await showAccountUpdateModal(
      context: context,
      body: ConfirmEmail.new,
      updateUser: false,
      apiCall: (formData) => context.read<AuthRepository>().confirmEmail(formData),
      title: 'Confirm email',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          children: [
            Center(
              child: Wrap(
                direction: Axis.vertical,
                spacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AvatarPicker(
                    avatar: user!.avatar,
                    radius: 50,
                    onSuccess: (File file) {
                      setState(() {
                        user!.avatar = file.path;
                      });
                      context.read<ProfileRepository>().uploadAvatar(file);
                    },
                  ),
                  Text(user!.name ?? 'Jhon Doe ')
                ],
              ),
            ),
            const Divider(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                editProfile(context);
              },
            ),
            const Divider(height: 20, thickness: 10, color: Color.fromRGBO(240, 240, 240, 1)),
            ListTile(
              leading: const Icon(Icons.password_outlined),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                changePassword(context);
              },
            ),
            const Divider(height: 10, thickness: 2, color: Color.fromRGBO(240, 240, 240, 1)),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(user!.email),
                  Visibility(
                    visible: !user!.emailVerified,
                    child: TextButton(
                      child: const Text(
                        'Confirm email',
                        style: TextStyle(color: Colors.indigo),
                      ),
                      onPressed: () {
                        confirmEmail(context);
                      },
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                changeEmail(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                editNotifications(context);
              },
            ),
            const Divider(height: 20, thickness: 10, color: Color.fromRGBO(240, 240, 240, 1)),
          ],
        ),
        Center(
          child: ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
            onTap: logout,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:split_trip/widgets/reminder_settings.dart';

import '../constants/theme_constants.dart';

class EditNotifications extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Map<String, dynamic> errors;
  final Map<String, dynamic>? additional;

  const EditNotifications({super.key, required this.formData, required this.errors, this.additional});

  @override
  State<EditNotifications> createState() => _EditNotificationsState();
}

class _EditNotificationsState extends State<EditNotifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: cTextFormFieldHeight,
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('Push notifications'),
            subtitle: const Text(
              'Receive notifications when group changes',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: CupertinoSwitch(
              value: widget.formData['push_notifications'],
              onChanged: (bool value) {
                setState(() {
                  widget.formData['push_notifications'] = value;
                });
              },
            ),
          ),
          ReminderSettings(
            label: widget.formData['debt_reminder_period'] is String
                ? Period.fromString(widget.formData['debt_reminder_period'])
                : widget.formData['debt_reminder_period'],
            onPeriodSelected: (Enum? data) {
              setState(() {
                widget.formData['debt_reminder_period'] = data?.name;
              });
            },
          )
        ],
      ),
    );
  }
}

import 'dart:collection';
import 'dart:io';

import 'package:dropdown_cupertino/dropdown_cupertino.dart';
import 'package:flutter/material.dart';

class ReminderSettings extends StatefulWidget {
  final Function(Enum?) onPeriodSelected;
  final Period label;

  const ReminderSettings({super.key, required this.onPeriodSelected,  required this.label});

  @override
  State<ReminderSettings> createState() => _ReminderSettingsState();
}

enum Period {
  daily("Once a day", "daily"),
  weekly("Once a week", "weekly"),
  monthly("Once a month", "monthly");

  final String label;
  final String name;

  const Period(this.label, this.name);

  static Period fromString(String value) {
    return Period.values.firstWhere(
          (period) => period.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Period.weekly,
    );
  }
}


Map<Period?, String> periods = {
  Period.daily: Period.daily.label,
  Period.weekly: Period.weekly.label,
  Period.monthly: Period.monthly.label
};

typedef MenuEntry = DropdownMenuEntry<String>;

class _ReminderSettingsState extends State<ReminderSettings> {

  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    periods.entries.map<MenuEntry>((entry) => MenuEntry(value: entry.key!.name, label: entry.value)),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Set a period for debt reminders'),
        ),
        SizedBox(
          width: double.infinity,
          child: Platform.isIOS
              ? DropDownCupertino(
            initialText: widget.label.label,
            pickList: periods,
            onSelectedItemChanged: (Enum? selected) {
              widget.onPeriodSelected(selected);
            },
          )
              : DropdownMenu(
            width: MediaQuery.of(context).size.width,
            dropdownMenuEntries: menuEntries,
            initialSelection: widget.label.name,
            onSelected: (String? value) {
              widget.onPeriodSelected(Period.fromString(value!));
            },
          ),
        ),
      ],
    );
  }


}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:split_trip/screens/group_list_screen.dart';
import 'package:split_trip/screens/group_view_screen.dart';

import '../models/group_model.dart';
import '../repositories/group_repository.dart';
import '../widgets/theme_components/loader.dart';

class AddMemberScreen extends StatefulWidget {
  static const String routeName = 'addMemberHandler';
  final String groupId;

  const AddMemberScreen({super.key, required this.groupId});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _addMemberToGroup();
  }

  Future<void> _addMemberToGroup() async {
    try {
      final groupRepository = Provider.of<GroupRepository>(context, listen: false);
      final Response response = await groupRepository.addMember(widget.groupId);
      final GroupModel group = await groupRepository.view(widget.groupId);

      if (!mounted) return;

      if (response.statusCode == HttpStatus.created) {
        Navigator.pushReplacementNamed(
          context,
          GroupViewScreen.routeName,
          arguments: group,
        );

        return;
      }

      if (response.statusCode == HttpStatus.notFound) {
        setState(() {
          _errorMessage = "Group doesn't exist anymore";
          _isLoading = false;
        });

        return;
      }

      Navigator.pushReplacementNamed(context, GroupListScreen.routeName);

    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? screenLoader()
              : _errorMessage != null
              ? Text(_errorMessage!)
              : const SizedBox(),
        ),
      ),
    );
  }
}

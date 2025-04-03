import 'package:flutter/cupertino.dart';
import 'package:split_trip/repositories/group_repository.dart';
import 'package:split_trip/services/overlay_service.dart';

import '../models/group_model.dart';
import '../services/request_service.dart';

class GroupProvider extends ChangeNotifier {
  final GroupRepository groupRepository;

  GroupProvider(this.groupRepository) {
    loadGroups(OverlayService.navigatorKey.currentState!.context);
  }

  List<GroupModel> _groups = [];
  bool _isLoading = false;

  List<GroupModel> get groups => _groups;
  bool get isLoading => _isLoading;

  Future<void> loadGroups(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final List? data = await RequestService.send<List>(context, groupRepository.list());

    if (data != null) {
      _groups = data.map((json) => GroupModel.fromJson(json)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  addGroup(Map<String, dynamic> data) {
    _groups.insert(0, GroupModel.fromJson(data));
    notifyListeners();
  }

  void clear() {
    _groups = [];
    notifyListeners();
  }
}
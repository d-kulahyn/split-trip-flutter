import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:split_trip/enums/debt_status_enums.dart';
import 'package:split_trip/interceptors/access_token_interceptor.dart';
import 'package:split_trip/interceptors/common_interceptor.dart';
import 'package:split_trip/constants/api_constants.dart';
import 'package:split_trip/models/group_model.dart';

class GroupRepository {
  final http.Client _client;

  GroupRepository()
      : _client = InterceptedClient.build(
    requestTimeout: const Duration(seconds: 5),
    interceptors: [CommonInterceptor(), AccessTokenInterceptor()],
  );

  Future<http.Response> list() async {
    return await _client.get(scheme("/v1/groups"));
  }

  Future<http.Response> create(Map<String, dynamic> formData) {
    return _client.post(scheme("/v1/groups"), body: jsonEncode(formData));
  }

  Future<http.Response> update(String groupId, Map<String, dynamic> formData) {
    return _client.put(scheme("/v1/groups/$groupId"), body: jsonEncode(formData));
  }

  Future<http.Response> toggleSimplify(String groupId) {
    return _client.put(scheme("/v1/groups/$groupId/simplifyDebts"));
  }

  Future<GroupModel> view(String id) async {
    final response = await _client.get(scheme("/v1/groups/$id"));

    return GroupModel.fromJson(jsonDecode(response.body));
  }

  Future<http.Response> addMember(String groupId) {
    return _client.post(scheme("/v1/groups/$groupId/members"));
  }

  Future<http.Response> leaveGroup(String groupId, int userId) {
    return _client.delete(scheme("/v1/groups/$groupId/members"), body: jsonEncode({'ids': [userId]}));
  }

  Future<http.Response> addExpense(String groupId, Map<String, dynamic> data) {
    return _client.post(scheme("/v1/groups/$groupId/expenses"), body: jsonEncode(data));
  }

  Future<http.Response> changeDebtStatus(int debtId, DebtStatusEnums status) {
    return _client.put(scheme("/v1/debts/$debtId"), body: jsonEncode({"status": status.name}));
  }

  Future<http.Response> uploadAvatar(File file, String groupId) async {
    final Uri uri = scheme("/v1/groups/$groupId/avatar");

    final request = http.MultipartRequest("POST", uri);

    request.files.add(await http.MultipartFile.fromPath('avatar', file.path));

    final streamedResponse = await _client.send(request);

    return await http.Response.fromStream(streamedResponse);
  }
}

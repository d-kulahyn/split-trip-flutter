import 'package:split_trip/constants/api_constants.dart';

class InviteLinkGenerator {

  static String generate(String groupId) {

   return scheme("groups/$groupId").toString();
  }
}
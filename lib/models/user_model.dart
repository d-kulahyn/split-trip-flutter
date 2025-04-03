import '../valueObject/balance.dart';
import '../widgets/reminder_settings.dart';

class UserModel {
  int id;
  String? name;
  String? avatar;
  String currency;
  String email;
  bool emailVerified;
  String? firebaseCloudMessagingToken;
  bool? emailNotifications;
  bool? pushNotifications;
  Period? debtReminderPeriod;
  Balance balance;

  UserModel({
    required this.id,
    required this.email,
    required this.currency,
    required this.balance,
    this.name,
    this.avatar,
    this.emailNotifications,
    this.pushNotifications,
    this.debtReminderPeriod,
    this.firebaseCloudMessagingToken,
    required this.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        emailVerified: data['email_is_verified'],
        currency: data['currency'],
        avatar: data['avatar'],
        balance: Balance(
            owe: double.parse(data['balance']['owe'].toString()),
            paid: double.parse(data['balance']['paid'].toString()),
            balance: double.parse(data['balance']['balance'].toString())
        ),
        firebaseCloudMessagingToken: data['firebase_cloud_messaging_token'],
        emailNotifications: data['email_notifications'] ?? true,
        pushNotifications: data['push_notifications'] ?? true,
        debtReminderPeriod: Period.fromString(data['debt_reminder_period']));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "currency": currency,
      "name": name,
      "avatar": avatar,
      "balance": {
        "owe": balance.owe,
        "paid": balance.paid,
        "balance": balance.balance
      },
      "email_is_verified": emailVerified,
      "firebase_cloud_messaging_token": firebaseCloudMessagingToken,
      "email_notifications": emailNotifications,
      "push_notifications": pushNotifications,
      "debt_reminder_period": debtReminderPeriod
    };
  }
}

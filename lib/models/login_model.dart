import 'package:hive/hive.dart';
part 'login_model.g.dart';

@HiveType(typeId: 0)
class Login extends HiveObject {
  @HiveField(0)
  late String userName;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String password;

  @HiveField(3)
  late bool isLoggedIn = false;
}

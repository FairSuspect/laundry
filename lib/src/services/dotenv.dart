import 'package:flutter_dotenv/flutter_dotenv.dart';

late Env env;

class Env {
  final String? userName;
  final String? password;

  const Env({this.userName, this.password});
}

Future<void> init(String path) async {
  await dotenv.load(fileName: path);
  env =
      Env(userName: dotenv.env['USER_NAME'], password: dotenv.env['PASSWORD']);
}

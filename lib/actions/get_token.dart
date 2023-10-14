import 'package:dotenv/dotenv.dart';

String getToken() {
  final env = DotEnv()..load();

  return env['DISCORD_TOKEN'] ?? '';
}
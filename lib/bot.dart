import 'dart:math';

import 'package:cron/cron.dart';
import 'package:diretiva_primaria_discord_bot/actions/register_bot.dart';

import 'actions/get_token.dart';
import 'actions/send_message.dart';
import 'config/app_strings.dart' as app_strings;
import 'commands/list_directives_command.dart' as list_directives_command;

Future<void> run() async {
  final token = getToken();
  final bot = await registerBot(token);

  final cron = Cron();

  cron.schedule(Schedule.parse("40 14 * * 1-5"), () async {
    final directives = await list_directives_command.listDirectives();
    await sendMessage(
      bot: bot,
      message: directives.random,
      channelName: app_strings.channelName,
    );
  });
}

extension<T> on List<T> {
  T get random {
    final random = Random.secure();
    return elementAt(random.nextInt(length));
  }
}

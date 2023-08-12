import 'dart:math';

import 'package:cron/cron.dart';
import 'package:dotenv/dotenv.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import 'app_strings.dart' as app_strings;
import 'commands/add_directive_command.dart' as add_directive_command;
import 'commands/list_directives_command.dart' as list_directives_command;
import 'commands/remove_directive_command.dart' as remove_directive_command;

Future<void> run() async {
  final token = getToken();
  final bot = await registerBot(
    token,
    GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
  );

  final cron = Cron();

  cron.schedule(Schedule.parse("40 9 * * 1-5"), () async {
    final directives = await list_directives_command.listDirectives();
    await sendMessage(
      bot: bot,
      message: directives.random,
      channelName: app_strings.channelName,
    );
  });
}

String getToken() {
  final env = DotEnv()..load();

  return env['DISCORD_TOKEN'] ?? '';
}

Future<INyxxWebsocket> registerBot(String token, int intents) async {
  final bot = NyxxFactory.createNyxxWebsocket(token, intents)
    ..registerPlugin(Logging())
    ..registerPlugin(CliIntegration())
    ..registerPlugin(IgnoreExceptions())
    ..connect();

  final interactions = IInteractions.create(WebsocketInteractionBackend(bot));

  interactions.registerSlashCommand(add_directive_command.command);
  interactions.registerSlashCommand(list_directives_command.command);
  interactions.registerSlashCommand(remove_directive_command.command);

  interactions.syncOnReady();

  return bot;
}

Future<void> sendMessage({
  required INyxxWebsocket bot,
  required String message,
  required String channelName,
}) async {
  for (final guild in bot.guilds.values) {
    final channel = guild.channels
        .where((channel) => channel.name == channelName)
        .firstOrNull;

    if (channel != null) {
      await bot.httpEndpoints.sendMessage(
        channel.id,
        MessageBuilder.content(message),
      );
    }
  }
}

extension<T> on List<T> {
  T get random {
    final random = Random.secure();
    return elementAt(random.nextInt(length));
  }
}

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../commands/add_directive_command.dart' as add_directive_command;
import '../commands/list_directives_command.dart' as list_directives_command;
import '../commands/remove_directive_command.dart' as remove_directive_command;

Future<INyxxWebsocket> registerBot(
  String token, [
  int intents = GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
]) async {
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

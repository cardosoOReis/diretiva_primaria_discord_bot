import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../config/flush_directives.dart' as flush;
import 'list_directives_command.dart' as list_directives_command;

const commandName = 'remover';
const commandDescription = 'Remover uma diretiva.';

const commandArgument1Name = 'numero-diretiva';
const commandArgument1Description =
    'O numero da diretiva para remover, use /listar para saber o número.';

const successfulOperationMessage = 'Diretiva removida com sucesso!';
const unsuccessfulOperationMessage = 'Acontecu um erro ao remover a diretiva.';

final command = SlashCommandBuilder(
  commandName,
  commandDescription,
  [_directiveArgument],
)..registerHandler(_handler);

final _directiveArgument = CommandOptionBuilder(
  CommandOptionType.integer,
  commandArgument1Name,
  commandArgument1Description,
  required: true,
);

Future<bool> removeDirective(int index) async {
  final directives = await list_directives_command.listDirectives();
  if (index >= directives.length || index < 0) {
    return false;
  }
  directives.removeAt(index);
  flush.flush(directives);
  return true;
}

FutureOr<void> _handler(ISlashCommandInteractionEvent event) async {
  final indexArg = event.args.first.value as int;

  final result = await removeDirective(indexArg);

  await event.respond(MessageBuilder.content(formatResponse(result)));
}

String formatResponse(bool isSucess) =>
    isSucess ? successfulOperationMessage : unsuccessfulOperationMessage;

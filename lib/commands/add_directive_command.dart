import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../config/flush_directives.dart' as flush;
import 'list_directives_command.dart' as list_directives_command;

const commandName = 'adicionar';
const commandDescription = 'Adicionar diretiva';

const commandArgument1Name = 'diretiva';
const commandArgument1Description = 'Diretiva';

const responseMessage = 'Adicionado com sucesso!';

final command = SlashCommandBuilder(
  commandName,
  commandDescription,
  [_directiveArgument],
)..registerHandler(_handler);

final _directiveArgument = CommandOptionBuilder(
  CommandOptionType.string,
  commandArgument1Name,
  commandArgument1Description,
  required: true,
);

Future<void> addDirective(String directive) async {
  final directives = await list_directives_command.listDirectives();
  directives.add(directive);
  flush.flush(directives);
}

FutureOr<void> _handler(ISlashCommandInteractionEvent event) async {
  final directiveArg = event.args
      .where(
        (arg) => arg.name == commandArgument1Name,
      )
      .firstOrNull;

  final directive = directiveArg?.value?.toString() ?? '';
  await addDirective(directive);

  await event.respond(
    MessageBuilder.content(responseMessage),
    hidden: true,
  );
}

import 'dart:async';
import 'dart:io';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../config/app_strings.dart' as app_strings;

const commandName = 'listar';
const commandDescription = 'Lista todas as diretivas cadastradas';

final command = SlashCommandBuilder(commandName, commandDescription, [])
  ..registerHandler(_handler);

FutureOr<void> _handler(ISlashCommandInteractionEvent event) async {
  final directives = await listDirectives();

  await event.respond(
    MessageBuilder.content(formatDirectives(directives)),
    hidden: true,
  );
}

Future<List<String>> listDirectives() async {
  return File(app_strings.fileName).readAsLines();
}

String formatDirectives(List<String> directives) =>
    directives.indexed.map((d) => '- ${d.$1} - ${d.$2}').join('\n');

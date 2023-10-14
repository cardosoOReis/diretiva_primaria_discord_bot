import 'package:nyxx/nyxx.dart';

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

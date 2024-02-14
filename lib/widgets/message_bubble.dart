import 'package:flutter/material.dart';
import 'package:models/models.dart';

// ignore: must_be_immutable
class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key, required this.message, required this.logedUserId});

  final Message message;
  final String logedUserId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final alignment = (message.senderUserId != logedUserId)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    final color = (message.senderUserId == logedUserId)
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    final textColor = (message.senderUserId == logedUserId)
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSecondary;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * 0.66),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        child: Text(
          message.content ?? '',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: textColor,
              ),
        ),
      ),
    );
  }
}

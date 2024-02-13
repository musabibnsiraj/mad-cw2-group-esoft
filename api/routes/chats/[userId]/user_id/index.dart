import 'dart:async';
import 'dart:io';
import 'package:api/src/repositories/chat_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String userId) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, userId);
    case HttpMethod.post:
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.patch:
    case HttpMethod.head:
    case HttpMethod.options:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
  // return Response(body: 'Welcome to Dart Frog!');
}

Future<Response> _get(RequestContext context, String userId) async {
  // Use the message repository.
  final chatRepository = context.read<ChatRepository>();

  try {
    final chats = await chatRepository.getChatRoomsWithUsers(userId);
    return Response.json(body: {'chats': chats});
  } catch (err) {
    return Response.json(
      body: {'error': err.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:api/src/repositories/user_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
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

Future<Response> _get(RequestContext context) async {
  // Use the message repository.
  final userRepository = context.read<UserRepository>();

  try {
    final users = await userRepository.fetchUsers();
    return Response.json(body: {'users': users});
  } catch (err) {
    return Response.json(
      body: {'error': err.toString()},
      statusCode: HttpStatus.internalServerError,
    );
  }
}

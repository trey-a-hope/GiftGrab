import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/services/hive_session_service.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:nakama/nakama.dart';

/// Provider used to check if the user is authenticated.
class NakamaAuthNotifier extends AsyncNotifier<bool> {
  /// HiveSessionService instance.
  final _hiveSessionService = HiveSessionService();

  @override
  FutureOr<bool> build() async {
    // Initialize Nakama client.
    getNakamaClient(
      host: Globals.nakamaConfig.host,
      ssl: Globals.nakamaConfig.ssl,
      serverKey: Globals.nakamaConfig.serverKey,
      httpPort: Globals.nakamaConfig.httpPort,
    );

    // Fetch the current session.
    final session = await _hiveSessionService.sessionActive();

    return session != null;
  }

  /// Authenticate with email and password.
  Future authenticateEmail({
    required String email,
    required String password,
  }) async {
    // Authenticate with email and password.
    final session = await getNakamaClient().authenticateEmail(
      email: email,
      password: password,
      create: true,
      vars: {
        'email': email,
      },
    );

    // Save session token to local storage.
    _hiveSessionService.putSession(session: session);

    // Print Nakama user UID to console.
    debugPrint('Nakama UID: ${session.userId}');

    // Set authenticated state to true.
    state = const AsyncData(true);
  }

  /// Logout of the current session.
  Future logout() async {
    /*
      var session = _hiveSessionService.getSession();

      if (session == null) {
        throw Exception('No session found.');
      }

      TODO: Currently cannot logout of session via the Nakama Client...
      
      await getNakamaClient().sessionLogout(session: session);

      "GrpcError (gRPC Error (code: 16, codeName: UNAUTHENTICATED, 
      message: Auth token invalid, details: [], rawResponse: null, 
      trailers: {}))"

      For now, just clear the session from local storage.
    */

    // Clear session from local storage.
    await _hiveSessionService.clearSession();

    // Set authenticated state to false.
    state = const AsyncData(false);
  }
}

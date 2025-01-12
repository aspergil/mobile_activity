import 'dart:convert';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/constants.dart';

import 'api_event.dart';
import 'board_event.dart';

final boardRepositoryProvider = Provider<BoardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = BoardRepository(Logger('BoardRepository'), apiClient: apiClient);
  ref.onDispose(() => repo.dispose());
  return repo;
});

/// Repository giving access to lichess board API.
///
/// API doc: https://lichess.org/api#tag/Board
class BoardRepository {
  const BoardRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  /// Stream the events reaching a lichess user in real time as ndjson.
  Stream<ApiEvent> events() async* {
    final resp =
        await apiClient.stream(Uri.parse('$kLichessHost/api/stream/event'));
    _log.fine('Start streaming events.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where(
          (json) => json['type'] == 'gameStart' || json['type'] == 'gameFinish',
        )
        .map((json) => ApiEvent.fromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  /// Stream the state of a game being played with the Board API, as ndjson.
  Stream<BoardEvent> gameStateEvents(GameId id) async* {
    final resp = await apiClient
        .stream(Uri.parse('$kLichessHost/api/board/game/stream/$id'));
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where(
          (event) =>
              event['type'] == 'gameFull' || event['type'] == 'gameState',
        )
        .map((json) => BoardEvent.fromJson(json))
        .handleError((Object error) => _log.warning(error));
  }

  FutureResult<void> playMove(GameId gameId, Move move) {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/board/game/$gameId/move/${move.uci}'),
      retry: true,
    );
  }

  FutureResult<void> abort(GameId gameId) {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/board/game/$gameId/abort'),
      retry: true,
    );
  }

  FutureResult<void> resign(GameId gameId) {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/board/game/$gameId/resign'),
      retry: true,
    );
  }

  void dispose() {
    apiClient.close();
  }
}

import 'package:logging/logging.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/common/api_client.dart';
import 'package:lichess_mobile/src/model/user/activity.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/constants.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final repo = ActivityRepository(
    apiClient: apiClient,
    logger: Logger('ActivityRepository'),
  );
  ref.onDispose(() => repo.dispose());
  return repo;
});

class ActivityRepository {
  const ActivityRepository({required this.apiClient, required Logger logger})
      : _log = logger;

  final ApiClient apiClient;
  final Logger _log;

  FutureResult<IList<ActivityInterval>> getActivity({String user = 'veloce'}) {
    // Zhigalko_Sergei
    //BogdanLalic
    return apiClient
        .get(Uri.parse('$kLichessHost/api/user/$user/activity'))
        .then(
          (result) => result.flatMap(
            (response) => readJsonListOfObjects(
              response.body,
              mapper: ActivityInterval.fromJson,
              logger: _log,
            ),
          ),
        );
  }

  void dispose() => apiClient.close();
}

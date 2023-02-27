//import 'package:async/async.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
//import 'package:lichess_mobile/src/utils/l10n_context.dart';
//import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'activity_screen.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';

/*
final activityListProvider = FutureProvider.autoDispose((ref) {
  final activityRepo = ref.watch(activityRepositoryProvider);
  return Result.release(activityRepo.getActivity(user: 'Zhigalko_Sergei'));
});*/

class ActivityWidget extends ConsumerWidget {
  const ActivityWidget({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final activityState = ref.watch(userRecentGamesProvider(userId: user.id));
    final activityState = ref.watch(UserActivityProvider(id: user.id));

    return activityState.when(
        data: (data) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  //context.l10n.leaderboard,
                  'Activity',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                /*
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => ActivityScreen(
                        activityIntervalList: data,
                      ),
                    ),
                  );
                },*/
                //trailing: const Icon(CupertinoIcons.forward),
              ),
              Activities(activityIntervalList: data),
            ],
          );
        },
        error: (error, stackTrace) {
          debugPrint(
              'SEVERE: [ActivityWidget] could not load activity data; $error\n $stackTrace');
          return const Text('could not load activity');
        },
        loading: () => const CenterLoadingIndicator());
  }

  List<Widget> _buildList() {
    return [
      Text("data"),
    ];
  }
}

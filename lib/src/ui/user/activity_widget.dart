import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';

import 'package:lichess_mobile/src/common/styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
//import 'package:lichess_mobile/src/utils/l10n_context.dart';
//import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'activity_screen.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';

class ActivityWidget extends ConsumerWidget {
  const ActivityWidget({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityState = ref.watch(UserActivityProvider(id: user.id));

    return activityState.when(
      data: (data) {
        return Column(
          children: [
            const ListTile(
              title: Text('Activity', style: Styles.sectionTitle),
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
          'SEVERE: [ActivityWidget] could not load activity data; $error\n $stackTrace',
        );
        return const Text('could not load activity');
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}

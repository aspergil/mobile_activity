import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:lichess_mobile/src/utils/json.dart';
import 'package:lichess_mobile/src/common/models.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'activity.freezed.dart';

/*
@freezed
class Activity with _$Activity {
  const factory Activity({
    required List<Interval> interval,
  }) = _Activity;

  //factory Activity({required List<ActivityBlob> activityblob}) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      Activity.fromPick(pick(json).required());

  factory Activity.fromPick(RequiredPick pick) {
    return Activity(
      interval: pick().asListOrEmpty(ActivityInterval.fromPick),
    );
  }
}
*/
@freezed
class ActivityInterval with _$ActivityInterval {
  const factory ActivityInterval({
    required DateTime start,
    required DateTime end,
    required IMap<Perf, Games> games,
  }) = _ActivityInterval;

  factory ActivityInterval.fromJson(Map<String, dynamic> json) =>
      ActivityInterval.fromPick(pick(json).required());

  factory ActivityInterval.fromPick(RequiredPick p) {
    final gamesMap = p('games').asMapOrEmpty<String, Map<String, dynamic>>();

    return ActivityInterval(
      start: p('interval', 'start').asDateTimeFromMillisecondsOrThrow(),
      end: p('interval', 'end').asDateTimeFromMillisecondsOrThrow(),
      games: IMap({
        for (final entry in gamesMap.entries)
          if (perfNameMap.containsKey(entry.key) && entry.key != 'storm')
            perfNameMap.get(entry.key)!: Games(
              type: entry.key,
              draw: p('games', entry.key, 'draw').asIntOrThrow(),
              win: p('games', entry.key, 'win').asIntOrThrow(),
              loss: p('games', entry.key, 'loss').asIntOrThrow(),
              rpBefore: p('games', entry.key, 'rp', 'before').asIntOrThrow(),
              rpAfter: p('games', entry.key, 'rp', 'after').asIntOrThrow(),
            )
      }),
    );
  }
}

@freezed
class Games with _$Games {
  const factory Games({
    required String type,
    required int win,
    required int loss,
    required int draw,
    required int rpBefore,
    required int rpAfter,
  }) = _Games;

  factory Games.fromPick(RequiredPick p) {
    return Games(
        type: 'test', win: 1, loss: 2, draw: 3, rpBefore: 4, rpAfter: 5);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/constants.dart';
//import 'package:lichess_mobile/src/utils/style.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/model/user/activity.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({required this.activityIntervalList, super.key});
  final IList<ActivityInterval> activityIntervalList;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Home',
        middle: Text(context.l10n.leaderboard),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                sliver: constraints.maxWidth > kLargeScreenWidth
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 644,
                          crossAxisCount: (constraints.maxWidth / 300).floor(),
                        ),
                        delegate: SliverChildListDelegate(_buildList()),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(_buildList()),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.leaderboard),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > kLargeScreenWidth) {
            return GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 644,
                crossAxisCount: (constraints.maxWidth / 300).floor(),
              ),
              children: _buildList(),
            );
          } else {
            return ListView(
              children: _buildList(),
            );
          }
        },
      ),
    );
  }

  @allowedWidgetReturn
  List<Widget> _buildList() {
    return [Text('test'), Text('me')];
  }
}

class Activities extends StatelessWidget {
  const Activities({required this.activityIntervalList});
  final IList<ActivityInterval> activityIntervalList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // This is where we need to added the activity intervals
        ...activityIntervalList.map((activityInterval) =>
            ActivityListTile(activityInterval: activityInterval)),
        /*
        ...ListTile.divideTiles(
          color: dividerColor(context),
          context: context,
          tiles: activityIntervalList.map((activityInterval) =>
              ActivityListTile(activityInterval: activityInterval)),
        ),
        */
        const SizedBox(height: 12),
      ],
    );
  }
}

class ActivityListTile extends StatelessWidget {
  const ActivityListTile({required this.activityInterval});
  final ActivityInterval activityInterval;

  List<Widget> buildChildren() {
    List<Widget> builder = [];

    activityInterval.games!.forEach((interval) {
      builder.add(
        ListTile(
          leading: Icon(LichessIcons.bullet),
          //Text(data.type),
          visualDensity: VisualDensity(vertical: -4, horizontal: -4),
          title: Row(
            children: [
              //Text(interval.type),
              //icon: game.perf.icon,
              _RatingAndProgress(
                  interval.rpAfter, interval.rpAfter - interval.rpBefore),
            ],
          ),
          trailing: _WinDrawLoss(interval.win, interval.draw, interval.loss),
        ),
      );
    });
    return builder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading:
              Text("${DateFormat.yMMMMd().format(activityInterval.start)}"),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 45,
                child: Center(
                    child: Text("Win",
                        style: TextStyle(
                            //backgroundColor: Colors.blueAccent,
                            //color: LichessColors.good,
                            //fontWeight: FontWeight.bold
                            ))),
              ),
              SizedBox(
                width: 45,
                child: Center(
                    child: Text("Draw",
                        style: TextStyle(
                            //color: LichessColors.brag,
                            //fontWeight: FontWeight.bold
                            ))),
              ),
              SizedBox(
                width: 45,
                child: Center(
                    child: Text("Loss",
                        style: TextStyle(
                            //color: LichessColors.red,
                            //fontWeight: FontWeight.bold
                            ))),
              ),
            ],
          ),
        ),
        ...buildChildren(),
      ],
    );
  }
}
/*

        */

class _WinDrawLoss extends StatelessWidget {
  const _WinDrawLoss(this.win, this.draw, this.loss);
  final int win;
  final int draw;
  final int loss;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 45,
              child: Center(
                child: Text(win.toString(),
                    style: TextStyle(
                        //backgroundColor: Colors.amber,
                        color: LichessColors.good,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              width: 45,
              child: Center(
                  child: Text(draw.toString(),
                      style: TextStyle(
                          color: LichessColors.brag,
                          fontWeight: FontWeight.bold))),
            ),
            SizedBox(
              width: 45,
              child: Center(
                  child: Text(loss.toString(),
                      style: TextStyle(
                          color: LichessColors.red,
                          fontWeight: FontWeight.bold))),
            ),

            //Text("Losses")
          ],
        ),
      ],
    );
  }
}

class _RatingAndProgress extends StatelessWidget {
  const _RatingAndProgress(this.rating, this.progress);
  final int rating;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 50, child: Text(rating.toString())),
        const SizedBox(width: 5),
        if (progress < 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                LichessIcons.arrow_full_lowerright,
                size: 20,
                color: LichessColors.red,
              ),
              SizedBox(
                width: 30,
                child: Text(
                  '${progress.abs()}',
                  style: const TextStyle(color: LichessColors.red),
                ),
              )
            ],
          )
        else if (progress > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LichessIcons.arrow_full_upperright,
                size: 20,
                color: LichessColors.good,
              ),
              SizedBox(
                width: 30,
                child: Text(
                  '$progress',
                  style: const TextStyle(color: LichessColors.good),
                ),
              )
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}

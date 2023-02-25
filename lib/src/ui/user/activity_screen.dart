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

class Carousel extends StatelessWidget {
  const Carousel({required this.activityIntervalList});
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

    /*
    Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position

            controller: PageController(viewportFraction: 0.8),
            itemCount: activityIntervalList.length,
            itemBuilder: (BuildContext context, int itemIndex) {
              return CarouselItem(
                  activityInterval: activityIntervalList[itemIndex]);
            },
          ),
        )
      ],
    );*/
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
          //leading: Text(data.type),
          title: Row(
            children: [
              Text(interval.type),
              _WinDrawLoss(interval.win, interval.draw, interval.loss),
              //_RatingAndProgress(data.rpAfter, data.rpAfter - data.rpBefore),
              //Text("End"),
            ],
          ),
          trailing: _RatingAndProgress(
              interval.rpAfter, interval.rpAfter - interval.rpBefore),
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
        Text("${DateFormat.yMMMMd().format(activityInterval.start)}"),
        ...buildChildren(),
      ],
    );
  }
}

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
            Container(
              //constraints: BoxConstraints(minWidth: 20),
              //margin: const EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: LichessColors.good,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(win.toString()),
            ),
            Container(
              //constraints: BoxConstraints(minWidth: 20),
              //margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: LichessColors.brag,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(draw.toString()),
            ),
            Container(
              //constraints: BoxConstraints(minWidth: 24),
              //margin: const EdgeInsets.only(top: 25.0, bottom: 25.0),
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: LichessColors.red,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(loss.toString()),
            ),
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
